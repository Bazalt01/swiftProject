//
//  AnimatableLabel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 08/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class AnimatableLabel: UILabel {
    private weak var animator: LabelAnimator?
    private var targetText: NSAttributedString?
    var token: LabelAnimatorToken?
    
    deinit {
        removeObserver()
    }

    // MARK: - Public
    
    func setText(attributedText: NSAttributedString, animator: LabelAnimator?) {
        self.attributedText = nil
        self.animator = animator
        self.targetText = attributedText
        
        if let anim = animator {
            token = anim.addStepObserver(block: { [weak self]() in
                self?.animate()
            })
        }
        else {
            removeObserver()
            self.attributedText = attributedText
        }
    }
    
    func shouldAnimate() -> Bool {
        guard let text = targetText else { return false }
        return text.length > 0
    }
    
    func removeObserver() {
        guard let anim = animator, let animToken = token else { return }
        anim.removeStepObserver(token: animToken)
    }

    // MARK: - Private
    
    private func animate() {
        if let text = self.attributedText, let targText = self.targetText {
            if text.length == targText.length {
                removeObserver()
                self.attributedText = self.targetText
                return
            }
        }
        guard shouldAnimate() else {
            removeObserver()
            return
        }
        
        let lenght = self.attributedText == nil ? 0 : self.attributedText!.length
        let range = NSRange(location: 0, length: lenght)
        let attrText: NSMutableAttributedString = targetText!.attributedSubstring(from: range).mutableCopy() as! NSMutableAttributedString
        
        let blockCursor = NSAttributedString(string: "#", attributes: [NSAttributedStringKey.backgroundColor : textColor!])
        attrText.append(blockCursor)
        self.attributedText = attrText
    }    
}
