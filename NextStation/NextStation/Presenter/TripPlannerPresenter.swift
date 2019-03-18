//
//  TripPlannerPresenter.swift
//  NextStation
//
//  Created by Jonathan Martins on 17/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import GameplayKit

protocol TripPlannerPresenterDelegate:class {
    
    /// Graph object that holds all the nodes
    var graph:GKGraph{ get }
    
    /// Datasource for displaying the trip steps
    var tripSteps:[TripStep]{ get }
    
    /// Finds the shortest path between an origin station and destination station
    func findShortestPath()
    
    /// Sets the origin station
    func setOrigin(station:Station)
    
    /// Sets the destination station
    func setDestination(station:Station)
    
    /// Selects all stations
    func getStations() -> [Station]
    
    /// Checks the line direction given an initial station and it's next station
    func checkDirection(from currentStation:Station, to nextStation:Station?)->Station?
    
    /// Format a given minutes time to String
    func format(_ minutes:Int) -> String
}

class TripPlannerPresenter {
    
    /// Reference to the TripPlannerView
    private weak var view:TripPlannerViewDelegate!
    
    /// Datasource of nodes representing each station
    private var nodes = [StationNode]()
    
    /// Interval variable to maniplate tripSteps
    private var _tripSteps = [TripStep]()
    
    /// The origin station
    private var originStation:Station?
    
    /// The destination station
    private var destinationStation:Station?

    /// Binds the view to this presenter
    func attach(to view:TripPlannerViewDelegate){
        self.view = view
        createGraph()
    }
    
    /// Selects all stations and creates a Graph map from them
    private func createGraph() {
        getStations().forEach({
            nodes.append(StationNode($0))
        })
        graph.add(nodes)
        
        for index in 1...15 {
            var list = nodes.filter({$0.station.lineId == index})
            for (index, element) in list.enumerated() {
                let next = index+1
                if next < list.count{
                    element.addConnection(to: list[next], bidirectional: true, weight: 1.0)
                }
                let tranferences = element.station.tranferences
                for tranference in tranferences{
                    let result = nodes.first(where: {$0.station.id == tranference.id})!
                    element.addConnection(to: result, bidirectional: true, weight: 2.0)
                }
            }
        }
    }
    
    /// Creates the path description, given an array of stations
    private func createPathDescription(with stations:[Station]){
        _tripSteps.removeAll()
        
        var isTransference = false
        for (index, station) in stations.enumerated(){
            
            let nextStation = stations.element(at: index + 1)
            let direction   = checkDirection(from: station, to: nextStation)
            
            if isTransference{
                isTransference = false
                _tripSteps.append(TripStep(station: station, direction: direction, state: .TRANFERENCE))
            }
            else if index == 0{
                _tripSteps.append(TripStep(station: station, direction: direction, state: .BOARDING))
            }
            else if index == stations.count - 1{
                _tripSteps.append(TripStep(station: station, state: .EXIT))
            }
            else if station.lineId != nextStation?.lineId{
                isTransference = true
                _tripSteps.append(TripStep(station: station, state: .EXIT))
            }
            else{
                _tripSteps.append(TripStep(station: station, state: .GOING))
            }
        }
    }
}

/// Implementation of TripPlannerPresenterDelegate
extension TripPlannerPresenter:TripPlannerPresenterDelegate{
    
    var graph: GKGraph {
        return GKGraph()
    }
    
    var tripSteps: [TripStep] {
        return _tripSteps
    }

    func getStations() -> [Station] {
        return try! DatabaseManager.current.selectStations()
    }
    
    func setOrigin(station: Station) {
        let text = "Linha \(station.lineId) - \(station.name)"
        
        self.originStation = station
        self.view.updateOriginStationTextField(to: text)
    }

    func setDestination(station: Station) {
        let text = "Linha \(station.lineId) - \(station.name)"
        
        self.destinationStation = station
        self.view.updateDestinationStationTextField(to: text)
    }
    
    func findShortestPath(){
    
        guard let startStation = originStation else {
            view.showErrorMessage(title:"Ops!😅", message: "Acho que você esqueceu de selecionar a estação de origem!")
            print("The origin station was not set.")
            return
        }
        
        guard let endStation = destinationStation else {
            view.showErrorMessage(title:"Ops!😅", message: "Sem destino a gente não chega a lugar algum, né?")
            print("The destination station was not set.")
            return
        }
        
        if startStation.id == endStation.id{
            view.showErrorMessage(title:"Ajuda a gente, vai?😩", message: "A estação de origem tem que ser diferente da de destino, coleguinha!")
            print("Origin station must be different from the destination station.")
            return
        }

        let pointA = nodes.first(where: {$0.station.id == startStation.id})!
        let pointB = nodes.first(where: {$0.station.id == endStation.id})!
        let path   = graph.findPath(from: pointA, to: pointB)
    
        let stations = path.map({
            ($0 as! StationNode).station!
        })
        createPathDescription(with: stations)
        calculateAverageTripTime(with: stations)
        
        view.updateTableView()
    }
    
    func calculateAverageTripTime(with stations:[Station]){
        var time = 0.0
        for index in 1..<stations.count{
            let station = stations[index]
            time += try! (DatabaseManager.current.selectLines(number: station.lineId).first!.averageTimeBetweenStations)
        }
        view.updateAverageTripTime(to: format(Int(time)))
    }
    
    func format(_ minutes:Int) -> String {
        if minutes < 60{
            return "\(minutes) minutos"
        }
        else{
            return "\(minutes/60) hora(s) e \((minutes % 60)) minuto(s)"
        }
    }
    
    func checkDirection(from currentStation:Station, to nextStation:Station?)->Station?{
        
        let stations = try! DatabaseManager.current.selectStations(line: currentStation.lineId)
        
        guard let currentIndex = stations.firstIndex(where: { $0.id == currentStation.id }) else {
            return nil
        }
        
        guard let nextIndex = stations.firstIndex(where: { $0.id == nextStation?.id }) else {
            return nil
        }
        
        return nextIndex > currentIndex ? stations.last: stations.first
    }
}
