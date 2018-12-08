//
//  TemplateEditViewController.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class TemplateEditViewController: BaseCollectionViewController {
    private var viewModel: TemplateEditViewModel
    private var saveButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    init(viewModel: TemplateEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("template_editor", comment: "")
        
        if let cv = collectionView {
            cv.dataSource = viewModel.dataSource
            viewModel.dataSource.collectionView = cv
            cv.delegate = viewModel.collectionViewDelegate
        }
        
        viewModel.configure()
    }
    
    override func configureViews() {
        super.configureViews()
        configureSaveButton()
        navigationItem.rightBarButtonItem = configureBarButtonItem(button: saveButton)
    }
    
    override func configureSubsciptions() {
        super.configureSubsciptions()
        
        saveButton.rx.tap
            .throttle(1.0, scheduler: MainScheduler.instance)
            .bind(to: viewModel.saveSubject)
            .disposed(by: disposeBag)
        
        let keyboardWillShow = NotificationCenter.default.rx.notification(.UIKeyboardWillShow)
        let keyboardWillHide = NotificationCenter.default.rx.notification(.UIKeyboardWillHide)
        Observable.merge([keyboardWillHide, keyboardWillShow])
            .ca_subscribe { [weak self] in
                guard let `self` = self else { return }
                self.updateInsetRatioKeyboard(notification: $0) }
            .disposed(by: disposeBag)
    }
    
    func configureSaveButton() {
        let image = UIImage.ca_image(imageName: "ic_save", renderingMode: .alwaysTemplate) ?? UIImage()
        saveButton.setImage(image, for: .normal)
    }
    
    func configureBarButtonItem(button: UIButton) -> UIBarButtonItem {
        return UIBarButtonItem(customView: button)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        view.backgroundColor = AppearanceColor.collectionBackground
        Appearance.applyFor(barButton: saveButton)
    }
    
    // MARK: - Private
    
    private func updateInsetRatioKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let cv = collectionView else { return }
        
        let keyboardRect = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        if keyboardRect.minY >= view.frame.height {
            UIView.animate(withDuration: animationDuration) {
                cv.contentInset = UIEdgeInsets.zero
            }
        } else {
            UIView.animate(withDuration: animationDuration) {
                cv.contentInset.bottom += keyboardRect.height
            }
        }
    }
}

extension TemplateEditViewController: RouterHandler {
    func present(viewController: UIViewController) {
        guard let nc = navigationController else { return }
        nc.present(viewController, animated: true, completion: nil)
    }
    
    func popViewController() {
        guard let nc = navigationController else { return }
        nc.popViewController(animated: true)
    }        
}
