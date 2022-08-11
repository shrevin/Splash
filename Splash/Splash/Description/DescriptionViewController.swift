//
//  DescriptionViewController.swift
//  Splash
//
//  Created by Shreya Vinjamuri on 7/26/22.
//

import UIKit


@objc class DescriptionViewController: UIViewController {
    var blueView = UIView()
    @objc var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        UIView.transition(with: self.label, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.showAnimation()
        }) { True in
            self.view.addSubview(self.label)
        }
    }
    
    // MARK: - Setting up the view
    func setUpView() {
        self.blueView.frame = CGRect(x: self.view.bounds.size.width/2 - 35, y: self.view.bounds.size.height/2 - 35, width: 70, height: 70)
        self.label.frame = CGRect(x: self.view.bounds.size.width/2 - 175, y: self.view.bounds.size.height/2 - 175, width: 250, height: 200)
        self.blueView.backgroundColor = UIColor(red: 0.779, green: 0.897, blue: 0.934, alpha: 0.8)
        self.blueView.layer.cornerRadius = 16
        view.addSubview(blueView)
        self.label.center = self.view.center
        self.label.numberOfLines = 0
        self.label.textAlignment = .center
        self.label.font = UIFont(name: "Gill Sans", size: 20)
    }
    
    // MARK: - Configuring animation
    func showAnimation () {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.scale"
        animation.fromValue = 1
        animation.toValue = 5
        animation.duration = 0.4
        self.blueView.layer.add(animation, forKey: "basic")
        blueView.layer.transform = CATransform3DMakeScale(5, 5, 1)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

