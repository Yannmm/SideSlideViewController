//
//  SideSlideController.swift
//  container-view-controller
//
//  Created by 闫萌 on 17/11/30.
//  Copyright © 2017 ddpc. All rights reserved.
//

import UIKit

class SideSlideController: UIViewController {
    // MARK: - Constant
    private enum Constant {
        static let automaticSlideThreshhold: CGFloat = 30.0
        static let animationInterval: TimeInterval = 0.25
        static let sideWidthRatio: CGFloat = 323.0 / 375.0
        static let mainViewScaleBias: CGFloat = 0.05
    }
    
    // MARK: - Slide Operation
    /// 滑出
    public func slideOut(completion: (() -> Void)?) {
        if !isOut { // 展开
            setupViewsIfNecessary()
            fulfilAnimation(completion: completion)
        }
    }
    
    /// 收起
    public func slideIn(completion: (() -> Void)?) {
        if isOut { // 收起
            resetAnimation(completion: completion)
        }
    }
    
    
    // MARK: - Property
    /// 主控制器
    public let mainViewController: UIViewController
    /// 侧边控制器
    public let sideViewController: UIViewController
    /// 侧边是否展开
    public var isOut = false {
        didSet {
            if isOut {
                print("已展开")
            } else {
                print("已收起")
            }
        }
    }
    
    private lazy var sideWidth: CGFloat = {
        return Constant.sideWidthRatio * view.bounds.width
    }()
    
