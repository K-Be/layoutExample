//
//  ViewController.swift
//  ConstraintAnimationExample
//
//  Created by Andrew Romanov on 18.03.2022.
//

import UIKit

struct StaticLogger {

    fileprivate static var logBlock: ((_ text: String) -> Void )?

    static func log(_ text: String) {
        logBlock?(text)
    }

}


class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var xPosTextField: UITextField!
    @IBOutlet var animateButton: UIButton!
    @IBOutlet var shouldCallNeedLayout: UISwitch!
    @IBOutlet var outputTextView: UITextView!

    var xPositionOfView: NSLayoutConstraint?

    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        self.configStaticLogger()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configStaticLogger()
    }

    func configStaticLogger() {
        StaticLogger.logBlock = { [weak self] (text: String) in
            self?.log(text)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.xPosTextField.delegate = self
        self.animateButton.addTarget(self, action: #selector(changeAction(_:)), for: .touchUpInside)
        self.addMovingSubview()
    }

    // MARK: Actions
    @objc func changeAction(_ sender: Any?) {
        guard let input = self.xPosTextField.text, let position = Int(input), let constraint = self.xPositionOfView else {
            assert(false)
        }
        StaticLogger.log("will change constraint")
        constraint.constant = CGFloat(position)
        StaticLogger.log("did change constraint")
        if self.shouldCallNeedLayout.isOn {
            StaticLogger.log("will call setNeedsLayout")
            self.view.setNeedsLayout()
            StaticLogger.log("did call setNeedsLayout")
        }
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: [],
                       animations: {
            self.view.layoutIfNeeded()
        },
                       completion: nil)
    }

    // MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentString = textField.text as NSString? else {
            return false
        }
        let resultString = currentString.replacingCharacters(in: range, with: string)
        let isInt = Int(resultString) != nil
        return isInt
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.xPosTextField.resignFirstResponder()
        return false
    }

}

fileprivate extension ViewController {
    func addMovingSubview() {
        let mView = CustomView(frame: .zero)
        mView.backgroundColor = UIColor.red
        mView.isUserInteractionEnabled = false

        self.view.addSubview(mView)

        mView.translatesAutoresizingMaskIntoConstraints = false
        mView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        mView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        mView.topAnchor.constraint(equalTo: self.animateButton.bottomAnchor, constant: 20.0).isActive = true
        self.xPositionOfView = mView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0)
        self.xPositionOfView?.isActive = true
    }

    func log(_ text: String) {
        var currentText = self.outputTextView.text ?? ""
        if !currentText.isEmpty {
            currentText.append(contentsOf: "\n")
        }
        currentText.append(contentsOf: text)
        self.outputTextView.text = currentText
    }
}

