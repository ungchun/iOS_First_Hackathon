import UIKit
import CoreLocation
import RealmSwift
import SnapKit

final class ListViewController: UIViewController, CLLocationManagerDelegate  {
    
    // MARK: Properties
    //
    private struct Const {
        static let ImageSizeForLargeState: CGFloat = 40
        static let ImageRightMargin: CGFloat = 16
        static let ImageBottomMarginForLargeState: CGFloat = 12
    }
    let CityList = [
        "Gongju", "Gwangju", "Gumi", "Gunsan", "Daegu", "Daejeon",
        "Mokpo", "Busan", "Seosan", "Seoul", "Sokcho", "suwon", "Iksan", "Suncheon",
        "Ulsan", "Jeonju", "Jeju", "Cheonan", "Cheongju", "Chuncheon"
    ]
    var weatherModelList: [WeatherModel] = []
    //    var locationManager: CLLocationManager?
    //    var currentLocation: CLLocationCoordinate2D!
    
    // MARK: Views
    //
    private let alert = UIAlertController(title: "경고", message: "지역이 1개일 때는 삭제할 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
    private let plusBtn = UIImageView(image: UIImage (systemName: "plus.circle"))
    private let setBtn = UIImageView(image: UIImage (systemName: "gearshape"))
    private var dataViewControllers: [UIViewController] = []
    var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
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
                            self.tableView.reloadData()
                            print("@@@@ after reload \(cityName)")
                        }
                    case .failure(let networkError):
                        print("\(networkError)")
                    }
                }
            }
        }
        
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in }))
    }
    private func setNavigationBarTitle() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        self.title = "전국 날씨"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        self.navigationController!.navigationBar.standardAppearance = appearance;
        self.navigationController!.navigationBar.scrollEdgeAppearance = self.navigationController!.navigationBar.standardAppearance
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationBar.addSubview(plusBtn)
        navigationBar.addSubview(setBtn)
        
        plusBtn.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        plusBtn.clipsToBounds = true
        plusBtn.translatesAutoresizingMaskIntoConstraints = false
        setBtn.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        setBtn.clipsToBounds = true
        setBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            plusBtn.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            plusBtn.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            plusBtn.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            plusBtn.widthAnchor.constraint(equalTo: plusBtn.heightAnchor),
            
            setBtn.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin * 4.5),
            setBtn.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            setBtn.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            setBtn.widthAnchor.constraint(equalTo: plusBtn.heightAnchor)
        ])
    }
    private func navigationDetailView(_ tapIndex: Int) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        if self.weatherModelList.count > indexPath.item {
            if let cell = cell as? ListTableViewCell {
                cell.weatherModel = weatherModelList[indexPath.item]
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationDetailView( indexPath.row)
    }
}
