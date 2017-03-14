import UIKit
import XCTest
import RxSwift
import RxBlocking
@testable import RxGmail_Example

class Tests: XCTestCase {
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let inbox = global.rxGmail.listLabels()
            .map { $0.labels?
                .map { $0.name }
                .filter { $0 == "INBOX" }
                .first
            }
            .unwrap()
            .unwrap()
            .toBlocking()
        XCTAssert(try! inbox.single() == "INBOX", "Could not load label INBOX")
    }
}
