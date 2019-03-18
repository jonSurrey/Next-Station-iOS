//
//  TripPlannerViewController.swift
//  NextStation
//
//  Created by Jonathan Martins on 17/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

class TripPlannerViewController: UIViewController {
    
    /// The controller's view, instance of SearchView
    private unowned var _view:TripPlannerView { return self.view as! TripPlannerView }
    
    /// The presenter for SearchViewController
    private var presenter = TripPlannerPresenter()
    
    override func loadView() {
        self.view = TripPlannerView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sua Viagem"
        setNavigationBar(to: .white)
        addCloseButtonToNavigationBar()
        presenter.attach(to: self)
        
        _view.tableview.delegate   = self
        _view.tableview.dataSource = self
        _view.textFieldStationA.textField.delegate = self
        _view.textFieldStationB.textField.delegate = self
        _view.searchButton.addTarget(self, action: #selector(findShortestPathAction), for: .touchUpInside)
    }
    
    deinit {
        print("TripPlannerViewController was dealocated")
    }
    
    /// Action to search the shortest path between 2 selected stations
    @objc private func findShortestPathAction() {
        presenter.findShortestPath()
    }
}

/// Implementation of the SearchSelectionDelegate
extension TripPlannerViewController:UITextFieldDelegate, SearchSelectionDelegate{
    
    func onItemSelected<T>(item: T, on view: Int){
        let station = item as! Station
        
        if view == _view.textFieldStationA.textField.tag{
            presenter.setOrigin(station: station )
        }
        else{
            presenter.setDestination(station: station)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        openSearchController(for: textField)
        return false
    }
    
    /// Opens the SearchViewController
    private func openSearchController(for textField: UITextField){
        let stations         = presenter.getStations()
        let searchController = SearchViewController<Station>()

        searchController.setItems(stations, and: textField.tag, delegate: self)
        present(searchController, animated: false, completion: nil)
    }
}

extension TripPlannerViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tripSteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.getCell(indexPath, TripStepCell.self)!
        cell.configureCell(with: presenter.tripSteps[indexPath.row])
        return cell
    }
}

/// Implementation of the TripPlannerViewDelegate
extension TripPlannerViewController: TripPlannerViewDelegate{
    
    func updateAverageTripTime(to time: String) {
        let attributtedString = NSMutableAttributedString()
        attributtedString.normal("O tempo médio de viagem será de ").bold("\(time)")
        
        _view.averageTimeLabel.attributedText = attributtedString
        _view.averageTimeLabel.isHidden = false
    }
    
    func updateTableView() {
        _view.tableview.reloadData()
    }
    
    func updateOriginStationTextField(to text:String){
        _view.textFieldStationA.textField.text = text
    }
    
    func updateDestinationStationTextField(to text:String){
        _view.textFieldStationB.textField.text = text
    }
    
    func showErrorMessage(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendi", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
