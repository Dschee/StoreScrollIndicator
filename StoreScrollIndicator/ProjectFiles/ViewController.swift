//
//  ViewController.swift
//  StoreScrollIndicator
//
//  Created by Satori Maru on 16.10.11.
//  Copyright © 2016年 usagimaru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var scrollIndicatorView1: ScrollIndicatorView!
	@IBOutlet weak var scrollIndicatorView2: ScrollIndicatorView!
	@IBOutlet weak var scrollIndicatorView3: ScrollIndicatorView!
	@IBOutlet weak var scrollIndicatorView4: ScrollIndicatorView!
	@IBOutlet weak var scrollIndicatorView5: ScrollIndicatorView!
	@IBOutlet weak var stackedIndicatorView1: StackedIndicatorView!
	@IBOutlet weak var stackedIndicatorView2: StackedIndicatorView!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let pageCount = UInt(5)
		self.scrollIndicatorView1.numberOfPages = pageCount
		self.scrollIndicatorView2.numberOfPages = pageCount
		self.scrollIndicatorView3.numberOfPages = pageCount
		self.scrollIndicatorView1.style = .marker
		self.scrollIndicatorView2.style = .progress
		self.scrollIndicatorView3.style = .marker
		self.scrollIndicatorView4.style = .autoProgress
		self.scrollIndicatorView5.style = .autoProgress
		self.scrollIndicatorView4.delegate = self
		self.scrollIndicatorView5.delegate = self
		self.scrollIndicatorView4.timerDuration = 3.0
		self.scrollIndicatorView5.timerDuration = 5.0
		
		self.stackedIndicatorView1.numberOfIndicators = pageCount
		self.stackedIndicatorView2.numberOfIndicators = 6
		self.stackedIndicatorView1.resetTimerWhenCompleted = true
		self.stackedIndicatorView2.resetTimerWhenCompleted = true
		self.stackedIndicatorView1.setTimerDuration(duration: 2)
		self.stackedIndicatorView2.setTimerDuration(duration: 1)
		self.stackedIndicatorView1.spacing = 2
		self.stackedIndicatorView2.spacing = 16
		self.stackedIndicatorView1.delegate = self
		self.stackedIndicatorView2.delegate = self
		
		self.scrollView.layoutIfNeeded()
		self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * CGFloat(pageCount), height: self.scrollView.frame.height)
		
		let colors = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1),#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
		for (i, indicator) in self.stackedIndicatorView2.indicators.enumerated() {
			indicator.indicatorColor = colors[i]
		}
		
		for i in 0..<pageCount {
			let v = UIView()
			v.clipsToBounds = true
			
			let x = self.scrollView.frame.width * CGFloat(i)
			v.frame = CGRect(x: x, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
			v.backgroundColor = UIColor(hue: CGFloat(i)/CGFloat(pageCount), saturation: 0.3, brightness: 1, alpha: 1)
			
			self.scrollView.addSubview(v)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.scrollIndicatorView4.startTimer()
		self.scrollIndicatorView5.startTimer()
		self.stackedIndicatorView1.start()
		self.stackedIndicatorView2.start()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}

}

extension ViewController: UIScrollViewDelegate {
	
	private func endScrolling() {
		self.scrollIndicatorView1.fadeOut()
		self.scrollIndicatorView2.fadeOut()
		self.scrollIndicatorView3.fadeOut()
		self.scrollIndicatorView4.fadeOut()
		self.scrollIndicatorView5.fadeOut()
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView){
		self.scrollIndicatorView1.scrollToOffsetOf(scrollView: scrollView)
		self.scrollIndicatorView2.scrollToOffsetOf(scrollView: scrollView)
		self.scrollIndicatorView3.scrollToOffsetOf(scrollView: scrollView)
		
		if scrollView.isTracking || scrollView.isDragging {
			self.scrollIndicatorView1.fadeIn()
			self.scrollIndicatorView2.fadeIn()
			self.scrollIndicatorView3.fadeIn()
			self.scrollIndicatorView4.fadeIn()
			self.scrollIndicatorView5.fadeIn()
		}
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		endScrolling()
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		endScrolling()
	}
	
	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		endScrolling()
	}
	
}

extension ViewController: ScrollIndicatorViewDelegate {
	
	func scrollIndicatorViewDidComplete(sender: ScrollIndicatorView){
		sender.reset()
		sender.startTimer()
	}
	
}

extension ViewController: StackedIndicatorViewDelegate {
	
	func stackedIndicator(view: StackedIndicatorView, didComplete indicator: ScrollIndicatorView, at index: Int) {
		
	}
	
	func stackedIndicator(view: StackedIndicatorView, shouldStartNext indicator: ScrollIndicatorView, at index: Int) -> Bool {
		return true
	}
	
	func stackedIndicatorViewDidCompleteAll(sender: StackedIndicatorView){
		sender.start()
	}
	
}
