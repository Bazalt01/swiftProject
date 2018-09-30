//
//  TemplateShareCell.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 27/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit

class TemplateShareCell: BaseCollectionViewCell {
    private let verStackView = UIStackView()
    private let horStackView = UIStackView()
    private let saveButton = ButtonWithBlock()
    private let templateLabel = UILabel()
    private let resultLabel = UILabel()
    private var localViewModel: TemplateShareCellModel? {
        return viewModel as? TemplateShareCellModel
    }
    
    override var viewModel: ViewModel? {
        didSet {
            guard let vm = localViewModel else {
                return
            }
            templateLabel.attributedText = updatedTemplateTextAppearance(attr: vm.templateAttrText)
            resultLabel.text = vm.result
            saveButton.setImage(vm.icon, for: .normal)
        }
    }
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        configureAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var fittingSize = ca_configuredFittingSize(size: size)
        saveButton.sizeToFit()
        fittingSize.width -= saveButton.bounds.size.width
        var totalSize = CGSize(width: size.width, height: contentView.layoutMargins.ca_verticalInset)
        
        totalSize.height += CGFloat((verStackView.arrangedSubviews.count - 1)) * verStackView.spacing
        for view in verStackView.arrangedSubviews {
            totalSize.height += ViewSizeProcessor.calculateSize(label: view as! UILabel, fittingSize: fittingSize).height + 1.0
        }
        
        return totalSize
    }
    
    func configureViews() {
        configureVerStackView()
        configureHorStackView()
        contentView.addSubview(horStackView)
        horStackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView.snp.margins)
        }
        contentView.layoutMargins = UIEdgeInsets(ca_edge: LayoutConstants.spacing)
        
        horStackView.addArrangedSubview(verStackView)
        horStackView.addArrangedSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(ca_size: 50))
        }
        
        configuredTemplateLabel()
        configuredResultLabel()
        
        verStackView.addArrangedSubview(templateLabel)
        verStackView.addArrangedSubview(resultLabel)
        
        saveButton.actionBlock = { [weak self] in
            self?.handleSaved()
        }
    }
    
    private func configureVerStackView() {
        verStackView.axis = .vertical
        verStackView.alignment = .leading
        verStackView.distribution = .fill
        verStackView.spacing = LayoutConstants.spacing
    }
    
    private func configureHorStackView() {
        horStackView.axis = .horizontal
        horStackView.alignment = .leading
        horStackView.distribution = .fill
        horStackView.spacing = LayoutConstants.spacing
    }
    
    private func configuredTemplateLabel() {
        templateLabel.numberOfLines = 0
    }
    
    private func configuredResultLabel() {
        resultLabel.numberOfLines = 0
    }
    
    private func configureAppearance() {        
        Appearance.applyFor(baseLabel: templateLabel)
        Appearance.applyFor(baseLabel: resultLabel)
        saveButton.tintColor = AppearanceColor.tint
        contentView.backgroundColor = AppearanceColor.viewBackground
    }
    
    private func updatedTemplateTextAppearance(attr: NSAttributedString) -> NSAttributedString {
        let mAttr = NSMutableAttributedString(attributedString: attr)
        let range = NSRange(location: 0, length: attr.length)
        mAttr.addAttribute(NSAttributedStringKey.font, value: self.templateLabel.font!, range: range)
        return mAttr.copy() as! NSAttributedString
    }
    
    private func handleSaved() {
        guard let lvm = localViewModel else {
            return
        }
        lvm.updateSaved()
        saveButton.setImage(lvm.icon, for: .normal)
    }
}


