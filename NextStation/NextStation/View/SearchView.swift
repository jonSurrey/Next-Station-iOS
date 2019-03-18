//
//  SearchView.swift
//  NextStation
//
//  Created by Jonathan Martins on 19/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import Foundation

protocol SearchViewDelegate:class {
    
    ///Notificates the view to update the UITableView items
    func updateTableView()
}

class SearchView: UIView {
    
    /// The searchView to perform searches
    let searchField:RoundedTextField = {
        let roundedTextField = RoundedTextField()
        roundedTextField.textField.placeholder = "Nome da estação"
        roundedTextField.translatesAutoresizingMaskIntoConstraints = false
        return roundedTextField
    }()
    
    /// The button to close the SearchViewController
    let cancelButton:UIButton = {
        let button = UIButton()
        button.setTitle("Cancelar", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.backgroundColor = .clear
        button.setTitleColor(.darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// The list of items to be filtered
    let searchResult:UITableView = {
        let tableview = UITableView()
        tableview.estimatedRowHeight = 100
        tableview.tableFooterView = UIView()
        tableview.backgroundColor = .white
        tableview.keyboardDismissMode = .onDrag
        tableview.registerCell(SearchStationCell.self)
        tableview.rowHeight = UITableView.automaticDimension
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Sets up the constraints
    private func setupConstraints(){
        self.addSubview(searchField)
        self.addSubview(cancelButton)
        self.addSubview(searchResult)
        
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            searchField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -5),
            searchField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant:15),
            
            cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            cancelButton.centerYAnchor.constraint(equalTo: searchField.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 70),
            cancelButton.heightAnchor.constraint(equalToConstant: 35),
            
            searchResult.topAnchor     .constraint(equalTo: searchField.bottomAnchor, constant: 5),
            searchResult.bottomAnchor  .constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            searchResult.leadingAnchor .constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            searchResult.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
