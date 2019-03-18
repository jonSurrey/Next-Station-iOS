//
//  StatusItemCell.swift
//  NextStation
//
//  Created by Jonathan Martins on 15/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

class StatusItemCell:BaseCell{
    
    /// Indicates the status situation colour
    private let statusIcon:UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Indicates the colour of the line
    private let lineColour:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// The last time that the line was updated
    private let lastUpdateTime:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The name of the line
    private let lineName:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The status of the line
    private let lineStatus:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The description of the situation
    private let lineDescription:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(lineName)
        self.contentView.addSubview(lineStatus)
        self.contentView.addSubview(statusIcon)
        self.contentView.addSubview(lineColour)
        self.contentView.addSubview(lastUpdateTime)
        self.contentView.addSubview(lineDescription)
        NSLayoutConstraint.activate([
            lastUpdateTime.topAnchor    .constraint(equalTo: self.contentView.topAnchor, constant: 10),
            lastUpdateTime.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            
            lineColour.widthAnchor  .constraint(equalToConstant: 13),
            lineColour.heightAnchor .constraint(equalToConstant: 35),
            lineColour.topAnchor    .constraint(equalTo: lastUpdateTime.bottomAnchor, constant: 5),
            lineColour.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),

            statusIcon.centerYAnchor.constraint(equalTo: lineColour.centerYAnchor),
            statusIcon.leadingAnchor.constraint(equalTo: lineColour.trailingAnchor, constant: 5),
            statusIcon.heightAnchor .constraint(equalToConstant: 20),
            statusIcon.widthAnchor  .constraint(equalToConstant: 20),
            
            lineName.centerYAnchor.constraint(equalTo: statusIcon.centerYAnchor),
            lineName.leadingAnchor.constraint(equalTo: statusIcon.trailingAnchor, constant: 5),
            lineName.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1/2.5),
            
            lineStatus.centerYAnchor.constraint(equalTo: lineName.centerYAnchor),
            lineStatus.leadingAnchor.constraint(equalTo: lineName.trailingAnchor),
            lineStatus.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            
            lineDescription.leadingAnchor .constraint(equalTo: lineName.leadingAnchor),
            lineDescription.trailingAnchor.constraint(equalTo: lineStatus.trailingAnchor),
            lineDescription.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            lineDescription.topAnchor     .constraint(equalTo: lineColour.bottomAnchor),
            lineDescription.bottomAnchor  .constraint(equalTo: self.contentView.bottomAnchor, constant:-10),
         ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configures the cell
    func setupCell(for line:Line){
        lineName  .text      = format(line.number)
        lineStatus.text      = format(line.status)
        lineStatus.textColor = colorFor(line.status)
        
        lineDescription.text = line.description
        lastUpdateTime .text = "Última Atualização: \(line.lastUpdate)"
    
        statusIcon.image = UIImage(named: image(for: line.status))
        lineColour.backgroundColor = UIColor.init(hexString: line.colour)
    }
    
    /// Sets the status colour image
    private func image(for status:Status)-> String{
        switch status {
            case .NORMAL:
                return "state_1"
            case .PARALISADA:
                return "state_3"
            case .REDUZIDA,.PARCIAL:
                return "state_2"
            default:
                return "state_0"
        }
    }
    
    /// Sets the colour of the line
    private func colorFor(_ status:Status) -> UIColor {
        switch status {
            case .NORMAL:
                return UIColor.init(hexString: "#388E3C")
            case .REDUZIDA, .PARCIAL:
                return UIColor.init(hexString: "#FBC02D")
            case .PARALISADA:
                return UIColor.init(hexString: "#d32f2f")
            default:
                return UIColor.init(hexString: "#455A64")
        }
    }
    
    ///  Sets the Status of the line
    private func format(_ status:Status) -> String {
        switch status {
            case .NORMAL:
                return "Normal"
            case .REDUZIDA:
                return "Velocidade Reduzida"
            case .PARALISADA:
                return "Paralisada"
            case .ENCERRADA:
                return "Operação Encerrada"
            case .PARCIAL:
                return "Operação Parcial"
            case .UNKNOWN:
                return "Sem Informação"
        }
    }
    
    /// Sets the formatted name of the line
    func format(_ number:LineNumber) -> String {
        switch number {
            case .AZUL:
                return "Linha 1 - Azul"
            case .VERDE:
                return "Linha 2 - Verde"
            case .VERMELHA:
                return "Linha 3 - Vermelha"
            case .AMARELA:
                return "Linha 4 - Amarela"
            case .LILAS:
                return "Linha 5 - Lilás"
            case .RUBI:
                return "Linha 7 - Rubi"
            case .DIAMANTE:
                return "Linha 8 - Diamante"
            case .ESMERALDA:
                return "Linha 9 - Esmeralda"
            case .TURQUESA:
                return "Linha 10 - Turquesa"
            case .CORAL:
                return "Linha 11 - Coral"
            case .SAFIRA:
                return "Linha 12 - Safira"
            case .JADE:
                return "Linha 13 - Jade"
            case .PRATA:
                return "Linha 15 - Prata"
        }
    }
}
