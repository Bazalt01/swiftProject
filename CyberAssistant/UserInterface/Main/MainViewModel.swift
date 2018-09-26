//
//  MainViewModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 09/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift

let kLimitForShowing = 3
let delayTimeKey = "delay_time"

class MainViewModel: SpeechManagerDelegate {
    private var router: MainRouter
    private var speechManager: SpeechManager
    private var templateManager: TemplateManager
    private(set) var delayTime: Int

    private var templateModels = [TemplateModel]() {
        didSet {
            updateModelResultList()
        }
    }
    
    private(set) var isPlaying = false
    
    let canPlayObserver = PublishSubject<Bool>()
    let templateResultsObserver = PublishSubject<[String]>()
    let needNewTemplateObserver = PublishSubject<Bool>()
    let speechCompletedObserver = PublishSubject<Void>()
    
    // MARK: - Inits
    
    init(speechManager: SpeechManager, templateManager: TemplateManager, router: MainRouter) {
        self.speechManager = speechManager
        self.templateManager = templateManager
        self.router = router
        
        let time = UserDefaults.standard.integer(forKey: delayTimeKey)
        self.delayTime = time > 0 ? time : kDefaultTime
    }
    
    // MARK: - Public
    
    func configure() {
        templateManager.configure()
        speechManager.delegate = self
        configureSubscriptions()
        updateModels(models: templateManager.models)
    }
    
    func updateDelayTyme(time: Int) {
        assert(time > 0)
        guard (time > 0) else {
            return
        }
        
        delayTime = time
        UserDefaults.standard.setValue(time, forKey: delayTimeKey)
    }
    
    func openTemplates() {
        router.openTemplatesController()
    }
    
    func openNewTemplate() {
        router.openNewTemplateController()
    }
    
    func openSettings() {
        router.openSettingsController()
    }
    
    func playNextSpeechModel() {
        guard isPlaying == false, let model = templateModels.first else {
            return
        }
        isPlaying = true
        speechManager.syntesize(text: model.totalValue)
    }
    
    func updateTemplatePosition() {
        guard let model = templateModels.first else {
            return
        }
        model.generateTemplate()
        var models = templateModels
        models.removeFirst()
        models.append(model)
        templateModels = models
    }
    
    // MARK: - Private
    
    private func updateModelResultList() {
        guard templateModels.count > 0 else {
            needNewTemplateObserver.onNext(true)
            templateResultsObserver.onNext([])
            return
        }
        
        var models = templateModels
        if templateModels.count > kLimitForShowing {
            models = Array(templateModels[0..<kLimitForShowing])
        }
        
        let result = models.map { (model) -> String in
            return model.totalValue
        }
        templateResultsObserver.onNext(result)
        needNewTemplateObserver.onNext(false)
    }
    
    private func configureSubscriptions() {
        templateManager.templateModelsObserver.subscribe(onNext: { [weak self](fetchResult) in
            if let result = fetchResult {
                self?.updateModels(models: result.models as! [TemplateModel])
            }
        })
    }
    
    private func updateModels(models: [TemplateModel]) {
        let models = models.filter({ (model) -> Bool in
            return model.muted == false
        })
        for model in models {
            model.generateTemplate()
        }
        templateModels = randomSortedModels(models: models)
        canPlayObserver.onNext(templateModels.count > 0)
    }
    
    private func randomSortedModels(models: [TemplateModel]) -> [TemplateModel] {
        var result = [TemplateModel]()
        var temp = models
        while temp.count > 0 {
            let index: Int = Int(arc4random_uniform(UInt32(temp.count - 1)))
            result.append(temp[index])
            temp.remove(at: index)
        }
        return result
    }
}

extension MainViewModel {
    func didFinishPlaying(sender:SpeechManager) {
        isPlaying = false
        speechCompletedObserver.onNext(())
    }
}
