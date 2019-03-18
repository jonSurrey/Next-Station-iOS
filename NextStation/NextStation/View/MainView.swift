//
//  MainView.swift
//  NextStation
//
//  Created by Jonathan Martins on 28/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import Parchment
import Foundation

extension PagingViewController{
    var selectedIndex:Int{
        get{
            return 0
        }
    }
}

protocol MainViewDelegate:class{
    
    /// Sets the title of the NavigationBar
    func setNavigationBar(title:String)
    
    /// Sets the colour of the NavigationBar
    func setNavigationTitleColour(to colour: String)
    
    /// Sets the MainView's background colour
    func setBackgroundColour(to hexColour:String)
    
    /// Moves the PagingViewController to the given index
    func movePagingViewController(to index:Int)
    
    /// Indicates if the status bar should be dark or not, according to the the boolean flag
    func setStatusBarTo(darkMode:Bool)
}

class MainView: UIView {
    
    /// The view that holds the children ViewControllers and allows swiping
    let pagingViewController:PagingViewController<SelectionItem> = {
        let pagingViewController = PagingViewController<SelectionItem>()
        pagingViewController.menuItemSource  = .class(type: SelectionPagingCell.self)
        pagingViewController.menuItemSize    = .fixed(width: 120, height: 50)
        pagingViewController.menuInteraction = .scrolling
        pagingViewController.indicatorColor  = .clear
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return pagingViewController
    }()
    
    /// The title of the ViewController
    let title:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Situação das Linhas"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The view that holds the buttons actions at the bottom of the MainView
    let bottomView:UIView = {
        let view = UIView()
        view.addDropShadow()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Holds the buttons so we can align them as we want
    private let stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    /// The button to open the TripPlanner ViewController
    let tripButton:IconTitleButton = {
        let button = IconTitleButton()
        button.icon.image = UIImage(named: "icon_trip")
        button.label.text = "Sua Viagem"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// The button to open the SMSViewController
    let smsButton:IconTitleButton = {
        let button = IconTitleButton()
        button.icon.image = UIImage(named: "icon_sms")
        button.label.text = "SMS Denúncia"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        stackView .addArrangedSubview(tripButton)
        stackView .addArrangedSubview(smsButton)
        bottomView.addSubview(stackView)
        
        self.addSubview(title)
        self.addSubview(pagingViewController.view)
        self.addSubview(bottomView)
        NSLayoutConstraint.activate([
            title.heightAnchor  .constraint(equalToConstant: 50),
            title.topAnchor     .constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            title.leadingAnchor .constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            pagingViewController.view.topAnchor     .constraint(equalTo: title.bottomAnchor),
            pagingViewController.view.bottomAnchor  .constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            pagingViewController.view.leadingAnchor .constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            pagingViewController.view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            stackView.topAnchor     .constraint(equalTo: bottomView.topAnchor),
            stackView.bottomAnchor  .constraint(equalTo: bottomView.bottomAnchor),
            stackView.leadingAnchor .constraint(equalTo: bottomView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            
            bottomView.heightAnchor  .constraint(equalToConstant: 50),
            bottomView.bottomAnchor  .constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            bottomView.leadingAnchor .constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

