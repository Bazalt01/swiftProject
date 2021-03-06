//
//  Appearance.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 18/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

let scale: CGFloat = isIPad ? 1.6 : 1
let isIPad = UIDevice.current.userInterfaceIdiom == .pad

struct AppearanceFont {
    static let button = UIFont.systemFont(ofSize: scale * 17, weight: UIFont.Weight.light)
    static let addButton = UIFont.systemFont(ofSize: scale * 24, weight: UIFont.Weight.light)
    static let barButton = UIFont.systemFont(ofSize: scale * 17)
    static let textField = UIFont.systemFont(ofSize: scale * 17)
    static let textView = UIFont.systemFont(ofSize: scale * 17, weight: UIFont.Weight.light)
    static let titleLabel = UIFont.systemFont(ofSize: scale * 17)
    static let navigationLabel = UIFont.systemFont(ofSize: isIPad ? 22 : 17)
    static let headerLabel = UIFont.systemFont(ofSize: scale * 17, weight: UIFont.Weight.bold)
    static let attentionLabel = UIFont.systemFont(ofSize: scale * 24)
    static let timeLabel = UIFont.systemFont(ofSize: scale * 56, weight: UIFont.Weight.light)
    static let baseLabel = UIFont.systemFont(ofSize: scale * 17, weight: UIFont.Weight.light)
}

struct AppearanceSize {
    static let buttonHeight: CGFloat = scale * 44.0
    static let playButtonSize: CGFloat = scale * 32.0
    static let labelHeight: CGFloat = scale * 44.0
    static let textFieldHeight: CGFloat = scale * 44.0
    static let textViewHeight: CGFloat = scale * 44.0
    static let separatorHeight: CGFloat = scale * 20.0
    static let cellActionWidth: CGFloat = scale * 70.0
    static let timeRegulatorSize: CGFloat = scale * 20.0
    static let circleTimeViewSize: CGFloat = isIPad ? 240.0 : 160.0
    static let pixelSize = CGSize(ca_size: isIPad ? 24.0 : 12.0)
    static let collectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: isIPad ? 200 : 0, bottom: 0, right: isIPad ? 100 : 0)
}

private let purple = UIColor(hue: 257.0/360.0, saturation: 0.6, brightness: 1.0, alpha: 1.0)
private let cyberGreen = UIColor(hue: 132.0/360.0, saturation: 0.67, brightness: 0.85, alpha: 1.0)
private let darkCyberGreen = UIColor(hue: 132.0/360.0, saturation: 0.67, brightness: 0.35, alpha: 1.0)
private let lightGray = UIColor(hue: 0, saturation: 0, brightness: 0.9, alpha: 1)
private let gray = UIColor(hue: 0, saturation: 0, brightness: 0.8, alpha: 1)
private let ashBlack = UIColor(white: 0.1, alpha: 1.0)
private let ashLight = UIColor(white: 0.2, alpha: 1.0)
private let white = UIColor(white: 0.9, alpha: 1.0)
private let black = UIColor.black
private let red = UIColor(hue: 1.0, saturation: 0.75, brightness: 1.0, alpha: 1.0)
private let orange = UIColor.orange

struct AppearanceColor {
    
    static let buttonTitle = black
    static let buttonTitleHighlited = black
    static let buttonBackground = cyberGreen
    static let buttonBackgroundHighlited = cyberGreen
    
    static let addButtonTitle = cyberGreen
    static let addButtonTitleHighlited = cyberGreen.withAlphaComponent(0.6)
    
    static let barButtonTitle = ashBlack
    static let barButtonTitleHighlited = ashLight
    
    static let textField = cyberGreen
    static let textFieldBorder = ashLight
    static let textFieldBackground = ashLight
    
    static let textView = cyberGreen
    static let textViewBorder = cyberGreen
    static let textViewBackground = ashBlack
    
    static let titleLabel = cyberGreen
    static let titleLabelBackground = ashBlack
    
    static let baseLabel = cyberGreen
    static let baseLabelBackground = ashBlack
    
    static let empty = ashLight
    static let emptyBackground = ashBlack
    
    static let viewBackground = ashBlack
    static let collectionBackground = ashBlack
    static let tableCellBackground = cyberGreen
    
    static let tableLabel = ashBlack
    static let tableLabelBackground = cyberGreen
    
    static let actionIcon = white
    static let deleteBackground = red
    static let muteBackground = orange
    static let shareBackground = purple
    
    static let circleShape = cyberGreen
    static let circleTimeButton = cyberGreen
    
    static let templateBracket = white
    static let templateValue = orange
    
    static let navigationBarColor = cyberGreen
    static let navigationBarTintColor = ashBlack
    static let navigationBarTitleColor = ashBlack
    
    static let tint = cyberGreen
}

struct AppearanceBorder {
    static let textField: CGFloat = scale * 0.0
    static let textView: CGFloat = scale * 0.5
    static let circle: CGFloat = scale * 3.5
}

struct AppearanceCornerRadius {
    static let textField: CGFloat = scale * 0.0
    static let textView: CGFloat = scale * 0.0
    static let image: CGFloat = 6.0
}

