//
//  MainViewModel.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 09/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

let kLimitForShowing = 3
let delayTimeKey = "delay_time"

class MainViewModel: SpeechManagerDelegate {
    private var router: MainRouter
    private var speechManager: SpeechManager
    private var templateManager: TemplateManager
    private(set) var delayTime: Int

    private var templateModels: [TemplateModel] = [] {
        didSet {
            updateModelResultList()
        }
    }
    
    private(set) var isPlaying = false
    
    private let canPlaySubject = PublishSubject<Bool>()
    private let templatesSubject = BehaviorRelay<[String]>(value: [])
    private let needNewTemplateSubject = PublishSubject<Bool>()
    private let didCompleteSpeechSubject = PublishSubject<Void>()
    
    var canPlay: Observable<Bool> {
        return canPlaySubject.share()
    }
    var templates: Observable<[String]> {
        return templatesSubject.share()
    }
    var needNewTemplate: Observable<Bool> {
        return needNewTemplateSubject.share()
    }
    var didCompleteSpeech: Observable<Void> {
        return didCompleteSpeechSubject.share()
    }
    
    private let disposeBag = DisposeBag()
    
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
    }
    
    func updateDelayTyme(time: Int) {
        assert(time > 0)
        guard (time > 0) else { return }
        
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
        guard isPlaying == false, let model = templateModels.first else { return }
        isPlaying = true
        speechManager.syntesize(text: model.totalValue)
    }
    
    func updateTemplatePosition() {
        guard let model = templateModels.first else { return }
        model.generateTemplate()
        
        var models = templateModels
        models.removeFirst()
        models.append(model)
        templateModels = models
    }
    
    func showHasntTemplatesMessage() {
        router.openAlertController(title: NSLocalizedString("attention", comment: ""),
                                   message: NSLocalizedString("attention", comment: "do_you_want_create_new_template"),
                                   acceptHandler: { [weak self] in
                                    guard let `self` = self else { return }
                                    self.router.openNewTemplateController()
            }, cancelHandler: nil)
    }
    
    // MARK: - Private
    
    private func updateModelResultList() {
        guard templateModels.count > 0 else {
            needNewTemplateSubject.onNext(true)
            templatesSubject.accept([])
            return
        }
        
        var models = templateModels
        if templateModels.count > kLimitForShowing {
            models = Array(templateModels[0..<kLimitForShowing])
        }
        
        let result = models.map { $0.totalValue }
        templatesSubject.accept(result)
        needNewTemplateSubject.onNext(false)
    }
    
    private func configureSubscriptions() {
        templateManager.models
            .ca_subscribe { [weak self] templates in
                guard let `self` = self else { return }
                self.updateModels(models: templates) }
            .disposed(by: disposeBag)
        
        templateManager.fetchResult
            .ca_subscribe { [weak self] fetchResult in
                guard let `self` = self else { return }
                self.updateModels(models: fetchResult.models as! [TemplateModel]) }
            .disposed(by: disposeBag)
    }
    
    private func updateModels(models: [TemplateModel]) {
        let models = models.filter({ !$0.muted })
        models.forEach { $0.generateTemplate() }
        templateModels = randomSortedModels(models: models)
        canPlaySubject.onNext(templateModels.count > 0)
    }
    
    private func randomSortedModels(models: [TemplateModel]) -> [TemplateModel] {
        var result: [TemplateModel] = []
        var temp = models
        while temp.count > 0 {
            let index = Int(arc4random_uniform(UInt32(temp.count - 1)))
            result.append(temp[index])
            temp.remove(at: index)
        }
        return result
    }
}

extension MainViewModel {
    func didFinishPlaying(sender:SpeechManager) {
        isPlaying = false
        didCompleteSpeechSubject.onNext(())
    }
}
