import UIKit
import CoreLocation
import RealmSwift

final class ListViewController: UIViewController, CLLocationManagerDelegate  {
    
    lazy var collectionView: UITableView = {
        
        let cv = UITableView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    var weatherModelList: [WeatherModel] = []
    
    
    
    let alert = UIAlertController(title: "경고", message: "지역이 1개일 때는 삭제할 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
//    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
    
    
    
    
    private let imageView = UIImageView(image: UIImage (systemName: "plus.circle"))
    private let imageView2 = UIImageView(image: UIImage (systemName: "gearshape"))
    
//    private lazy var dataSource = { self.}
    
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 32
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    
    private func setupUI() {
        

        navigationController?.navigationBar.prefersLargeTitles = true
        //      title = "Large Title"
        
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        
        self.title = "전국 날씨"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        self.navigationController!.navigationBar.standardAppearance = appearance;
        self.navigationController!.navigationBar.scrollEdgeAppearance = self.navigationController!.navigationBar.standardAppearance
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationBar.addSubview(imageView)
        navigationBar.addSubview(imageView2)
        
        
        // setup constraints
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView2.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView2.clipsToBounds = true
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            imageView2.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin * 4.5),
            imageView2.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView2.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView2.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
    
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D!
    
    // MARK: Properties
    //
    let CityList = [
        "Gongju", "Gwangju", "Gumi", "Gunsan", "Daegu", "Daejeon",
        "Mokpo", "Busan", "Seosan", "Seoul", "Sokcho", "suwon", "Iksan", "Suncheon",
        "Ulsan", "Jeonju", "Jeju", "Cheonan", "Cheongju", "Chuncheon"
    ]
    
    // MARK: Views
    //
//    private var listView: ListView!
//    private var listView: ListViewTable!
    var dataViewControllers: [UIViewController] = []
    
    
    // MARK: Life Cycle
    //
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        CityList.forEach { value in
        //            let region = Region()
        //            region.name = value
        //            RealmManager.shared.create(region)
        //        }
        //        try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!)
        
        collectionView.register(ListViewTableCell.self, forCellReuseIdentifier: ListViewTableCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let realmDatas = RealmManager.shared.realm.objects(Region.self)
        for cityName in realmDatas {
            let cityName = cityName.name
            DispatchQueue.global(qos: .background).async {
                WeatherManager(cityName: cityName).getWeather { result in
                    switch result {
                    case .success(let weatherValue):
                        self.weatherModelList.append(weatherValue)
                        
                        DispatchQueue.main.async {
                            let detailVC = DetailViewController()
                            detailVC.weatherModel = weatherValue
                            detailVC.receivedModel(weatherModel: weatherValue)
                            self.dataViewControllers.append(detailVC)
                            self.collectionView.reloadData()
                            print("@@@@ after reload \(cityName)")
                        }
                    case .failure(let networkError):
                        print("\(networkError)")
                    }
                }
            }
        }
        
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        collectionView.rowHeight = 150
        
//        setupView()
        setupUI()
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in }))
    }
    
    // MARK: functions
    //
    private func setupView() {
//        let listView = ListView(frame: self.view.frame)
        //        listView.cellTapAction = navigationDetailView(_: _:)
        let listView = ListViewTable()
        self.view.addSubview(listView)
        
        let realmDatas = RealmManager.shared.realm.objects(Region.self)
        for cityName in realmDatas {
            let cityName = cityName.name
            DispatchQueue.global(qos: .background).async {
                WeatherManager(cityName: cityName).getWeather { result in
                    switch result {
                    case .success(let weatherValue):
                        listView.weatherModelList.append(weatherValue)
                        
                        DispatchQueue.main.async {
                            let detailVC = DetailViewController()
                            detailVC.weatherModel = weatherValue
                            detailVC.receivedModel(weatherModel: weatherValue)
                            self.dataViewControllers.append(detailVC)
                            listView.collectionView.reloadData()
                            print("@@@@ after reload \(cityName)")
                        }
                    case .failure(let networkError):
                        print("\(networkError)")
                    }
                }
            }
        }
    }
    
    private func setNavigationBarTitle() {
        self.title = "전국 날씨"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        self.navigationController!.navigationBar.standardAppearance = appearance;
        self.navigationController!.navigationBar.scrollEdgeAppearance = self.navigationController!.navigationBar.standardAppearance
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    private func navigationDetailView(_ weatherModel: WeatherModel, _ tapIndex: Int) {
        let pageVC = PageViewController()
        pageVC.startIndex = tapIndex
        pageVC.dataViewControllers = self.dataViewControllers
        pageVC.modalPresentationStyle = .fullScreen
        self.present(pageVC, animated: false)
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          
          if editingStyle == .delete {
              if weatherModelList.count == 1 {
                  self.present(alert, animated: true, completion: nil)
              } else {
                  if let userinfo = RealmManager.shared.realm.objects(Region.self).filter(NSPredicate(format: "name = %@", weatherModelList[indexPath.row].name)).first {
                      RealmManager.shared.delete(userinfo)
                      
                      weatherModelList.remove(at: indexPath.row)
                      tableView.deleteRows(at: [indexPath], with: .fade)
                  }
              }
          }
      }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RealmManager.shared.realm.objects(Region.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListViewTableCell.reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        if self.weatherModelList.count > indexPath.item {
            if let cell = cell as? ListViewTableCell {
                cell.weatherModel = weatherModelList[indexPath.item]
            }
        }
        return cell
    }
}
