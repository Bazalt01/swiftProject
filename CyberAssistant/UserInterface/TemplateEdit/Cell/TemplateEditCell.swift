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
        get {
            guard viewModel is TemplateEditCellModel else {
                return nil
            }
            return viewModel as? TemplateEditCellModel
        }
    }
    
    override var viewModel: CellViewModel? {
        didSet {
            if let vm = localViewModel {
                templateEditTextView.attributedText = updateTemplateTextAppearance(attr: vm.templateAttrText)
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
        let margins = UIEdgeInsets(edge: LayoutConstants.spacing)
        contentView.layoutMargins = margins
        
        configureSubsciptions()
    }
    
    func configuredTemplateEditTextView() {        
    }
    
    func configureSubsciptions() {
        templateEditTextView.rx.attributedText.asObservable().subscribe(onNext: { [weak self](attrText) in
            self?.updateAttrText(attrText: attrText)
        })
    }
    
    func updateAttrText(attrText: NSAttributedString?) {
        var value = NSAttributedString(string: "")
        if attrText != nil {
            value = attrText!
        }
        self.localViewModel?.update(template: value)
        self.templateEditTextView.attributedText = self.localViewModel?.templateAttrText
    }
    
    func configureAppearance() {
        Appearance.applyFor(textView: templateEditTextView)
        contentView.backgroundColor = AppearanceColor.viewBackground
    }
    
    func updateTemplateTextAppearance(attr: NSAttributedString) -> NSAttributedString {
        let mAttr = NSMutableAttributedString(attributedString: attr)
        let range = NSRange(location: 0, length: attr.length)
        mAttr.addAttribute(NSAttributedStringKey.font, value: self.templateEditTextView.font!, range: range)
        return mAttr.copy() as! NSAttributedString
    }
}
