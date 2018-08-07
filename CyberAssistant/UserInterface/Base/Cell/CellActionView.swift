//
//  CellSwipeActionView.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 01/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit

class CellActionView: UIView {
    var actionButton = ButtonWithBlock()
    var viewModel: CellActionViewModel
    var selected: Bool = false {
        didSet {
            updateIcon()
        }
    }
    
    init(viewModel: CellActionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureViews()
        configureAppearance()
        configureSubscriptions()
        self.selected = viewModel.selected
        updateIcon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        self.addSubview(actionButton)
        actionButton.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        actionButton.actionBlock = viewModel.actionBlock
    }
    
    private func configureAppearance() {
        switch viewModel.type {
        case .delete:
            Appearance.applyFor(deleteButton: actionButton)
            break
        case .mute:
            Appearance.applyFor(muteButton: actionButton)
        }
    }
    
    private func configureSubscriptions() {
        _ = self.viewModel.selecteObserver.subscribe(onNext: { [weak self](selected) in
            self?.processSelected(selected: selected)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    private func processSelected(selected: Bool) {
        self.selected = selected        
    }
    
    private func updateIcon() {    
        let actionIcon = selected ? viewModel.selectedIcon : viewModel.deselectedIcon
        if let icon = actionIcon {
            actionButton.setImage(icon, for: .normal)
        }
    }
}
