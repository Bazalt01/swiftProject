//
//  TemplateShareViewController.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 27/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import RxSwift

class TemplateShareViewController: BaseCollectionViewController {
    private let viewModel: TemplateShareViewModel
    private let emptyView = EmptyView()
    
    private let disposeBag = DisposeBag()
    
    // MARK: Inits
    
    init(viewModel: TemplateShareViewModel) {
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
        
        title = NSLocalizedString("template_share", comment: "")
        
        if let cv = collectionView {
            cv.dataSource = viewModel.dataSource
            viewModel.dataSource.collectionView = cv
            cv.delegate = viewModel.collectionViewDelegate
        }
        
        viewModel.configure()
        
        configureEmptyView()
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.right.equalTo(-LayoutConstants.spacing)
            make.left.equalTo(LayoutConstants.spacing)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Public
    
    override func configureAppearance() {
        super.configureAppearance()
        view.backgroundColor = AppearanceColor.collectionBackground
    }
    
    override func configureSubsciptions() {
        super.configureSubsciptions()
        self.viewModel.hasTemplates
            .ca_subscribe { [weak self] in self?.emptyView.isHidden = $0 }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private
    
    private func configureEmptyView() {
        guard let image = UIImage.ca_image(imageName: "eye", renderingMode: .alwaysTemplate) else { return }
        emptyView.emptyModel = EmptyModel(message: NSLocalizedString("you_need_creating_template", comment: ""), image: image)
    }
}

extension TemplateShareViewController: RouterHandler {
}
