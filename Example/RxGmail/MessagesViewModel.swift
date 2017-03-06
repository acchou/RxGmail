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

func getHeaders(rawHeaders: [RxGmail.MessagePartHeader]?) -> [String:String] {
    guard let rawHeaders = rawHeaders else { return [:] }
    var headers = [String:String]()
    rawHeaders.forEach {
        if let name = $0.name {
            headers[name] = $0.value ?? ""
        }
    }
    return headers
}

func MessagesViewModel(rxGmail: RxGmail) -> MessagesViewModelType {
    return { inputs in
        let query = RxGmail.MessageListQuery.query(withUserId: "me")
        query.labelIds = [inputs.selectedLabel.identifier]
        if case .Unread = inputs.mode {
            query.q = "is:unread"
        }
        let messageHeaders = rxGmail
            .listMessages(query: query)       // RxGmail.MessageListResponse
            .map { $0.messages }              // [RxGmail.Message]?
            .unwrap()                         // [RxGmail.Message]
            .flatMap { Observable.from($0) }  // RxGmail.Message
            .map { $0.identifier }            // String?
            .unwrap()                         // String (message identifier)
            .flatMap {
                 rxGmail.getMessage(messageId: $0)
            }                                 // RxGmail.Message (with all headers)
            .map { message -> MessageHeader in
                let headers = getHeaders(rawHeaders: message.payload?.headers)
                return MessageHeader(
                    sender: headers["From"] ?? "",
                    subject: headers["Subject"] ?? "",
                    date: headers["Date"] ?? ""
                )
            }                                 // MessageHeader
            .toArray()
            .shareReplayLatestWhileConnected()

        return MessagesViewModelOutputs(messageHeaders: messageHeaders)
    }
}
