//
//  TemplateEditViewController.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 26/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit

class TemplateEditViewController: BaseCollectionViewController {
    private var viewModel: TemplateEditViewModel
    private var saveButton = UIButton()
    
    init(viewModel: TemplateEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Template editor"
        
        if let cv = collectionView {
            cv.dataSource = viewModel.dataSource
            viewModel.dataSource.collectionView = cv
            cv.delegate = viewModel.collectionViewDelegate
        }
        
        viewModel.configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.performAnimation()
    }
    
    override func configureViews() {
        super.configureViews()
        configureSaveButton()
        let barBattonItem = configureBarButtonItem(button: saveButton)
        navigationItem.rightBarButtonItem = barBattonItem
    }
    
    override func configureSubsciptions() {
        super.configureSubsciptions()
        
        weak var weakSelf = self
        saveButton.rx.tap.subscribe(onNext: { () in
            weakSelf?.viewModel.saveTemplate()
        })
        
        NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillShow).subscribe(onNext: { (notification) in
            weakSelf?.updateInsetRatioKeyboard(notification: notification)
        })
        
        NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillHide).subscribe(onNext: { (notification) in
            weakSelf?.updateInsetRatioKeyboard(notification: notification)
        })        
    }
    
    private func updateInsetRatioKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let cv = collectionView else {
            return
        }
        
        let keyboardRect = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect;
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        if keyboardRect.minY >= view.frame.height {
            UIView.animate(withDuration: animationDuration) {
                self.updateCollectionContentInset()
            }
        }
        else {
            UIView.animate(withDuration: animationDuration) {
                cv.contentInset.bottom += keyboardRect.height
            }
        }
    }
    
    func configureSaveButton() {
        if let image = UIImage.image(imageName: "ic_save", renderingMode: .alwaysTemplate) {
            saveButton.setImage(image, for: .normal)
        }
    }
    
    func configureBarButtonItem(button: UIButton) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        view.backgroundColor = AppearanceColor.collectionBackground
        Appearance.applyFor(barButton: saveButton)
    }
}

extension TemplateEditViewController: RouterHandler {
    func presentViewController(viewController: UIViewController) {
        if let nc = navigationController {
            nc.present(viewController, animated: true, completion: nil)
        }
    }
    
    func popViewController() {
        if let nc = navigationController {
            nc.popViewController(animated: true)
        }
    }        
}