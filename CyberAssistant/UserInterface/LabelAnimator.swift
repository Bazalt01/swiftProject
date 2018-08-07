//
//  LabelAnimator.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 08/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import RxSwift

typealias LabelAnimatorToken = Int

class LabelAnimator {
    private var index: Int = 0
    private var timer: Timer?
    private(set) var stepObserverBlocks = [LabelAnimatorToken : () -> Void]()
    
    init(stepDuration: CGFloat) {
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(stepDuration), target: self, selector: #selector(handledTime(sender:)), userInfo: nil, repeats: true)
    }
    
    @objc private func handledTime(sender: Timer) {
        for block in stepObserverBlocks.values {
            block()
        }
    }
    
    func start() {
        if let timer = self.timer {
            timer.fire()
        }
    }
    
    func stop() {
        if let timer = self.timer {
            timer.invalidate()
        }
    }
    
    func addStepObserver(block: @escaping () -> Void) -> LabelAnimatorToken {
        let token = index
        stepObserverBlocks[token] = block
        index += 1
        return token
    }
    
    func removeStepObserver(token: LabelAnimatorToken) {
        stepObserverBlocks[token] = nil
    }
}
