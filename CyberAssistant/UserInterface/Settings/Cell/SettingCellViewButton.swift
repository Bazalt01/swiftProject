//
//  SettingCellViewButton.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 26/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class SettingCellViewButton: SettingCellView {
    private let titleLabel = UILabel()
    override var viewModel: SettingCellModel? {
        didSet {
            applyViewModel(viewModel: viewModel)
        }
    }
    
    private var localViewModel: SettingCellModelButton? {
        guard let vm = viewModel else {
            return nil
        }
        
        assert(vm is SettingCellModelButton)
        return vm as? SettingCellModelButton
    }
    
    // MARK: - Public
    
    override func configureViews() {
        super.configureViews()
        configureTitleLabel()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        contentView.addGestureRecognizer(tap)
        stackView.addArrangedSubview(titleLabel)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        Appearance.applyFor(tableLabel: titleLabel)
    }

    // MARK: - Private
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let vm = localViewModel else {
            return
        }
        vm.action()
    }
    
    private func applyViewModel(viewModel: SettingCellModel?) {
        titleLabel.text = viewModel?.title
    }
    
    private func configureTitleLabel() {
        titleLabel.textAlignment = .center
    }
}
