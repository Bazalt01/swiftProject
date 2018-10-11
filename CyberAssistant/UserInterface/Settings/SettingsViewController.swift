//
//  SettingsViewController.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 25/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class SettingsViewController: BaseViewController {
    let viewModel: SettingsViewModel
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - Inits
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        
        viewModel.configure()
        
        configureTableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        viewModel.didReloadData.ca_subscribe { [weak self] in
            self?.tableView.reloadData()
        }
        
        configureAppearance()
        tableView.reloadData()        
    }
    
    // MARK: - Private
    
    private func configureTableView() {        
        tableView.dataSource = self
        tableView.register(SettingCellButton.self, forCellReuseIdentifier: SettingCellButton.className())
        tableView.register(SettingCellWithOption.self, forCellReuseIdentifier: SettingCellWithOption.className())
        tableView.register(SettingOptionCell.self, forCellReuseIdentifier: SettingOptionCell.className())
    }
    
    private func configureAppearance() {
        tableView.backgroundColor = AppearanceColor.collectionBackground
        tableView.separatorColor = AppearanceColor.collectionBackground
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.cellModelAtIndexPath(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: model.cellClass.className(), for: indexPath) as! SettingCellView
        cell.viewModel = model
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells(section: section)
    }
}

extension SettingsViewController: RouterHandler {
    func presentViewController(viewController: UIViewController) {
        if let nc = navigationController {
            nc.present(viewController, animated: true, completion: nil)            
        }
    }
    
    func pushToViewController(viewController: UIViewController) {
        navigationController!.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        navigationController!.popViewController(animated: true)
    }
}
