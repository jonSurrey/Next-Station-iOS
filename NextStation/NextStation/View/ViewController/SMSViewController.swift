//
//  SMSViewController.swift
//  NextStation
//
//  Created by Jonathan Martins on 28/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import MessageUI

protocol SMSViewDelegate:class {
    
    /// Notifies the view to displays a feedback message with a given title and message
    func displayFeedback(title:String, message: String)
    
    /// Notifies the view to open the SMS app on the device to send the user's message
    func sendSMS(to number:String, message:String)
}

class SMSViewController: UITableViewController {

    /// The presenter for SMSViewController
    private var presenter = SMSPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SMS Denúncia"
        setNavigationBar(to: .white)
        addCloseButtonToNavigationBar()
        
        configureTableView()
        presenter.attach(to: self)
    }
    
    deinit {
        print("SMSViewController was dealocated")
    }
    
    /// Sets up the UITableView
    private func configureTableView(){
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView     = UIView()
        self.tableView.backgroundColor     = .white
        self.tableView.estimatedRowHeight  = 100
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.registerCell(SelectionCell.self)
        self.tableView.registerCell(TextFieldCell.self)
        self.tableView.register(ButtonCell.self, forHeaderFooterViewReuseIdentifier: String(describing: ButtonCell.self))
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    /// Opens the SearchViewController
    private func openListSelectionController(with items:[BaseModel], position:Int){
        let searchController = SearchViewController<BaseModel>()
        searchController.setItems(items, and: position, delegate: self)
        present(searchController, animated: false, completion: nil)
    }
}

extension SMSViewController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let formItem = presenter.formItems[indexPath.row]
        if formItem.type == .SELECTION_STATION || formItem.type == .SELECTION_LINE{
            if formItem.items.isEmpty{
                displayFeedback(title: "Ops!😅", message: "Você deve primeiro escolher uma linha para ver as estações correspondentes a ela.")
            }
            else{
                openListSelectionController(with: formItem.items, position: indexPath.row)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.formItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formItem = presenter.formItems[indexPath.row]
        switch formItem.type {
            case .SELECTION_LINE, .SELECTION_STATION:
                let cell = tableView.getCell(indexPath, SelectionCell.self)!
                cell.configureCell(with: formItem)
                return cell
            case .TEXTFIELD_TEXT, .TEXTFIELD_NUMBER:
                let cell = tableView.getCell(indexPath, TextFieldCell.self)!
                cell.configureCell(with: formItem)
                cell.callback = { [weak self] (text) in
                    self?.presenter.formItems[indexPath.row].data = text
                }
                return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let identifier = String(describing: ButtonCell.self)
        let footer     = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! ButtonCell
        
        footer.addCallback { [weak self] in
            self?.presenter.validateForm()
        }

        return footer
    }
}

/// Implementation of the SearchSelectionDelegate
extension SMSViewController:SearchSelectionDelegate{
    
    func onItemSelected<T>(item: T, on view: Int){
        let item = (item as! BaseModel)
        
        if presenter.formItems[view].type == .SELECTION_LINE{
            presenter.getStationsFor(line: item.id)
        }
        presenter.formItems[view].data = item.text
        
        self.tableView.reloadData()
    }
}

/// Implementation of MFMessageComposeViewControllerDelegate to notify if the SMS was successfully sent
extension SMSViewController:MFMessageComposeViewControllerDelegate{
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        switch result {
            case .sent:
                displayFeedback(title: "Obrigado por ajudar!👮🏻‍♂️", message: "SMS Enviado com sucesso!")
            case .failed:
                displayFeedback(title: "Eita!😐", message: "Houve algum erro ao enviar o SMS. Verifique suas configurações e tente novamente.")
            default:
                return
        }
    }
}

/// Implementation of the SMSViewDelegate
extension SMSViewController:SMSViewDelegate{
    
    /// Displays a feddback to the user to warning that the SMS may be charged
    private func displaySMSWarning(_ composeVC:MFMessageComposeViewController) {
        let alert = UIAlertController(title: "Atenção⚠️🤔", message: "Você poderá ser cobrado por esse serviço, deseja continuar?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { [weak self] (action) in
            self?.present(composeVC, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Não", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendSMS(to number:String, message:String){
        if MFMessageComposeViewController.canSendText() {
            let composeVC  = MFMessageComposeViewController()
            composeVC.body = message
            composeVC.recipients = [number]
            composeVC.messageComposeDelegate = self
            
            self.displaySMSWarning(composeVC)
        } else {
            displayFeedback(title: "Eita!😐", message: "Parece que esse dispositivo não permite o envio de mensagens. Verifique suas configurações e tente novamente.")
        }
    }
    
    func displayFeedback(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendi", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
