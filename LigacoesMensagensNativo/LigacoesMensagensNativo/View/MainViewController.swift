//
//  MainViewController.swift
//  LigacoesMensagensNativo
//
//  Created by Fabrício Guilhermo on 25/03/20.
//  Copyright © 2020 Fabrício Guilhermo. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - Vatiables
    var message = Message()
    var tempNumb = ""

    // MARK: - UI elements
    /// Creates a text field to add a telephone number.
    private lazy var numberTextField: UITextField = {
        let numberTextField = UITextField(frame: .zero)
        numberTextField.translatesAutoresizingMaskIntoConstraints = false
        numberTextField.placeholder = "Phone number"
        numberTextField.textContentType = .telephoneNumber
        numberTextField.keyboardType = .numberPad
        numberTextField.clearButtonMode = .always
        numberTextField.delegate = self
        numberTextField.addTarget(self, action: #selector(typingNumber), for: .editingChanged)
        setupDismissNumberPad(on: numberTextField)

        return numberTextField
    }()

    /// Creates a label to validate the telephone number.
    private lazy var validateLabel: UILabel = {
        let validateLabel = UILabel(frame: .zero)
        validateLabel.translatesAutoresizingMaskIntoConstraints = false
        validateLabel.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        validateLabel.text = ""

        return validateLabel
    }()

    /// Creates a button to send messages to the registered number.
    private lazy var messageButton: UIButton = {
        let messageButton = UIButton(type: .roundedRect)
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.setTitle("Enviar mensagem", for: .normal)
        messageButton.layer.cornerRadius = 25
        messageButton.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        messageButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        messageButton.addTarget(self, action: #selector(messageButtonAction(_ :)), for: .allEvents)

        return messageButton
    }()

    /// Creates a button to call to the registered number.
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

    // MARK: - Application lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        view.addSubview(numberTextField)
        view.addSubview(validateLabel)
        view.addSubview(messageButton)
        view.addSubview(callButton)
        messageButton.isHidden = true
        callButton.isHidden = true

        setupLayout()
    }

    // MARK: - Functions
    /// Add functions like send message or call due the total of numbers in the text field.
    /// - Parameter textField: The text field with a number pad to add a done button to dismiss keyboard.
    private func setupDismissNumberPad(on textField: UITextField) {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.sizeToFit()

        textField.inputAccessoryView = toolbar
    }

    /// Add functions like send message or call due the total of numbers in the text field.
    /// - Parameter textField: The text field to be limited and recieve the actions.
    @objc private func typingNumber(textField: UITextField){
        if let typedText = textField.text {
            tempNumb = typedText
            if tempNumb.count < 8 {
                validateLabel.text = "Digite um número válido"
                messageButton.isHidden = true
                callButton.isHidden = true
            } else if tempNumb.count == 8 {
                validateLabel.text = ""
                messageButton.isHidden = true 
                callButton.isHidden = false
            } else {
                validateLabel.text = ""
                messageButton.isHidden = false
            }
        }
    }

    /// Dismiss the keyboard when the button done is clicked
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }

    // MARK: - Button action
    /// Message button action, present the message component to send a message.
    /// - Parameter _: the button itself
    @objc private func messageButtonAction(_ sender: UIButton) {
        guard let phoneNumber = numberTextField.text else { return }
        if let messageComponent = message.smsConfig(send: phoneNumber) {
            messageComponent.messageComposeDelegate = message
            self.present(messageComponent, animated: true, completion: nil)
        }
    }

    /// Call button action, show the option to call the telephone number shown.
    /// - Parameter _: the button itself.
    @objc private func callButtonAction(_ sender: UIButton) {
        guard let phoneNumber = numberTextField.text else { return }
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            fatalError()
        }
    }
}

// MARK: - Extensions
extension MainViewController: UITextFieldDelegate {
    // Asks the delegate if the specified text should be changed.
    // And gives a max length of characters allowed in the text field (9)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = numberTextField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else { return false }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 9
    }
}

extension MainViewController {
    /// Setup all elements constraints.
    private func setupLayout() {
        numberTextField.leftAnchor
            .constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        numberTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        numberTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        numberTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true

        validateLabel.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: 4).isActive = true
        validateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        validateLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true

        messageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messageButton.bottomAnchor.constraint(equalTo: callButton.topAnchor, constant: -8).isActive = true
        messageButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        messageButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: 70).isActive = true

        callButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        callButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        callButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        callButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        callButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
}
