//
//  EmptyView.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 23/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit

struct EmptyModel {
    let message: String
    let image: UIImage    
}

class EmptyView: UIView {
    private var messageLabel = UILabel()
    private var imageView = UIImageView()
    
    var emptyModel: EmptyModel? {
        didSet {
            applyModel(model: emptyModel)
        }
    }
    
    // MARK: Inits
    
    init() {
        super.init(frame: .zero)
        configureViews()
        configureAppearance()
    }
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Private
    
    private func configureViews() {
        configureImageView()
        configureMessageLabel()

        let stackView = configuredStackView()
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(messageLabel)
    }
    
    private func configureMessageLabel() {
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
    }
    
    private func configuredStackView () -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = LayoutConstants.spacing * 2.0
        return stackView
    }
    
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFit
    }
    
    private func applyModel(model: EmptyModel?) {
        messageLabel.text = model?.message
        imageView.image = model?.image
    }
    
    private func configureAppearance() {
        Appearance.applyFor(emptyImage: imageView)
        Appearance.applyFor(emptyLabel: messageLabel)
        backgroundColor = AppearanceColor.viewBackground
    }
}

