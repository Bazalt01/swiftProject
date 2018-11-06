//
//  EnterView.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 18/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreGraphics

enum EnterOption {
    case All
    case SignIn
    case SignUp
}

struct AuthResult {
    private(set) var login: String
    private(set) var password: String
    
    static func empty() -> AuthResult {
        return AuthResult(login: "", password: "")
    }
}


class EnterView: UIView {
    private var viewModel: EnterViewModel
    
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let loginTextField = UITextField()
    private let passwordTextField = UITextField()
    private let repeatPasswordTextField = UITextField()
    private let enterButton = UIButton()
    private let signInUpButton = UIButton()
    
    private var visibleElementsSets = Dictionary<EnterOption, Array<UIView>>()
    
    var currentOption: EnterOption = .All {
        didSet {
            setVisibleElements(visible: true, fromOption: .All, toOption: currentOption)
            updateTitle()
            updateSignInUpButton()
        }
    }
    
    private let signInSubject = PublishSubject<AuthResult>()
    private let signUpSubject = PublishSubject<AuthResult>()
    private let errorMessageSubject = PublishSubject<String>()
    
    var signIn: Observable<AuthResult> {
        return signInSubject.share()
    }
    var signUp: Observable<AuthResult> {
        return signUpSubject.share()
    }
    var errorMessage: Observable<String> {
        return errorMessageSubject.share()
    }
    
    let disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    init() {
        self.viewModel = EnterViewModel()
        super.init(frame: CGRect.zero)
        configureViews()
        configureSubsciptions()
        configureAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func clearFields() {
        loginTextField.text = nil
        clearPasswords()
    }
    
    func clearPasswords() {
        passwordTextField.text = nil
        if currentOption == .SignUp {
            repeatPasswordTextField.text = nil
        }
    }
    
    // MARK: - Private
    
    private func configureViews() {
        configureStackView()
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        configureTitleLabel()
        stackView.addArrangedSubview(titleLabel)
        applyHeightConstraint(height: Appearance.height(view: titleLabel), view: titleLabel)
        
        configureLoginTextField()
        configurePasswordTextField()
        configureRepeatPasswordTextField()
        configureEnterButton()
        configureSignInUpButton()
        
        visibleElementsSets[.SignIn] = [loginTextField, passwordTextField, enterButton, signInUpButton]
        visibleElementsSets[.SignUp] = [loginTextField, passwordTextField, repeatPasswordTextField, enterButton, signInUpButton]
        visibleElementsSets[.All] = [loginTextField, passwordTextField, repeatPasswordTextField, enterButton, signInUpButton]
        
        func addElementsToStackView(elements: [UIView]) {
            for viewElement in elements {
                stackView.addArrangedSubview(viewElement)
                applyHeightConstraint(height: Appearance.height(view: viewElement), view: viewElement)
            }
        }
        
        func addSeparators(elements: inout [UIView]) {
            elements.insert(SeparatorView(), at: 0)
            if let index = elements.firstIndex(of: enterButton) {
                elements.insert(SeparatorView(), at: index)
            }
        }
        
        var elements = visibleElementsSets[.All]!
        
        addSeparators(elements: &elements)
        addElementsToStackView(elements: elements)
        
        setVisibleElements(visible: false, fromOption: .All, toOption: .All)
    }
    
    private func applyHeightConstraint(height: CGFloat, view: UIView) {
        view.snp.makeConstraints { $0.height.equalTo(height) }
    }
    
    private func setVisibleElements(visible: Bool, fromOption: EnterOption, toOption: EnterOption) {
        guard let elementsFrom = visibleElementsSets[fromOption], let elementsTo = visibleElementsSets[toOption] else { return }
        
        let elementSetFrom = Set(elementsFrom)
        let elementSetTo = Set(elementsTo)
        
        let intersection = elementSetFrom.intersection(elementSetTo)
        let subtracting = elementSetFrom.subtracting(elementSetTo)
        
        UIView.animate(withDuration: 0.3) {
            for view in intersection {
                if view.isHidden == visible {
                    view.isHidden = !visible
                    view.alpha = visible ? 1.0 : 0.0
                }
            }
            
            for view in subtracting {
                if view.isHidden != visible {
                    view.isHidden = visible
                    view.alpha = visible ? 0.0 : 1.0
                }
            }
        }
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = LayoutConstants.spacing
    }
    
    private func configureTitleLabel() {
        updateTitle()
    }
    
    private func configureLoginTextField() {
        loginTextField.delegate = self
        loginTextField.placeholder = NSLocalizedString("login", comment: "")
    }
    
    private func configurePasswordTextField() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        passwordTextField.placeholder = NSLocalizedString("password", comment: "")
    }
    
