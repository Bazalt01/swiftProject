//
//  TemplateEditRuleCell.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

let fittingOptions: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]

class TemplateEditRuleCell: BaseCollectionViewCell {
    private let stackView = UIStackView()
    private let ruleLabel = AnimatableLabel()
    private let exampleLabel = AnimatableLabel()
    private let resultLabel = AnimatableLabel()
    
    private var localViewModel: TemplateEditRuleCellModel? {
        guard viewModel is TemplateEditRuleCellModel else {
            return nil
        }
        return viewModel as? TemplateEditRuleCellModel
    }
    
    override var viewModel: ViewModel? {
        didSet {
            if let vm = localViewModel {
//                ruleLabel.setText(attributedText: vm.rule, animator: vm.labelAnimator)
//                exampleLabel.setText(attributedText: vm.example, animator: vm.labelAnimator)
//                resultLabel.setText(attributedText: vm.result, animator: vm.labelAnimator)
                ruleLabel.attributedText = vm.rule
                exampleLabel.attributedText = vm.example
                resultLabel.attributedText = vm.result
            }
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
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let fittingSize = ca_configuredFittingSize(size: size)
        var totalSize = CGSize(width: size.width, height: contentView.layoutMargins.ca_verticalInset)
        
        totalSize.height += CGFloat((stackView.arrangedSubviews.count - 1)) * stackView.spacing
        for view in stackView.arrangedSubviews {
            totalSize.height += ViewSizeProcessor.calculateSize(label: view as! UILabel, fittingSize: fittingSize).height + 1.0
        }
        
        return totalSize
    }
    
    // MARK: - Private
    
    private func configureViews() {
        configureStackView()
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView.snp.margins)
        }
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
