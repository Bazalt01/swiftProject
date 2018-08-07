//
//  TemplateCellModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 14/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift

class TemplateCellModel: BaseCellViewModel {
    var templateAttrText: NSAttributedString {
        get {
            return TemplateFormatter.format(template: template!.value)
        }
    }
    var templateExample: String {
        return template != nil ? template!.totalValue : ""
    }
    private(set) var template: TemplateModel?
    private(set) var actionViewModels: [CellActionViewModel]?
    
    private var muteActionViewModel: CellActionViewModel?

    var deleteBlock: (() -> Void)?
    var muteBlock: (() -> Void)?
    private(set) var muted = false {
        didSet {
            mutedChangedObserver.onNext(muted)
        }
    }
    
    let pressActionObserver = PublishSubject<Void>()
    let mutedChangedObserver = PublishSubject<Bool>()
    
    init(template: TemplateModel) {
        self.template = template
        template.generateTemplate()
        super.init(cellClass: TemplateCell.self)
        
        self.muted = template.muted
        
        let delete = configuredDeleteActionViewModel()
        let mute = configuredMuteActionViewModel()
        muteActionViewModel = mute
        self.actionViewModels = [mute, delete]
    }
    
    required init(cellClass: BaseCollectionViewCell.Type) {
        super.init(cellClass: cellClass)
    }
    
    private func configuredDeleteActionViewModel() -> CellActionViewModel {
        let icon = UIImage.image(imageName: "ic_trash", renderingMode: .alwaysTemplate)
        return CellActionViewModel.init(type: .delete, selectedIcon: nil, deselectedIcon: icon) { [weak self]() in
            if let deleteBlock = self?.deleteBlock {
                deleteBlock()
            }
        }
    }
    
    private func configuredMuteActionViewModel() -> CellActionViewModel {
        let unmuteIcon = UIImage.image(imageName: "ic_unmute", renderingMode: .alwaysTemplate)
        let muteIcon = UIImage.image(imageName: "ic_mute", renderingMode: .alwaysTemplate)
        let model = CellActionViewModel.init(type: .mute, selectedIcon: unmuteIcon, deselectedIcon: muteIcon) { [weak self]() in
            if let muteBlock = self?.muteBlock {
                self?.updateMute()
                muteBlock()
            }
        }
        model.selected = muted
        return model
    }
    
    private func updateMute() {
        if let vm = muteActionViewModel {
            vm.selected = !vm.selected
            muted = vm.selected
            pressActionObserver.onNext(())
        }        
    }
}
