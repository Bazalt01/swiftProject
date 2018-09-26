//
//  SettingCellView.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 26/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit

enum TableCellType {
    case button
}

class SettingCellView: UITableViewCell {
    var stackView = UIStackView()
    var viewModel: SettingCellModel?
    
    // MARK: - Inits
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
 
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    class func className() -> String {
        return NSStringFromClass(self)
    }
    
    func configureViews() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.margins.equalToSuperview()
        }
        
        contentView.layoutMargins = UIEdgeInsets(edge: LayoutConstants.spacing)
        selectionStyle = .none
        configureAppearance()
    }
    
    func configureAppearance() {
        contentView.backgroundColor = AppearanceColor.tableCellBackground
    }

    // MARK: - Private
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
    }
}
