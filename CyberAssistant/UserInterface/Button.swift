//
//  ButtonWithBlock.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 01/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class ButtonWithBlock: UIButton {
    var actionBlock: (() -> Void)? {
        didSet {
            configureAction()
        }
    }
    
    // MARK: - Private
    
    private func configureAction() {
        if actionBlock == nil {
            self.removeTarget(self, action: #selector(handlePress(sender:)), for: .touchUpInside)
        }
        else {
            self.addTarget(self, action: #selector(handlePress(sender:)), for: .touchUpInside)
        }
    }
    
    @objc private func handlePress(sender: UIButton) {
        if let block = actionBlock {
            block()
        }
    }
}
