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
        return TemplateFormatter.format(template: template!.value)        
    }
    var templateExample: String {
        return template != nil ? template!.totalValue : ""
    }
    private(set) var template: TemplateModel?
    private(set) var actionViewModels: [CellActionViewModel]?
    
    private var muteActionViewModel: CellActionViewModel?
    private var shareActionViewModel: CellActionViewModel?

    var deleteBlock: (() -> Void)?
    
    var muteBlock: (() -> Void)?
    private(set) var muted = false {
        didSet {
            didMutedChanged.onNext(muted)
        }
    }
    
    var shareBlock: (() -> Void)?
    private(set) var shared = false {
        didSet {
            didSharedChanged.onNext(shared)
        }
    }
    
    let didPressAction = PublishSubject<Void>()
    let didMutedChanged = PublishSubject<Bool>()
    let didSharedChanged = PublishSubject<Bool>()
    
    // MARK: - Inits
    
    init(template: TemplateModel) {
        self.template = template
        template.generateTemplate()
        super.init(viewClass: TemplateCell.self)
        
        self.muted = template.muted
        self.shared = template.shared
        
        let delete = configuredDeleteActionViewModel()
        let mute = configuredMuteActionViewModel()
        let share = configuredShareActionViewModel()
        muteActionViewModel = mute
        shareActionViewModel = share
        self.actionViewModels = [share, mute, delete]
    }
    
    required init(viewClass: (UIView & View).Type) {
        super.init(viewClass: viewClass)
    }
    
    // MARK: - Private
    
    private func configuredDeleteActionViewModel() -> CellActionViewModel {
        let icon = UIImage.ca_image(imageName: "ic_trash", renderingMode: .alwaysTemplate)
        return CellActionViewModel.init(type: .delete, selectedIcon: nil, deselectedIcon: icon) { [weak self]() in
            if let deleteBlock = self?.deleteBlock {
                deleteBlock()
            }
        }
    }
    
    private func configuredMuteActionViewModel() -> CellActionViewModel {
        let unmuteIcon = UIImage.ca_image(imageName: "ic_unmute", renderingMode: .alwaysTemplate)
        let muteIcon = UIImage.ca_image(imageName: "ic_mute", renderingMode: .alwaysTemplate)
        let model = CellActionViewModel.init(type: .mute, selectedIcon: unmuteIcon, deselectedIcon: muteIcon) { [weak self]() in
            if let muteBlock = self?.muteBlock {
                self?.updateMute()
                muteBlock()
            }
        }
        model.selected = muted
        return model
    }
    
    private func configuredShareActionViewModel() -> CellActionViewModel {
        let privateIcon = UIImage.ca_image(imageName: "ic_private", renderingMode: .alwaysTemplate)
        let shareIcon = UIImage.ca_image(imageName: "ic_share", renderingMode: .alwaysTemplate)
        let model = CellActionViewModel.init(type: .share, selectedIcon: privateIcon, deselectedIcon: shareIcon) { [weak self]() in
            if let shareBlock = self?.shareBlock {
                self?.updateShare()
                shareBlock()
            }
        }
        model.selected = shared
        return model
    }
    
    private func updateMute() {
        if let vm = muteActionViewModel {
            vm.selected = !vm.selected
            muted = vm.selected
            didPressAction.onNext(())
        }        
    }
    
    private func updateShare() {
        if let vm = shareActionViewModel {
            vm.selected = !vm.selected
            shared = vm.selected
            didPressAction.onNext(())
        }
    }
}
