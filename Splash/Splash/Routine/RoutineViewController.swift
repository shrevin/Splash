//
//  RoutineViewController.swift
//  Splash
//
//  Created by Shreya Vinjamuri on 8/1/22.
//

import UIKit
import SCLAlertView

class RoutineViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
    @IBOutlet var startButton: UIButton!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var collectionView: UICollectionView!
    var colors: [UIColor] = [.link, .systemGreen, .systemBlue, .red, .systemOrange, .black, .systemPurple, .systemYellow, .systemPink]
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width - 30, height: view.frame.size.height / 5)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView.isScrollEnabled = false
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        collectionView.addGestureRecognizer(gesture)
        self.setConstraint()
        self.startButton.layer.cornerRadius = 16
    }
    
    func setConstraint() {
        for constraint in self.backgroundView.constraints {
            if constraint.identifier == "totalHeight" {
               constraint.constant = self.collectionView.frame.height + 200
            }
        }
        self.backgroundView.layoutIfNeeded()
    }
    
    func updateConstraint() {
        for constraint in self.backgroundView.constraints {
            if constraint.identifier == "totalHeight" {
                constraint.constant = constraint.constant + 150
            }
        }
        self.backgroundView.layoutIfNeeded()
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer){
        guard let collectionView = collectionView else {
            return
        }
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        @unknown default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 16
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 30, height: view.frame.size.height / 5)
    }
    
    // Re-order functions
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = colors.remove(at: sourceIndexPath.row)
        colors.insert(item, at: destinationIndexPath.row)
    }
    
    @IBAction func clickAdd(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Gill Sans", size: 20)!,
            kTextFont: UIFont(name: "Gill Sans", size: 14)!,
            kButtonFont: UIFont(name: "Gill Sans", size: 14)!,
            showCloseButton: false,
            dynamicAnimatorActive: true
        )
                
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
                
        // Creat the subview
        let subview = UIView(frame: CGRect(x: 0,y: 0,width: 216,height: 150))
        let x = (subview.frame.width - 180) / 2
                
        // Add textfield 1
        let textfield1 = UITextField(frame: CGRect(x: x,y: 10,width: 180,height: 35))
        textfield1.layer.borderColor = UIColor.black.cgColor
        textfield1.layer.borderWidth = 1.5
        textfield1.layer.cornerRadius = 5
        textfield1.placeholder = "Title"
        textfield1.textAlignment = NSTextAlignment.center
        subview.addSubview(textfield1)
                
        // Add textfield 2
        let textfield2 = UITextField(frame: CGRect(x: x,y: textfield1.frame.maxY + 10,width: 180,height: 35))
        textfield2.layer.borderWidth = 1.5
        textfield2.layer.cornerRadius = 5
        textfield2.layer.borderColor = UIColor.black.cgColor
        textfield2.placeholder = "# of minutes"
        textfield2.textAlignment = NSTextAlignment.center
        textfield2.textContentType = .dateTime;
        subview.addSubview(textfield2)
        
        // Add textfield 3
        let textfield3 = UITextField(frame: CGRect(x: x,y: textfield2.frame.maxY + 10,width: 180,height: 35))
        textfield3.layer.borderWidth = 1.5
        textfield3.layer.cornerRadius = 5
        textfield3.layer.borderColor = UIColor.black.cgColor
        textfield3.placeholder = "# of seconds"
        textfield3.textAlignment = NSTextAlignment.center
        subview.addSubview(textfield3)
                
        // Add the subview to the alert's UI property
        alert.customSubview = subview
        _ = alert.addButton("Add") {
            print("Clicked Add")
            print(textfield1.text)
            print(textfield2.text)
            print(textfield3.text)
            self.colors.append(UIColor .systemPink)
            self.collectionView.reloadData()
            self.updateConstraint()
        }
                
        // Add Button with visible timeout and custom Colors
        let showTimeout = SCLButton.ShowTimeoutConfiguration(prefix: "(", suffix: " s)")
        _ = alert.addButton("Timeout Button", backgroundColor: UIColor(red: 0.541, green: 0.753, blue: 0.875, alpha: 1), textColor: UIColor.black, showTimeout: showTimeout) {
            print("Timeout Button tapped")
        }

        let timeoutValue: TimeInterval = 60.0
        let timeoutAction: SCLAlertView.SCLTimeoutConfiguration.ActionType = {
                print("Timeout occurred")
        }
                
        _ = alert.showInfo("Create Routine", subTitle: "Enter a title and the time you want this step of your shower to take", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: timeoutValue, timeoutAction: timeoutAction))
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
