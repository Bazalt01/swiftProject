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
    private let viewModel: SettingsViewModel
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private let disposeBag = DisposeBag()
    
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
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        viewModel.didReloadData
            .ca_subscribe { [weak self] in
                guard let `self` = self else { return }
                self.tableView.reloadData() }
            .disposed(by: disposeBag)
        
        configureAppearance()
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
    func present(viewController: UIViewController) {
        guard let nc = navigationController else { return }
        nc.present(viewController, animated: true, completion: nil)
    }
    
    func push(viewController: UIViewController) {
        guard let nc = navigationController else { return }
        nc.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        guard let nc = navigationController else { return }
        nc.popViewController(animated: true)
    }
}
