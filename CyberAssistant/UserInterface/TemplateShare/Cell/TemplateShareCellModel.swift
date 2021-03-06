//
//  TemplateShareCellModel.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 27/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TemplateShareCellModel: BaseCellViewModel {
    var author: String {
        return template.author!.name
    }
    private(set) var templateAttrText = NSAttributedString()
    var result: String {
        if template.totalValue.count == 0 {
            template.generateTemplate()
        }
        return template.totalValue
    }
    
    private(set) var template: SharedTemplateModel
    
    private let saveIcon = UIImage.ca_image(imageName: "ic_save", renderingMode: .alwaysTemplate) ?? UIImage()
    private let trashIcon = UIImage.ca_image(imageName: "ic_trash", renderingMode: .alwaysTemplate) ?? UIImage()
    
    private let iconSubject = BehaviorRelay<UIImage>(value: UIImage())
    
    var icon: Observable<UIImage> {
        return iconSubject.share()
    }
    
    private var didSave: PublishSubject<SharedTemplateModel>
    
    // MARK: - Inits
    
    init(template: SharedTemplateModel, didSave: PublishSubject<SharedTemplateModel>) {
        self.template = template
        self.didSave = didSave
        super.init(viewClass: TemplateShareCell.self)
        self.iconSubject.accept(saveIcon)
        self.templateAttrText = attributedTemplate(template: template.value)
    }
    
    @available(*, unavailable)
    required init(viewClass: (UIView & View).Type) {
        fatalError("init(viewClass:) has not been implemented")
    }
    
    // MARK: - Public
    
    func updateSaved() {
        template.saved = !template.saved
        didSave.onNext(template)
        iconSubject.accept(template.saved ? trashIcon : saveIcon)
    }
    
    // MARK: - Private
    
    private func attributedTemplate(template: String) -> NSAttributedString {
        let attributes = [NSAttributedStringKey.foregroundColor : AppearanceColor.textView, NSAttributedStringKey.font : AppearanceFont.textView]
        let attrText = NSMutableAttributedString(string: template, attributes: attributes)
        return TemplateFormatter.format(attrTemplate: attrText)
    }
}
