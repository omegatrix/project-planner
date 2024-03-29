//
//  CircularProgressBar.swift
//  ProjectPlanner
//
//  Created by user153198 on 5/8/19.
//  Copyright © 2019 Arnold Anthonypillai. All rights reserved.
//

import UIKit

class CircularProgressBar: UIView
{
    /*
     This file is created by using the code in https://gist.github.com/yogeshmanghnani/d73ad00eed7b3b55784c0d24e9852332
     
     I followedthe guide created by the developer at https://codeburst.io/circular-progress-bar-in-ios-d06629700334
    */

    override func awakeFromNib()
    {
        super.awakeFromNib()
        setupView()
        label.text = "0"
    }
    
    public var progress: Int = 0
    
    
    //MARK: Public
    
    public var lineWidth:CGFloat = 20
    {
        didSet
        {
            foregroundLayer.lineWidth = lineWidth
            backgroundLayer.lineWidth = lineWidth - (0.20 * lineWidth)
        }
    }
    
    public var labelSize: CGFloat = 20
    {
        didSet
        {
            label.font = UIFont.systemFont(ofSize: labelSize)
            label.sizeToFit()
            configLabel()
        }
    }
    
    public var daysRemain: Int = 0
    public var showDaysRemain: Bool = false
    public var strokeEndVal: CGFloat = 0
    
    public func setProgress(to progressConstant: Double, withAnimation: Bool)
    {
        var backgroundStrokeEnd: CGFloat = 1.0
        var foregroundStrokeEnd: CGFloat = 0.0
        
        
        var progress: Double
        {
            get
            {
                if progressConstant > 1 { return progressConstant }
                else if progressConstant < 0 { return 0 }
                else { return progressConstant }
            }
        }        
        
        foregroundLayer.strokeEnd = CGFloat(progress) / 100.0
        
        if withAnimation
        {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = CGFloat(progress / 100.0)
            animation.duration = 2
            foregroundLayer.add(animation, forKey: "foregroundAnimation")
            
        }
        
        
        var currentTime:Double = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            if currentTime >= 2
            {
                timer.invalidate()
            }
            
            else
            {
                currentTime += 0.05
                let percent = currentTime/2
                self.progress = Int(progress * percent)
                self.label.text = (self.showDaysRemain) ? "\(self.daysRemain) Day(s) Left" : "\(Int(progress * percent))% Complete"
                self.label.textColor = UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1.0) //aqua colour
                self.setForegroundLayerColorForSafePercent()
                self.configLabel()
            }
        }
        
        timer.fire()
        
    }
    
    public func showView()
    {
        self.isHidden = false
    }
    
    public func hideView()
    {
        self.isHidden = true
    }
    
    
    
    
    //MARK: Private
    private var label = UILabel()
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private var radius: CGFloat
    {
        get
        {
            if self.frame.width < self.frame.height { return (self.frame.width - lineWidth)/2 }
            else { return (self.frame.height - lineWidth)/2 }
        }
    }
    
    private var pathCenter: CGPoint{ get{ return self.convert(self.center, from:self.superview) } }
    private func makeBar()
    {
        self.layer.sublayers = nil
        drawBackgroundLayer()
        drawForegroundLayer()
    }
    
    private func drawBackgroundLayer()
    {
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        self.backgroundLayer.path = path.cgPath
        self.backgroundLayer.strokeColor = UIColor.lightGray.cgColor
        self.backgroundLayer.lineWidth = lineWidth - (lineWidth * 20/100)
        self.backgroundLayer.fillColor = UIColor.clear.cgColor
        self.backgroundLayer.strokeEnd = 1
        self.layer.addSublayer(backgroundLayer)
        
    }
    
    private func drawForegroundLayer()
    {
        
        let startAngle = (-CGFloat.pi/2)
        let endAngle = 2 * CGFloat.pi + startAngle
        
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        foregroundLayer.lineCap = CAShapeLayerLineCap.round
        foregroundLayer.path = path.cgPath
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeColor = UIColor.red.cgColor
        //foregroundLayer.strokeEnd = 0
        
        self.layer.addSublayer(foregroundLayer)
        
    }
    
    private func makeLabel(withText text: String) -> UILabel
    {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = UIFont.systemFont(ofSize: labelSize)
        label.sizeToFit()
        label.center = pathCenter
        return label
    }
    
    private func configLabel()
    {
        label.sizeToFit()
        label.center = pathCenter
    }
    
    private func setForegroundLayerColorForSafePercent()
    {
        if(self.progress > 75)
        {
            self.foregroundLayer.strokeColor = UIColor.green.cgColor
        }
        
        else if(self.progress > 50 && progress <= 75)
        {
            self.foregroundLayer.strokeColor = UIColor.yellow.cgColor
        }
        
        else if(self.progress > 25 && self.progress <= 50)
        {
            self.foregroundLayer.strokeColor = UIColor.orange.cgColor
        }
        
        else
        {
            self.foregroundLayer.strokeColor = UIColor.red.cgColor
        }
        
    }
    
    private func setupView()
    {
        makeBar()
        self.addSubview(label)
    }
    
    
    
    //Layout Sublayers
    private var layoutDone = false
    override func layoutSublayers(of layer: CALayer)
    {
        if !layoutDone
        {
            let tempText = label.text
            setupView()
            label.text = tempText
            layoutDone = true
        }
        
    }
}
