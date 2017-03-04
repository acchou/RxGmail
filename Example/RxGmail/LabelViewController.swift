import UIKit
import RxSwift
import RxCocoa
import RxGmail

class LabelViewController: UITableViewController, LabelViewModelInjector {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let selectedLabel = tableView.rx.modelSelected(Label.self).asObservable()
        
        let inputs = LabelViewModelInputs (
            selectedLabel: selectedLabel
        )

        let outputs = labelViewModel(inputs)

        tableView.dataSource = nil

        outputs.labels.bindTo(tableView.rx.items(cellIdentifier: "Label")) { row, label, cell in
            cell.textLabel?.text = label.name
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
