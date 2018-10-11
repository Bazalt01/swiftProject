//
//  SettingCellView.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 26/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit

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
        
        contentView.layoutMargins = UIEdgeInsets(ca_edge: LayoutConstants.spacing)
        selectionStyle = .none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        contentView.addGestureRecognizer(tap)
        
        configureAppearance()
    }
    
    func configureAppearance() {
        contentView.backgroundColor = AppearanceColor.tableCellBackground
        backgroundColor = AppearanceColor.tableCellBackground
    }

    // MARK: - Private
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if let vm = viewModel {
            vm.selectAction()
        }
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
    }
}
