//
//  LineViewController.swift
//  NextStation
//
//  Created by Jonathan Martins on 11/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

class LineViewController: UIViewController {
    
    /// The controller's view, instance of LineView
    private unowned var _view:LineView { return self.view as! LineView }
    
    /// The presenter for LineViewController
    private var presenter = LinePresenter()
    
    /// The datasource which holds the stations of a line
    private var stationItems:[StationItem] = []
    
    /// Callback for when a tranference is selected
    var onTransferSelected:((Int)->Void)?

    /// Callback for when a station is selected
    var onStationSelected:((Station)->Void)?
    
    override func loadView() {
        self.view = LineView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        presenter.loadStationItems()
        presenter.selectColourAndCompany()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _view.animateWrapper()
    }
    
    deinit {
        print("LineViewController was dealocated")
    }
    
    /// Initiates the presenter with the line that will be displayed
    func initPresenterWith(_ line:Line){
        presenter.attach(to: self, with: line)
    }
    
    /// Sets up views and delegates
    private func setupViews(){
        _view.tableview.delegate   = self
        _view.tableview.dataSource = self
    }
}

extension LineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        stationItems.forEach({
            $0.isSelected = false
        })
        let stationItem = stationItems[indexPath.row]
        stationItem.isSelected = true
        tableView.reloadData()
        
        onStationSelected?(stationItem.station)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell        = tableView.getCell(indexPath, StationItemCell.self)!
        let stationItem = stationItems[indexPath.row]
        
        cell.callback = onTransferSelected
        cell.setupCell(stationItem)
        
        return cell
    }
}

/// Implementation of LineViewDelegate
extension LineViewController:LineViewDelegate {
    
    func updateTableView(_ items: [StationItem]) {
        self.stationItems = items
        _view.tableview.reloadData()
    }
    
    func updateLineName(_ name: String) {
        _view.lineName.text = name
    }
    
    func updateCompanyLogo(_ logo: String) {
        _view.lineIcon.image = UIImage(named: logo)
    }
}
