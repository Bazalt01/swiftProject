//
//  RxSwift+Utils.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 20/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import RxSwift

extension ObservableType {
    func ca_subscribe(onNext: ((Self.E) -> Void)?) {
        let _ = subscribe(onNext: onNext, onError: nil, onCompleted: nil, onDisposed: nil)
    }
}
