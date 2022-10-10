import UIKit
import CoreLocation
import RealmSwift
import SnapKit

final class ListViewController: UIViewController, CLLocationManagerDelegate  {
    
    // MARK: Properties
    //
    static var isChangeRegion = false
    private struct Const {
        static let ImageSizeForLargeState: CGFloat = 40
        static let ImageRightMargin: CGFloat = 16
        static let ImageBottomMarginForLargeState: CGFloat = 12
    }
    var weatherModelList: [WeatherModel] = []
    
    // MARK: Views
    //
    private let alert = UIAlertController(title: "경고", message: "지역이 1개일 때는 삭제할 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
    private var dataViewControllers: [UIViewController] = []
    var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Life Cycle
    //
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
        }
    override func viewWillAppear(_ animated: Bool) {
        if ListViewController.isChangeRegion {
            print("@@@@ viewWillAppear")
            ListViewController.isChangeRegion = false
            tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
            tableView.delegate = self
            tableView.dataSource = self
            self.tableView.reloadData()
            
            weatherModelList.removeAll()
            dataViewControllers.removeAll()
            
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
                            }
                        case .failure(let networkError):
                            print("\(networkError)")
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                            print("@@@@ \(self.dataViewControllers.count)")
                        }
                    case .failure(let networkError):
                        print("@@@@ \(networkError) \(cityName)")
                    }
                }
            }
        }
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in }))
    }
    private func setNavigationBarTitle() {
        self.title = "전국 날씨"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        self.navigationController!.navigationBar.standardAppearance = appearance;
        self.navigationController!.navigationBar.scrollEdgeAppearance = self.navigationController!.navigationBar.standardAppearance
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let plusButton   = UIBarButtonItem(image: UIImage (systemName: "plus"),  style: .plain, target: self, action: #selector(navigationAddRegionView))
        let setButton = UIBarButtonItem(image: UIImage (systemName: "gearshape"),  style: .plain, target: self, action: #selector(navigationSettingView))
        navigationItem.rightBarButtonItems = [setButton, plusButton]
    }
    private func navigationDetailView(_ tapIndex: Int) {
        let pageVC = PageViewController()
        pageVC.startIndex = tapIndex
        pageVC.dataViewControllers = self.dataViewControllers
        pageVC.modalPresentationStyle = .fullScreen
        self.present(pageVC, animated: false)
    }
    @objc func navigationAddRegionView() {
        let addRegionViewController = AddRegionViewController()
        self.navigationController?.pushViewController(addRegionViewController, animated: true)
    }
    @objc func navigationSettingView() {
        let settingViewController = SettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: true)
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
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print("@@@@ \(RealmManager.shared.realm.objects(Region.self).count)")
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
        navigationDetailView(indexPath.row)
    }
}
