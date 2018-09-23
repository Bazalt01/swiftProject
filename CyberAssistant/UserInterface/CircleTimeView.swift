//
//  CircleTimeView.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 09/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit
import Darwin
import RxSwift
import SnapKit

let kDefaultTime = 5
let kMaxTime = 60
let kShapeInset: CGFloat = 2.0
let kDefaultAnimationDuration = 0.3
let kCircleDegree = 360
let kRegulatorDelayAnimation = 1.0
let kRegulatorAnimationKey = "regulator_animation"

class CircleTimeView: UIView {
    private let stackView = UIStackView()
    private let circleLayer = CAShapeLayer()
    private let timeRegulatorLayer = CAShapeLayer()
    private let timeLabel = UILabel()
    private let timeRegulator = UIView()
    
    private let playButton = UIButton()
    private let buttonShapeLayer = CAShapeLayer()
    private let playPath = UIBezierPath()
    private let stopPath = UIBezierPath()
    private let panGesture = UIPanGestureRecognizer()
    private let tapGesture = UITapGestureRecognizer()
    
    private let showingRegulatorAnimation = CABasicAnimation()
    private let hidingRegulatorAnimation = CABasicAnimation()
    
    private(set) var isPlaying = false
    
    private var timer: Timer?
    
    private(set) var time: Int
    private var currentTime: Int = 0 {
        didSet {
            timeLabel.text = String(currentTime)
        }
    }
    private var timeLineForward = true
    
    var canPlay = false
    let playObserver = PublishSubject<Bool>()
    let timeObserver = PublishSubject<Int>()
    let timeOver = PublishSubject<Void>()
 
    // MARK: - Inits
    
    init(time: Int, frame: CGRect) {
        self.time = time
        self.currentTime = time
        super.init(frame: frame)
        self.configure()
    }
    
    override init(frame: CGRect) {
        self.time = kDefaultTime
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.time = kDefaultTime
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layouts
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShapeLayer()
        
        let degree = CGFloat(360 / 60 * time)
        let center = bounds.center()
        updateTimeRegulatorPosition(degree: degree, center: center)
    }
    
    // MARK: - Public
    
    func fire() {
        guard isPlaying else {
            return
        }
        currentTime = 0
        self.dropTimeLine()
        
        // Needs cuple milliseconds for droping the time line without an animation
        DispatchQueue.main.async { [weak self]() in
            self?.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self!, selector: #selector(self?.handleTimer(sender:)), userInfo: nil, repeats: true)
            self?.timer!.fire()
        }
    }
    
    func play() {
        guard isPlaying == false else {
            return
        }
        changeButtonPathAnimated()
        isPlaying = true
        startTimeLine()
    }
    
    func stop() {
        guard isPlaying else {
            return
        }
        changeButtonPathAnimated()
        isPlaying = false
        timer!.invalidate()
        finishTimeLine()
    }
    
    // MARK: - Private
    
