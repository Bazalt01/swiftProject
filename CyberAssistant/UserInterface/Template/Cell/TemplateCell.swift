//
//  TemplateCell.swift
//  CasinoAssistant
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
        guard viewModel is TemplateCellModel else {
            return nil
        }
        return viewModel as? TemplateCellModel
    }
    private var disposables = [Disposable]()
    
    override var viewModel: ViewModel? {
        didSet {
            if let vm = localViewModel {
                updateMutedAppearance(muted: vm.muted)
                install(viewModel: vm)
                configureSubscriptions(viewModel: vm)
            }
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
        for disposable in disposables {
            disposable.dispose()
        }
        disposables = []
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
    
    private func install(viewModel: TemplateCellModel) {
        templateLabel.attributedText = viewModel.templateAttrText
        exampleLabel.text = viewModel.templateExample
        if let avm = viewModel.actionViewModels {
            self.actionViewModels = avm
        }
    }
    
    private func configureViews() {
        configureStackView()
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView.snp.margins)
        }
        contentView.layoutMargins = UIEdgeInsets(ca_edge: LayoutConstants.spacing)
        
        configuredTemplateLabel()
        configuredExampleLabel()        
        
        stackView.addArrangedSubview(templateLabel)
        stackView.addArrangedSubview(exampleLabel)                        
    }
    
    private func configureSubscriptions(viewModel: TemplateCellModel) {
        let pressDisposable = viewModel.pressActionObserver.subscribe(onNext: { [weak self]() in
            self?.hideActions()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        disposables.append(pressDisposable)
        
        let mutedDisposable = viewModel.mutedChangedObserver.subscribe(onNext: { [weak self](muted) in
            self?.updateMutedAppearance(muted: muted)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
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
