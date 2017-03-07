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
    var messageParts: Observable<MessagePart>
}

typealias MessageViewModelType = (MessageViewModelInputs) -> MessageViewModelOutputs

func MessageViewModel(rxGmail: RxGmail) -> MessageViewModelType {
    return { inputs in
        let message = rxGmail.getMessage(messageId: inputs.messageId)

        let labels = message
            .map { $0.labelIds }
            .unwrap()
            .flatMap { Observable.from($0) }
            .map { MessagePart.header(name: "Label", value: $0) }

        let headers = message
            .map { $0.payload?.headers }
            .unwrap()
            .flatMap { Observable.from($0) }
            .map { MessagePart.header(name: $0.name ?? "", value: $0.value ?? "") }

        let mimeType = message
            .map { $0.payload?.mimeType }
            .unwrap()
            .map { MessagePart.header(name: "Mime type", value: $0) }

        let size = message
            .map { $0.sizeEstimate?.stringValue }
            .unwrap()
            .map { MessagePart.header(name: "Size estimate", value: $0) }

        let attachments = message
            .map { $0.payload?.filename }
            .unwrap()
            .map { MessagePart.header(name: "Attachment", value: $0) }

        let body = message
            .map { $0.payload?.body?.data }
            .unwrap()
            .map { MessagePart.body(contents: $0) }

        let messageParts = Observable.concat([labels, headers, mimeType, size, attachments, body])

        return MessageViewModelOutputs(messageParts: messageParts)
    }
}
