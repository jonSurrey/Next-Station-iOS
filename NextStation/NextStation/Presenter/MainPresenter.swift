//
//  MainPresenter.swift
//  NextStation
//
//  Created by Jonathan Martins on 28/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

protocol MainPresenterDelegate:class {
    
    /// Selects the colour of a given line and notifies the view to update it
    func getColourFor(line index:Int)
    
    /// Selects a line of a given index
    func getLine(for index:Int) -> Line?
    
    /// Notifies to the view the index page related to a line
    func selectIndexFor(line index:Int)
    
    /// Formats a String to the first - last stations' name
    func getTitleFor(line index:Int)
    
    /// Notifies the view to set the line's origin - destination name
    func firstAndLastStationNameFor(line number:Int)->String
}

class MainPresenter{
    
    /// Reference to the MainView
    private weak var view:MainViewDelegate!
    
    /// The datasource for the TabLayout
    let tabs = [(number:0 ,title:"Status" ),
                (number:1 ,title:"Linha 1"),
                (number:2 ,title:"Linha 2"),
                (number:3 ,title:"Linha 3"),
                (number:4 ,title:"Linha 4"),
                (number:5 ,title:"Linha 5"),
                (number:7 ,title:"Linha 7"),
                (number:8 ,title:"Linha 8"),
                (number:9 ,title:"Linha 9"),
                (number:10,title:"Linha 10"),
                (number:11,title:"Linha 11"),
                (number:12,title:"Linha 12"),
                (number:13,title:"Linha 13"),
                (number:15,title:"Linha 15")]
    
    /// Binds the view to this presenter
    func attach(to view:MainViewDelegate){
        self.view = view
    }
}

/// Implementation of the MainPresenterDelegate
extension MainPresenter:MainPresenterDelegate{
    
    func selectIndexFor(line number: Int) {
        guard let index = tabs.firstIndex(where: {$0.number == number}) else {
            return
        }
        view.movePagingViewController(to: index)
    }
    
    func getLine(for index:Int) -> Line? {
        return try! DatabaseManager.current.selectLines(number:tabs[index].number).first
    }
    
    func getTitleFor(line index:Int){
        let title = firstAndLastStationNameFor(line: index)
        view.setNavigationBar(title: title)
    }
    
    func firstAndLastStationNameFor(line index:Int)->String{
        let stations = getLine(for: index)?.stations
        if let first = stations?.first?.name, let last = stations?.last?.name{
            return "\(first) - \(last)"
        }
        else{
            return "Situação das Linhas"
        }
    }
    
    func getColourFor(line index:Int){
        if let line = try! DatabaseManager.current.selectLines(number: tabs[index].number).first{
            switch line.number {
                case .AZUL, .VERDE, .VERMELHA, .LILAS, .RUBI, .ESMERALDA, .CORAL, .JADE, .TURQUESA, .SAFIRA:
                    view.setNavigationTitleColour(to: "#FFFFFFFF")
                    view.setStatusBarTo(darkMode: false)
                case .AMARELA, .DIAMANTE, .PRATA:
                    view.setNavigationTitleColour(to: "#FF000000")
                    view.setStatusBarTo(darkMode: true)
            }
            let colour = line.colour
            view.setBackgroundColour(to: colour)
        }
        else{
            view.setStatusBarTo(darkMode: false)
            view.setBackgroundColour (to: "#0C3D6D")
            view.setNavigationTitleColour(to: "#FFFFFF")
        }
    }
}
