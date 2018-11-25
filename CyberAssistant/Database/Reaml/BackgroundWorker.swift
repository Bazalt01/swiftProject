//
//  BackgroundWorker.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 22/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

// https://academy.realm.io/posts/realm-notifications-on-background-threads-with-swift/

class BackgroundWorker: NSObject {
    private var thread: Thread!
    private var block: os_block_t!
    
    @objc internal func runBlock() { block() }
    
    internal func start(_ block: @escaping os_block_t) {
        self.block = block
        
        let threadName = String(describing: self)
            .components(separatedBy: .punctuationCharacters)[1]
        
        thread = Thread { [weak self] in
            while (self != nil && !self!.thread.isCancelled) {
                RunLoop.current.run(
                    mode: RunLoopMode.defaultRunLoopMode,
                    before: Date.distantFuture)
            }
            Thread.exit()
        }
        thread.name = "\(threadName)-\(UUID().uuidString)"
        thread.start()
        
        perform(#selector(runBlock),
                on: thread,
                with: nil,
                waitUntilDone: false,
                modes: [RunLoopMode.defaultRunLoopMode.rawValue])
    }
    
    public func stop() {
        thread.cancel()
    }
}
