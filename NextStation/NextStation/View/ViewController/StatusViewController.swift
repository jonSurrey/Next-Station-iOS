//
//  StatusViewController.swift
//  NextStation
//
//  Created by Jonathan Martins on 11/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

class StatusViewController: UITableViewController {
    
    /// The controller's view, instance of StatusView
    private unowned var _view:StatusView { return self.view as! StatusView }
    
    /// The presenter for StatusPresenter
    private var presenter = StatusPresenter()
    
    /// Callback to notify the MainViewController when a line is selected in the Status list
    var onLineSelected:((Int)->Void)?
    
    override func loadView() {
        self.view = StatusView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        presenter.attach(to: self, requestService: RequestService())
        presenter.requestServiceStatus()
    }
    
    deinit {
        print("StatusViewController was dealocated")
    }
    
    /// Sets up the views
    private func setupViews(){
        _view.tableview.delegate   = self
        _view.tableview.dataSource = self
        _view.refreshControl.addTarget(self, action: #selector(refreshServiceStatus), for: UIControl.Event.valueChanged)
    }
    
    /// Action to refresh the UITableView
    @objc private func refreshServiceStatus(){
        presenter.requestServiceStatus()
    }
}

extension StatusViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let number = presenter.linesSituation[indexPath.row].number.rawValue
        self.onLineSelected?(number)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.linesSituation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell(indexPath, StatusItemCell.self)!
        cell.setupCell(for: presenter.linesSituation[indexPath.row])
        return cell
    }
}

/// Implementation of the StatusViewDelegate
extension StatusViewController:StatusViewDelegate{
    
    func hideErrorMessage() {
        _view.errorMessage.isHidden = true
    }
    
    func showErrorMessage() {
        _view.errorMessage.isHidden = false
    }
    
    func updateTableviewItems() {
        _view.indicatorView.stopAnimating()
        if _view.refreshControl.isRefreshing{
            _view.refreshControl.endRefreshing()
        }
        _view.tableview.reloadData()
    }
}
