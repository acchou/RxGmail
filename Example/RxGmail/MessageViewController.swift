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

        outputs.messageParts.bindTo(tableView.rx.items) { (table: UITableView, row: IndexPath, messagePart: MessagePart) in
            let cell = table.dequeueReusableCell(withIdentifier: "")
        }
        .disposed(by: disposeBag)

//        items
//            .bindTo(tableView.rx.items) { (tableView, row, element) in
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
//                cell.textLabel?.text = "\(element) @ row \(row)"
//                return cell
//            }
//            .disposed(by: disposeBag)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
