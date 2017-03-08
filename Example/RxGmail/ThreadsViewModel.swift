import RxSwift
import RxGmail

struct Thread {
    var identifier: String
    var sender: String
    var subject: String
    var date: String
}

enum ThreadsQueryMode {
    case All
    case Unread
}

struct ThreadsViewModelInputs {
    var selectedLabel: Label
    var mode: ThreadsQueryMode
}

struct ThreadsViewModelOutputs {
    var threadHeaders: Observable<[Thread]>
}

typealias ThreadsViewModelType = (ThreadsViewModelInputs) -> ThreadsViewModelOutputs

func ThreadsViewModel(rxGmail: RxGmail) -> ThreadsViewModelType {
    return { inputs in
        let query = RxGmail.ThreadListQuery.query(withUserId: "me")
        query.labelIds = [inputs.selectedLabel.identifier]
        if case .Unread = inputs.mode {
            query.q = "is:unread"
        }

        // Do the lazy thing and load all message headers every time this view appears. A more production ready implementation would use caching.
        let threadHeaders = rxGmail
            .listThreads(query: query)                  // RxGmail.ThreadListResponse
            .flatMap {
                rxGmail.fetchDetails($0.threads ?? [], detailType: .metadata)
            }                                           // [RxGmail.Thread] (with all headers)
            .flatMap { Observable.from($0) }            // RxGmail.Thread
            .map { thread -> Thread in
                let headers = thread.messages?.first?.parseHeaders() ?? [:]
                return Thread(
                    identifier: thread.identifier ?? "",
                    sender: headers["From"] ?? "",
                    subject: headers["Subject"] ?? "",
                    date: headers["Date"] ?? ""
                )
            }                                            // MessageHeader
            .toArray()
            .shareReplay(1)

        return ThreadsViewModelOutputs(threadHeaders: threadHeaders)
    }
}
