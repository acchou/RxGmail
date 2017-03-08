import RxSwift
import RxGmail

enum MessagePart {
    case header(name: String, value: String)
    case body(contents: String)
}

struct MessageViewModelInputs {
    var messageId: String
}

struct MessageViewModelOutputs {
    var messageParts: Observable<[MessagePart]>
}

typealias MessageViewModelType = (MessageViewModelInputs) -> MessageViewModelOutputs

func MessageViewModel(rxGmail: RxGmail) -> MessageViewModelType {
    return { inputs in
        let message = rxGmail.getMessage(messageId: inputs.messageId).shareReplay(1)

        let headers = message
            .map { $0.payload?.headers }
            .unwrap()
            .flatMap { Observable.from($0) }
            .filter { ["From", "To", "Subject", "Date"].contains($0.name ?? "") }
            .map { MessagePart.header(name: ($0.name ?? "") + ":", value: $0.value ?? "") }

        let labels = message
            .map { $0.labelIds }
            .unwrap()
            .flatMap { Observable.from($0) }
            .map { MessagePart.header(name: "Label:", value: $0) }

        let mimeType = message
            .map { $0.payload?.mimeType }
            .unwrap()
            .map { MessagePart.header(name: "Mime type:", value: $0) }

        let size = message
            .map { $0.sizeEstimate?.stringValue }
            .unwrap()
            .map { MessagePart.header(name: "Size estimate:", value: $0) }

        let attachments = message
            .map { $0.payload?.filename }
            .unwrap()
            .filter { $0 != "" }
            .map { MessagePart.header(name: "Attachment:", value: $0) }

        let body = message.debug("BODY")
            .flatMap { Observable.from($0.payload?.parts ?? []) }
            .map { $0.body?.data }
            .unwrap()
            .map { data -> String? in
                if  let decodedData = Data(base64URLEncoded: data),
                    let msgBody = String(data: decodedData, encoding: .utf8)
                {
                    return msgBody
                } else {
                    return nil
                }
            }
            .unwrap()
            .take(1)
            .debug("BODY MSG")
            .map { MessagePart.body(contents: $0) }

        let messageParts = Observable.concat([headers, labels, mimeType, size, attachments, body]).toArray()

        return MessageViewModelOutputs(messageParts: messageParts)
    }
}
