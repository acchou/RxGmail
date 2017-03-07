import UIKit
import RxSwift
import RxCocoa

class MessageViewController: UITableViewController {
    let disposeBag = DisposeBag()
    var messageId: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        let inputs = MessageViewModelInputs(messageId: messageId)
        let outputs = global.messageViewModel(inputs)

        tableView.dataSource = nil

        outputs.messageParts.bindTo(tableView.rx.items) { table, row, messagePart in
            switch messagePart {
            case let .header(name, value):
                let cell = table.dequeueReusableCell(withIdentifier: "HeaderCell")!
                cell.textLabel?.text = name
                cell.detailTextLabel?.text = value
                return cell

            case let .body(contents):
                let cell = table.dequeueReusableCell(withIdentifier: "MessageBodyCell")!
                cell.textLabel?.text = contents
                return cell
            }
        }
        .disposed(by: disposeBag)
    }
}
