//
//  LabelAnimator.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 08/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

typealias LabelAnimatorToken = Int

class LabelAnimator {
    private var index = 0
    private var timer: Timer?
    private(set) var stepBlocks: [LabelAnimatorToken : os_block_t] = [:]
    
    // MARK: - Inits
    
    init(stepDuration: CGFloat) {
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(stepDuration), target: self, selector: #selector(handledTime(sender:)), userInfo: nil, repeats: true)
    }
    
    // MARK: - Public
        
    func start() {
        timer?.fire()
    }
    
    func stop() {
        timer?.invalidate()
    }
    
    func addStepObserver(block: @escaping os_block_t) -> LabelAnimatorToken {
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
        stepBlocks.values.forEach { $0() }
    }
}
