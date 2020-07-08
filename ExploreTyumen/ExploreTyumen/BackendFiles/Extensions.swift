//
//  Extensions.swift
//  TyumenDiscoverTheCity
//
//  Created by Глеб Завьялов on 09/08/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            // xib not loaded, or its top view is of the wrong type
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.edges(to: self)
        return contentView   // 7
    }
}

extension UIView {
    
    func edges(to view: UIView) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

extension UIImage {
    func resize(toWidth scaledToWidth: CGFloat) -> UIImage {
        let image = self
        let oldWidth = image.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = image.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        let scaledSize = CGSize(width:newWidth, height:newHeight)
        UIGraphicsBeginImageContextWithOptions(scaledSize, true, image.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}

extension UIView{
    func fadeIn(){
        UIView.animate(withDuration: 0.35, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {self.alpha = 1.0}, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.35, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    
    func fastFadeIn(){
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {self.alpha = 1.0}, completion: nil)
    }
    
    func fastFadeOut() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}


extension UIColor {
    
    convenience init(rgbColorCodeRed red: Int, green: Int, blue: Int, alpha: CGFloat) {
        
        let redPart: CGFloat = CGFloat(red) / 255
        let greenPart: CGFloat = CGFloat(green) / 255
        let bluePart: CGFloat = CGFloat(blue) / 255
        
        self.init(red: redPart, green: greenPart, blue: bluePart, alpha: alpha)
        
    }
}

extension UIView{
    func asCircle() {
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true
    }
}

extension UITextView {
    
    func scrollToBotom() {
        let range = NSMakeRange(text.characters.count - 1, 1);
        scrollRangeToVisible(range);
    }
    
    func scrollToTop(){
        self.scrollRangeToVisible(NSRange(location: 0, length: 0));
    }
}

extension UIImage{
    func blurEffect() -> UIImage {
        var context = CIContext(options: nil)
        
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: self)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(3, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.x, y: -origin.y,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}

extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    public func fixedOrientation() -> UIImage {
        if imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2)
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat.pi/2)
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        }
        
        switch imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
            break
        }
        
        let ctx: CGContext = CGContext(data: nil,
                                       width: Int(size.width),
                                       height: Int(size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent,
                                       bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        let cgImage: CGImage = ctx.makeImage()!
        
        return UIImage(cgImage: cgImage)
    }
}


extension CALayer {
    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
    }
}

extension CALayer {
    func addShadow() {
        self.shadowOffset = .zero
        self.shadowOpacity = 0.2
        self.shadowRadius = 10
        self.shadowColor = UIColor.black.cgColor
        self.masksToBounds = false
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

@IBDesignable class GradientView: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    @IBInspectable var topColor: UIColor = .red {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = .yellow {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowY: CGFloat = -3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowBlur: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointX: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        self.gradientLayer = self.layer as! CAGradientLayer
        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        self.layer.shadowRadius = shadowBlur
        self.layer.shadowOpacity = 1
        
    }
    
    func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
        let fromColors = self.gradientLayer?.colors
        let toColors: [AnyObject] = [ newTopColor.cgColor, newBottomColor.cgColor]
        self.gradientLayer?.colors = toColors
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.gradientLayer?.add(animation, forKey:"animateGradient")
    }
}


@IBDesignable
class ImageTextField: UITextField {
    
    var textFieldBorderStyle: UITextField.BorderStyle = .roundedRect
    
    // Provides left padding for image
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += padding
        return textRect
    }
    
    // Provides right padding for image
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= padding
        return textRect
    }
    
    @IBInspectable var fieldImage: UIImage? = nil {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var padding: CGFloat = 0
    @IBInspectable var color: UIColor = UIColor.gray {
        didSet {
            updateView()
        }
    }
    @IBInspectable var bottomColor: UIColor = UIColor.clear {
        didSet {
            if bottomColor == UIColor.clear {
                self.borderStyle = .roundedRect
            } else {
                self.borderStyle = .bezel
            }
            self.setNeedsDisplay()
        }
    }
    
    func updateView() {
        
        if let image = fieldImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = image
        
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }

        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.bounds.origin.x, y: self.bounds.height
            - 0.5))
        path.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.height
            - 0.5))
        path.lineWidth = 0.5
        self.bottomColor.setStroke()
        path.stroke()
    }
}

