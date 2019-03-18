//
//  TripStepCell.swift
//  NextStation
//
//  Created by Jonathan Martins on 21/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

class TripStepCell:BaseCell{
    
    /// Represents the colour of the line
    private let linePipeView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Represents a station point
    private let circleView:CircleView = {
        let view = CircleView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        view.fullCircle()
        view.border_Width    = 4
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// The name of the station
    private let stationName:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(linePipeView)
        self.contentView.addSubview(stationName)
        self.contentView.addSubview(circleView)
        NSLayoutConstraint.activate([
            linePipeView.widthAnchor  .constraint(equalToConstant: 10),
            linePipeView.topAnchor    .constraint(equalTo: self.contentView.topAnchor),
            linePipeView.bottomAnchor .constraint(equalTo: self.contentView.bottomAnchor),
            linePipeView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30),
            
            circleView.widthAnchor  .constraint(equalToConstant: 25),
            circleView.heightAnchor .constraint(equalToConstant: 25),
            circleView.centerYAnchor.constraint(equalTo: linePipeView.centerYAnchor),
            circleView.centerXAnchor.constraint(equalTo: linePipeView.centerXAnchor),
            
            stationName.topAnchor     .constraint(equalTo: self.contentView.topAnchor     , constant: 5),
            stationName.heightAnchor  .constraint(greaterThanOrEqualToConstant: 35),
            stationName.bottomAnchor  .constraint(equalTo: self.contentView.bottomAnchor  , constant: -5),
            stationName.leadingAnchor .constraint(equalTo: circleView.trailingAnchor      , constant: 10),
            stationName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configures the cell;s information
    func configureCell(with tripStep:TripStep){
        setDescription(for: tripStep)
        
        circleView.border_Color      = UIColor.init(hexString: tripStep.line.colour)
        linePipeView.backgroundColor = UIColor.init(hexString: tripStep.line.colour)
    }
    
    /// Sets the steps of the trip according to the TripStep.State
    func setDescription(for tripStep:TripStep){
        
        let formattedString = NSMutableAttributedString()
        switch tripStep.state {
            case .BOARDING:
                formattedString.normal("Embarque na estação ")
                               .bold(tripStep.station.name)
            case .EXIT:
                formattedString.normal("Desembarque na estação ")
                               .bold(tripStep.station.name)
            case .TRANFERENCE:
                formattedString.normal("Faça transferência para a ")
                               .bold("Linha \(tripStep.line.number.rawValue) \(tripStep.line.colourName)")
            default:
                formattedString.normal(tripStep.station.name)
        }
        
        if let direction = tripStep.direction?.name{
            formattedString.normal(" sentido ")
                           .bold(direction)
        }
        stationName.attributedText = formattedString
    }
}
