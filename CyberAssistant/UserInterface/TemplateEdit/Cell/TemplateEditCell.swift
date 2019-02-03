//
//  TemplateEditCell.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TemplateEditCell: CollectionViewCell {
    private var templateEditTextView = UITextView()
    private var localViewModel: TemplateEditCellModel? {
        return viewModel as? TemplateEditCellModel
    }
    
    private let disposeBag = DisposeBag()
    
    override var viewModel: ViewModel? {
        didSet {
            templateEditTextView.text = localViewModel?.template
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
    
    func configureViews() {
        contentView.addSubview(templateEditTextView)
        templateEditTextView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView.layoutMargins)
            make.height.greaterThanOrEqualTo(scale * 150)
        }
        let margins = UIEdgeInsets(ca_edge: LayoutConstants.spacing)
        contentView.layoutMargins = margins
        
        configureSubsciptions()
    }
    
    func configureSubsciptions() {
        templateEditTextView.rx.text
            .ca_subscribe { [weak self] in
                guard let localViewModel = self?.localViewModel else { return }
                localViewModel.update(template: $0) }
            .disposed(by: disposeBag)        
    }
    
    func configureAppearance() {
        Appearance.applyFor(textView: templateEditTextView)
        contentView.backgroundColor = AppearanceColor.viewBackground
    }
}
