//
//  SearchViewController.swift
//  NextStation
//
//  Created by Jonathan Martins on 19/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

protocol SearchSelectionDelegate:class {
    
    /// Notifies the host which item was selected and which view triggered the SearchViewController to open
    func onItemSelected<T:Filterable>(item:T, on view:Int)
}

class SearchViewController<T:Filterable>: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    /// The ID of the source that opened the SearchViewController
    private var viewSource:Int!
    
    /// Callback to notify the whoever opened the SearchViewController
    private weak var delegate:SearchSelectionDelegate!
    
    /// The presenter for SearchViewController
    private var presenter = SearchPresenter<T>()
    
    /// The controller's view, instance of SearchView
    private unowned var _view:SearchView { return self.view as! SearchView }
    
    override func loadView() {
        self.view = SearchView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _view.searchResult.delegate   = self
        _view.searchResult.dataSource = self
        _view.cancelButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        _view.searchField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    deinit {
        print("SearchViewController was dealocated")
    }
    
    /// Notifies when the TextField content has changed
    @objc private func textFieldDidChange(_ textField:UITextField) {
        let text = textField.text ?? ""
        presenter.filterItems(contains: text)
    }
    
    /// Sets the datasource to be searched and the source that opened the SearchViewController
    func setItems(_ items:[T], and viewSource:Int, delegate:SearchSelectionDelegate){
        self.delegate   = delegate
        self.viewSource = viewSource
        presenter.attach(to: self, and: items)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = presenter.items[indexPath.row]
        delegate.onItemSelected(item: item, on: viewSource)
        dismissViewController()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.items[indexPath.row]
        if let station = item as? Station{
            let cell = tableView.getCell(indexPath, SearchStationCell.self)!
            cell.configureCell(with: station)
            return cell
        }
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = item.filterValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items.count
    }
}

/// Implementation of the SearchViewDelegate
extension SearchViewController:SearchViewDelegate{
    func updateTableView() {
        self._view.searchResult.reloadData()
    }
}
