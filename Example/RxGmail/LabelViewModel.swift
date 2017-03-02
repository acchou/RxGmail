import RxSwift
import RxSwiftExt
import RxGmail

struct Label {
    var name: String
    var messageTotal: String
}

struct LabelViewModelInputs {
}

struct LabelViewModelOutputs {
    var labels: Observable<[Label]>
}

typealias LabelViewModelType = (LabelViewModelInputs) -> LabelViewModelOutputs

func getLabels(labels: [RxGmail.Label]) -> [Label] {
    return labels
        .map { Label(name: $0.name!, messageTotal: String(describing: $0.messagesTotal!)) }
        .sorted { $0.name < $1.name }
}

func LabelViewModel(rxGmail: RxGmail) -> LabelViewModelType {
    return { inputs in
        let labels = rxGmail.listLabels()
            .map { $0.labels }
            .unwrap()
            .map(getLabels)

        return LabelViewModelOutputs(labels: labels)
    }
}
