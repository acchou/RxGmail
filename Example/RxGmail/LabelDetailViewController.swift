import UIKit
import RxSwift
import RxCocoa
import RxGmail

class LabelDetailViewController: UITableViewController {
    let disposeBag = DisposeBag()
    var selectedLabel: Label!

    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var labelListVisibility: UILabel!
    @IBOutlet weak var messageListVisibility: UILabel!
    @IBOutlet weak var messagesTotal: UILabel!
    @IBOutlet weak var messagesUnread: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var threadsTotal: UILabel!
    @IBOutlet weak var threadsUnread: UILabel!
    @IBOutlet weak var type: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let inputs = LabelDetailViewModelInputs(selectedLabel: selectedLabel)
        let outputs = global.labelDetailViewModel(inputs)

        outputs.id.bindTo(id.rx.text)
            .disposed(by: disposeBag)

        outputs.labelListVisibility.bindTo(labelListVisibility.rx.text)
            .disposed(by: disposeBag)

        outputs.messageListVisibility.bindTo(messageListVisibility.rx.text)
            .disposed(by: disposeBag)

        outputs.messagesTotal.bindTo(messagesTotal.rx.text)
            .disposed(by: disposeBag)

        outputs.messagesUnread.bindTo(messagesUnread.rx.text)
            .disposed(by: disposeBag)

        outputs.name.bindTo(name.rx.text)
            .disposed(by: disposeBag)

        outputs.threadsTotal.bindTo(threadsTotal.rx.text)
            .disposed(by: disposeBag)

        outputs.threadsUnread.bindTo(threadsUnread.rx.text)
            .disposed(by: disposeBag)

        outputs.type.bindTo(type.rx.text)
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell,
            let detailLabel = cell.detailTextLabel {
            switch detailLabel {
            case messagesTotal:
                let messagesVC = segue.destination as! MessagesViewController
                messagesVC.selectedLabel = selectedLabel
                messagesVC.mode = .All

            case messagesUnread:
                let messagesVC = segue.destination as! MessagesViewController
                messagesVC.selectedLabel = selectedLabel
                messagesVC.mode = .Unread

            // TODO: Handle threads segues.
            default:
                fatalError()
            }
        }
    }
}
