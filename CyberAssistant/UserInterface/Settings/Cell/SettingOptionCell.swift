//
//  SettingOptionCell.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 08/10/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class SettingOptionCell: SettingCellView {
    private let titleLabel = UILabel()
    override var viewModel: SettingCellModel? {
        didSet {
            titleLabel.text = viewModel?.title
        }
    }
    
    // MARK: - Public
    
    override func configureViews() {
        super.configureViews()
        configureTitleLabel()
        stackView.addArrangedSubview(titleLabel)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        Appearance.applyFor(tableLabel: titleLabel)
    }
    
    // MARK: - Private
    
    private func configureTitleLabel() {
        titleLabel.textAlignment = .left
    }
}
