//
//  HeaderView.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 28/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit

class HeaderView: BaseSupplementaryView {
    private let titleLabel = UILabel()
    private var localViewModel: HeaderViewModel? {
        return viewModel as? HeaderViewModel
    }
    override var viewModel: ViewModel? {
        didSet {
            guard let vm = localViewModel else { return }
            titleLabel.text = vm.title
        }
    }
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        configureAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let fittingSize = ca_configuredFittingSize(size: size)
        
        var totalSize = CGSize(width: size.width, height: layoutMargins.ca_verticalInset)
        totalSize.height += ViewSizeProcessor.calculateSize(label: titleLabel, fittingSize: fittingSize).height + 1.0
        return totalSize
    }
    
    // MARK: - Private
    
    private func configureViews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(LayoutConstants.spacing)
            make.right.equalToSuperview().offset(-LayoutConstants.spacing)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureAppearance() {
        Appearance.applyFor(headerLabel: titleLabel)
        backgroundColor = AppearanceColor.viewBackground
    }
}
