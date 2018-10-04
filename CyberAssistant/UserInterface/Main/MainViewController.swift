//
//  MainViewController.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 08/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: BaseViewController {
    var viewModel: MainViewModel
    
    private var circleTimeView: CircleTimeView?
    private var templatesButton = UIButton()
    private var settingsButton = UIButton()
    private var templateLabels = [UILabel]()
    private var newTemplateButton = UIButton()
    
    // MARK: - Inits
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureSubsciptions()
        configureAppearance()
        
        viewModel.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        circleTimeView!.stop()
    }
    
    // MARK: - Private
    
    private func configureViews() {
        configurePlayButton()
        
        let circleTimeView = CircleTimeView(time: self.viewModel.delayTime, frame: .zero)
        self.circleTimeView = circleTimeView
        
        view.addSubview(circleTimeView)
        circleTimeView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(ca_size: AppearanceSize.circleTimeViewSize))
        }

        let stackView = configuredStackView()
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(circleTimeView.snp.bottom).offset(80)
            make.right.equalTo(-LayoutConstants.spacing)
            make.left.equalTo(LayoutConstants.spacing)
        }
        
        configureTemplateLabels()
        for label in templateLabels {
            stackView.addArrangedSubview(label)
        }
        
        configureTemplatesButton()
        view.addSubview(templatesButton)
        templatesButton.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
                make.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            }
            else {
                make.top.equalTo(topLayoutGuide.snp.bottom).inset(10)
                make.right.equalTo(view).inset(10)
            }
        }
        
        configureSettingsButton()
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
                make.left.equalTo(view.safeAreaLayoutGuide).inset(10)
            }
            else {
                make.top.equalTo(topLayoutGuide.snp.bottom).inset(10)
                make.left.equalTo(view).inset(10)
            }
        }
        
        configureNewTemplateButton()
        stackView.addArrangedSubview(newTemplateButton)
        newTemplateButton.isHidden = true
    }
    
    private func configuredStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = LayoutConstants.spacing * 1.5
        return stackView
    }
    
    private func configurePlayButton() {
    }
    
    private func configureTemplatesButton() {
        if let image = UIImage.ca_image(imageName: "ic_templates", renderingMode: .alwaysTemplate) {
            templatesButton.setImage(image, for: .normal)            
        }
    }
    
    private func configureSettingsButton() {
        if let image = UIImage.ca_image(imageName: "ic_settings", renderingMode: .alwaysTemplate) {
            settingsButton.setImage(image, for: .normal)
        }
    }
    
    private func configureTemplateLabels() {
        for _ in 0..<kLimitForShowing {
            let label = UILabel()
            label.numberOfLines = 2
            label.textAlignment = .center
            templateLabels.append(label)
        }
    }
    
    private func configureNewTemplateButton() {        
        newTemplateButton.setTitle(NSLocalizedString("create_new_template", comment: ""), for: .normal)
    }
    
    private func configureSubsciptions() {
        circleTimeView?.playObservable.ca_subscribe(onNext: { [weak self](isPlaying) in
            if isPlaying {
                self?.viewModel.playNextSpeechModel()
            }
        })
        
        circleTimeView?.cantPlayObservable.ca_subscribe(onNext: { [weak self](isPlaying) in
            self?.viewModel.showHasntTemplatesNotification()
        })
        
        circleTimeView?.timeOverObservable.ca_subscribe(onNext: { [weak self]() in
            self?.viewModel.updateTemplatePosition()
            self?.viewModel.playNextSpeechModel()
        })
        
        circleTimeView?.timeObservable.ca_subscribe(onNext: { [weak self](time) in
            self?.viewModel.updateDelayTyme(time: time)
        })
        
        templatesButton.rx.tap.ca_subscribe(onNext: { [weak self]() in
            self?.viewModel.openTemplates()
        })
        
        settingsButton.rx.tap.ca_subscribe(onNext: { [weak self]() in
            self?.viewModel.openSettings()
        })

        newTemplateButton.rx.tap.ca_subscribe(onNext: { [weak self]() in
            self?.viewModel.openNewTemplate()
        })
        
        viewModel.templateResults.ca_subscribe(onNext: { [weak self](templateResults) in
            self?.updateLabels(labelTexts: templateResults)
        })
        
        viewModel.canPlay.ca_subscribe(onNext: { [weak self](canPlay) in
            self?.circleTimeView?.canPlay = canPlay
        })
        
        viewModel.needNewTemplate.ca_subscribe(onNext: { [weak self](needNewTempalate) in
            self?.newTemplateButton.isHidden = needNewTempalate == false
        })
        
        viewModel.didCompleteSpeech.ca_subscribe { [weak self]() in
            self?.circleTimeView?.fire()
        }
    }
    
    private func updateLabels(labelTexts:[String]) {
        guard labelTexts.count > 0 else {
            for label in templateLabels {
                label.isHidden = true
            }
            return
        }
        
        templateLabels.enumerated().forEach { (offset, element) in
            if offset < labelTexts.count {
                let text = labelTexts[offset]
                element.text = text
                element.isHidden = false
            }
            else {
                element.isHidden = true
            }
        }
    }
    
    private func configureAppearance() {
        view.backgroundColor = AppearanceColor.viewBackground
        templateLabels.enumerated().forEach { (offset, element) in
            if offset == 0 {
                Appearance.applyFor(baseLabel: element)
            }
            else {
                Appearance.applyFor(muteLabel: element)
            }
        }
        Appearance.applyFor(addButton: newTemplateButton)
        templatesButton.tintColor = AppearanceColor.tint
        settingsButton.tintColor = AppearanceColor.tint
    }
}

extension MainViewController: RouterHandler {
    func pushToViewController(viewController: UIViewController) {
        if let nc = navigationController {
            
            nc.navigationBar.alpha = 0
            nc.isNavigationBarHidden = false
            UIView.animate(withDuration: TimeInterval(UINavigationControllerHideShowBarDuration)) {
                nc.navigationBar.alpha = 1
            }
            nc.pushViewController(viewController, animated: true)
        }
    }
    
    func presentViewController(viewController: UIViewController) {
        if let nc = navigationController {
            nc.present(viewController, animated: true, completion: nil)
        }
    }
}
