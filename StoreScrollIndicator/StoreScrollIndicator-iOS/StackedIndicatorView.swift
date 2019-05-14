//
//  StackedIndicatorView.swift
//
//  Created by Satori Maru on 16.11.03.
//  Copyright © 2016年 usagimaru. All rights reserved.
//

import UIKit

public protocol StackedIndicatorViewDelegate: AnyObject {
	
	func stackedIndicator(view: StackedIndicatorView, didComplete indicator: ScrollIndicatorView, at index: Int)
	func stackedIndicator(view: StackedIndicatorView, shouldStartNext indicator: ScrollIndicatorView, at index: Int) -> Bool
	func stackedIndicatorViewDidCompleteAll(sender: StackedIndicatorView)
	
}

public class StackedIndicatorView: UIView {
	
	private var stackView = UIStackView()
	fileprivate(set) public var indicators = [ScrollIndicatorView]()
	
	public var spacing: CGFloat {
		get {
			return self.stackView.spacing
		}
		set {
			self.stackView.spacing = newValue
		}
	}
	
	public var numberOfIndicators: UInt = 1 {
		didSet {
			setIndicators()
		}
	}
	
	public var resetTimerWhenCompleted: Bool = false
	
	public weak var delegate: StackedIndicatorViewDelegate?
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		_init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		_init()
	}
	
	private func _init() {
		addSubview(self.stackView)
		
		self.stackView.translatesAutoresizingMaskIntoConstraints = false
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
													  options: [],
		                                              metrics: nil,
		                                              views: ["view" : self.stackView]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
													  options: [],
		                                              metrics: nil,
		                                              views: ["view" : self.stackView]))
		
		self.stackView.alignment = .fill
		self.stackView.distribution = .fillEqually
		self.stackView.axis = .horizontal
		self.spacing = 2
	}
	
	private func setIndicators() {
		for indicator in self.indicators {
			self.stackView.removeArrangedSubview(indicator)
			indicator.stopTimer()
		}
		self.indicators.removeAll()
		
		for _ in 0..<numberOfIndicators {
			let indicator = ScrollIndicatorView()
			indicator.style = .autoProgress
			indicator.delegate = self
			indicator.timerDuration = 2.0
			indicator.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
			self.stackView.addArrangedSubview(indicator)
			self.indicators.append(indicator)
		}
	}
	
	public func setTimerDuration(duration: CGFloat) {
		for indicator in self.indicators {
			indicator.timerDuration = duration
		}
	}
	
	public func start() {
		if let firstIndicator = self.indicators.first {
			if self.delegate?.stackedIndicator(view: self, shouldStartNext: firstIndicator, at: 0) ?? true {
				firstIndicator.startTimer()
			}
		}
	}
	
	public func reset() {
		for indicator in self.indicators {
			indicator.reset()
		}
	}

}

extension StackedIndicatorView: ScrollIndicatorViewDelegate {
	
	public func scrollIndicatorViewDidComplete(sender: ScrollIndicatorView){
		if !self.indicators.contains(sender) {
			return
		}
		
		if let index = self.indicators.firstIndex(of: sender) {
			if index < self.indicators.count - 1 {
				self.delegate?.stackedIndicator(view: self, didComplete: self.indicators[index], at: index)
				
				let next = index + 1
				let nextIndicator = self.indicators[next]
				if self.delegate?.stackedIndicator(view: self, shouldStartNext: nextIndicator, at: next) ?? true {
					nextIndicator.startTimer()
				}
			}
			else if index == self.indicators.count - 1 {
				let indicator = self.indicators[index]
				self.delegate?.stackedIndicator(view: self, didComplete: indicator, at: index)
				
				if self.resetTimerWhenCompleted {
					reset()
				}
				
				self.delegate?.stackedIndicatorViewDidCompleteAll(sender: self)
			}
		}
	}
	
}