struct Appearance {
    static func applyFor(button: UIButton) {
        button.titleLabel?.font = AppearanceFont.button
        button.setTitleColor(AppearanceColor.buttonTitle, for: .normal)
        button.setTitleColor(AppearanceColor.buttonTitleHighlited, for: .highlighted)
        if let image = UIImage.ca_image(withFillColor: AppearanceColor.buttonBackground, radius: AppearanceCornerRadius.image) {
            button.setBackgroundImage(image, for: .normal)
        }
        if let image = UIImage.ca_image(withFillColor: AppearanceColor.buttonBackgroundHighlited, radius: AppearanceCornerRadius.image) {
            button.setBackgroundImage(image, for: .highlighted)
        }    
    }        
    
    static func applyFor(addButton button: UIButton) {
        button.titleLabel?.font = AppearanceFont.addButton
        button.setTitleColor(AppearanceColor.addButtonTitle, for: .normal)
        button.setTitleColor(AppearanceColor.addButtonTitleHighlited, for: .highlighted)
        button.tintColor = AppearanceColor.addButtonTitle
    }
    
    static func applyFor(barButton button: UIButton) {
        button.titleLabel?.font = AppearanceFont.barButton
        button.setTitleColor(AppearanceColor.barButtonTitle, for: .normal)
        button.setTitleColor(AppearanceColor.barButtonTitleHighlited, for: .highlighted)
    }
    
    static func applyFor(textField: UITextField) {
        textField.borderStyle = .roundedRect
        textField.font = AppearanceFont.textField
        textField.textColor = AppearanceColor.textField
        textField.backgroundColor = AppearanceColor.textFieldBackground
    }
    
    static func applyFor(titleLabel label: UILabel) {
        label.font = AppearanceFont.titleLabel
        label.textColor = AppearanceColor.titleLabel
        label.backgroundColor = AppearanceColor.titleLabelBackground
        label.textAlignment = .center
    }
    
    static func applyFor(deleteButton button: UIButton) {
        button.tintColor = AppearanceColor.actionIcon
        button.backgroundColor = AppearanceColor.deleteBackground
    }
    
    static func applyFor(muteButton button: UIButton) {
        button.tintColor = AppearanceColor.actionIcon
        button.backgroundColor = AppearanceColor.muteBackground
    }
    
    static func applyFor(shareButton button: UIButton) {
        button.tintColor = AppearanceColor.actionIcon
        button.backgroundColor = AppearanceColor.shareBackground
    }
    
    static func applyFor(baseLabel label: UILabel) {
        label.font = AppearanceFont.baseLabel
        label.textColor = AppearanceColor.baseLabel
        label.backgroundColor = AppearanceColor.baseLabelBackground
    }
    
    static func applyFor(headerLabel label: UILabel) {
        label.font = AppearanceFont.headerLabel
        label.textColor = AppearanceColor.baseLabel
        label.backgroundColor = AppearanceColor.baseLabelBackground
    }
    
    static func applyFor(emptyLabel label: UILabel) {
        label.font = AppearanceFont.attentionLabel
        label.textColor = AppearanceColor.empty
        label.backgroundColor = AppearanceColor.emptyBackground
    }
    
    static func applyFor(emptyImage image: UIImageView) {        
        image.tintColor = AppearanceColor.empty
        image.backgroundColor = AppearanceColor.emptyBackground
    }
    
    static func applyFor(muteLabel label: UILabel) {
        label.font = AppearanceFont.baseLabel
        label.textColor = AppearanceColor.baseLabel.withAlphaComponent(0.6)
        label.backgroundColor = AppearanceColor.baseLabelBackground
    }
    
    static func applyFor(tableLabel label: UILabel) {
        label.font = AppearanceFont.baseLabel
        label.textColor = AppearanceColor.tableLabel
        label.backgroundColor = AppearanceColor.tableLabelBackground
    }
    
    static func applyFor(textView: UITextView) {
        textView.font = AppearanceFont.textView
        textView.textColor = AppearanceColor.textView
        textView.backgroundColor = AppearanceColor.textViewBackground
        textView.layer.borderColor = AppearanceColor.textViewBorder.cgColor
        textView.layer.borderWidth = AppearanceBorder.textView
        textView.layer.cornerRadius = AppearanceCornerRadius.textView
    }
    
    static func applyFor(navigationBar: UINavigationBar) {        
        navigationBar.barTintColor = AppearanceColor.navigationBarColor
        navigationBar.tintColor = AppearanceColor.navigationBarTintColor
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : AppearanceColor.navigationBarTitleColor,
            NSAttributedString.Key.font : AppearanceFont.navigationLabel
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : AppearanceFont.navigationLabel], for: .normal)
    }
    
    static func applyFor(timeLabel: UILabel) {
        timeLabel.font = AppearanceFont.timeLabel
        timeLabel.textColor = AppearanceColor.baseLabel
    }
    
    static func height(view: UIView) -> CGFloat {
        if view.isKind(of: UITextField.self) {
            return AppearanceSize.textFieldHeight
        }
        else if view.isKind(of: UITextView.self) {
            return AppearanceSize.textViewHeight
        }
        else if view.isKind(of: UILabel.self) {
            return AppearanceSize.labelHeight
        }
        else if view.isKind(of: UIButton.self) {
            return AppearanceSize.buttonHeight
        }
        else if view.isKind(of: SeparatorView.self) {
            let separator = view as! SeparatorView
            switch separator.type {
            case .general: return AppearanceSize.separatorHeight                
            }
        }
        return 0
    }
}
