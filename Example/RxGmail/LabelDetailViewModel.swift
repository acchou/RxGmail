import RxSwift
import RxGmail

struct LabelDetailViewModelInputs {
    var selectedLabel: Label
}

struct LabelDetailViewModelOutputs {
    var id: Observable<String?>
    var labelListVisibility: Observable<String?>
    var messageListVisibility: Observable<String?>
    var messagesTotal: Observable<String?>
    var messagesUnread: Observable<String?>
    var name: Observable<String?>
    var threadsTotal: Observable<String?>
    var threadsUnread: Observable<String?>
    var type: Observable<String?>
}

typealias LabelDetailViewModelType = (LabelDetailViewModelInputs) -> LabelDetailViewModelOutputs

func LabelDetailViewModel(rxGmail: RxGmail) -> LabelDetailViewModelType {
    return { inputs in
        let response = rxGmail.getLabel(labelId: inputs.selectedLabel.identifier).shareReplay(1)

        let id = response.map { $0.identifier }
        let labelListVisibility = response.map { $0.labelListVisibility }
        let messageListVisibility = response.map { $0.messageListVisibility }
        let messagesTotal = response.map { $0.messagesTotal?.stringValue }
        let messagesUnread = response.map { $0.messagesUnread?.stringValue }
        let name = response.map { $0.name }
        let threadsTotal = response.map { $0.threadsTotal?.stringValue }
        let threadsUnread = response.map { $0.threadsUnread?.stringValue }
        let type = response.map { $0.type }

        return LabelDetailViewModelOutputs (
            id: id,
            labelListVisibility: labelListVisibility,
            messageListVisibility: messageListVisibility,
            messagesTotal: messagesTotal,
            messagesUnread: messagesUnread,
            name: name,
            threadsTotal: threadsTotal,
            threadsUnread: threadsUnread,
            type: type
        )
    }
}
