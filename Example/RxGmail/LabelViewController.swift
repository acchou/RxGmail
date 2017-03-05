import UIKit
import RxSwift
import RxCocoa
import RxGmail

class LabelViewController: UITableViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let selectedLabel = tableView.rx.modelSelected(Label.self).asObservable()

        let inputs = LabelViewModelInputs ()
        let outputs = global.labelViewModel(inputs)

        tableView.dataSource = nil

        outputs.labels.bindTo(tableView.rx.items(cellIdentifier: "Label")) { row, label, cell in
            cell.textLabel?.text = label.name
        }
        .disposed(by: disposeBag)

        selectedLabel.subscribe(onNext: {
            self.performSegue(withIdentifier: "ShowLabelDetail", sender: $0)
        })
        .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let labelDetailVC = segue.destination as! LabelDetailViewController
        labelDetailVC.selectedLabel = sender as! Label
    }
}