extension UIImage {
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}


class LoadingImageView: UIImageView{
    var imageUrlString: String?
    
    override func awakeFromNib(){
        self.layoutIfNeeded()
        self.layer.masksToBounds = true
    }
    
    func loadImageWithCache(withUrl: String){
        
        self.fastFadeOut()
        self.image = nil
        
        imageUrlString = withUrl
        

        
        if let cachedImage = imageCache.object(forKey: withUrl as AnyObject) as? UIImage{
            self.image = cachedImage
            self.fastFadeIn()
            return
        }
        
        let url = URL(string: withUrl)
        if(url != nil){
            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                if(error != nil){
                    self.image = UIImage()
                    print(error)
                    return
                }else{
                    DispatchQueue.main.async {
                        
                        let imageToCache = UIImage(data: data!)
                        
                        if(self.imageUrlString == withUrl){
                            imageCache.setObject(imageToCache!, forKey: withUrl as AnyObject)
                            self.image = imageToCache
                            self.fastFadeIn()
                        }
                    }   
                }
            }).resume()
        }
    }
    
    
    
    func loadBlurImageWithCache(withUrl: String){
        
        self.fastFadeOut()
        self.image = nil
        
        imageUrlString = withUrl
        
      
        
        
        
        if let cachedImage = imageCache.object(forKey: withUrl as AnyObject) as? UIImage{
            self.image = cachedImage.blurEffect()
            self.fastFadeIn()
            return
        }
        
        let url = URL(string: withUrl)
        if(url != nil){
            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                if(error != nil){
                    self.image = UIImage()
                    print(error)
                    return
                }else{
                    DispatchQueue.main.async {
                        
                        let imageToCache = UIImage(data: data!)
                        
                        if(self.imageUrlString == withUrl){
                            imageCache.setObject(imageToCache!, forKey: withUrl as AnyObject)
                            self.image = imageToCache!.blurEffect()
                            self.fastFadeIn()
                        }
                    }
                }
            }).resume()
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


class Time: Comparable, Equatable {
    init(_ date: Date) {
        //get the current calender
        let calendar = Calendar.current
        
        //get just the minute and the hour of the day passed to it
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        
        //calculate the seconds since the beggining of the day for comparisions
        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60
        
        //set the varibles
        secondsSinceBeginningOfDay = dateSeconds
        hour = dateComponents.hour!
        minute = dateComponents.minute!
    }
    
    init(_ hour: Int, _ minute: Int) {
        //calculate the seconds since the beggining of the day for comparisions
        let dateSeconds = hour * 3600 + minute * 60
        
        //set the varibles
        secondsSinceBeginningOfDay = dateSeconds
        self.hour = hour
        self.minute = minute
    }
    
    var hour : Int
    var minute: Int
    
    var date: Date {
        //get the current calender
        let calendar = Calendar.current
        
        //create a new date components.
        var dateComponents = DateComponents()
        
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        return calendar.date(byAdding: dateComponents, to: Date())!
    }
    
    /// the number or seconds since the beggining of the day, this is used for comparisions
    private let secondsSinceBeginningOfDay: Int
    
    //comparisions so you can compare times
    static func == (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay == rhs.secondsSinceBeginningOfDay
    }
    
    static func < (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay < rhs.secondsSinceBeginningOfDay
    }
    
    static func <= (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay <= rhs.secondsSinceBeginningOfDay
    }
    
    
    static func >= (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay >= rhs.secondsSinceBeginningOfDay
    }
    
    
    static func > (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay > rhs.secondsSinceBeginningOfDay
    }
}



extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