    private func configure() {
        configureStackView()
        configureTimeLabel()
        configurePlayButton()
        configureShapeLayer()
        configurePanGesture()
        configureTimeRegulator()
        configureTapGesture()
        configureShowingResulatorAnimation()
        configureHiddingResulatorAnimation()
        
        timeLabel.addGestureRecognizer(tapGesture)
        
        layer.addSublayer(circleLayer)

        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(playButton)
        playButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(size: AppearanceSize.playButtonSize))
        }
        
        addSubview(timeRegulator)
        
        addGestureRecognizer(panGesture)
        configureAppearance()
    }

    private func configureStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = LayoutConstants.circleTimeSpacing
    }
    
    private func configureTimeLabel() {
        timeLabel.text = String(time)
        timeLabel.isUserInteractionEnabled = true
    }
    
    private func configurePlayButton() {
        configurePlayStopShapesLayer()
        buttonShapeLayer.path = playPath.cgPath
        playButton.layer.addSublayer(buttonShapeLayer)
        playButton.addTarget(self, action: #selector(handlePressPlay), for: .touchUpInside)
    }
    
    private func configurePlayStopShapesLayer() {
        let frame = CGRect(origin: .zero, size: CGSize(size: AppearanceSize.playButtonSize))
        configurePlayPath(frame: frame)
        configureStopPath(frame: frame)
        buttonShapeLayer.frame = frame
        buttonShapeLayer.lineWidth = 4.0
        buttonShapeLayer.lineJoin = kCALineJoinRound
    }

    private func configureShapeLayer() {
        circleLayer.lineWidth = AppearanceBorder.circle
        circleLayer.lineCap = kCALineCapRound
    }
    
    private func configuredCirclePath(frame: CGRect) -> UIBezierPath {
        let radius = min(frame.size.height, frame.size.width) / 2.0
        let path = UIBezierPath(roundedRect: frame, cornerRadius: radius)
        path.lineCapStyle = .round
        path.stroke()
        return path
    }
    
    private func configurePlayPath(frame: CGRect) {
        let inset = frame.width * 0.15
        playPath.move(to: CGPoint(x: inset, y: 0.0))
        playPath.addLine(to: CGPoint(x: frame.width - inset, y: frame.height / 2.0))
        playPath.addLine(to: CGPoint(x: inset, y: frame.height))
        playPath.close()
    }
    
    private func configureStopPath(frame: CGRect) {
        stopPath.move(to: .zero)
        stopPath.addLine(to: CGPoint(x: frame.width, y: 0.0))
        stopPath.addLine(to: CGPoint(x: frame.width, y: frame.height))
        stopPath.addLine(to: CGPoint(x: 0.0, y: frame.height))
        stopPath.close()
    }
    
    private func configureTimeRegulator() {
        let rect = CGRect(origin: .zero, size: CGSize(size: AppearanceSize.timeRegulatorSize))
        let path = UIBezierPath(ovalIn: rect)
        timeRegulatorLayer.frame = rect
        timeRegulatorLayer.path = path.cgPath
        timeRegulator.layer.addSublayer(timeRegulatorLayer)
        timeRegulator.frame = rect
        timeRegulator.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    private func configureShowingResulatorAnimation() {
        showingRegulatorAnimation.keyPath = "transform.scale"
        showingRegulatorAnimation.fromValue = 0
        showingRegulatorAnimation.toValue = 1
        showingRegulatorAnimation.duration = kDefaultAnimationDuration
        showingRegulatorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)        
    }
    
    private func configureHiddingResulatorAnimation() {
        hidingRegulatorAnimation.keyPath = "transform.scale"
        hidingRegulatorAnimation.fromValue = 1
        hidingRegulatorAnimation.toValue = 0
        hidingRegulatorAnimation.duration = kDefaultAnimationDuration
        hidingRegulatorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    }
    
    private func configurePanGesture() {
        panGesture.addTarget(self, action: #selector(handlePan(sender:)))
    }
    
    private func configureTapGesture() {
        tapGesture.addTarget(self, action: #selector(handleTap(sender:)))
    }
    
    private func updateShapeLayer() {
        var frame = self.bounds
        frame.origin.x = kShapeInset
        frame.origin.y = kShapeInset
        frame.size.width -= kShapeInset * 2
        frame.size.height -= kShapeInset * 2
        circleLayer.path = configuredCirclePath(frame: frame).cgPath
        circleLayer.frame = self.bounds
    }
    
    private func calculateTimeRegulatorPosition(point: CGPoint) {
        let center = bounds.center()
        let targetPoint = CGPoint(x: point.x - center.x, y: point.y - center.y)
        let value = targetPoint.y / targetPoint.x
        var degree = atan(value) * 180.0 / CGFloat.pi
        
        if (targetPoint.x == 0.0) {
            degree = targetPoint.y > 0.0 ? 180.0 : 0.0
        }
        else
        {
            degree += targetPoint.x > 0.0 ? 90.0 : 270.0
        }
        updateTime(degree: Int(ceil(degree)))
        updateTimeRegulatorPosition(degree: degree, center: center)
    }
    
    private func updateTimeRegulatorPosition(degree: CGFloat, center: CGPoint) {
        let turnedDegree = correctedDegree(degree: degree)
        let radian = turnedDegree * CGFloat.pi / 180.0
        let radius = min(bounds.width / 2.0, bounds.height / 2.0) - kShapeInset - AppearanceBorder.circle / 4.0
        let y = sin(radian) * radius
        var x = sqrt(pow(radius, 2) - pow(y, 2))
        if degree > 180 {
            x = -x
        }
        let result = CGPoint(x: x + center.x, y: y + center.y)
        timeRegulator.center = result
    }
    
    private func correctedDegree(degree: CGFloat) -> CGFloat{
        var turnedDegree = degree - 90.0
        if turnedDegree < 0 {
            turnedDegree = 360.0 + turnedDegree
        }
        return turnedDegree
    }
    
    private func updateTime(degree: Int) {
        let oneSecond = kCircleDegree / kMaxTime
        var targetTime = degree / oneSecond
        if targetTime == 0 {
            targetTime = 1
        }
        if time == targetTime {
            return
        }
        time = targetTime
        currentTime = time
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    private func updateTimeLine(animated: Bool, value: Int) {
        let totalValue = 1.0 / CGFloat(time) * CGFloat(value)
        let strokeStart = timeLineForward ? 0.0 : totalValue
        let strokeEnd = timeLineForward ? totalValue : 1.0
        
        CATransaction.begin()
        CATransaction.setDisableActions(animated == false)
        circleLayer.strokeStart = strokeStart
        circleLayer.strokeEnd = strokeEnd
        CATransaction.commit()
    }
    
    private func showTimeRegulator() {
        timeRegulator.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        timeRegulator.layer.removeAnimation(forKey: kRegulatorAnimationKey)
        timeRegulator.layer.add(showingRegulatorAnimation, forKey: kRegulatorAnimationKey)
    }
    
    private func hideTimeRegulator() {
        timeRegulator.layer.transform = CATransform3DScale(CATransform3DIdentity, 0, 0, 1)
        timeRegulator.layer.removeAnimation(forKey: kRegulatorAnimationKey)
        timeRegulator.layer.add(hidingRegulatorAnimation, forKey: kRegulatorAnimationKey)
    }
    
    private func changeButtonPathAnimated() {
        let fromPath = isPlaying ? stopPath : playPath
        let toPath = isPlaying ? playPath : stopPath
        
        let animation = CABasicAnimation()
        animation.keyPath = "path"
        animation.fromValue = fromPath
        animation.toValue = toPath
        animation.duration = kDefaultAnimationDuration
        
        buttonShapeLayer.path = toPath.cgPath
        buttonShapeLayer.add(animation, forKey: "path_animation")
    }
    
    private func configureAppearance() {
        buttonShapeLayer.fillColor = AppearanceColor.circleTimeButton.cgColor
        buttonShapeLayer.strokeColor = AppearanceColor.circleTimeButton.cgColor
        circleLayer.strokeColor = AppearanceColor.circleShape.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        timeRegulatorLayer.fillColor = AppearanceColor.circleShape.cgColor
        Appearance.applyFor(timeLabel: timeLabel)
    }
    
    private func dropTimeLine() {
        timeLineForward = !timeLineForward
        updateTimeLine(animated: false, value: currentTime)
    }
    
    private func startTimeLine() {
        hideTimeRegulator()
    }
    
    private func finishTimeLine() {
        timeLineForward = true
        currentTime = time
        
        updateTimeLine(animated: true, value: currentTime)
        showTimeRegulator()
    }
    
    // MARK: - Handlers
    
    @objc private func handlePressPlay(sender: UIButton) {
        if canPlay == false {
            return
        }
        changeButtonPathAnimated()
        
        if isPlaying {
            timer?.invalidate()
            finishTimeLine()
        }
        else {
            startTimeLine()
        }
        
        isPlaying = !isPlaying
        playObserver.onNext(isPlaying)
    }
    
    @objc private func handlePan(sender: UIPanGestureRecognizer) {
        if isPlaying {
            return
        }
        switch sender.state {
        case .changed:
            calculateTimeRegulatorPosition(point: sender.location(in: self))
            break
        case .ended:
            timeObserver.onNext(time)
            break
        default:
            break
        }
    }
    
    @objc private func handleTap(sender: UIPanGestureRecognizer) {
        showTimeRegulator()
    }
    
    @objc private func handleTimer(sender: Timer) {
        guard isPlaying else {
            return
        }
        currentTime += 1
        updateTimeLine(animated: true, value: currentTime)

        if currentTime >= time {
            timer?.invalidate()
            self.timeOver.onNext(())
        }
    }
}
