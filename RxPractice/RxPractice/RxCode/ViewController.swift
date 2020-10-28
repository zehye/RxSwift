//
//  ViewController.swift
//  RxPractice
//
//  Created by 졔님 on 2020/10/28.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    var counter: Int = 0
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countLbl: UILabel!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.counter += 1
            self.countLbl.text = "\(self.counter)"
        }
    }
    
    func rxswiftLoadImage(from imageURl: String) -> Observable<UIImage?> {
        return Observable.create { seal in
            asyncLoadImage(from: imageURl) { image in
                seal.onNext(image)
                seal.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    @IBAction func onLoadImage(_ sender: Any) {
        imageView.image = nil
        
        let disposable = rxswiftLoadImage(from: LARGER_IMAGE_URL)
            .observeOn(MainScheduler.instance)
            .subscribe({ result in
                switch result {
                case let .next(image):
                    self.imageView.image = image
                    
                case let .error(err):
                    print(err.localizedDescription)
                    
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        disposeBag = DisposeBag()
    }
    
    
}

