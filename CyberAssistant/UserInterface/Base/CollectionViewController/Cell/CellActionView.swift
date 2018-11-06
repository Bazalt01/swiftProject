//
//  CellSwipeActionView.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 01/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CellActionView: UIView {
    var button = UIButton()
    var viewModel: CellActionViewModel
    
    let disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    init(viewModel: CellActionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureViews()
        configureAppearance()
        configureSubscriptions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func configureViews() {
        addSubview(button)
        button.snp.makeConstraints { $0.edges.equalTo(self) }
    }
    
    private func configureAppearance() {
        switch viewModel.type {
        case .delete:
            Appearance.applyFor(deleteButton: button)
            break
        case .mute:
            Appearance.applyFor(muteButton: button)
            break
        case .share:
            Appearance.applyFor(shareButton: button)
            break
        }
    }
    
    private func configureSubscriptions() {
        viewModel.icon
            .bind(to: button.rx.image())
            .disposed(by: disposeBag)
        button.rx.tap
            .bind(to: viewModel.actionSubject)
            .disposed(by: disposeBag)
    }
}
