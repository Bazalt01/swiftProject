//
//  TemplateCellModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 14/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TemplateCellModel: BaseCellViewModel {
    var templateAttrText: NSAttributedString {
        return TemplateFormatter.format(template: template!.value)        
    }
    var templateExample: String {
        return template?.totalValue ?? ""
    }
    
    private(set) var template: TemplateModel?
    private(set) var actionViewModels: [CellActionViewModel]?
    
    var actionBlock: ((_ type: CellActionType) -> Void)?
    
    private var muteActionViewModel: CellActionViewModel?
    private var shareActionViewModel: CellActionViewModel?
    
    private let didPressSubject = PublishSubject<Void>()
    private let didMutedSubject = BehaviorRelay<Bool>(value: false)
    private let didSharedSubject = BehaviorRelay<Bool>(value: false)
    
    var didPress: Observable<Void> {
        return didPressSubject.share()
    }
    var didMuted: Observable<Bool> {
        return didMutedSubject.share()
    }
    var didShared: Observable<Bool> {
        return didSharedSubject.share()
    }
    
    let disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    init(template: TemplateModel) {
        self.template = template
        template.generateTemplate()
        super.init(viewClass: TemplateCell.self)
        
        self.didMutedSubject.accept(template.muted)
        self.didSharedSubject.accept(template.shared)
        
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
        let icon = UIImage.ca_image(imageName: "ic_trash", renderingMode: .alwaysTemplate) ?? UIImage()
        let model = CellActionViewModel(type: .delete, selectedIcon: icon, deselectedIcon: icon)
        model.didPress
            .ca_subscribe { [weak self] in
                guard let `self` = self, let actionBlock = self.actionBlock else { return }
                actionBlock(.delete) }
            .disposed(by: disposeBag)
        return model
    }
    
    private func configuredMuteActionViewModel() -> CellActionViewModel {
        let unmuteIcon = UIImage.ca_image(imageName: "ic_unmute", renderingMode: .alwaysTemplate) ?? UIImage()
        let muteIcon = UIImage.ca_image(imageName: "ic_mute", renderingMode: .alwaysTemplate) ?? UIImage()
        let model = CellActionViewModel(type: .mute, selectedIcon: unmuteIcon, deselectedIcon: muteIcon)
        model.didPress
            .ca_subscribe { [weak self] in
                guard let `self` = self,
                    let actionBlock = self.actionBlock,
                    let vm = self.muteActionViewModel else { return }
                vm.selected = !vm.selected
                self.didMutedSubject.accept(vm.selected)
                self.didPressSubject.onNext(())
                actionBlock(.mute) }
            .disposed(by: disposeBag)
        model.selected = didMutedSubject.value
        return model
    }
    
    private func configuredShareActionViewModel() -> CellActionViewModel {
        let privateIcon = UIImage.ca_image(imageName: "ic_private", renderingMode: .alwaysTemplate) ?? UIImage()
        let shareIcon = UIImage.ca_image(imageName: "ic_share", renderingMode: .alwaysTemplate) ?? UIImage()
        let model = CellActionViewModel.init(type: .share, selectedIcon: privateIcon, deselectedIcon: shareIcon)
        model.didPress
            .ca_subscribe { [weak self] in
                guard let `self` = self,
                    let actionBlock = self.actionBlock,
                    let vm = self.shareActionViewModel else { return }
                vm.selected = !vm.selected
                self.didSharedSubject.accept(vm.selected)
                self.didPressSubject.onNext(())
                actionBlock(.share) }
            .disposed(by: disposeBag)
        model.selected = didSharedSubject.value
        return model
    }
}
