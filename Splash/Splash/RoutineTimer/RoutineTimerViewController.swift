//
//  RoutineTimerViewController.swift
//  Splash
//
//  Created by Shreya Vinjamuri on 8/6/22.
//

import UIKit
import GravitySliderFlowLayout
import AVFAudio

class RoutineTimerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var finishButton: UIButton!
    @IBOutlet var startButton: UIButton!
    let collectionViewCellHeightCoefficient: CGFloat = 0.85
    let collectionViewCellWidthCoefficient: CGFloat = 0.55
    var routineArray = [Routine]();
    var dataLoader:DataLoaderProtocol = ParseDataLoaderManager()
    var timerIndex = 0
    var timer = Timer();
    var startTime = CFTimeInterval()
    var finish = false
    var width = 0.0
    var height = 0.0
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpCollectionView()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods to set up views and cells
    func setUpView() {
        self.startButton.layer.cornerRadius = 16;
        self.finishButton.layer.cornerRadius = 16;
        self.titleLabel.text = "Your Routine: " + String(self.routineArray.count) + " steps"
    }
    
    func setUpCollectionView () {
        let gravitySliderLayout = GravitySliderFlowLayout(with: CGSize(width: collectionView.frame.size.height * collectionViewCellWidthCoefficient, height: collectionView.frame.size.height * collectionViewCellHeightCoefficient))
        collectionView.collectionViewLayout = gravitySliderLayout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        //self.collectionView.isScrollEnabled = false
    }
    
    private func configureRoutineTimerCell(_ cell: RoutineTimerCell, for indexPath: IndexPath) {
        cell.clipsToBounds = false
        cell.layer.borderColor = UIColor.black.cgColor;
        cell.layer.borderWidth = 0.5;
        cell.layer.cornerRadius = 10;
        
        cell.layer.shadowColor = UIColor.white.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 20
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 30)
                
    }

    // MARK: - Collection view data source and delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.routineArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! RoutineTimerCell
        self.width = cell.frame.width
        self.height = cell.frame.height
        self.configureRoutineTimerCell(cell, for: indexPath)
        cell.setCell(titleLabel: dataLoader.getTitleFor(self.routineArray[indexPath.row]))
        cell.tag = indexPath.row
        return cell;
    }
    
    // MARK: - Methods for updating cell timers and scrolling to next cell
    func visibleCell() {
        if (finish) {
           return
        }
        let cellToShow = collectionView.cellForItem(at: IndexPath(row: timerIndex, section: 0)) as! RoutineTimerCell
        cellToShow.circleTimer.maxValue = Float(self.dataLoader.getTimeFor(routineArray[timerIndex]))
        cellToShow.circleTimer.incrementValue()
        let max = cellToShow.circleTimer.maxValue
        let dispatchAfter = DispatchTimeInterval.seconds(Int(max + 1))
        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
            if (self.timerIndex < self.routineArray.count - 1) {
                self.timerIndex = self.timerIndex + 1
                self.scrollToNextCell()
                self.visibleCell()
            }
        }
    }
    
    func scrollToNextCell(){
        //get cell size
        self.playSound()
        let cellSize = CGSize(width: self.width * 3.18, height: self.height * 3.18);
        //get current content Offset of the Collection view
        let contentOffset = collectionView.contentOffset;
        //scroll to next cell
        collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y:  contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
    }
    
    // MARK: - Action methods for buttons
    @IBAction func clickStart(_ sender: Any) {
        self.startButton.isHidden = true
        self.startTime = CACurrentMediaTime()
        visibleCell()
    }
    
    @IBAction func clickFinish(_ sender: Any) {
        finish = true
        self.timer.invalidate()
        let elapsedTime = CACurrentMediaTime() - self.startTime;
        print(elapsedTime)
    }
    
    // MARK: - Methods for playing sound
    func playSound() {
        let url = Bundle.main.url(forResource: "nextStep", withExtension: "mp3")
        guard url != nil else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            player?.play()
        } catch {
            print("error")
        }
    }
    
    // MARK: - Methods for saving shower request
    func saveShower() {
        
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