//
//  SettingCellWithOption.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 07/10/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class SettingCellWithOption: SettingCellView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    override var viewModel: SettingCellModel? {
        didSet {
            guard let vm = localViewModel else { return }
            applyViewModel(viewModel: vm)
        }
    }
    var localViewModel: SettingCellWithOptionModel? {
        return viewModel as? SettingCellWithOptionModel
    }
    
    // MARK: - Public
    
    override func configureViews() {
        super.configureViews()
        
        let stackView = configuredStackView()
        self.stackView.addArrangedSubview(stackView)
        
        configureTitleLabel()
        configureValueLabel()

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        Appearance.applyFor(tableLabel: titleLabel)
        Appearance.applyFor(tableLabel: valueLabel)
    }
    
    // MARK: - Private
    
    private func applyViewModel(viewModel: SettingCellWithOptionModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }

    private func configuredStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        return stackView
    }
    
    private func configureTitleLabel() {
        titleLabel.textAlignment = .left
    }
    
    private func configureValueLabel() {
        valueLabel.textAlignment = .right
    }
}
