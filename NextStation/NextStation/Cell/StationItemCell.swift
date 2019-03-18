//
//  StationItemCell.swift
//  NextStation
//
//  Created by Jonathan Martins on 15/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

class StationItemCell:BaseCell{
    
    /// Indicates the colour of the line
    private let linePipeView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Indicates the station point
    private let circleView:CircleView = {
        let view = CircleView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.fullCircle()
        view.border_Width    = 2
        view.border_Color    = .white
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Indicates the name of the station
    private let stationName:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Indicates the address of the station
    private let stationAddressName:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Aligns the transferences aside to the linePipeView
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .trailing
        stackView.spacing = 5.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
  
        self.contentView.addSubview(stackView)
        self.contentView.addSubview(stationName)
        self.contentView.addSubview(linePipeView)
        self.contentView.addSubview(circleView)
        self.contentView.addSubview(stationAddressName)
        NSLayoutConstraint.activate([
            linePipeView.widthAnchor  .constraint(equalToConstant: 45),
            linePipeView.heightAnchor .constraint(greaterThanOrEqualToConstant: 50),
            linePipeView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            linePipeView.topAnchor    .constraint(equalTo: self.contentView.topAnchor    ),
            linePipeView.bottomAnchor .constraint(equalTo: self.contentView.bottomAnchor ),
            
            stackView.centerYAnchor .constraint(equalTo: linePipeView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: linePipeView.leadingAnchor, constant:-5),
            
            circleView.centerXAnchor.constraint(equalTo: linePipeView.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: linePipeView.centerYAnchor),
            circleView.heightAnchor .constraint(equalToConstant: 30),
            circleView.widthAnchor  .constraint(equalToConstant: 30),
            
            stationName.centerYAnchor .constraint(equalTo: circleView.centerYAnchor),
            stationName.leadingAnchor .constraint(equalTo: linePipeView.trailingAnchor, constant: 8),
            stationName.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant:-8),
            
            stationAddressName.topAnchor     .constraint(equalTo: stationName.bottomAnchor),
            stationAddressName.leadingAnchor .constraint(equalTo: stationName.leadingAnchor),
            stationAddressName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant:-8),
            stationAddressName.bottomAnchor  .constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Callback to notify when a tranference is selected
    var callback:((Int)->Void)?
    
    /// Configures the cell
    func setupCell(_ item:StationItem){
        addStationTranferences(item.tranferences)
        
        stationName.text             = item.station.name
        stationAddressName.text      = item.station.address
        circleView.backgroundColor   = item.isSelected ? .black:.white
        linePipeView.backgroundColor = UIColor.init(hexString: item.lineColour)
    }
    
    /// Adds the tranference views to the stackview
    private func addStationTranferences(_ tranferences:[Station]){
        
        stackView.removeAllSubviews()
        for tranference in tranferences{
            let line       = Line(tranference.lineId)
            let circleview = createCircleView(line: line.number.rawValue)
            circleview.backgroundColor = UIColor.init(hexString: line.colour)
            circleview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTranferenceSelected)))
            stackView.addArrangedSubview(circleview)
        }
    }
    
    /// Create the views that will represent the transferences
    private func createCircleView(line:Int)->CircleView{
        let circleView = CircleView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        circleView.widthAnchor .constraint(equalToConstant: 20).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        circleView.label.text = "\(line)"
        circleView.fullCircle()
        circleView.tag = line
        return circleView
    }
    
    /// Action click of the tranference views
    @objc private func onTranferenceSelected(sender:UITapGestureRecognizer){
        if let view = sender.view as? CircleView{
            callback?(view.tag)
        }
    }
}
