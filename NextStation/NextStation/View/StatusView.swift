//
//  StatusView.swift
//  NextStation
//
//  Created by Jonathan Martins on 26/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import Foundation

protocol StatusViewDelegate:class {
    
    /// Notificates the view to hide the error message
    func hideErrorMessage()
    
    /// Notificates the view to display the error message
    func showErrorMessage()
    
    /// Notificates the view to refresh the UITableView items
    func updateTableviewItems()
}

class StatusView: UIView {
    
    /// The list of the lines' status
    let tableview:UITableView = {
        let tableview = UITableView()
        tableview.estimatedRowHeight = 100
        tableview.tableFooterView = UIView()
        tableview.backgroundColor = .white
        tableview.registerCell(StatusItemCell.self)
        tableview.rowHeight = UITableView.automaticDimension
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    /// Indicates if the UITableView is refreshed
    let refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    /// Indicates if the UITableView is refreshing when the app is loads on the first time
    let indicatorView:UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.color = .black
        indicatorView.startAnimating()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    /// The error message to be displayed if the UITableView does not load the content
    let errorMessage:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.isHidden = true
        label.text = "Não foi possível carregar as situações das linhas. Deslize o dedo para atualizar."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Sets up the constraints
    private func setupConstraints(){
        
        self.addSubview(tableview)
        self.addSubview(errorMessage)
        self.addSubview(indicatorView)
        NSLayoutConstraint.activate([
            errorMessage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorMessage.bottomAnchor .constraint(equalTo: self.centerYAnchor),
            errorMessage.widthAnchor  .constraint(equalTo: self.widthAnchor, multiplier: 1/1.3),

            indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorView.bottomAnchor .constraint(equalTo: self.centerYAnchor),
            
            tableview.topAnchor     .constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableview.bottomAnchor  .constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            tableview.leadingAnchor .constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
        tableview.refreshControl = refreshControl
    }
}
