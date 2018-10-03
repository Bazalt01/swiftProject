//
//  TemplateViewController.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 12/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit

class TemplateViewController: BaseCollectionViewController {
    private var viewModel: TemplateViewModel
    private let addButton = UIButton()
    private let shareButton = UIButton()
    private let emptyView = EmptyView()
    
    // MARK: - Inits
    
    init(viewModel: TemplateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Templates"
        
        if let cv = collectionView {
            cv.dataSource = viewModel.dataSource
            viewModel.dataSource.collectionView = cv
            cv.delegate = viewModel.collectionViewDelegate
        }
        viewModel.configure()
    }
    
    // MARK: - Public
    
    override func configureViews() {
        super.configureViews()
        configureAddTemplateButton()
        configureShareTemplateButton()
        let addBarBattonItem = configureBarButtonItem(button: addButton)
        let shareBarBattonItem = configureBarButtonItem(button: shareButton)
        navigationItem.rightBarButtonItems = [addBarBattonItem, shareBarBattonItem]
        
        configureEmptyView()
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { (make) in
            make.right.equalTo(-LayoutConstants.spacing)
            make.left.equalTo(LayoutConstants.spacing)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureSubsciptions() {
        super.configureSubsciptions()
        addButton.rx.tap.ca_subscribe(onNext: { [weak self]() in
            self?.viewModel.createNewTemplate()
        })

        shareButton.rx.tap.ca_subscribe(onNext: { [weak self]() in
            self?.viewModel.openShareTemplates()
        })
        
        viewModel.hasTemplates.ca_subscribe(onNext: { [weak self](hasTemplates) in
            self?.emptyView.isHidden = hasTemplates
        })
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        view.backgroundColor = AppearanceColor.collectionBackground
    }
    
    // MARK: - Private
    
    private func configureAddTemplateButton() {
        if let image = UIImage.ca_image(imageName: "ic_add", renderingMode: .alwaysTemplate) {
            addButton.setImage(image, for: .normal)
        }
    }
    
    private func configureShareTemplateButton() {
        if let image = UIImage.ca_image(imageName: "ic_share", renderingMode: .alwaysTemplate) {
            shareButton.setImage(image, for: .normal)
        }
    }
    
    private func configureBarButtonItem(button: UIButton) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
    
    private func configureEmptyView() {
        if let image = UIImage.ca_image(imageName: "eye", renderingMode: .alwaysTemplate) {
            emptyView.emptyModel = EmptyModel(message: "You need creating a template", image: image)
        }
    }
}

extension TemplateViewController: RouterHandler {
    func pushToViewController(viewController: UIViewController) {
        if let nc = navigationController {
            nc.pushViewController(viewController, animated: true)
        }
    }
}
