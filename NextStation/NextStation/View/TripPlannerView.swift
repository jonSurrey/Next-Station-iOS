//
//  TripPlannerView.swift
//  NextStation
//
//  Created by Jonathan Martins on 17/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import Foundation

protocol TripPlannerViewDelegate:class {
    
    /// Notifies the view to update the UITableview items
    func updateTableView()
    
    /// Notifies the view to display a given error title and message
    func showErrorMessage(title:String, message:String)
    
    /// Notifies the view to update the origin textField
    func updateOriginStationTextField(to text:String)
    
    /// Notifies the view to update the destination textField
    func updateDestinationStationTextField(to text:String)
    
    /// Notifies the view to update the average trip time
    func updateAverageTripTime(to time:String)
    
}

class TripPlannerView: UIView {
    
    /// The selection field for the origin station
    let textFieldStationA:RoundedTextField = {
        let roundedTextField = RoundedTextField()
        roundedTextField.textField.tag = 0
        roundedTextField.textField.placeholder = "Estação origem"
        roundedTextField.translatesAutoresizingMaskIntoConstraints = false
        return roundedTextField
    }()
    
    /// The selection field for the destination station
    let textFieldStationB:RoundedTextField = {
        let roundedTextField = RoundedTextField()
        roundedTextField.textField.tag = 1
        roundedTextField.textField.placeholder = "Estação destino"
        roundedTextField.translatesAutoresizingMaskIntoConstraints = false
        return roundedTextField
    }()
    
    /// The list to display the steps between 2 stations
    let tableview:UITableView = {
        let tableview = UITableView()
        tableview.estimatedRowHeight = 100
        tableview.tableFooterView = UIView()
        tableview.backgroundColor = .white
        tableview.separatorStyle  = .none
        tableview.registerCell(TripStepCell.self)
        tableview.rowHeight = UITableView.automaticDimension
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    /// The button to perform the search
    let searchButton:UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 35))
        button.setTitle("Buscar", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.backgroundColor = UIColor.init(hexString: "#0C3D6D")
        button.setTitleColor(.white, for: .normal)
        button.corner_Radius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Shows the average time for the complete trip
    let averageTimeLabel:UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        self.addSubview(tableview)
        self.addSubview(searchButton)
        self.addSubview(averageTimeLabel)
        self.addSubview(textFieldStationA)
        self.addSubview(textFieldStationB)
        
        NSLayoutConstraint.activate([
            textFieldStationA.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textFieldStationA.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/1.2),
            textFieldStationA.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant:10),
            
            textFieldStationB.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textFieldStationB.widthAnchor.constraint(equalTo: textFieldStationA.widthAnchor),
            textFieldStationB.topAnchor.constraint(equalTo: textFieldStationA.bottomAnchor, constant: 10),
            
            searchButton.topAnchor     .constraint(equalTo: textFieldStationB.bottomAnchor, constant: 15),
            searchButton.centerXAnchor .constraint(equalTo: self.centerXAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 35) ,
            searchButton.widthAnchor.constraint(equalToConstant: 120) ,

            averageTimeLabel.topAnchor     .constraint(equalTo: searchButton.bottomAnchor, constant: 10),
            averageTimeLabel.leadingAnchor .constraint(equalTo: textFieldStationA.leadingAnchor),
            averageTimeLabel.trailingAnchor.constraint(equalTo: textFieldStationA.trailingAnchor),
            
            tableview.topAnchor     .constraint(equalTo: averageTimeLabel.bottomAnchor, constant: 20),
            tableview.bottomAnchor  .constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            tableview.leadingAnchor .constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
