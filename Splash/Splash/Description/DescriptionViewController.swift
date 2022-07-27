//
//  DescriptionViewController.swift
//  Splash
//
//  Created by Shreya Vinjamuri on 7/26/22.
//

import UIKit

class DescriptionViewController: UIViewController {
    let redView = UIView(frame: CGRect(x: 20, y: 100, width: 140, height: 100))
    let animation = CABasicAnimation()
    override func viewDidLoad() {
        super.viewDidLoad()
        redView.backgroundColor = .systemRed
        view.addSubview(redView)
        // Do any additional setup after loading the view.
        animateRight();
        animateDown()
    }
    
    func animateRight() {
        animation.keyPath = "position.x" // Note: z-axis
        animation.fromValue = 20 + 140/2
        animation.toValue = 300
        animation.duration = 1
        redView.layer.add(animation, forKey: "basic")
        redView.layer.position = CGPoint(x: 300, y: 100)
    }
    
    func animateDown() {
        animation.keyPath = "position.y"
        animation.fromValue = 100 + 100/2;
        animation.toValue = 600
        animation.duration = 1
        redView.layer.add(animation, forKey: "basic")
        redView.layer.position = CGPoint(x: 300, y: 600)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = view.bounds
//        gradientLayer.colors = [UIColor.blue.cgColor,  UIColor.purple.cgColor]
//        view.layer.addSublayer(gradientLayer)
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
