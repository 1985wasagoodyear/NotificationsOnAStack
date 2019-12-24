//
//  NotifyViewController.swift
//  NSNotificationChain
//
//  Created by K Y on 8/19/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    static let vcAction: NSNotification.Name = .init("vcAction")
}

private let center = NotificationCenter.default

final class NotifyViewController: UIViewController {

    // MARK: - Static Properties
    
    /// counter for number of VCs currently in-use
    static var vcCount = 0
    
    // MARK: - UI Properties
    
    /// UI to represent the current VC number
    @IBOutlet var vcNumLabel: UILabel!
    
    // MARK: - Properties
    
    // the current text of the VC
    var numText: String {
        return vcNumLabel.text ?? "Err"
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotifyViewController.vcCount += 1
        vcNumLabel.text = String(NotifyViewController.vcCount)
        center.addObserver(self,
                           selector: #selector(observerAction),
                           name: .vcAction,
                           object: nil)
        print("did register VC \(numText)")
    }
    
    /// override deinit to show order in which VCs are destroyed
    deinit {
        NotifyViewController.vcCount -= 1
        print("VC \(numText) was destroyed!")
    }
    
    // MARK: - Custom Action Methods
    
    /// called when a notification is posted
    /// gives insight to data structure used to contain NSNotifications
    @objc func observerAction() {
        print("VC \(numText) reporting in")
    }
    
    // MARK: - Custom Action Methods
    
    /// reports which VC posted the notification, then has all VCs listed post the notification
    @IBAction func postAction(_ sender: Any) {
        print("VC \(numText) did post notification")
        center.post(name: .vcAction,
                    object: nil)
    }
    
    /// action for posting a new VC
    @IBAction func pushAction(_ sender: Any) {
        // Core Animation Transaction block for handling many non-animated pushes
        CATransaction.begin()
        navigationController?.pushViewController(NotifyViewController.newVC(),
                                                 animated: false)
        CATransaction.commit()
    }
    
    /// helper for testing a large amount of pushes
    @IBAction func testPush100VCsAction(_ sender: Any) {
        print("now pushing 100 VCs onto navigation stack")
        for _ in 0..<100 {
            pushAction(self)
        }
    }
    
    @IBAction func flushAllVCsAction(_ sender: Any) {
        print("now flushing all VCs on navigation stack")
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension NotifyViewController {
    static func newVC() -> NotifyViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "vc") as! NotifyViewController
    }
}
