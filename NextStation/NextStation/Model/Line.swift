//
//  Line.swift
//  NextStation
//
//  Created by Jonathan Martins on 23/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation

/// Types the possible status of a line
enum Status{
    case NORMAL
    case REDUZIDA
    case PARALISADA
    case ENCERRADA
    case PARCIAL
    case UNKNOWN
}

/// Types the lines' number to their correspondent colour
enum LineNumber:Int, Decodable {
    case AZUL      = 1
    case VERDE     = 2
    case VERMELHA  = 3
    case AMARELA   = 4
    case LILAS     = 5
    case RUBI      = 7
    case DIAMANTE  = 8
    case ESMERALDA = 9
    case TURQUESA  = 10
    case CORAL     = 11
    case SAFIRA    = 12
    case JADE      = 13
    case PRATA     = 15
}

struct Line:Decodable {
    
    enum CodingKeys: String, CodingKey {
        case _status     = "Status"
        case number      = "LinhaId"
        case description = "Descricao"
        case _lastUpdate = "DataGeracao"
    }
    
    /// Indicates the operational status of the line
    private var _status:String?
    var status:Status{
        get{
            return formattedStatus()
        }
    }
    
    /// Indicates when the line status was updated
    private var _lastUpdate:String?
    var lastUpdate:String{
        get{
            return formattedStatusTime()
        }
        set(newValue){
            _lastUpdate = newValue
        }
    }
    
    /// The colour of the line
    var colour:String{
        get{
            return getColour()
        }
    }
    
    /// The company logo icon name
    var companyImageName:String{
        get{
            return formattedComapanyImageName()
        }
    }
    
    /// The colour's name of the line
    var colourName:String{
        get{
            return getColourName()
        }
    }
    
    /// The number of the line
    var number:LineNumber
    
    /// The company which the line belongs
    var company:String?
    
    /// The stations of the line
    var stations:[Station] = []
    
    /// The average time between the stations
    var averageTimeBetweenStations:Double = 0.0
    
    /// The coordinates for the line's path
    var path:[Path] = []
    
    /// Indicates if there is any ocurrence on the line
    var description:String?
    
    init(_ number:Int, _ company:String = "", _ path:[Path] = [], _ stations:[Station] = [], _ averageTimeBetweenStations:Double=0.0){
        self.path        = path
        self.number      = LineNumber(rawValue: number)!
        self.company     = company
        self.stations    = stations
        self.averageTimeBetweenStations = averageTimeBetweenStations
    }
    
    /// mMkes the company's image name
    private func formattedComapanyImageName()->String{
        switch number {
            case .AZUL, .VERDE, .VERMELHA, .PRATA:
                return "logo_metro"
            case .AMARELA:
                return "logo_viaquatro"
            case .LILAS:
                return "logo_viamobilidade"
            case .RUBI, .DIAMANTE, .ESMERALDA, .TURQUESA, .CORAL, .SAFIRA, .JADE:
                return "logo_cptm"
        }
    }
    
    /// Wraps the situation in a LineNumber ENUM
    private func formattedStatus() -> Status {
        guard let _status = _status else{
            return Status.UNKNOWN
        }
        
        if _status.lowercased().contains("normal"){
           return Status.NORMAL
        }
        else if _status.lowercased().contains("reduzida"){
            return Status.REDUZIDA
        }
        else if _status.lowercased().contains("paralisada"){
            return Status.PARALISADA
        }
        else if _status.lowercased().contains("encerrada"){
            return Status.ENCERRADA
        }
        else if _status.lowercased().contains("parcial"){
            return Status.PARCIAL
        }
        return Status.UNKNOWN
    }
    
    /// Returns the line coulour according to its number
    private func getColour() -> String {
        switch number {
            case .AZUL:
                return "#0455A1"
            case .VERDE:
                return "#007E5E"
            case .VERMELHA:
                return "#EE372F"
            case .AMARELA:
                return "#FFD400"
            case .LILAS:
                return "#9B3894"
            case .RUBI:
                return "#CA016B"
            case .DIAMANTE:
                return "#97A098"
            case .ESMERALDA:
                return "#02A396"
            case .TURQUESA:
                return "#0A798C"
            case .CORAL:
                return "#F2846A"
            case .SAFIRA:
                return "#133C8D"
            case .JADE:
                return "#0DA667"
            case .PRATA:
                return "#B0BEC5"
        }
    }
    
    /// Returns the line coulour name according to its number
    private func getColourName() -> String {
        switch number {
            case .AZUL:
                return "Azul"
            case .VERDE:
                return "Verde"
            case .VERMELHA:
                return "Vermelha"
            case .AMARELA:
                return "Amarela"
            case .LILAS:
                return "Lilás"
            case .RUBI:
                return "Rubi"
            case .DIAMANTE:
                return "Diamante"
            case .ESMERALDA:
                return "Esmeralda"
            case .TURQUESA:
                return "Turquesa"
            case .CORAL:
                return "Coral"
            case .SAFIRA:
                return "Safira"
            case .JADE:
                return "Jade"
            case .PRATA:
                return "Prata"
        }
    }
    
    /// Formats the last update status time 
    private func formattedStatusTime()->String{
        
        guard let date = _lastUpdate else{
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale     = Locale(identifier: "pt")
        
        if let date = dateFormatter.date(from: date){
            dateFormatter.dateFormat = "dd/MM/yyyy - HH:mm"
            return dateFormatter.string(from: date)
        }
        
        return "-"
    }
}
