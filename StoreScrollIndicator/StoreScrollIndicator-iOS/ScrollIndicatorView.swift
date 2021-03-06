//
//  ScrollIndicatorView.swift
//
//  Created by Satori Maru on 16.10.11.
//  Copyright © 2016年 usagimaru. All rights reserved.
//

import UIKit

// Original Background Color: #D8D8D8
// Original Indicator Color: #525252

public protocol ScrollIndicatorViewDelegate: AnyObject {
	
	func scrollIndicatorViewDidComplete(sender: ScrollIndicatorView)
	
}

public class ScrollIndicatorView: UIView {
	
	public enum ScrollIndicatorStyle: Int {
		case marker
		case progress
		case autoProgress
	}
	
	private var fadingIn: Bool = false
	private var fadingOut: Bool = false
	private var pageValue: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	private var indicator = UIView()
	private weak var timer: Timer?
	private var animating: Bool = false
	
	public var numberOfPages: UInt = 0
	public var timerDuration: CGFloat = 1.0
	public var style: ScrollIndicatorStyle = .marker
	@IBInspectable public var indicatorColor: UIColor! = #colorLiteral(red: 0.3234693706, green: 0.3234777451, blue: 0.3234732151, alpha: 1) {
		didSet {
			self.indicator.backgroundColor = indicatorColor
		}
	}
	
	public weak var delegate: ScrollIndicatorViewDelegate?
	
	
    override init(frame: CGRect) {
		super.init(frame: frame)
		_init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		_init()
	}
	
	private func _init() {
		self.clipsToBounds = true
		self.alpha = 0.4
		
		self.indicator.clipsToBounds = true
		self.indicator.backgroundColor = self.indicatorColor
		
		addSubview(self.indicator)
	}
	
	
	// MARK: -
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		if layer.cornerRadius != frame.height / 2 {
			layer.cornerRadius = frame.height / 2
		}
		if self.indicator.layer.cornerRadius != frame.height / 2 {
			self.indicator.layer.cornerRadius = frame.height / 2
		}
		
		let h = frame.height
		var w = CGFloat(0.0)
		var x = CGFloat(0.0)
		
		switch style {
		case .marker:
			x = self.pageValue
			w = numberOfPages > 0 ? frame.width / CGFloat(self.numberOfPages) : 0
		case .progress, .autoProgress:
			w = self.pageValue
		}
		
		let indicatorFrame = CGRect(x: x, y: 0, width: w, height: h)
		self.indicator.frame = indicatorFrame
	}
	
	
	// MARK: -
	
	func scrollTo(pageOffset: CGFloat, pageWidth: CGFloat) {
		switch style {
		case .marker:
			let pageRate = (frame.width / pageWidth / CGFloat(self.numberOfPages))
			let x = pageOffset * pageRate
			self.pageValue = x
		case .progress:
			let pageRate = (frame.width / pageWidth / CGFloat(self.numberOfPages - 1))
			let x = pageOffset * pageRate
			self.pageValue = x
		default:
			break
		}
	}
	
	public func scrollToOffsetOf(scrollView: UIScrollView) {
		scrollTo(pageOffset: scrollView.contentOffset.x, pageWidth: scrollView.frame.width)
	}
	
	public func fadeIn() {
		if self.fadingIn {return}
		
		self.fadingIn = true
		self.fadingOut = false
		UIView.animate(withDuration: 0.25,
		               delay: 0,
					   options: .beginFromCurrentState,
		               animations: {
						self.alpha = 1.0
			},
		               completion: { (finished: Bool) in
						self.fadingIn = false
		})
	}
	
	public func fadeOut() {
		if self.fadingOut {return}
		
		self.fadingOut = true
		self.fadingIn = false
		UIView.animate(withDuration: 0.8,
		               delay: 0.3,
		               options: .beginFromCurrentState,
		               animations: {
						self.alpha = 0.4
			},
		               completion: { (finished: Bool) in
						self.fadingOut = false
		})
	}
	
	public func startTimer() {
		if self.timer != nil || self.style != .autoProgress || (self.style == .autoProgress && self.pageValue == frame.width) {
			return
		}
		
		self.animating = true
		let interval = 1.0 / 60.0
		self.timer = Timer.scheduledTimer(timeInterval: interval,
										  target: self,
										  selector: #selector(timerAction),
										  userInfo: nil,
										  repeats: true)
		RunLoop.current.add(self.timer!, forMode: .common)
	}
	
	public func stopTimer() {
		if style != .autoProgress {
			return
		}
		
		self.timer?.invalidate()
		self.timer = nil
		self.animating = false
	}
	
	public func reset() {
		self.timer?.invalidate()
		self.timer = nil
		self.animating = false
		self.pageValue = 0
	}
	
	@objc public func timerAction(sender: Timer) {
		if self.timerDuration <= 0.0 || !self.animating {
			stopTimer()
			return
		}
		
		let v = max(min(self.pageValue + frame.width / self.timerDuration / 60.0, frame.width), 0.0)
		self.pageValue = v
		
		if self.pageValue == frame.width {
			stopTimer()
			self.delegate?.scrollIndicatorViewDidComplete(sender: self)
		}
	}
	
}

extension ScrollIndicatorView: UIScrollViewDelegate {
	
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
		scrollToOffsetOf(scrollView: scrollView)
		
		if scrollView.isTracking || scrollView.isDragging {
			fadeIn()
		}
	}
	
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		fadeOut()
	}
	
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		fadeOut()
	}
	
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		fadeOut()
	}
	
}
