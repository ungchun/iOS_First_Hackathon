import UIKit
import CoreLocation
import RealmSwift

final class ListViewController: UIViewController, CLLocationManagerDelegate  {
    
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
    private var listView: ListView!
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
//        setupView {
//            listView.collectionView.reloadData()
//        }
//        requestAuthorization()
        
        setupView()

        setNavigationBarTitle()
    }
    
    // MARK: functions
    //
    private func setupView() {
//        var count = 0
        let listView = ListView(frame: self.view.frame)
        listView.cellTapAction = navigationDetailView(_: _:)
        self.view.addSubview(listView)
        
//        UserInfo.shared.longitude = currentLocation.longitude
//        UserInfo.shared.latitude = currentLocation.latitude
        
        
        // 본인 위치
//        let detailVC = DetailViewController()
//        self.dataViewControllers.append(detailVC)
        
        let realmDatas = RealmManager.shared.realm.objects(Region.self)
        print("??? \(realmDatas)")
//        for i in 0..<realmDatas.count {
//            let cityName = String(describing: realmDatas[i].name)
//            DispatchQueue.global(qos: .background).async {
//                WeatherManager(cityName: cityName).getWeather { result in
//                    switch result {
//                    case .success(let weatherValue):
//                        DispatchQueue.main.async {
//                            listView.weatherModelList += [weatherValue]
//                            listView.collectionView.reloadData()
//                            print("after reload")
//                            let detailVC = DetailViewController()
//                            detailVC.weatherModel = weatherValue
//                            detailVC.receivedModel(weatherModel: weatherValue)
//                            self.dataViewControllers.append(detailVC)
//                        }
//                    case .failure(let networkError):
//                        print("\(networkError)")
//                    }
//                }
//            }
//        }
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
//                            listView.weatherModelList += [weatherValue]
                            listView.collectionView.reloadData()
//                            count += 1
                            print("after reload \(cityName)")
                        }
                    case .failure(let networkError):
                        print("\(networkError)")
                    }
                }
            }
        }
//        if count == realmDatas.count {
//            print("completion \(count) \(realmDatas.count)")
//            completion()
//        }
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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            setMyCoordinate()
            break
        case .authorizedAlways:
            print("authorizedAlways")
            setMyCoordinate()
            break
        default:
            print("위치 거절")
            break
        }
    }
    
    private func requestAuthorization() {
        locationManager = CLLocationManager()
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestWhenInUseAuthorization()
        locationManager!.delegate = self
        locationManagerDidChangeAuthorization(locationManager!)
    }
    
    private func setMyCoordinate() {
        currentLocation = locationManager!.location?.coordinate
        UserInfo.shared.longitude = currentLocation.longitude
        UserInfo.shared.latitude = currentLocation.latitude
        
        print("currentLocation.longitude \(currentLocation.longitude)")
        print("currentLocation.latitude \(currentLocation.latitude)")

    }
    
}
