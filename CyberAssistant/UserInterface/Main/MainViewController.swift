//
//  MainViewController.swift
//  CyberAssistant
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
    private var templateLabels: [UILabel] = []
    private var newTemplateButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
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
        circleTimeView?.stop()
    }
    
    // MARK: - Private
    
    private func configureViews() {
        configurePlayButton()
        
        let circleTimeView = CircleTimeView(time: self.viewModel.delayTime, frame: .zero)
        self.circleTimeView = circleTimeView
        
        view.addSubview(circleTimeView)
        circleTimeView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(scale * -40)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(ca_size: AppearanceSize.circleTimeViewSize))
        }

        let stackView = configuredStackView()
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(circleTimeView.snp.bottom).offset(scale * 80)
            make.right.equalTo(-LayoutConstants.spacing)
            make.left.equalTo(LayoutConstants.spacing)
        }
        
        configureTemplateLabels()
        templateLabels.forEach { stackView.addArrangedSubview($0) }
        
        configureTemplatesButton()
        view.addSubview(templatesButton)
        templatesButton.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide).inset(scale * 10)
                make.right.equalTo(view.safeAreaLayoutGuide).inset(scale * 10)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom).inset(scale * 10)
                make.right.equalTo(view).inset(10)
            }
        }
        
        configureSettingsButton()
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide).inset(scale * 10)
                make.left.equalTo(view.safeAreaLayoutGuide).inset(scale * 10)
            }
            else {
                make.top.equalTo(topLayoutGuide.snp.bottom).inset(scale * 10)
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
    
    private func configurePlayButton() {}
    
    private func configureTemplatesButton() {
        guard let image = UIImage.ca_image(imageName: "ic_templates", renderingMode: .alwaysTemplate) else { return }
        templatesButton.setImage(image, for: .normal)
    }
    
    private func configureSettingsButton() {
        guard let image = UIImage.ca_image(imageName: "ic_settings", renderingMode: .alwaysTemplate) else { return }
        settingsButton.setImage(image, for: .normal)
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
        let viewModel = self.viewModel
        let circleTimeView = self.circleTimeView
        circleTimeView?.isPlaying
            .filter { $0 }
            .ca_subscribe { _ in viewModel.playNextSpeechModel() }
            .disposed(by: disposeBag)
        
        circleTimeView?.cantPlay
            .ca_subscribe { _ in viewModel.showHasntTemplatesMessage() }
            .disposed(by: disposeBag)
        
        circleTimeView?.timeOver
            .ca_subscribe {
                viewModel.updateTemplatePosition()
                viewModel.playNextSpeechModel() }
            .disposed(by: disposeBag)
        
        circleTimeView?.time
            .ca_subscribe { viewModel.updateDelayTyme(time: $0) }
            .disposed(by: disposeBag)
        
        templatesButton.rx.tap
            .throttle(1.0, scheduler: MainScheduler.instance)
            .ca_subscribe { viewModel.openTemplates() }
            .disposed(by: disposeBag)
        
        settingsButton.rx.tap
            .throttle(1.0, scheduler: MainScheduler.instance)
            .ca_subscribe { viewModel.openSettings() }
            .disposed(by: disposeBag)
        
        newTemplateButton.rx.tap
            .throttle(1.0, scheduler: MainScheduler.instance)
            .ca_subscribe { viewModel.openNewTemplate() }
            .disposed(by: disposeBag)
        
        viewModel.templates
            .ca_subscribe { [weak self] templates in
                self?.templateLabels.forEach { $0.isHidden = true }
                templates.enumerated().forEach { (offset, template) in
                    self?.templateLabels[offset].text = template
                    self?.templateLabels[offset].isHidden = false
                }}
            .disposed(by: disposeBag)
        
        viewModel.canPlay
            .ca_subscribe { circleTimeView?.canPlay = $0 }
            .disposed(by: disposeBag)
        
        viewModel.needNewTemplate
            .ca_subscribe { [weak self] in self?.newTemplateButton.isHidden = !$0 }
            .disposed(by: disposeBag)
        
        viewModel.didCompleteSpeech
            .ca_subscribe { circleTimeView?.fire() }
            .disposed(by: disposeBag)
        
        viewModel.stop
            .ca_subscribe { circleTimeView?.stop() }
            .disposed(by: disposeBag)
    }
    
    private func configureAppearance() {
        view.backgroundColor = AppearanceColor.viewBackground
        templateLabels.enumerated().forEach { (offset, element) in
            if offset == 0 {
                Appearance.applyFor(baseLabel: element)
            } else {
                Appearance.applyFor(muteLabel: element)
            }
        }
        Appearance.applyFor(addButton: newTemplateButton)
        templatesButton.tintColor = AppearanceColor.tint
        settingsButton.tintColor = AppearanceColor.tint
    }
}

extension MainViewController: RouterHandler {
    func push(viewController: UIViewController) {
        guard let nc = navigationController else { return }
        nc.navigationBar.alpha = 0
        nc.isNavigationBarHidden = false
        UIView.animate(withDuration: TimeInterval(UINavigationControllerHideShowBarDuration)) {
            nc.navigationBar.alpha = 1
        }
        nc.pushViewController(viewController, animated: true)
    }
    
    func present(viewController: UIViewController) {
        guard let nc = navigationController else { return }
        nc.present(viewController, animated: true, completion: nil)
    }
}
