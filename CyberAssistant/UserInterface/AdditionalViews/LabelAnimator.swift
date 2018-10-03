//
//  LabelAnimator.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 08/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

typealias LabelAnimatorToken = Int

class LabelAnimator {
    private var index: Int = 0
    private var timer: Timer?
    private(set) var stepBlocks = [LabelAnimatorToken : () -> Void]()
    
    // MARK: - Inits
    
    init(stepDuration: CGFloat) {
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(stepDuration), target: self, selector: #selector(handledTime(sender:)), userInfo: nil, repeats: true)
    }
    
    // MARK: - Public
        
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
        stepBlocks[token] = block
        index += 1
        return token
    }
    
    func removeStepObserver(token: LabelAnimatorToken) {
        stepBlocks[token] = nil
    }
    
    // MARK: - Private
    
    @objc private func handledTime(sender: Timer) {
        for block in stepBlocks.values {
            block()
        }
    }
}
