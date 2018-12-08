//
//  TemplateShareCell.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 27/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TemplateShareCell: BaseCollectionViewCell {
    private let verStackView = UIStackView()
    private let horStackView = UIStackView()
    private let saveButton = UIButton()
    private let templateLabel = UILabel()
    private let resultLabel = UILabel()
    private var localViewModel: TemplateShareCellModel? {
        return viewModel as? TemplateShareCellModel
    }
    
    private var disposables: [Disposable] = []
    
    override var viewModel: ViewModel? {
        didSet {
            guard let vm = localViewModel else { return }
            templateLabel.attributedText = updatedTemplateTextAppearance(attr: vm.templateAttrText)
            resultLabel.text = vm.result
            let imageDispose = vm.icon.bind(to: saveButton.rx.image())
            let pressDispose = saveButton.rx.tap.ca_subscribe { vm.updateSaved() }
            disposables = [imageDispose, pressDispose]
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposables.forEach { $0.dispose() }
        templateLabel.attributedText = nil
        resultLabel.text = nil
    }
    
    func configureViews() {
        configureVerStackView()
        configureHorStackView()
        contentView.addSubview(horStackView)
        horStackView.snp.makeConstraints { $0.edges.equalTo(self.contentView.snp.margins) }
        contentView.layoutMargins = UIEdgeInsets(ca_edge: LayoutConstants.spacing)
        
        horStackView.addArrangedSubview(verStackView)
        horStackView.addArrangedSubview(saveButton)
        saveButton.snp.makeConstraints { $0.size.equalTo(CGSize(ca_size: scale * 50)) }
        
        configuredTemplateLabel()
        configuredResultLabel()
        
        verStackView.addArrangedSubview(templateLabel)
        verStackView.addArrangedSubview(resultLabel)
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
}


