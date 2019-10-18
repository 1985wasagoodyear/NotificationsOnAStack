//
//  ViewController.swift
//  NSNotificationChain
//
//  Created by K Y on 8/19/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    static let vcAction: NSNotification.Name = .init("vcAction")
}

final class ViewController: UIViewController {

    static var vcCount = 0
    @IBOutlet var vcNumLabel: UILabel!
    
    var numText: String {
        return vcNumLabel.text ?? "Err"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vcNumLabel.text = String(ViewController.vcCount)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(observerAction),
                                               name: .vcAction,
                                               object: nil)
        print("did register VC \(numText)")
    }
    
    @objc func observerAction() {
        print("VC \(numText) reporting in")
    }
    
    @IBAction func postAction(_ sender: Any) {
        print("VC \(numText) did post notification")
        NotificationCenter.default.post(name: .vcAction,
                                        object: nil)
    }
    
    @IBAction func pushAction(_ sender: Any) {
        ViewController.vcCount += 1
        navigationController?.pushViewController(ViewController.newVC(),
                                                 animated: true)
    }
    
    deinit {
        print("VC \(numText) was destroyed!")
    }
    
}

extension ViewController {
    static func newVC() -> ViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "vc") as! ViewController
    }
}
