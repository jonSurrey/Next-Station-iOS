//
//  FormCell.swift
//  NextStation
//
//  Created by Jonathan Martins on 28/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

class SelectionCell:BaseCell{
    
    /// The cells label title
    private let title:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The cell's textfield
    private let textfield:UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .none
        textfield.isEnabled = false
        textfield.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textfield.placeholder = "Selecione"
        textfield.textColor = .lightGray
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    /// Configures the cell
    func configureCell(with formItem:FormItem){
        title    .text = formItem.label
        textfield.text = formItem.data
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(textfield)
        NSLayoutConstraint.activate([
            title.topAnchor    .constraint(equalTo: self.contentView.topAnchor    , constant: 15),
            title.bottomAnchor .constraint(equalTo: self.contentView.bottomAnchor , constant: -15),
            title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            
            textfield.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            textfield.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            textfield.leadingAnchor.constraint(equalTo:  title.trailingAnchor, constant: 10),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TextFieldCell:BaseCell{
    
    /// The cells label
    private let title:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The cell's textfield
    private let textfield:UITextField = {
        let textfield = UITextField()
        textfield.clearButtonMode = .whileEditing
        textfield.borderStyle = .none
        textfield.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textfield.placeholder = "Digite"
        textfield.textColor = .lightGray
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    /// Configures the cell
    func configureCell(with formItem:FormItem){
        title    .text = formItem.label
        textfield.text = formItem.data
        textfield.keyboardType = formItem.type == .TEXTFIELD_NUMBER ? .numberPad:.default
        textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    /// Callback to notify the host that the UITextField's text of this cell has changed
    var callback:((String?)->Void)?
    
    /// Notifies when something is typed in the UITextField of this cell
    @objc private func textFieldDidChange(_ textField:UITextField) {
        callback?(textField.text ?? "")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(textfield)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
        
            textfield.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            textfield.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            textfield.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            textfield.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ButtonCell:UITableViewHeaderFooterView{
    
    /// The cell's button
    let sendButton:UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 35))
        button.setTitle("Enviar SMS", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.backgroundColor = UIColor.init(hexString: "#0C3D6D")
        button.setTitleColor(.white, for: .normal)
        button.corner_Radius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// The callback to notify the host that the button was cliked
    private var callback:(()->Void)?
    
    /// Sets a callback to the button
    func addCallback(_ callback:@escaping ()->Void){
        self.callback = callback
        sendButton.addTarget(self, action: #selector(buttonDidClicked), for: .touchUpInside)
    }
    
    /// Action to notify that the button was clicked
    @objc private func buttonDidClicked(_ button:UIButton) {
        callback?()
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        
        self.contentView.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.topAnchor   .constraint(equalTo: self.contentView.topAnchor, constant: 15),
            sendButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            sendButton.centerXAnchor .constraint(equalTo: self.contentView.centerXAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 35) ,
            sendButton.widthAnchor.constraint(equalToConstant: 120) ,
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
