//
//  MainViewController.swift
//  NextStation
//
//  Created by Jonathan Martins on 11/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import Parchment
import FloatingPanel

class MainViewController:UIViewController{
    
    /// The controller's view, instance of MainView
    private unowned var _view:MainView { return self.view as! MainView }
    
    /// The presenter for MainViewController
    private var presenter = MainPresenter()
    
    /// Instance of MapViewController displayed by the FloatingPanelController
    private let contentVC = MapViewController()
    
    /// Warpper for the contentVC
    private let floatingPanel = FloatingPanelController()
    
    /// Callback to notify when a station is select in some of the LineViewController
    var onStationSelected:((Station)->Void)?
    
    /// Flag to indicate if the StatusBar should be dark or not
    var darkMode = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkMode ? .default:.lightContent
    }
    
    override func loadView() {
        self.view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarTitleAndBottomActions()
        setupPagingViewController()
        setupFloatingPanel()
        
        presenter.attach(to: self)
        presenter.getColourFor(line: 0)
    }
    
    /// Sets up the NavigationBar title and the actions on the buttons on the bottomBar
    private func setupNavigationBarTitleAndBottomActions(){
        _view.smsButton .addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSMSReport)))
        _view.tripButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTripPlanner)))
        
        guard let frame = self.navigationController?.navigationBar.frame else {
            return
        }
        _view.title.frame = frame
        navigationItem.titleView = _view.title
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    /// Sets up the PagingViewController
    private func setupPagingViewController(){
        _view.pagingViewController.delegate   = self
        _view.pagingViewController.dataSource = self
    }
    
    /// Instatiate a LineViewController according to the given index
    private func viewController(for line:Line) -> LineViewController{
        let viewController = LineViewController()
        viewController.initPresenterWith(line)
        
        viewController.onStationSelected = { [weak self] (station) in
            self?.floatingPanel.move(to: .full, animated: true, completion: {
                self?.contentVC.presenter.centerMap(on: station)
            })
        }
        viewController.onTransferSelected = { [weak self] (number) in
            self?.presenter.selectIndexFor(line: number)
        }
        return viewController
    }
    
    /// Action to open the TripPlannerViewController
    @objc private func openTripPlanner() {
        let navigationController = UINavigationController(rootViewController: TripPlannerViewController())
        present(navigationController, animated: true, completion: nil)
    }
    
    /// Action to open the SMSReportController
    @objc private func openSMSReport() {
        let navigationController = UINavigationController(rootViewController: SMSViewController())
        present(navigationController, animated: true, completion: nil)
    }
}

/// Implementation of PagingViewController's delegates
extension MainViewController:PagingViewControllerDataSource, PagingViewControllerDelegate{
    
    func numberOfViewControllers<T>(in pagingViewController: PagingViewController<T>) -> Int where T : PagingItem, T : Comparable, T : Hashable {
        return presenter.tabs.count
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController where T : PagingItem, T : Comparable, T : Hashable {
        switch index {
            case 0:
                let mainViewController = StatusViewController()
                mainViewController.onLineSelected = { [weak self] (number) in
                    self?.presenter.selectIndexFor(line: number)
                }
                return mainViewController
            default:
                let line = presenter.getLine(for: index)!
                return viewController(for: line)
        }
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T where T : PagingItem, T : Comparable, T : Hashable {
        let number = presenter.tabs[index].number
        return SelectionItem(index: index, line: number == 0 ? nil:Line(number, "")) as! T
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, didScrollToItem pagingItem: T, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) where T : PagingItem, T : Comparable, T : Hashable {
 
        let number = pagingItem.hashValue
        presenter.getColourFor(line: number)
        presenter.getTitleFor(line: number)
    }
}

/// Implementation of the FloatingPanel's delegates
extension MainViewController:FloatingPanelControllerDelegate, FloatingPanelLayout{
    
    public var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .tip]
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
            case .full:
                return 16.0
            case .tip:
                return 75.0
            default:
                return nil
        }
    }

    func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        return [
            surfaceView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            surfaceView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
        ]
    }
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return self
    }
    
    /// Sets up the FloatingPanel
    private func setupFloatingPanel(){
        floatingPanel.surfaceView.shadowHidden    = false
        floatingPanel.surfaceView.backgroundColor = .clear
        
        floatingPanel.delegate = self
        floatingPanel.set(contentViewController: contentVC)
        floatingPanel.addPanel(toParent: self, belowView: _view.bottomView, animated: false)
    }
}

/// Implementation of the MainViewDelegate
extension MainViewController:MainViewDelegate{
    
    func setStatusBarTo(darkMode: Bool) {
        self.darkMode = darkMode
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func movePagingViewController(to index:Int){
        _view.pagingViewController.select(index: index, animated: true)
    }
    
    func setBackgroundColour(to colour: String) {
        let colour = UIColor.init(hexString: colour)
        UIView.animate(withDuration: 0.2) {
            self._view.backgroundColor = colour
            self._view.bottomView.backgroundColor = colour
            self.contentVC._view.header.backgroundColor = colour
        }
    }

    func setNavigationTitleColour(to colour: String) {
        let colour = UIColor.init(hexString: colour)
        _view.title     .textColor = colour
        _view.smsButton .setColour(to: colour)
        _view.tripButton.setColour(to: colour)
        contentVC._view.headerTitle.textColor = colour
    }
    
    func setNavigationBar(title: String) {
        _view.title.text = title
    }
}