    private func configureRepeatPasswordTextField() {
        repeatPasswordTextField.isSecureTextEntry = true
        repeatPasswordTextField.delegate = self
        repeatPasswordTextField.placeholder = NSLocalizedString("repeat_password", comment: "")
    }
    
    private func configureEnterButton() {
        enterButton.setTitle(NSLocalizedString("enter", comment: ""), for: .normal)
    }
    
    private func configureSignInUpButton() {
        updateSignInUpButton()
    }
    
    private func configureSubsciptions() {
        enterButton.rx.tap
            .ca_subscribe { [weak self] in self?.pressEnter() }
            .disposed(by: disposeBag)
        
        signInUpButton.rx.tap
            .ca_subscribe { [weak self] in self?.signButtonPress() }
            .disposed(by: disposeBag)
    }
    
    private func signButtonPress() {
        self.clearPasswords()
        self.currentOption = (self.currentOption == .SignIn) ? .SignUp : .SignIn
    }
    
    private func updateTitle() {
        switch currentOption {
        case .All, .SignIn:
            titleLabel.text = NSLocalizedString("sign_in", comment: "")
            break
        case .SignUp:
            titleLabel.text = NSLocalizedString("sign_up", comment: "")
            break
        }
    }
    
    private func updateSignInUpButton() {
        switch currentOption {
        case .All, .SignIn:
            signInUpButton.setTitle(NSLocalizedString("sign_up", comment: ""), for: .normal)
            break
        case .SignUp:
            signInUpButton.setTitle(NSLocalizedString("sign_in", comment: ""), for: .normal)
            break
        }
    }
    
    private func pressEnter() {
        guard let login = self.loginTextField.text, let password = self.passwordTextField.text else { return }
        
        _ = self.viewModel.authResult(login: login, password: password, repeatPassword: self.repeatPasswordTextField.text, option: self.currentOption)
            .catchError { error in
                self.errorMessageSubject.onNext(ErrorManager.errorMessage(code: error as! ErrorCode))
                return Observable<AuthResult>.just(AuthResult.empty()) }
            .ca_subscribe { [unowned self] result in
                let subject = self.currentOption == .SignIn ? self.signInSubject : self.signUpSubject
                subject.onNext(result) }
    }
    
    
    private func configureAppearance() {
        self.backgroundColor = AppearanceColor.viewBackground
        stackView.backgroundColor = AppearanceColor.viewBackground
        Appearance.applyFor(titleLabel: titleLabel)
        Appearance.applyFor(textField: loginTextField)
        Appearance.applyFor(textField: passwordTextField)
        Appearance.applyFor(textField: repeatPasswordTextField)
        Appearance.applyFor(button: enterButton)
        Appearance.applyFor(button: signInUpButton)
    }
}

extension EnterView: UITextFieldDelegate {
    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return viewModel.shouldReturn(text: textField.text)
    }
    
    private func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return viewModel.shouldChange(text: textField.text)
    }
}

fileprivate let kTextLimit = 30
fileprivate let kLoginMin = 3
fileprivate let kPasswordMin = 8

fileprivate class EnterViewModel {
    
    func shouldReturn(text: String?) -> Bool {
        guard let value = text, value.count == 0 else { return false }
        return value.last! == "\n"
    }
    
    func shouldChange(text: String?) -> Bool {
        guard let value = text else { return true }
        return value.count <= kTextLimit
    }
    
    func authResult(login: String, password: String, repeatPassword: String?, option: EnterOption) -> Observable<AuthResult> {
        return Observable<AuthResult>.create({ observer in
            
            if login.count < kLoginMin {
                observer.onError(ErrorCode.loginIsTooShort)
            } else if password.count == 0 {
                observer.onError(ErrorCode.passwordIsEmpty)
            } else if password.count < kPasswordMin {
                observer.onError(ErrorCode.passwordIsTooShort)
            } else if option == .SignUp {
                if repeatPassword == nil || repeatPassword!.count == 0 {
                    observer.onError(ErrorCode.repeatPasswordIsEmpty)
                } else if password != repeatPassword {
                    observer.onError(ErrorCode.repeatPasswordIsNotEqual)
                } else {
                    observer.onNext(AuthResult(login: login, password: password))
                }
                return Disposables.create()
            }
            
            observer.onNext(AuthResult(login: login, password: password))
            observer.onCompleted()
            return Disposables.create()
        })
    }
}
