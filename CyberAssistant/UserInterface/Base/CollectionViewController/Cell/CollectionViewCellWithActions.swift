//
//  CollectionViewCellWithActions.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 16/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class CollectionViewCellWithActions: BaseCollectionViewCell {
    lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panHandler(sender:)))
        gesture.delegate = self
        return gesture
    }()
    var startPanPoint: CGPoint?
    var startContentViewPosition: CGFloat = 0.0
    
    var actionViewModels: [CellActionViewModel]? {
        didSet {
            configureActions()
            configurePanGesture()
        }
    }
    private var actionViews = [UIView]()
    
    // MARK: - Public
    
    override func prepareForReuse() {
        super.prepareForReuse()
        actionViewModels = nil
        startPanPoint = nil
        startContentViewPosition = 0.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutActionViews()
    }
    
    func hideActions() {
        guard let point = startPanPoint else {
            return
        }
        let shiftLimit: CGFloat = CGFloat(actionViews.count) * AppearanceSize.cellActionWidth
        let currentPoint = CGPoint(x: point.x + shiftLimit, y: point.y)
        UIView.animate(withDuration: kSwipeAnimationDuration, animations: {
            self.moveActionView(startPoint: point, currentPoint: currentPoint)
        }) { (finish) in
            self.startContentViewPosition = 0.0
            self.startPanPoint = nil
        }
    }

    // MARK: - Private
    
    private func configureActions() {
        for view in actionViews {
            view.removeFromSuperview()
        }
        actionViews = []
        
        guard let acts = actionViewModels else {
            self.clipsToBounds = false
            return
        }
        self.clipsToBounds = true
        
        for actionVM in acts {
            let view = CellActionView(viewModel: actionVM)
            addSubview(view)
            actionViews.append(view)
        }
    }
    
    private func layoutActionViews() {
        guard actionViews.count > 0 && startPanPoint == nil else {
            return
        }
        
        let x = self.frame.maxX
        let y: CGFloat = 0.0
        let height = self.frame.height
        let width = AppearanceSize.cellActionWidth
        for view in actionViews {
            view.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    private func configurePanGesture() {
        if actionViewModels == nil {
            self.removeGestureRecognizer(panGesture)
        }
        else {
            self.addGestureRecognizer(panGesture)
        }
    }
    
    @objc private func panHandler(sender: UIPanGestureRecognizer) {
        let currentPoint = sender.location(in: self)
        switch sender.state {
        case .began:
            startPanPoint = currentPoint
            break
        case .changed:
            assert(startPanPoint != nil)
            moveActionView(startPoint: startPanPoint!, currentPoint: currentPoint)
            break
        case .cancelled, .failed:
            assert(startPanPoint != nil)
            moveActionView(startPoint: startPanPoint!, currentPoint: startPanPoint!)
            startPanPoint = nil
        case .ended:
            assert(startPanPoint != nil)
            let currentPoint = calculatePointForEnd(startPoint: startPanPoint!, currentPoint: currentPoint)
            UIView.animate(withDuration: currentPoint.duration, animations: {
                self.moveActionView(startPoint: self.startPanPoint!, currentPoint: currentPoint.point)
            }) { (finish) in
                self.startContentViewPosition = self.contentView.frame.origin.x
            }
            break
        default:
            break
        }
    }
    
    private func moveActionView(startPoint: CGPoint, currentPoint: CGPoint) {
        let shiftLimit: CGFloat = CGFloat(actionViews.count) * AppearanceSize.cellActionWidth
        let diff = startPoint.x - currentPoint.x
        
        var contentViewX = startContentViewPosition - diff
        if contentViewX > 0.0 {
            contentViewX = 0.0
        }
        else if contentViewX < -shiftLimit {
            contentViewX = -shiftLimit
        }
        contentView.frame.origin.x = contentViewX
        let shiftWidth: CGFloat = fabs(contentViewX / CGFloat(actionViews.count))
        actionViews.enumerated().forEach { (offset, view) in
            let shift: CGFloat = shiftWidth * CGFloat(actionViews.count - offset)
            view.frame.origin.x = contentView.frame.size.width - shift
        }        
    }
    
    private func calculatePointForEnd(startPoint: CGPoint, currentPoint: CGPoint) -> (point: CGPoint, duration: Double)  {
        let shiftLimit: CGFloat = CGFloat(actionViews.count) * AppearanceSize.cellActionWidth
        let diff = fabs(startPoint.x - currentPoint.x)
        let rest = shiftLimit - diff
        let duration = kSwipeAnimationDuration * Double(rest / shiftLimit)
        
        if shiftLimit / fabs(diff) >= 2.0 {
            return (point: startPoint, duration: duration)
        }
        else {
            let direction: CGFloat = startPoint.x - currentPoint.x >= 0 ? -1.0 : 1.0
            let point = CGPoint(x: currentPoint.x + rest * direction, y: currentPoint.y)
            return (point: point, duration: duration)
        }
    }
}

extension CollectionViewCellWithActions: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((panGesture.velocity(in: panGesture.view)).x) > abs((panGesture.velocity(in: panGesture.view)).y)
    }
}
