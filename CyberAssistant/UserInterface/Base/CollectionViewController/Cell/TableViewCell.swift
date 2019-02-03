//
//  TableViewCell.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 04/02/2019.
//  Copyright © 2019 g.tokmakov. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, View {
    var viewModel: ViewModel? {
        didSet {
            apply(viewModel: viewModel)
        }
    }
    
    func apply(viewModel: ViewModel?) {
    }
}
