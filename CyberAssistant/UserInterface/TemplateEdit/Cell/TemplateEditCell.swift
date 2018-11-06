//
//  TemplateEditCell.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TemplateEditCell: BaseCollectionViewCell {
    private var templateEditTextView = UITextView()
    private var localViewModel: TemplateEditCellModel? {
        return viewModel as? TemplateEditCellModel
    }
    
    private let disposeBag = DisposeBag()
    
    override var viewModel: ViewModel? {
        didSet {
            guard let vm = localViewModel else { return }
            templateEditTextView.text = vm.template
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
        configureSubsciptions()
        configureAppearance()
    }
    
    // MARK: - Public
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let _ = localViewModel else { return super.sizeThatFits(size) }
        var fittingSize = CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude)
        fittingSize.height = 150
        return fittingSize
    }
    
    func configureViews() {
        contentView.addSubview(templateEditTextView)
        templateEditTextView.snp.makeConstraints { $0.edges.equalTo(self.contentView.layoutMargins) }
        let margins = UIEdgeInsets(ca_edge: LayoutConstants.spacing)
        contentView.layoutMargins = margins
        
        configureSubsciptions()
    }
    
    func configureSubsciptions() {
        templateEditTextView.rx.text
            .ca_subscribe { [weak self] in
                guard let `self` = self, let localViewModel = self.localViewModel else { return }
                localViewModel.update(template: $0) }
            .disposed(by: disposeBag)
    }
    
    func configureAppearance() {
        Appearance.applyFor(textView: templateEditTextView)
        contentView.backgroundColor = AppearanceColor.viewBackground
    }
}
