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

        tableView.rx
            .modelSelected(MessageCell.self)
            .subscribe(onNext: {
                self.performSegue(withIdentifier: "ShowThreadMessageDetails", sender: $0)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let messageVC = segue.destination as! MessageViewController
        let message = sender as! MessageCell
        messageVC.messageId = message.identifier
    }
}
