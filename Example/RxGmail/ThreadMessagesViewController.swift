//
//  ThreadMessagesViewController.swift
//  RxGmail
//
//  Created by Andy Chou on 3/6/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ThreadMessagesViewController: UITableViewController {
    let disposeBag = DisposeBag()
    var threadId: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        let inputs = ThreadMessagesViewModelInputs(threadId: threadId)
        let outputs = global.threadMessagesViewModel(inputs)

        tableView.dataSource = nil

        outputs.messageCells.bindTo(tableView.rx.items(cellIdentifier: "ThreadMessageCell")) { index, message, cell in
            cell.textLabel?.text = message.subject
            cell.detailTextLabel?.text = message.sender
        }
        .disposed(by: disposeBag)
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
