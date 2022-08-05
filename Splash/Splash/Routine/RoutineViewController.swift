//
//  RoutineViewController.swift
//  Splash
//
//  Created by Shreya Vinjamuri on 8/1/22.
//

import UIKit
import SCLAlertView
import AVFAudio

class RoutineViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
    @IBOutlet var collectionView: UICollectionView!
    var dataLoader:DataLoaderProtocol = ParseDataLoaderManager()
    var routineArray = NSMutableArray()
    
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollectionView()
        self.getData()
    }
    
    // MARK: - Helper methods for setting up views, getting data, and handling gestures in view
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width - 30, height: view.frame.size.height / 5)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
        collectionView?.dataSource = self
        collectionView?.delegate = self
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        collectionView.addGestureRecognizer(gesture)
    }
    
    func getData() {
        self.routineArray = self.dataLoader.getRoutineData();
        self.collectionView.reloadData();
        
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
    
    // MARK: - Collection view data source and delegate methods
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "view", for: indexPath) as? RoutineCollectionReusableView{
            sectionHeader.title.text = "What steps make up your shower?"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return routineArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var routineCell = RoutineCell();
        var buttonCell = ButtonCell();
        if (indexPath.row == self.routineArray.count) {
            buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttonCell", for: indexPath) as! ButtonCell
            buttonCell.layer.cornerRadius = 16
            buttonCell.backgroundColor = .white
            let timePart = Helper.formatTimeString(Int32(self.getTotalTime()))
            buttonCell.customize(timePart)
            return buttonCell;
        } else {
            routineCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RoutineCell
            routineCell.layer.cornerRadius = 16
            routineCell.backgroundColor = UIColor(red: 0.929, green: 0.656, blue: 0.529, alpha: 1.0)
            routineCell.setCell(routineArray[indexPath.row] as! Routine);
            return routineCell;
        }
        
    }
    
    // MARK: - Collection view flow layout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 402, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 30, height: view.frame.size.height / 5)
    }
    
    // Re-order functions
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if (indexPath.row != self.routineArray.count) {
            return true
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = routineArray[sourceIndexPath.row]
        routineArray.removeObject(at: sourceIndexPath.row)
        routineArray.insert(item, at: destinationIndexPath.row)
        
    }
    
    // MARK: - Helper methods for repeated functionality
    func getTotalTime() -> Int {
        var total = 0;
        for routine in routineArray {
            total = total + Int(self.dataLoader.getTimeFor(routine as! Routine));
        }
        return total;
    }
    
    func createTextfield(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, title: String, keyboard: UIKeyboardType) -> UITextField {
        let textfield = UITextField(frame: CGRect(x: x,y: y,width: width,height: height))
        textfield.layer.borderColor = UIColor.black.cgColor
        textfield.layer.borderWidth = 1.5
        textfield.layer.cornerRadius = 5
        textfield.placeholder = title
        textfield.textAlignment = NSTextAlignment.center
        textfield.keyboardType = keyboard
        return textfield
    }
    
    // MARK: - Methods for adding and deleting cells
    @IBAction func clickDelete(_ sender: Any) {
        let contentView = (sender as! UIView).superview
        let cell = contentView?.superview as! RoutineCell
        let cellIndexPath = self.collectionView.indexPath(for: cell)
        let routine = self.routineArray[(cellIndexPath?.row)!] as! Routine
        self.dataLoader.remove(routine)
        self.routineArray.removeObject(at: (cellIndexPath?.row)!)
        self.collectionView.deleteItems(at: [cellIndexPath!])
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
        let textfield1 = self.createTextfield(x: x, y: 10, width: 180, height: 35, title: "Title", keyboard: .default)
        subview.addSubview(textfield1)
                
        // Add textfield 2
        let textfield2 = self.createTextfield(x: x, y: textfield1.frame.maxY + 10, width: 180, height: 35, title: "# of minutes", keyboard: .numberPad)
        subview.addSubview(textfield2)
        
        // Add textfield 3
        let textfield3 = self.createTextfield(x: x, y: textfield2.frame.maxY + 10, width: 180, height: 35, title: "# of seconds", keyboard: .numberPad)
        subview.addSubview(textfield3)
                
        // Add the subview to the alert's UI property
        alert.customSubview = subview
        _ = alert.addButton("Add") {
            let min = Int(textfield2.text ?? "1")
            let sec = Int(textfield3.text ?? "0")
            let time = (min!*60) + sec!
            self.dataLoader.postRoutine(textfield1.text, time: time as NSNumber) { boolean, error in
                self.getData()
            }
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
                
        _ = alert.showInfo("Add Step to Routine", subTitle: "Enter a title and the time you want this step of your shower to take", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: timeoutValue, timeoutAction: timeoutAction))
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
