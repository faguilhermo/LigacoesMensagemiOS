//
//  MainViewController.swift
//  LigacoesMensagensNativo
//
//  Created by Fabrício Guilhermo on 25/03/20.
//  Copyright © 2020 Fabrício Guilhermo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var message = Message()

    private lazy var numberTextField: UITextField = {
        let numberTextField = UITextField(frame: .zero)
        numberTextField.translatesAutoresizingMaskIntoConstraints = false
        numberTextField.placeholder = "Phone number"
        numberTextField.textContentType = .telephoneNumber
        numberTextField.keyboardType = .numberPad
        numberTextField.clearButtonMode = .always
        setupDismissNumberPad(on: numberTextField)

        return numberTextField
    }()

    private lazy var validateLabel: UILabel = {
        let validateLabel = UILabel(frame: .zero)
        validateLabel.translatesAutoresizingMaskIntoConstraints = false
        validateLabel.text = ""

        return validateLabel
    }()

    private lazy var messageButton: UIButton = {
        let messageButton = UIButton(type: .roundedRect)
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.setTitle("Enviar mensagem", for: .normal)
        messageButton.layer.cornerRadius = 25
        messageButton.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        messageButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        messageButton.addTarget(self, action: #selector(messageButtonAction(_ :)), for: .touchUpInside)

        return messageButton
    }()

    private lazy var callButton: UIButton = {
        let callButton = UIButton(type: .roundedRect)
        callButton.translatesAutoresizingMaskIntoConstraints = false
        callButton.setTitle("Fazer ligação", for: .normal)
        callButton.layer.cornerRadius = 25
        callButton.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        callButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        callButton.addTarget(self, action: #selector(callButtonAction(_ :)), for: .touchUpInside)

        return callButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        view.addSubview(numberTextField)
        view.addSubview(validateLabel)
        view.addSubview(messageButton)
        view.addSubview(callButton)

        setupLayout()
    }

    private func setupLayout() {
        numberTextField.leftAnchor
            .constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        numberTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 20).isActive = true
        numberTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        numberTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true

        validateLabel.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: 4).isActive = true
        validateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        validateLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 20).isActive = true

        messageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messageButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        messageButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: 70).isActive = true

        callButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        callButton.bottomAnchor.constraint(equalTo: messageButton.topAnchor, constant: -8).isActive = true
        callButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        callButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }

    private func setupDismissNumberPad(on textField: UITextField) {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.sizeToFit()

        textField.inputAccessoryView = toolbar
    }

    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @objc private func messageButtonAction(_ sender: UIButton) {
        guard let phoneNumber = numberTextField.text else { return }
        if let messageComponent = message.smsConfig(send: phoneNumber) {
            messageComponent.messageComposeDelegate = message
            self.present(messageComponent, animated: true, completion: nil)
        }
    }

    @objc private func callButtonAction(_ sender: UIButton) {
        guard let phoneNumber = numberTextField.text else { return }
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            fatalError()
        }
    }
}