    // MARK: - Life Cycle
    public init(mainViewController: UIViewController, sideViewController: UIViewController) {
        self.mainViewController = mainViewController
        self.sideViewController = sideViewController
        super.init(nibName: nil, bundle: nil)
        
        addChildViewController(mainViewController)
        addChildViewController(sideViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Managing the View
    override func viewDidLoad() {
        view.backgroundColor = UIColor.black
        setupMainView()
        // 添加屏幕边缘滑动手势
        view.addGestureRecognizer(screenEdgePanGestureRecognizer)
    }
    
    private func setupMainView() {
        view.addSubview(mainViewController.view)
        mainViewController.view.frame = view.bounds
        mainViewController.didMove(toParentViewController: self)
    }
    
    private func setupSideView() {
        view.addSubview(sideViewController.view)
        sideViewController.view.frame = CGRect(x: -sideWidth, y: 0.0, width: sideWidth, height: view.bounds.height)
        sideViewController.didMove(toParentViewController: self)
    }
    
    private func setupViewsIfNecessary() {
        if gestureRecognizerView.superview == nil {
            view.addSubview(gestureRecognizerView)
            gestureRecognizerView.frame = view.bounds
        }
        if sideViewController.view.superview == nil {
            setupSideView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 如果side显示，则优先调用他的，否则才调用main
        if sideViewController.view.superview != nil {
            sideViewController.beginAppearanceTransition(true, animated: animated)
        } else {
            mainViewController.beginAppearanceTransition(true, animated: animated)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 如果side显示，则优先调用他的，否则才调用main
        if sideViewController.view.superview != nil {
            sideViewController.endAppearanceTransition()
        } else {
            mainViewController.endAppearanceTransition()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainViewController.beginAppearanceTransition(false, animated: animated)
        if sideViewController.view.superview != nil {
            sideViewController.beginAppearanceTransition(false, animated: animated)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mainViewController.endAppearanceTransition()
        if sideViewController.view.superview != nil {
            sideViewController.endAppearanceTransition()
        }
    }
    
    private func setupGestureRecognizersWhenOut() {
        // 添加返回手势
        if tapGestureRecognizer.view == nil {
            gestureRecognizerView.addGestureRecognizer(tapGestureRecognizer)
        }
        if panGestureRecognizer.view == nil {
            gestureRecognizerView.addGestureRecognizer(panGestureRecognizer)
        }
        view.removeGestureRecognizer(screenEdgePanGestureRecognizer)
    }
    
    private func setupGestureRecognizersWhenIn() {
        gestureRecognizerView.removeGestureRecognizer(panGestureRecognizer)
        gestureRecognizerView.removeGestureRecognizer(tapGestureRecognizer)
        view.addGestureRecognizer(screenEdgePanGestureRecognizer)
    }
    
    // MARK: - Managing Child View Controllers in a Custom Container
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
    
    // MARK: - Managing the Status Bar
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return mainViewController
    }
    
    // MARK: - Action
    @objc private func edgePan( _ screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = screenEdgePanGestureRecognizer.translation(in: gestureRecognizerView).x
        switch screenEdgePanGestureRecognizer.state {
        case .began: // 开始，添加视图
            setupViewsIfNecessary()
            sideInMainOutTransition(animated: false)
        case .changed: // 不断滑动
            if translation > sideWidth { // 滑动距离够了
                return
            }
            sideViewController.view.frame.origin.x = -sideWidth + translation
            gestureRecognizerView.alpha = translation / sideWidth
            let bias = translation / sideWidth * Constant.mainViewScaleBias
            mainViewController.view.transform = CGAffineTransform(scaleX: 1.0 - bias, y: 1.0 - bias)
            
        case .cancelled, .failed:
            resetAnimation(completion: nil)
        case .ended:
            
            if translation < Constant.automaticSlideThreshhold { // 滑动距离不足以促成抽屉
                resetAnimation(completion: nil)
            } else if translation < sideWidth {
                // 促成抽屉，但滑动距离还不够
                let xVelocity = screenEdgePanGestureRecognizer.velocity(in: gestureRecognizerView).x
                // 只能向右
                if xVelocity > 0.0 { // 向右
                    fulfilAnimation(completion: nil)
                } else { // 向左
                    resetAnimation(completion: nil)
                }
            } else { // 完全滑动
                setupGestureRecognizersWhenOut()
            }
        default:
            print("不可能的状态：\(screenEdgePanGestureRecognizer.state)")
        }
    }
    
    private func reset() {
        sideViewController.view.frame.origin.x = -sideWidth
        gestureRecognizerView.alpha = 0.0
        mainViewController.view.transform = CGAffineTransform.identity
    }
    
    private func resetAnimation(completion: (() -> Void)?) {
        sideOutMainInTransition(animated: true)
        UIView.animate(withDuration: Constant.animationInterval, animations: { [unowned self] in
            self.reset()
        }) { [unowned self] (done) in
            self.sideViewController.endAppearanceTransition()
            self.mainViewController.endAppearanceTransition()
            self.remove()
            completion?()
        }
    }
    
    private func remove() {
        gestureRecognizerView.removeFromSuperview()
        setupGestureRecognizersWhenIn()
        
        sideViewController.willMove(toParentViewController: nil)
        sideViewController.view.removeFromSuperview()
//        sideViewController.removeFromParentViewController()
        isOut = false
    }
    
    private func fulfill() {
        sideViewController.view.frame.origin.x = 0.0
        gestureRecognizerView.alpha = 1.0
        mainViewController.view.transform = CGAffineTransform(scaleX: 1.0 - Constant.mainViewScaleBias, y: 1.0 - Constant.mainViewScaleBias)
    }
    
    private func fulfilAnimation(completion: (() -> Void)?) {
        sideInMainOutTransition(animated: true)
        UIView.animate(withDuration: Constant.animationInterval, animations: { [unowned self] in
            self.fulfill()
            }, completion: { [unowned self] (done) in
                self.sideViewController.endAppearanceTransition()
                self.mainViewController.endAppearanceTransition()
                self.setupGestureRecognizersWhenOut()
                self.isOut = true
                completion?()
        })
    }
    
    private func sideOutMainInTransition(animated: Bool) {
        sideViewController.beginAppearanceTransition(false, animated: animated)
        mainViewController.beginAppearanceTransition(true, animated: animated)
    }
    
    private func sideInMainOutTransition(animated: Bool) {
        sideViewController.beginAppearanceTransition(true, animated: animated)
        mainViewController.beginAppearanceTransition(false, animated: animated)
    }
    
    @objc private func tapped() {
        // 消失
        resetAnimation(completion: nil)
    }
    
    @objc private func pan(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let x = panGestureRecognizer.location(in: gestureRecognizerView).x
        switch panGestureRecognizer.state {
        case .began:
            print("开始啦")
            sideOutMainInTransition(animated: false)
        case .changed:
            if x < sideWidth { // 进入侧边栏范围
                sideViewController.view.frame.origin.x = x - sideWidth
                gestureRecognizerView.alpha = 1 - abs(sideViewController.view.frame.origin.x) / sideWidth
                let bias = gestureRecognizerView.alpha * Constant.mainViewScaleBias
                mainViewController.view.transform = CGAffineTransform(scaleX: 1.0 - bias, y: 1.0 - bias)
                
                if x <= 0.0 { // 拖动到头
                    sideViewController.endAppearanceTransition()
                    mainViewController.endAppearanceTransition()
                }
            }
        case .cancelled, .failed:
            print("手势取消")
        case .ended:
            if sideViewController.view.frame.origin.x > -sideWidth { // 没有完全归位
                let xVelocity = panGestureRecognizer.velocity(in: gestureRecognizerView).x
                // 只能向左
                if xVelocity > 0.0 { // 向右
                    fulfilAnimation(completion: nil)
                } else { // 向左
                    resetAnimation(completion: nil)
                }
            } else { // 完全归位
                self.remove()
                isOut = false
            }
            
        default:
            print("其他状态")
        }
    }
    
    // MARK: - Configuring a Navigation Interface
    override var navigationItem: UINavigationItem {
        return mainViewController.navigationItem
    }
    
    // MARK: - Lazy
    private lazy var gestureRecognizerView: UIView = {
        let grv = UIView()
        grv.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        grv.alpha = 0.0
        return grv
    }()
    
    private lazy var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
        let sepgr = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePan))
        sepgr.edges = [.left]
        return sepgr
    }()
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let pgr = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        pgr.require(toFail: screenEdgePanGestureRecognizer)
        return pgr
    }()
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tgr = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tgr.require(toFail: screenEdgePanGestureRecognizer)
        tgr.numberOfTapsRequired = 1
        return tgr
    }()
}
