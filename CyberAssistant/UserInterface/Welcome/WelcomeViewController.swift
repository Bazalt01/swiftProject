//
//  WelcomeViewController.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 18/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxGesture

let kEnterViewWidth: CGFloat = 300.0
let keyboardOffset: CGFloat = 20.0

class WelcomeViewController: BaseViewController {
    private var viewModel: WelcomeViewModel
    private let enterView = EnterView()
    private var centerYConstraint: Constraint?
    private var bottomConstraint: Constraint?
    private let transitor = Transitor()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        self.transitioningDelegate = transitor        
        configureViews()
        
        view.addSubview(enterView)
        enterView.snp.makeConstraints { (make) in
            self.centerYConstraint = make.centerY.equalToSuperview().constraint
            self.bottomConstraint = make.bottom.equalToSuperview().constraint
            make.centerX.equalToSuperview()
            make.width.equalTo(kEnterViewWidth)
        }
        self.bottomConstraint!.deactivate()
        
        configureSubsciptions()
        configureAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func configureViews() {
        enterView.currentOption = .SignIn
    }
    
    private func configureSubsciptions() {
        let viewModel = self.viewModel
        enterView.signIn
            .flatMap { viewModel.signIn(result: $0) }
            .subscribe(onNext: nil, onError: { [weak self] _ in
                guard let `self` = self else { return }
                self.view.endEditing(true)
                self.enterView.clearPasswords()
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        enterView.signUp
            .flatMap { viewModel.signUp(result: $0) }
            .subscribe(onNext: nil, onError: { [weak self] _ in
                guard let `self` = self else { return }
                self.view.endEditing(true)
                self.enterView.clearPasswords()
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        enterView.errorMessage
            .ca_subscribe { viewModel.showError(error: $0) }
            .disposed(by: disposeBag)
        
        let keyboardWillShow = NotificationCenter.default.rx.notification(.UIKeyboardWillShow)
        let keyboardWillHide = NotificationCenter.default.rx.notification(.UIKeyboardWillHide)
        Observable.merge([keyboardWillHide, keyboardWillShow])
            .ca_subscribe { [weak self] in
                guard let `self` = self else { return }
                self.updateEnterViewPositionRatioKeyboard(notification: $0) }
            .disposed(by: disposeBag)
        
        view.addGestureRecognizer(UITapGestureRecognizer())
        view.rx.tapGesture()
            .ca_subscribe { [weak self] _ in
                guard let `self` = self else { return }
                self.view.endEditing(true) }
            .disposed(by: disposeBag)
    }
    
    private func updateEnterViewPositionRatioKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardRect = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect;
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        guard let centerY = centerYConstraint,
              let bottom = bottomConstraint else { return }
        
        if keyboardRect.minY >= view.frame.height {
            bottom.deactivate()
            centerY.activate()
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        } else {
            let diff = keyboardRect.minY - (keyboardOffset + enterView.frame.maxY)
            guard diff <= 0 else { return }
            
            let offset = keyboardRect.height + keyboardOffset
            centerY.deactivate()
            bottom.activate()
            UIView.animate(withDuration: animationDuration) {
                bottom.update(offset: -offset)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func configureAppearance() {
        view.backgroundColor = AppearanceColor.viewBackground
    }
}

extension WelcomeViewController: RouterHandler {
    func present(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
