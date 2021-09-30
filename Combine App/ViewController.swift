//
//  ViewController.swift
//  Combine App
//
//  Created by Pasha on 30.09.2021.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var purchaseButtton: UIButton!
    private var cancellable: AnyCancellable?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancellable = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: priceTextField)
            .map { $0.object as? UITextField }
            .compactMap { $0?.text}
            .map { str -> UIColor in
                if let number = Double(str){
                    if number > 10 {
                        return .green
                    }
                }
                return .red
            }
            .assign(to: \.tintColor, on: purchaseButtton)
        
        
        
    }
}

