import RxSwift
import RxGmail

struct ThreadMessagesViewModelInputs {
    var threadId: String
}

struct ThreadMessagesViewModelOutputs {
    var messageCells: Observable<[MessageCell]>
}

typealias ThreadMessagesViewModelType = (ThreadMessagesViewModelInputs) -> ThreadMessagesViewModelOutputs

func ThreadMessagesViewModel(rxGmail: RxGmail) -> ThreadMessagesViewModelType {
    return { inputs in

        // Do the lazy thing and load all Thread headers every time this view appears. A more production ready implementation would use caching.
        let messageCells = rxGmail
            .getThread(threadId: inputs.threadId)        // RxGmail.Thread
            .flatMap {
                rxGmail.fetchDetails($0.messages ?? [], detailType: .metadata)
            }                                            // [RxGmail.Message] (with all headers)
            .flatMap { Observable.from($0) }             // RxGmail.Message
            .map { message -> MessageCell in
                let headers = message.parseHeaders()
                return MessageCell(
                    identifier: message.identifier ?? "",
                    sender: headers["From"] ?? "",
                    subject: headers["Subject"] ?? "",
                    date: headers["Date"] ?? ""
                )
            }                                            // MessageCell
            .toArray()                                   // [MessageCell]
            .shareReplayLatestWhileConnected()

        return ThreadMessagesViewModelOutputs(messageCells: messageCells)
    }
}
