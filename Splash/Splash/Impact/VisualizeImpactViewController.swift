//
//  VisualizeImpactViewController.swift
//  Splash
//
//  Created by Shreya Vinjamuri on 7/28/22.
//

import UIKit
import GravitySliderFlowLayout

class VisualizeImpactViewController:  UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView!
    let collectionViewCellHeightCoefficient: CGFloat = 0.85
    let collectionViewCellWidthCoefficient: CGFloat = 0.55
    let gradientFirstColor = UIColor(red: 0.541, green: 0.753, blue: 0.875, alpha: 1).cgColor
    let gradientSecondColor = UIColor(red: 0.278, green: 0.412, blue: 0.580, alpha: 1).cgColor
    let cellsShadowColor = UIColor.black.cgColor
    var dataLoader:DataLoaderProtocol = ParseDataLoaderManager()
    var averageShowerTime = CGFloat()
    var averageShowerTimeWithSave = CGFloat()
    let images = [UIImage(named: "stats"), UIImage(named: "decrease"), UIImage(named: "save")]
    var titles = [NSString]()
    var topLabels = [CGFloat]()
    var bottomLabels = [CGFloat]()
    @objc var waterFlow = CGFloat()
    @objc var showersPerWeek = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollectionView()
        self.getData()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods for setting up collection view and getting data
    func setUpCollectionView () {
        let gravitySliderLayout = GravitySliderFlowLayout(with: CGSize(width: collectionView.frame.size.height * collectionViewCellWidthCoefficient, height: collectionView.frame.size.height * collectionViewCellHeightCoefficient))
        collectionView.collectionViewLayout = gravitySliderLayout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func getData () {
        let total = CGFloat(self.dataLoader.getTotalShowerTime(self.dataLoader.getCurrentUser()));
        let showers = CGFloat(self.dataLoader.getNumShowers(self.dataLoader.getCurrentUser()));
        self.averageShowerTime = (total / showers / 60.0)
        self.averageShowerTimeWithSave = self.averageShowerTime * 0.9
        topLabels.append(self.calcGalPerWeek(avg:averageShowerTime))
        topLabels.append(self.calcGalPerWeek(avg:averageShowerTimeWithSave))
        topLabels.append(self.calcGalPerWeek(avg:averageShowerTime) - self.calcGalPerWeek(avg:averageShowerTimeWithSave))
        bottomLabels.append(self.calcGalPerYear(avg:averageShowerTime))
        bottomLabels.append(self.calcGalPerYear(avg:averageShowerTimeWithSave))
        bottomLabels.append(self.calcGalPerYear(avg:averageShowerTime) - self.calcGalPerYear(avg:averageShowerTimeWithSave))
        titles.append("Your stats with an average shower time of " +  String(format: "%.2f", self.averageShowerTime) + " min" as NSString)
        titles.append("New stats if you decrease your shower time by " + String(format: "%.2f", (self.averageShowerTime - self.averageShowerTimeWithSave)) + " min" as NSString)
        titles.append("The amount of water you can save if you decrease your shower time by " + String(format: "%.2f", (self.averageShowerTime - self.averageShowerTimeWithSave)) + " min" as NSString)
    }
    
    // MARK: - Collection view data source methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImpactCell
        configureImpactCell(cell, for: indexPath)
        cell.setCell(img: images[indexPath.row]!, top: "Gallons/week: " + String(format: "%.2f", self.topLabels[indexPath.row]) as NSString , bottom: "Gallons/year: " + String(format: "%.2f", self.bottomLabels[indexPath.row]) as NSString, title: titles[indexPath.row])
        return cell;
    }
    
    // MARK: - Helper methods to configure cell and make calculations
    private func configureImpactCell(_ cell: ImpactCell, for indexPath: IndexPath) {
            cell.clipsToBounds = false
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = cell.bounds
            gradientLayer.colors = [gradientFirstColor, gradientSecondColor]
            gradientLayer.cornerRadius = 21
            gradientLayer.masksToBounds = true
            cell.layer.insertSublayer(gradientLayer, at: 0)
            
            cell.layer.shadowColor = cellsShadowColor
            cell.layer.shadowOpacity = 0.2
            cell.layer.shadowRadius = 20
            cell.layer.shadowOffset = CGSize(width: 0.0, height: 30)
        }
    
    func calcGalPerWeek(avg: CGFloat)->CGFloat {
        return avg * self.waterFlow * self.showersPerWeek
    }
    
    func calcGalPerYear(avg: CGFloat) -> CGFloat {
        return self.calcGalPerWeek(avg: avg) * 52.0
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
