//
//  HederView.swift
//  side-slide-controller
//
//  Created by yannmm on 18/5/6.
//  Copyright © 2018 ddpc. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    // MARK: - Constant
    private enum Constant {
        static let effectiveHeight: CGFloat = 44.0
        static let defaultSafeAreaTopInset: CGFloat = 20.0
        static let title = "嘀嗒出租车"
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = UIColor.orange
        
        // 添加视图
//        addSubview(contentView)
//        contentView.addSubview(logoImageView)
//        contentView.addSubview(leftButton)
//        contentView.addSubview(rightButton)
//        contentView.addSubview(indicatorView)
//
//        // 添加约束
//        contentView.snp.makeConstraints { (make) in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.height.equalTo(Constant.effectiveHeight)
//        }
//
//        logoImageView.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//        }
//
//        leftButton.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.leading.equalToSuperview().offset(5.0)
//            //                make.size.equalTo(CGSize(width: 20.0, height: 20.0))
//        }
//
//        rightButton.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.trailing.equalToSuperview().offset(-5.0)
//            //                make.size.equalTo(CGSize(width: 20.0, height: 20.0))
//        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuring Size
    override var intrinsicContentSize: CGSize {
        if #available(iOS 11, *) {
            let size = CGSize(width: UIScreen.main.bounds.size.width, height: Constant.effectiveHeight + safeAreaInsets.top)
            return size
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width, height: Constant.effectiveHeight + Constant.defaultSafeAreaTopInset)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if #available(iOS 11, *) {
            return CGSize(width: UIScreen.main.bounds.size.width, height: Constant.effectiveHeight + safeAreaInsets.top)
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width, height: Constant.effectiveHeight + Constant.defaultSafeAreaTopInset)
        }
    }
    
    override func safeAreaInsetsDidChange() {
        invalidateIntrinsicContentSize()
        superview?.layoutIfNeeded()
//        print("safeAreaInsetsDidChange")
//        print("改变了哈：\(intrinsicContentSize)")
//        sizeToFit()
    }
    
    // MARK: - Action
//    @objc private func leftButtonTapped() {
//        if let slide = viewController?.parent as? SideSlideController {
//            slide.slideOut(completion: {
//                //
//            })
//        }
//    }
    
//    @objc private func rightButtonTapped() {
//        let vc = NotificationViewController()
//        vc.pushAnimation = .bottom
//        rightButton.dd_showsDot = false
//        UIApplication.shared.rootNavigationController?.pushViewController(vc, animated: true)
//    }
    
    
    // MARK: - Lazy
//    private lazy var logoImageView: UIImageView = {
//        let liv = UIImageView(image: UIImage(named: "didaTaxi"))
//        return liv
//    }()
//
//    private lazy var indicatorView: UIView = {
//        let siv = UIView()
//        siv.backgroundColor = UIColor.orange
//        return siv
//    }()
//
//    private lazy var leftButton: UIButton = {
//        let lb = UIButton(type: .custom)
//        lb.setImage(UIImage(named: "iconSideMenu"), for: .normal)
//        lb.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
//        lb.adjustsImageWhenHighlighted = false
//        return lb
//    }()
//
//    private lazy var rightButton: UIButton = {
//        let rb = UIButton(type: .custom)
//        rb.setImage(UIImage(named: "iconNotice"), for: .normal)
//        rb.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
//        rb.adjustsImageWhenHighlighted = false
//        return rb
//    }()
//
//    private lazy var contentView: UIView = {
//        let cv = UIView()
//        cv.backgroundColor = UIColor.clear
//        return cv
//    }()
}
