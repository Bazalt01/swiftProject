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

let kEnterViewWidth: CGFloat = 300.0
let keyboardOffset: CGFloat = 20.0

class WelcomeViewController: BaseViewController {
    private var viewModel: WelcomeViewModel
    private let enterView = EnterView()
    private var centerYConstraint: Constraint?
    private var bottomConstraint: Constraint?
    
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        enterView.currentOption = .SignIn
    }
    
    private func configureSubsciptions() {
        enterView.signInObserver.subscribe(onNext: { [weak self](result) in
            self?.processSignIn(result: result)
        })
        
        enterView.signUpObserver.subscribe(onNext: { [weak self](result) in
            self?.processSignUp(result: result)
        })
        
        enterView.errorObserver.subscribe(onNext: { [weak self](error) in
            self?.viewModel.showError(error: error)
        })
        
        NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillShow).subscribe(onNext: { [weak self](notification) in
            self?.updateEnterViewPositionRatioKeyboard(notification: notification)
        })
        NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillHide).subscribe(onNext: { [weak self](notification) in
            self?.updateEnterViewPositionRatioKeyboard(notification: notification)
        })
        
        let tap = UITapGestureRecognizer.init()
        tap.rx.event.asObservable().subscribe(onNext: { [weak self](gesture) in
            self?.view.endEditing(true)
        })
        view.addGestureRecognizer(tap)
    }
    
    private func processSignIn(result: AuthResult) {
        viewModel.signIn(result: result, success: {
        }, failure: { [weak self]() in
            self?.view.endEditing(true)
            self?.enterView.clearPasswords()
        })
    }
    
    private func processSignUp(result: AuthResult) {
        viewModel.signUp(result: result, success: {
        }, failure: { [weak self]() in
            self?.view.endEditing(true)
            self?.enterView.clearPasswords()
        })
    }
    
    private func updateEnterViewPositionRatioKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        let keyboardRect = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect;
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        guard let centerY = centerYConstraint, let bottom = bottomConstraint else {
            return
        }
        
        if keyboardRect.minY >= view.frame.height {
            bottom.deactivate()
            centerY.activate()
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
        else {
            let diff = keyboardRect.minY - (keyboardOffset + enterView.frame.maxY)
            guard diff <= 0 else {
                return
            }
            
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
    func presentViewController(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
