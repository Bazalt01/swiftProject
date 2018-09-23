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
    private let emptyView = EmptyView()
    
    // MARK: - Inits
    
    init(viewModel: TemplateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
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
    
    override func configureViews() {
        super.configureViews()
        configureAddPatternButton()
        let barBattonItem = configureBarButtonItem(button: addButton)
        navigationItem.rightBarButtonItem = barBattonItem
        
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
        addButton.rx.tap.subscribe(onNext: { [weak self]() in
            self?.viewModel.createNewTemplate()
        })
        
        viewModel.hasTemplatesObserver.subscribe(onNext: { [weak self](hasTemplates) in
            self?.emptyView.isHidden = hasTemplates
        })
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        view.backgroundColor = AppearanceColor.collectionBackground
    }
    
    func configureAddPatternButton() {
        if let image = UIImage.image(imageName: "ic_add", renderingMode: .alwaysTemplate) {
            addButton.setImage(image, for: .normal)
        }
    }
    
    func configureBarButtonItem(button: UIButton) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
    
    func configureEmptyView() {
        if let image = UIImage.image(imageName: "eye", renderingMode: .alwaysTemplate) {
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
