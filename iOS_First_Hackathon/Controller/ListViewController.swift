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
        
        // API 통해서 city weather 값 가져옴
        for cityName in realmDatas {
            //main thread에서 load할 경우 URL 로딩이 길면 화면이 멈춘다.
            //이를 방지하기 위해 다른 thread에서 처리함.
            let cityName = cityName.name
            DispatchQueue.global(qos: .background).async {
                WeatherManager(cityName: cityName).getWeather { result in
                    switch result {
                    case .success(let weatherValue):
                        DispatchQueue.main.async {
                            listView.weatherModelList += [weatherValue]
                            listView.collectionView.reloadData()
                            
                            let vc = DetailViewController()
                            vc.weatherModel = weatherValue
                            vc.receivedModel(weatherModel: weatherValue)
                            self.dataViewControllers.append(vc)
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
    
    fileprivate func navigationDetailView(_ weatherModel: WeatherModel, _ tapIndex: Int) {
        let pageVC = PageViewController()
        pageVC.startIndex = tapIndex
        //        pageVC.testArray = self.testArray
        pageVC.dataViewControllers = self.dataViewControllers
        //        pageVC.receivedModel(weatherModel: weatherModel)
        print("tapIndex \(tapIndex)")
        pageVC.modalPresentationStyle = .fullScreen
        self.present(pageVC, animated: false)
        
        
        //        let detailVC = DetailViewController()
        //        detailVC.receivedModel(weatherModel: weatherModel)
        //        detailVC.modalPresentationStyle = .fullScreen
        //        self.present(detailVC, animated: false)
    }
}

