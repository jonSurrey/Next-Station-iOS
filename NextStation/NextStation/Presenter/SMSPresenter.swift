//
//  SMSPresenter.swift
//  NextStation
//
//  Created by Jonathan Martins on 28/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

protocol SMSPresenterDelegate:class {
    
    /// Holds the sms number according to the selected line
    var smsNumber:String { get }

    /// Selects the stations related a given line
    func getStationsFor(line:Int)
    
    /// Validates if the form fields were rightfully filled
    func validateForm()
}

class SMSPresenter {
    
    /// Reference to the SMSView
    private weak var view:SMSViewDelegate!
    
    /// Internal variable to manipulate smsNumber
    private var _smsNumber = ""
    
    /// The datasource for the form list
    var formItems:[FormItem] = []
    
    /// Metro's SMS number
    let METRO_NUMBER = "973332252"
    
    /// CPTM's SMS number
    let CPTM_NUMBER = "971504949"
    
    /// Binds the view to this presenter
    func attach(to view:SMSViewDelegate){
        self.view = view
        setupItemsOptions()
    }
    
    /// Initiates the form datasource
    private func setupItemsOptions(){
        
        let lines = try! DatabaseManager.current.selectLines().map({
            BaseModel(id:$0.number.rawValue, text:"\($0.number.rawValue) - \($0.colourName)")
        })

        formItems = [FormItem(type: .SELECTION_LINE   , label: "Linha", items: lines),
                     FormItem(type: .SELECTION_STATION, label: "Próxima estação"     ),
                     FormItem(type: .TEXTFIELD_NUMBER , label: "Número do vagão"     ),
                     FormItem(type: .TEXTFIELD_TEXT   , label: "Assunto"             ),
                     FormItem(type: .TEXTFIELD_TEXT   , label: "Detalhes da denúncia")]
    }
    
    /// Sets the SMS number according to the selected line
    private func setSMSNumberFor(_ line:Int){
        let company = try! DatabaseManager.current.selectLines(number: line).first!.company!
        if company.lowercased().elementsEqual("cptm"){
            _smsNumber = CPTM_NUMBER
        }
        else{
            _smsNumber = METRO_NUMBER
        }
    }
}

/// Implementation of SMSPresenterDelegate
extension SMSPresenter:SMSPresenterDelegate {
    
    var smsNumber: String {
        get {
            return _smsNumber
        }
    }
    
    func validateForm(){
        if formItems.filter({ !$0.isChecked }).isEmpty {
            let message = formItems.map({
                "\($0.label): \($0.data!)"
            }).joined(separator:"\n")
            
            view.sendSMS(to: smsNumber, message: message)
        }
        else{
            view.displayFeedback(title: "Ops!😅", message: "Antes de enviar seu SMS, por favor, preencha todos os campos.")
        }
    }
    
    func getStationsFor(line: Int) {
        setSMSNumberFor(line)
        
        let stations = try! DatabaseManager.current.selectStations(line: line).map({
            BaseModel(id:$0.id, text:"\($0.name)")
        })
        formItems[1].items = stations
    }
}
