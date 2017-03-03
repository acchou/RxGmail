import RxSwift
import RxSwiftExt
import RxGmail

struct Label {
    var identifier: String
    var name: String
}

func <(lhs: String?, rhs: String?) -> Bool {
    if lhs == rhs { return false }
    guard let lhs = lhs else { return true }
    guard let rhs = rhs else { return false }
    return lhs < rhs
}

struct LabelViewModelInputs {
}

struct LabelViewModelOutputs {
    var labels: Observable<[Label]>
}

typealias LabelViewModelType = (LabelViewModelInputs) -> LabelViewModelOutputs

func getLabels(labels: [RxGmail.Label]) -> [Label] {
    return labels.sorted { $0.name < $1.name }
        .filter { $0.name != nil }
        .map { Label(identifier: $0.identifier!, name: $0.name!) }
}

func LabelViewModel(rxGmail: RxGmail) -> LabelViewModelType {
    return { inputs in
        let labels = rxGmail.listLabels()
            .debug("labels")
            .map { $0.labels }
            .unwrap()
            .map(getLabels)

        return LabelViewModelOutputs(labels: labels)
    }
}
