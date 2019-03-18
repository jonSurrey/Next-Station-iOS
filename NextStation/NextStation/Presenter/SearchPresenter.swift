//
//  SearchPresenter.swift
//  NextStation
//
//  Created by Jonathan Martins on 21/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

protocol SearchPresenterDelegate:class {
    
    associatedtype T:Filterable
    
    /// The items which the Controller will display. The items' type can be any type that conforms the Filterable protocol
    var items:[T]{ get }
    
    /// Filters the items that constains the given text
    func filterItems(contains text:String)
}

class SearchPresenter<T:Filterable> {
    
    /// Holds all the items of the list
    private var _items:[T] = []
    
    /// Holds only the items filtered from the _items
    private var _filteredItems:[T] = []
    
    /// Reference to the SearchView
    private weak var view:SearchViewDelegate!
    
    /// Binds the view and datasource to this presenter
    func attach(to view:SearchViewDelegate, and items:[T]){
        self.view   = view
        self._items = items
        self._filteredItems = self._items
    }
}

/// Implementation of the SearchPresenterDelegate
extension SearchPresenter:SearchPresenterDelegate{
    
    var items: [T] {
        return _filteredItems
    }
    
    func filterItems(contains text: String) {
        if !text.isEmpty{
            _filteredItems = _items.filter({
                $0.filterValue.normalized().contains(text.normalized())
            })
        }
        else{
            _filteredItems = _items
        }
        view.updateTableView()
    }
}
