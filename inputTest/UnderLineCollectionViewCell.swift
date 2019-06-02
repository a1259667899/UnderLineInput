//
//  UnderLineCollectionViewCell.swift
//  inputTest
//
//  Created by Sinder X D Sun on 2019/5/31.
//  Copyright © 2019 Sinder X D Sun. All rights reserved.
//

import UIKit

enum UnderlineMode {
    case normal
    case highLight
}

class UnderLineCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var flashLine: UIView!
    @IBOutlet weak var numberLable: UILabel!
    @IBOutlet weak var indicateLine: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateNumberValue(number: String? = nil, underlineMode: UnderlineMode) {
        switch underlineMode {
        case .normal:
            self.indicateLine.backgroundColor = UIColor.lightGray
            self.flashLine.isHidden = true
        case .highLight:
            self.flashLine.isHidden = false
            self.indicateLine.backgroundColor = UIColor.black
            self.flashLine.layer.add(self.opacityAnimation(time: 0.7), forKey: "A")
        }
        guard let value = number else {
            self.numberLable.text = ""
            return
        }
        self.numberLable.text = value
    }
    
    func opacityAnimation(time: Double)-> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "opacity")
        animation.fromValue = NSNumber.init(value: 1.0)
        animation.toValue = NSNumber(value: 0.0)
        animation.autoreverses = true
        animation.duration = time
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }
}

