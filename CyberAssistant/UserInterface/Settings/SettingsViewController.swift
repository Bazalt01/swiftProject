//
//  SettingsViewController.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 25/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit

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
        
        title = NSLocalizedString("settings", comment: "")
        
        viewModel.configure()
        
        configureTableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        configureAppearance()
        tableView.reloadData()        
    }
    
    // MARK: - Private
    
    private func configureTableView() {        
        tableView.dataSource = self
        tableView.register(SettingCellButton.self, forCellReuseIdentifier: SettingCellView.className())
    }
    
    private func configureAppearance() {
        tableView.backgroundColor = AppearanceColor.collectionBackground
        tableView.separatorColor = AppearanceColor.collectionBackground
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCellView.className(), for: indexPath) as! SettingCellView
        cell.viewModel = viewModel.cellModelAtIndexPath(indexPath: indexPath)
        return cell
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
    
    func popViewController() {
        navigationController!.popViewController(animated: true)
    }
}
