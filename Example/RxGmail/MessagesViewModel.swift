import RxSwift
import RxGmail

struct MessageHeader {
    var sender: String
    var subject: String
    var date: String
}

struct MessagesViewModelInputs {
    var labelId: Observable<String>

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

        let messageHeaders = inputs.labelId.flatMapLatest { label -> Observable<[MessageHeader]> in
            let query = RxGmail.MessageListQuery.query(withUserId: "me")
            query.labelIds = [label]
            return rxGmail
                .listMessages(query: query)       // RxGmail.MessageListResponse
                .map { $0.messages }              // [RxGmail.Message]?
                .unwrap()                         // [RxGmail.Message]
                .flatMap { Observable.from($0) }  // RxGmail.Message
                .map {
                    let headers = getHeaders(rawHeaders: $0.payload?.headers)
                    return MessageHeader(
                        sender: headers["From"] ?? "",
                        subject: headers["Subject"] ?? "",
                        date: headers["Date"] ?? ""
                    )
                }
                .toArray()
        }
        .shareReplayLatestWhileConnected()

        return MessagesViewModelOutputs(messageHeaders: messageHeaders)
    }
}
