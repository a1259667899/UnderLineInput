//
//  UnderLineInputView.swift
//  inputTest
//
//  Created by Sinder X D Sun on 2019/5/31.
//  Copyright © 2019 Sinder X D Sun. All rights reserved.
//

import UIKit

typealias OTPInputFinishedBlock = (String)->Void

struct UnderLineInputViewConfig {
    var mode: InputViewMode = .otpCode
    var exceptionIndexs: [Int] = []
    var inputFinishedBlock: OTPInputFinishedBlock?
}

enum InputViewMode: Int {
    case otpCode      = 6
    case serialNumber = 12
}

struct InputValueModel {
    var value: String?
    var underLineMode: UnderlineMode = .normal
}

class UnderLineInputView: UIView {
    var inputModels: [InputValueModel]!
    var inputTextField: UITextField!
    var maskedView: UIView!
    var numberCollectionView: UICollectionView!
    
    var mode: InputViewMode = .otpCode
    
    var inputFinishedBlock: OTPInputFinishedBlock?
    
    var exceptionIndexs = [2, 10]
    
    var configs: UnderLineInputViewConfig! {
        didSet {
            self.initValues()
        }
    }
    
    var scale = 0    //floating scale with serialNumber format
    
}

extension UnderLineInputView {
    
    func initValues() {
        self.inputFinishedBlock = self.configs.inputFinishedBlock
        self.mode = self.configs.mode
        self.exceptionIndexs = self.configs.exceptionIndexs
        let defaultValue = InputValueModel()
        inputModels = [InputValueModel].init(repeating: defaultValue, count: self.mode.rawValue)
        inputModels[0].underLineMode = .highLight
        self.setupViews()
    }
    
    func setupViews() {
        inputTextField = UITextField()
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.delegate = self
        inputTextField.keyboardType = .numberPad
        maskedView = UIView()
        maskedView.translatesAutoresizingMaskIntoConstraints = false
        maskedView?.backgroundColor = UIColor.white
        numberCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        numberCollectionView.translatesAutoresizingMaskIntoConstraints = false
        numberCollectionView.register(UINib(nibName: "UnderLineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        numberCollectionView.register(UINib(nibName: "UndrLineFormatLineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell_1")
        numberCollectionView.delegate = self
        numberCollectionView.dataSource = self
        numberCollectionView.backgroundColor = UIColor.white
        self.addSubview(inputTextField)
        self.addSubview(maskedView)
        self.addSubview(numberCollectionView)
        
        let inputTextFieldH = "H:|-0-[inputTextField]-0-|"
        let inputTextFieldV = "V:|-0-[inputTextField]-0-|"
        let maskedViewH = "H:|-0-[maskedView]-0-|"
        let maskedViewV = "V:|-0-[maskedView]-0-|"
        let numberCollectionViewH = "H:|-0-[numberCollectionView]-0-|"
        let numberCollectionViewV = "V:|-0-[numberCollectionView]-0-|"
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: inputTextFieldH, options: [], metrics: nil, views: ["inputTextField": inputTextField]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: inputTextFieldV, options: [], metrics: nil, views: ["inputTextField": inputTextField]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: maskedViewH, options: [], metrics: nil, views: ["maskedView": maskedView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: maskedViewV, options: [], metrics: nil, views: ["maskedView": maskedView]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: numberCollectionViewH, options: [], metrics: nil, views: ["numberCollectionView": numberCollectionView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: numberCollectionViewV, options: [], metrics: nil, views: ["numberCollectionView": numberCollectionView]))
        
        self.inputTextField.becomeFirstResponder()
    }
}

extension UnderLineInputView: UITextFieldDelegate {
    /*
     The replacement string for the specified range. During typing, this parameter normally contains only the single new character that was typed, but it may contain more characters if the user is pasting text. When the user deletes one or more characters, the replacement string is empty.
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        debugPrint("textField.String:\(String(describing: textField.text))\n range:\(range.upperBound),\(range.lowerBound)\n replacementString:\(string)")
        if string.isEmpty {// is deledate action
            if self.mode == .otpCode {
                let defaultModel = InputValueModel(value: nil, underLineMode: .highLight)
                self.inputModels[range.lowerBound] = defaultModel
                if range.upperBound <= self.inputModels.count - 1 {
                    self.inputModels[range.upperBound].underLineMode = .normal
                }
                self.numberCollectionView.reloadData()
                return true
            } else {
                
                let defaultModel = InputValueModel(value: nil, underLineMode: .normal)
                let heightModel = InputValueModel(value: nil, underLineMode: .highLight)
                
                if self.exceptionIndexs.contains(range.lowerBound + scale) {
                    scale -= 1
                }
                debugPrint("upperBound: \(range.upperBound), lowerBound: \(range.lowerBound)   scale:  \(scale)")
                self.inputModels[range.lowerBound + scale] = heightModel
                if range.upperBound < self.inputModels.count - self.exceptionIndexs.count {
                    if self.exceptionIndexs.contains(range.upperBound + scale) {
                        self.inputModels[range.upperBound + scale + 1] = defaultModel
                    }
                    self.inputModels[range.upperBound + scale] = defaultModel
                }
                self.numberCollectionView.reloadData()
                return true
            }
        } else {
            if self.mode == .otpCode {
                if range.upperBound < self.inputModels.count {
                    let defaultModel = InputValueModel(value: string, underLineMode: .normal)
                    self.inputModels[range.lowerBound] = defaultModel
                    if range.upperBound < self.inputModels.count - 1 {
                        self.inputModels[range.lowerBound + 1].underLineMode = .highLight
                    }
                    self.numberCollectionView.reloadData()
                    if range.upperBound == self.inputModels.count - 1 {
                        self.inputFinishedBlock?(textField.text! + string)
                    }
                    return true
                }
                return false
            } else {
                if range.upperBound < self.inputModels.count - self.exceptionIndexs.count {
                    let defaultModel = InputValueModel(value: string, underLineMode: .normal)
                    self.inputModels[range.upperBound + scale] = defaultModel
                    if self.exceptionIndexs.contains(range.upperBound + 1 + scale) {
                        scale += 1
                        self.inputModels[range.upperBound + scale - 1] = defaultModel
                    }
                    if range.upperBound < self.inputModels.count - 1 - self.exceptionIndexs.count {
                        self.inputModels[range.upperBound + 1 + scale].underLineMode = .highLight
                    }
                    
                    self.numberCollectionView.reloadData()
                    if range.upperBound == self.inputModels.count - 1 - self.exceptionIndexs.count {
                        self.inputFinishedBlock?(textField.text! + string)
                    }
                    return true
                }
                return false
            }
        }
    }
}

extension UnderLineInputView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.inputModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.mode {
        case .otpCode:
            let cell:UnderLineCollectionViewCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UnderLineCollectionViewCell
            cell.updateNumberValue(number: self.inputModels[indexPath.row].value, underlineMode: self.inputModels[indexPath.row].underLineMode)
            return cell
        case .serialNumber:
            if self.exceptionIndexs.contains(indexPath.row) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_1", for: indexPath)
                return cell
            } else {
                let cell:UnderLineCollectionViewCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UnderLineCollectionViewCell
                cell.updateNumberValue(number: self.inputModels[indexPath.row].value, underlineMode: self.inputModels[indexPath.row].underLineMode)
                return cell
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.bounds.width - CGFloat(self.inputModels.count - 1) * 10) / CGFloat(self.inputModels.count), height: self.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.inputTextField.becomeFirstResponder()
    }
}
