//
//  ViewController.swift
//  inputTest
//
//  Created by Sinder X D Sun on 2019/5/31.
//  Copyright © 2019 Sinder X D Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let underlineView = UnderLineInputView.init(frame: CGRect(x: 50, y: 100, width: self.view.bounds.width - 100, height: 50))
        let config = UnderLineInputViewConfig(mode: .serialNumber, exceptionIndexs: [2, 5, 10], inputFinishedBlock: { inputValue in
                debugPrint("输入的 OTP Code ： \(inputValue)")
            })
        underlineView.configs = config
        self.view.addSubview(underlineView)
    }
}

