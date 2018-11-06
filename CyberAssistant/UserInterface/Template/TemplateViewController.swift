//
//  TemplateViewController.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 12/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class TemplateViewController: BaseCollectionViewController {
    private var viewModel: TemplateViewModel
    private let addButton = UIButton()
    private let shareButton = UIButton()
    private let emptyView = EmptyView()
    
    private let disposeBag = DisposeBag()
    
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
        
        title = NSLocalizedString("templates", comment: "")
        
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
        
        let viewModel = self.viewModel
        addButton.rx.tap
            .throttle(1.0, scheduler: MainScheduler.instance)
            .ca_subscribe { viewModel.createNewTemplate() }
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .throttle(1.0, scheduler: MainScheduler.instance)
            .ca_subscribe { viewModel.openShareTemplates() }
            .disposed(by: disposeBag)
        
        viewModel.hasTemplates
            .ca_subscribe { [weak self] in
                guard let `self` = self else { return }
                self.emptyView.isHidden = $0 }
            .disposed(by: disposeBag)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        view.backgroundColor = AppearanceColor.collectionBackground
    }
    
    // MARK: - Private
    
    private func configureAddTemplateButton() {
        guard let image = UIImage.ca_image(imageName: "ic_add", renderingMode: .alwaysTemplate) else { return }
        addButton.setImage(image, for: .normal)
    }
    
    private func configureShareTemplateButton() {
        guard let image = UIImage.ca_image(imageName: "ic_share", renderingMode: .alwaysTemplate) else { return }
        shareButton.setImage(image, for: .normal)
    }
    
    private func configureBarButtonItem(button: UIButton) -> UIBarButtonItem {
        return UIBarButtonItem(customView: button)
    }
    
    private func configureEmptyView() {
        guard let image = UIImage.ca_image(imageName: "eye", renderingMode: .alwaysTemplate) else { return }
        emptyView.emptyModel = EmptyModel(message: NSLocalizedString("you_need_creating_template", comment: ""), image: image)
    }
}

extension TemplateViewController: RouterHandler {
    func push(viewController: UIViewController) {
        guard let nc = navigationController else { return }
        nc.pushViewController(viewController, animated: true)        
    }
}
