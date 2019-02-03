//
//  TemplateEditRuleCell.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

let fittingOptions: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]

class TemplateEditRuleCell: CollectionViewCell {
    private let stackView = UIStackView()
    private let ruleLabel = AnimatableLabel()
    private let exampleLabel = AnimatableLabel()
    private let resultLabel = AnimatableLabel()
    
    private var localViewModel: TemplateEditRuleCellModel? {
        return viewModel as? TemplateEditRuleCellModel
    }
    
    override var viewModel: ViewModel? {
        didSet {
            guard let vm = localViewModel else { return }
            ruleLabel.attributedText = vm.rule
            exampleLabel.attributedText = vm.example
            resultLabel.attributedText = vm.result
        }
    }
    
    // MARK: - Inits
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        configureAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
        configureAppearance()
    }
    
    // MARK: - Public
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ruleLabel.text = nil
        exampleLabel.text = nil
        resultLabel.text = nil
        viewModel = nil
    }    
    
    // MARK: - Private
    
    private func configureViews() {
        configureStackView()
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalTo(self.contentView.snp.margins) }
        contentView.layoutMargins = UIEdgeInsets(ca_edge: LayoutConstants.spacing)
        
        configuredRuleLabel()
        configuredExampleLabel()
        configuredResultLabel()
        
        stackView.addArrangedSubview(ruleLabel)
        stackView.addArrangedSubview(exampleLabel)
        stackView.addArrangedSubview(resultLabel)
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = LayoutConstants.spacing
    }    

    private func configuredRuleLabel() {
        ruleLabel.numberOfLines = 0
    }
    
    private func configuredExampleLabel() {
        exampleLabel.numberOfLines = 0
    }
    
    private func configuredResultLabel() {
        resultLabel.numberOfLines = 0
    }
    
    private func configureAppearance() {
        Appearance.applyFor(baseLabel: ruleLabel)
        Appearance.applyFor(baseLabel: exampleLabel)
        Appearance.applyFor(baseLabel: resultLabel)
        contentView.backgroundColor = AppearanceColor.viewBackground
    }
}
