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
        guard viewModel is TemplateEditCellModel else {
            return nil
        }
        return viewModel as? TemplateEditCellModel        
    }
    
    override var viewModel: ViewModel? {
        didSet {
            if let vm = localViewModel {
                templateEditTextView.text = vm.template
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
        configureSubsciptions()
        configureAppearance()
    }
    
    // MARK: - Public
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let _ = localViewModel else {
            return super.sizeThatFits(size)
        }
        var fittingSize = CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude)
        fittingSize.height = 150
        return fittingSize
    }
    
    func configureViews() {
        configuredTemplateEditTextView()
        contentView.addSubview(templateEditTextView)
        templateEditTextView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView.layoutMargins)
        }
        let margins = UIEdgeInsets(ca_edge: LayoutConstants.spacing)
        contentView.layoutMargins = margins
        
        configureSubsciptions()
    }
    
    func configuredTemplateEditTextView() {        
    }
    
    func configureSubsciptions() {
        templateEditTextView.rx.text.asObservable().ca_subscribe(onNext: { [weak self](text) in
            self?.localViewModel?.update(template: text)
        })
    }
    
    func configureAppearance() {
        Appearance.applyFor(textView: templateEditTextView)
        contentView.backgroundColor = AppearanceColor.viewBackground
    }
}
