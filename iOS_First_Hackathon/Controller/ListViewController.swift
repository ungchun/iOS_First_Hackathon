import UIKit
import RealmSwift

final class ListViewController: UIViewController  {
    
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
        
        setupView()
        setNavigationBarTitle()
    }
    
    // MARK: functions
    //
    private func setupView() {
        let listView = ListView(frame: self.view.frame)
        listView.cellTapAction = navigationDetailView(_: _:)
        self.view.addSubview(listView)
        
        let realmDatas = RealmManager.shared.realm.objects(Region.self)
        for cityName in realmDatas {
            let cityName = cityName.name
            DispatchQueue.global(qos: .background).async {
                WeatherManager(cityName: cityName).getWeather { result in
                    switch result {
                    case .success(let weatherValue):
                        DispatchQueue.main.async {
                            listView.weatherModelList += [weatherValue]
                            listView.collectionView.reloadData()
                            
                            let detailVC = DetailViewController()
                            detailVC.weatherModel = weatherValue
                            detailVC.receivedModel(weatherModel: weatherValue)
                            self.dataViewControllers.append(detailVC)
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
