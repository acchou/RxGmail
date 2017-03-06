import RxSwift
import RxGmail

struct ThreadMessagesViewModelInputs {
    var threadId: String
}

struct ThreadMessagesViewModelOutputs {
    var messageHeaders: Observable<[MessageHeader]>
}

typealias ThreadMessagesViewModelType = (ThreadMessagesViewModelInputs) -> ThreadMessagesViewModelOutputs

func ThreadMessagesViewModel(rxGmail: RxGmail) -> ThreadMessagesViewModelType {
    return { inputs in

        // Do the lazy thing and load all Thread headers every time this view appears. A more production ready implementation would use caching.
        let messageHeaders = rxGmail
            .getThread(threadId: inputs.threadId)        // RxGmail.Thread
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

        return ThreadMessagesViewModelOutputs(messageHeaders: messageHeaders)
    }
}
