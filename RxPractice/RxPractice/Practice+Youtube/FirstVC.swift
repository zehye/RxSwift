//
//  FirstVC.swift
//  RxPractice
//
//  Created by 졔님 on 2020/10/29.
//

import UIKit
import RxSwift
import SwiftyJSON

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

class FirstVC: UIViewController {
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }
    
    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in v?.isHidden = !s},
                       completion: { [weak self] _ in self?.view.layoutIfNeeded()})
    }
    
    func downloadJson(_ url: String, completion: @escaping (String?) -> Void) {
        DispatchQueue.global().async {  // 동시에 진행 
            let url = URL(string: url)!
            let data = try! Data(contentsOf: url)
            let json = String(data: data, encoding: .utf8)
            
            DispatchQueue.main.async {
                completion(json)
            }
        }
    }
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func onLoad() {
        editView.text = ""
        self.setVisibleWithAnimation(self.activityIndicator, true)
        downloadJson(MEMBER_LIST_URL) { json in
            self.editView.text = json
            self.setVisibleWithAnimation(self.activityIndicator, false)
        }
    }
}
