import Foundation
import UIKit
import SpriteKit

class ListView: UIView {
    
    // MARK: Properties
    //
    var weatherModelList: [WeatherModel] = []
    var cellTapAction: ((_ weatherModel: WeatherModel, _ tapIndex: Int) -> Void)?
    
    // MARK: Views
    //
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width-20, height: 120)
        flowLayout.minimumLineSpacing = 10
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 40, left: 10, bottom: 10, right: 10)
        flowLayout.minimumInteritemSpacing = 1
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    
    // MARK: init
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: functions
    //
    private func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        //        collectionView.backgroundColor = .black
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor)
        ])
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier)
    }
    
    func cellTap(_ weatherModel: WeatherModel, _ tapIndex: Int) {
        cellTapAction!(weatherModel, tapIndex)
    }
}

extension ListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        if self.weatherModelList.count > indexPath.item {
            if let cell = cell as? ListCollectionViewCell {
                cell.weatherModel = weatherModelList[indexPath.item]
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellTap(weatherModelList[indexPath.item], indexPath.item)
    }
}

extension ListView: UICollectionViewDelegate {
}
