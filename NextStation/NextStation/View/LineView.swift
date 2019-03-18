//
//  LineView.swift
//  NextStation
//
//  Created by Jonathan Martins on 26/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import Foundation

protocol LineViewDelegate:class {
    
    /// Notifies the view to set the line's colour name
    func updateLineName (_ name:String)
    
    /// Notifies the view to set the line's company logo
    func updateCompanyLogo(_ logo:String)
    
    /// Notifies the view to update the UItableView
    func updateTableView(_ items:[StationItem])
}

class LineView: UIView {
    
    /// The wrapper for holding the name and icon of the line
    let wrapper:UIView = {
        let wrapper = UIView()
        wrapper.backgroundColor = .white
        wrapper.addDropShadow()
        wrapper.corner_Radius = 12
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        return wrapper
    }()
    
    /// The company logo of the line
    let lineIcon:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    /// The name of the line
    let lineName:UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The list which displays the stations composing the line
    let tableview:UITableView = {
        let tableview = UITableView()
        tableview.rowHeight          = UITableView.automaticDimension
        tableview.separatorStyle     = .none
        tableview.tableFooterView    = UIView()
        tableview.backgroundColor    = .white
        tableview.estimatedRowHeight = 100
        tableview.registerCell(StationItemCell.self)
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    /// The constraint for animating the wrapper's position
    private var wrapperTopConstraint:NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Sets up the constraints for this view
    private func setupConstraints(){
        
        wrapper.addSubview(lineIcon)
        wrapper.addSubview(lineName)
        
        self.addSubview(tableview)
        self.addSubview(wrapper)
        
        wrapperTopConstraint = wrapper.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: -5)
        NSLayoutConstraint.activate([
            wrapperTopConstraint!,
            wrapper.leadingAnchor .constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            lineIcon.widthAnchor  .constraint(equalToConstant: 15),
            lineIcon.heightAnchor .constraint(equalToConstant: 15),
            lineIcon.topAnchor    .constraint(equalTo: wrapper.topAnchor    , constant: 5),
            lineIcon.bottomAnchor .constraint(equalTo: wrapper.bottomAnchor , constant: -5),
            lineIcon.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 13),
            
            lineName.centerYAnchor .constraint(equalTo: lineIcon.centerYAnchor),
            lineName.leadingAnchor .constraint(equalTo: lineIcon.trailingAnchor, constant: 5),
            lineName.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -13),
            
            tableview.topAnchor     .constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableview.bottomAnchor  .constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            tableview.leadingAnchor .constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    /// Animates the wrapper
    func animateWrapper(){
        wrapperTopConstraint.constant = 35
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        }) { (finished) in
            self.wrapperTopConstraint.constant = -5
            UIView.animate(withDuration: 0.2, delay: 1.0, options: .curveEaseIn, animations: {
                self.layoutIfNeeded()
            })
        }
    }
}
