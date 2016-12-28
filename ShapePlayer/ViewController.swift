//
//  ViewController.swift
//  ShapePlayer
//
//  Created by Nguyen Bach on 12/27/16.
//  Copyright © 2016 Nguyen Bach. All rights reserved.
//

import UIKit

public class ViewController: UIViewController {
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        txt1.text = "1"
        txt2.text = "2"
        txt3.text = "3"
        drawView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    @IBOutlet weak var Perimeter: UILabel!
    @IBOutlet weak var Area: UILabel!
    @IBOutlet weak var option1: UILabel!
    @IBOutlet weak var option2: UILabel!
    @IBOutlet weak var option3: UILabel!
    @IBOutlet weak var Zoom: UISlider!
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var drawView: Shape!
    @IBAction func Segment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            drawView.segment = sender.selectedSegmentIndex
            option1.text = "a:"
            option2.text = "b:"
            option3.text = "c:"
            option3.isHidden = false
            txt3.isHidden = false
            
        }
        if sender.selectedSegmentIndex == 1 {
            drawView.segment = sender.selectedSegmentIndex
            option1.text = "a:"
            option2.text = "b:"
            option3.isHidden = true
            txt3.isHidden = true
//            let firsttxt = Double(txt1.text!)
//            let secondtxt = Double(txt2.text!)
//            if firsttxt != nil && secondtxt != nil{
//                let areaReal = Double(firsttxt! * secondtxt!)
//                Area.text = "Area: \(areaReal)"
//            }else{
//                Area.text = "Area: nil"
//            }
            
        }
        if sender.selectedSegmentIndex == 2 {
            drawView.segment = sender.selectedSegmentIndex
            option1.text = "radius:"
            option2.text = "degree:"
            option3.isHidden = true
            txt3.isHidden = true
        }
        if sender.selectedSegmentIndex == 3 {
            drawView.segment = sender.selectedSegmentIndex
            option1.text = "radius:"
            option2.text = "radius:"
            option3.isHidden = true
            txt3.isHidden = true
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func drawButton(_ sender: UIButton) {
        drawView.txt1 = Double(txt1.text!)!
        drawView.txt2 = Double(txt2.text!)!
        
       
        //drawView.txt3 = Double(txt3.text!)!
    }
    @IBAction func Zoom(_ sender: UISlider){
        drawView.zoom = Double(sender.value)
    }
    func PerimeterAndArea()  {
        Area?.text = String(drawView.area)
        Perimeter?.text = String(drawView.perimeter)
    }

}

extension ViewController: Share{
    func updateArea(area: String) {
        self.Area.text = "Area: \(area)"
    }
    
    func updatePerimeter(perimeter: String) {
        self.Perimeter.text = "Perimeter: \(perimeter)"
    }
}

protocol Share: class {
    func updateArea(area: String) -> ()
    func updatePerimeter(perimeter: String) -> ()
  
}

@IBDesignable class Shape: UIView{
    enum ShapeConstants: Int  {
       case Triangle = 0
       case Rectange = 1
       case Arc = 2
       case Ellipse = 3
        
    }
    var txt1 :Double = 100 {didSet{ setNeedsDisplay()}}
    var txt2 :Double = 100 {didSet{setNeedsDisplay()}}
    var txt3 :Double = 100 {didSet{setNeedsDisplay()}}
    var segment: Int = 0{didSet{setNeedsDisplay()}}
    var zoom: Double = 0.8{didSet{setNeedsDisplay()}}
    weak var delegate : Share?
    var perimeter: Double = 0 {didSet{self.delegate?.updatePerimeter(perimeter: String(perimeter))}}
    var area: Double = 0 {didSet{self.delegate?.updateArea(area: String(area))}}
    
    @IBInspectable var linewidth :CGFloat = 3.0
    
    override public func draw(_ rect: CGRect) {
        let linePath = UIBezierPath(rect: CGRect(x: 10, y: 10, width: self.frame.width - 10, height: self.frame.height - 10))
        linePath.lineWidth = self.linewidth
        UIColor.blue.setStroke()
        linePath.stroke()
        switch segment {
        case 0:
            Triangle()
        case 1:
            Rectangle()
        case 2:
            Arc()
        case 3:
            Ellipse()
        default:
            break
        }
        
        
    }
    func Rectangle()  {
        
        let edge1 = (txt1)
        let edge2 = (txt2)
        var area1 = area
        //let edge3 = (txt3)
     
        //        let point3 = CGPoint(x: a, y: b)
        
        //else{return}
        let linePath = UIBezierPath(rect: CGRect(x: 50, y: 50, width: edge1 * zoom, height: edge2 * zoom))
        
        linePath.lineWidth = self.linewidth

        linePath.close()
        UIColor.red.setStroke()
        linePath.stroke()
        
        area = Double(edge1) * Double(edge2)
        perimeter = (Double(edge1) + Double(edge2)) * 2
        

    }
    func Arc()  {
        let radius = txt1
        let degree = txt2
        let linePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2    , y: self.frame.height/2 ), radius: CGFloat(radius * zoom), startAngle: CGFloat((360 - degree).degreesToRadians) , endAngle: 0, clockwise: true)
        linePath.lineWidth = self.linewidth
        linePath.addLine(to: CGPoint(x: self.frame.width/2    , y: self.frame.height/2 ))
        
        linePath.close()
        UIColor.red.setStroke()
        linePath.stroke()
        area = Double(pow(radius, 2) * (degree/2))
        perimeter = Double(2 * M_PI * Double(radius) * degree / 360)
    }
    func Ellipse()  {
        let radius1 = txt1
        let radius2 = txt2
        let center1 = CGPoint(x: 50  , y: 50 )
        let linePath = UIBezierPath(ovalIn: CGRect(x: Double(center1.x), y: Double(center1.y), width: radius1 * zoom , height: radius2 * zoom))
            linePath.lineWidth = self.linewidth
            //linePath.addLine(to: CGPoint(x: self.frame.width/2    , y: self.frame.height/2 ))
            
            linePath.close()
            UIColor.red.setStroke()
            linePath.stroke()
            perimeter = Double(M_PI * sqrt((Double(radius1) * Double(radius1) + Double(radius2) * Double(radius2)) / 2))
            area =  Double(M_PI * Double(radius2) * Double(radius1))
        }
    func Triangle()  {
        var edge1 = txt1
        let edge2 = txt2
        let edge3 = txt3
        edge1 + edge2 >= edge3
        edge2 + edge3 >= edge1
        edge1 + edge3 >= edge2
        var a:Double = 100
        var b:Double = 100
        let point = CGPoint(x: a, y: b)
        edge1 = sqrt(a*50 + b*50)
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 50, y: 50))
        linePath.addLine(to: point)
        linePath.addLine(to: CGPoint(x: a + edge2, y: b))
        linePath.close()
        linePath.apply(CGAffineTransform(scaleX: CGFloat(zoom), y: CGFloat(zoom)))
        UIColor.red.setStroke()
        linePath.stroke()
        perimeter = (edge1 + edge2 + edge3) / 2
        area = Double(sqrt(perimeter * (perimeter - edge1) * (perimeter - edge2) * (perimeter - edge3)))
        //fail!!!
    }
   
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}

extension Double {
    var degreesToRadians: Double { return self * .pi / 180 }
    var radiansToDegrees: Double { return self * 180 / .pi }
}
