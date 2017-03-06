import RxSwift
import RxGmail

struct MessageHeader {
    var sender: String
    var subject: String
    var date: String
}

enum MessagesQueryMode {
    case All
    case Unread
}

struct MessagesViewModelInputs {
    var selectedLabel: Label
    var mode: MessagesQueryMode
}

struct MessagesViewModelOutputs {
    var messageHeaders: Observable<[MessageHeader]>
}

typealias MessagesViewModelType = (MessagesViewModelInputs) -> MessagesViewModelOutputs

func MessagesViewModel(rxGmail: RxGmail) -> MessagesViewModelType {
    return { inputs in
        let query = RxGmail.MessageListQuery.query(withUserId: "me")
        query.labelIds = [inputs.selectedLabel.identifier]
        if case .Unread = inputs.mode {
            query.q = "is:unread"
        }

        // Do the lazy thing and load all message headers every time this view appears. A more production ready implementation would use caching.
        let messageHeaders = rxGmail
            .listMessages(query: query)                  // RxGmail.MessageListResponse
            .flatMap {
                rxGmail.fetchDetails($0.messages ?? [], detailType: .metadata)
            }                                            // [RxGmail.Message] (with all headers)
            .flatMap { Observable.from($0) }             // RxGmail.Message
            .map { message -> MessageHeader in
                let headers = message.parseHeaders()
                return MessageHeader(
                    sender: headers["From"] ?? "",
                    subject: headers["Subject"] ?? "",
                    date: headers["Date"] ?? ""
                )
            }                                            // MessageHeader
            .toArray()
            .shareReplayLatestWhileConnected()

        return MessagesViewModelOutputs(messageHeaders: messageHeaders)
    }
}
