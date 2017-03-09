import UIKit
import RxSwift
import RxCocoa

class MessagesViewController: UITableViewController {
    let disposeBag = DisposeBag()
    var selectedLabel: Label!
    var mode: MessagesQueryMode!

    override func viewDidLoad() {
        super.viewDidLoad()

        let inputs = MessagesViewModelInputs(
            selectedLabel: selectedLabel,
            mode: mode
        )

        tableView.dataSource = nil

        let outputs = global.messagesViewModel(inputs)

        outputs.messageCells.bindTo(tableView.rx.items(cellIdentifier: "MessageCell")) {
            index, message, cell in
                cell.textLabel?.text = message.subject
                cell.detailTextLabel?.text = message.sender
        }
        .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(MessageCell.self)
            .subscribe(onNext: {
                self.performSegue(withIdentifier: "ShowMessageDetails", sender: $0)
            })
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let messageVC = segue.destination as! MessageViewController
        let message = sender as! MessageCell
        messageVC.messageId = message.identifier
    }
}
