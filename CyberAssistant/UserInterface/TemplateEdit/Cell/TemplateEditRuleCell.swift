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
    private var ruleLabel = AnimatableLabel()
    private var exampleLabel = AnimatableLabel()
    private var resultLabel = AnimatableLabel()
    
    private var localViewModel: TemplateEditRuleCellModel? {
        get {
            guard viewModel is TemplateEditRuleCellModel else {
                return nil
            }
            return viewModel as? TemplateEditRuleCellModel
        }
    }
    
    override var viewModel: CellViewModel? {
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ruleLabel.text = nil
        exampleLabel.text = nil
        resultLabel.text = nil
        viewModel = nil
    }
    
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
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let fittingSize = configuredFittingSize(size: size)
        var totalSize = CGSize(width: size.width, height: contentView.layoutMargins.verticalInset)                
        
        totalSize.height += CGFloat((stackView.arrangedSubviews.count - 1)) * stackView.spacing
        for view in stackView.arrangedSubviews {
            totalSize.height += ViewSizeProcessor.calculateSize(label: view as! UILabel, fittingSize: fittingSize).height + 1.0
        }
        
        return totalSize
    }        
    
    func configureViews() {
        configureStackView()
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView.snp.margins)
        }
        contentView.layoutMargins = UIEdgeInsets(edge: LayoutConstants.spacing)
        
        configuredRuleTextView()
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
    
    func configuredRuleTextView() {
        ruleLabel.numberOfLines = 0
    }
    
    func configuredExampleLabel() {
        exampleLabel.numberOfLines = 0
    }
    
    func configuredResultLabel() {
        resultLabel.numberOfLines = 0
    }
    
    func configureAppearance() {
        Appearance.applyFor(baseLabel: ruleLabel)
        Appearance.applyFor(baseLabel: exampleLabel)
        Appearance.applyFor(baseLabel: resultLabel)
        contentView.backgroundColor = AppearanceColor.viewBackground
    }
}
