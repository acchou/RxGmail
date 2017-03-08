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
    // Each event is an array of the labels to show in the table
    var labels: Observable<[Label]>
}

typealias LabelViewModelType = (LabelViewModelInputs) -> LabelViewModelOutputs

func convertGmailLabelsToViewLabels(_ gmailLabels: [RxGmail.Label]) -> [Label] {
    return gmailLabels.sorted { $0.name < $1.name }
        .filter { $0.name != nil }
        .map { Label(identifier: $0.identifier!, name: $0.name!) }
}

func LabelViewModel(rxGmail: RxGmail) -> LabelViewModelType {
    return { inputs in
        let labels = rxGmail.listLabels()
            .map { $0.labels }
            .unwrap()
            .map(convertGmailLabelsToViewLabels)
            .shareReplay(1)

        return LabelViewModelOutputs(labels: labels)
    }
}
