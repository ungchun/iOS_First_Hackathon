import Foundation
import UIKit
import SpriteKit

class ListViewTable: UIView {
    
    // MARK: Properties
    //
    var weatherModelList: [WeatherModel] = []
    var cellTapAction: ((_ weatherModel: WeatherModel, _ tapIndex: Int) -> Void)?
    
    // MARK: Views
    //
    lazy var collectionView: UITableView = {
        
        let cv = UITableView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    
    // MARK: init
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("@@@@ init")
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: functions
    //
    private func setup() {
        collectionView.register(ListViewTableCell.self, forCellReuseIdentifier: ListViewTableCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //        collectionView.backgroundColor = .black
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor)
        ])
        
        collectionView.rowHeight = 10
//        collectionView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func cellTap(_ weatherModel: WeatherModel, _ tapIndex: Int) {
        cellTapAction!(weatherModel, tapIndex)
    }
    
//    private func configureDataSource() -> UiCollectionViewDIff
}

extension ListViewTable: UITableViewDelegate, UITableViewDataSource {
    
    // 현재 날짜 기준으로 지나지 않은 기념일 다 불러옴
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("@@@@ numberOfRowsInSection \(RealmManager.shared.realm.objects(Region.self).count)")
        return RealmManager.shared.realm.objects(Region.self).count
//        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let nowMillisecondDate = Date().millisecondsSince1970
//        let anniversaryFilter = AnniversaryModel().AnniversaryInfo.filter { dictValue in
//            let keyValue = dictValue.keys.first
//            if nowMillisecondDate < (keyValue?.toDate.millisecondsSince1970)! {
//                return true
//            } else {
//                return false
//            }
//        }
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "AnniversaryTableViewCell", for: indexPath) as? AnniversaryTableViewCell ?? AnniversaryTableViewCell()
//        cell.setAnniversaryCellText(dictValue: AnniversaryModel().AnniversaryInfo[indexPath.row + (AnniversaryModel().AnniversaryInfo.count - anniversaryFilter.count)], url: AnniversaryModel().AnniversaryImageUrl[indexPath.row + (AnniversaryModel().AnniversaryInfo.count - anniversaryFilter.count)])
//        cell.selectionStyle = .none
//        cell.backgroundColor = UIColor(named: "bgColor")
//        return cell
        
//        let cell = collectionView.dequeueReusableCell(withIdentifier: ListViewTableCell.reuseIdentifier, for: indexPath)
        print("@@@@ indexpath")
        let cell = tableView.dequeueReusableCell(withIdentifier: ListViewTableCell.reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        if self.weatherModelList.count > indexPath.item {
            if let cell = cell as? ListViewTableCell {
                print("@@@@ if let")
                cell.weatherModel = weatherModelList[indexPath.item]
            }
        }
        return cell
    }
}

//extension ListView: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return weatherModelList.count
//        return RealmManager.shared.realm.objects(Region.self).count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier, for: indexPath)
//        cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
//        if self.weatherModelList.count > indexPath.item {
//            if let cell = cell as? ListCollectionViewCell {
//                cell.weatherModel = weatherModelList[indexPath.item]
//            }
//        }
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        cellTap(weatherModelList[indexPath.item], indexPath.item)
//    }
//
//}
//
//extension ListView: UICollectionViewDelegate {
//}
