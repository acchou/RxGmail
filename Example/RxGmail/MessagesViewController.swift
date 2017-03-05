import UIKit
import RxSwift

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
        outputs.messageHeaders.bindTo(tableView.rx.items(cellIdentifier: "MessageCell")) {
            index, messageHeader, cell in
                cell.textLabel?.text = messageHeader.subject
                cell.detailTextLabel?.text = messageHeader.sender
        }
        .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
