//
//  TemplateCell.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 12/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class TemplateCell: CollectionViewCellWithActions {
    private var stackView = UIStackView()
    private var templateLabel = UILabel()
    private var exampleLabel = UILabel()
    private var localViewModel: TemplateCellModel? {
        return viewModel as? TemplateCellModel
    }
    
    private var disposables: [Disposable] = []
    
    override var viewModel: ViewModel? {
        didSet {
            guard let vm = localViewModel else { return }
            install(viewModel: vm)
            configureSubscriptions(viewModel: vm)
        }
    }
    
    // MARK: - Inits
    
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
        templateLabel.text = nil
        exampleLabel.text = nil
        disposables.forEach { $0.dispose()}
        disposables = []
        viewModel = nil
    }    
    
    // MARK: - Private
    
    private func install(viewModel: TemplateCellModel) {
        templateLabel.attributedText = viewModel.templateAttrText
        exampleLabel.text = viewModel.templateExample
        guard let avm = viewModel.actionViewModels else { return }
        self.actionViewModels = avm
    }
    
    private func configureViews() {
        configureStackView()
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalTo(self.contentView.snp.margins) }
        contentView.layoutMargins = UIEdgeInsets(ca_edge: LayoutConstants.spacing)
        
        configuredTemplateLabel()
        configuredExampleLabel()        
        
        stackView.addArrangedSubview(templateLabel)
        stackView.addArrangedSubview(exampleLabel)                        
    }
    
    private func configureSubscriptions(viewModel: TemplateCellModel) {
        let pressDisposable = viewModel.didPress.ca_subscribe { [weak self] in self?.hideActions() }
        disposables.append(pressDisposable)
        
        let mutedDisposable = viewModel.didMuted.ca_subscribe { [weak self] in self?.updateMutedAppearance(muted: $0) }
        disposables.append(mutedDisposable)
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = LayoutConstants.spacing
    }
    
    private func configuredTemplateLabel() {
        templateLabel.numberOfLines = 0
    }
    
    private func configuredExampleLabel() {
        exampleLabel.numberOfLines = 0
    }
    
    private func configureAppearance() {
        Appearance.applyFor(baseLabel: templateLabel)
        Appearance.applyFor(baseLabel: exampleLabel)        
        contentView.backgroundColor = AppearanceColor.viewBackground
    }
    
    private func updateMutedAppearance(muted: Bool) {
        let alpha: CGFloat = muted ? 0.4 : 1.0
        let templateTextColor = templateLabel.textColor.withAlphaComponent(alpha)
        templateLabel.textColor = templateTextColor
        
        let exampleTextColor = exampleLabel.textColor.withAlphaComponent(alpha)
        exampleLabel.textColor = exampleTextColor
    }
}
