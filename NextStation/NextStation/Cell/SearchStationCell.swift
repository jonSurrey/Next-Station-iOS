//
//  SearchStationCell.swift
//  NextStation
//
//  Created by Jonathan Martins on 19/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

class SearchStationCell:BaseCell{
    
    /// The image of the company
    private let companyIcon:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// The colour of the line
    private let lineColour:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        view.fullCircle()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// The name of the station
    private let stationName:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(lineColour)
        self.contentView.addSubview(stationName)
        self.contentView.addSubview(companyIcon)
        NSLayoutConstraint.activate([
            companyIcon.widthAnchor  .constraint(equalToConstant: 20),
            companyIcon.heightAnchor .constraint(equalToConstant: 20),
            companyIcon.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            companyIcon.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            
            lineColour.widthAnchor  .constraint(equalToConstant: 15),
            lineColour.heightAnchor .constraint(equalToConstant: 15),
            lineColour.centerYAnchor.constraint(equalTo: companyIcon.centerYAnchor),
            lineColour.leadingAnchor.constraint(equalTo: companyIcon.trailingAnchor, constant: 5),
            
            stationName.topAnchor     .constraint(equalTo: self.contentView.topAnchor     , constant: 15),
            stationName.bottomAnchor  .constraint(equalTo: self.contentView.bottomAnchor  , constant: -15),
            stationName.leadingAnchor .constraint(equalTo: lineColour.trailingAnchor      , constant: 10),
            stationName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configures the cell
    func configureCell(with station:Station){
        
        let line = Line(station.lineId)
        
        stationName.text  = station.name
        companyIcon.image = UIImage(named: line.companyImageName)
        lineColour.backgroundColor = UIColor.init(hexString: line.colour)
    }
}
