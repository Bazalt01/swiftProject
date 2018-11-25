//
//  CollectionViewCell.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 12/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - Public
    
    class func ca_reuseIdentifier() -> String {
        return NSStringFromClass(self)
    }
}

protocol CollectionSupplementaryView: View {    
}

protocol CollectionViewCell: View {
}
