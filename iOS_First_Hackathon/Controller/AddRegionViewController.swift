import UIKit

class AddRegionViewController: UIViewController {
    
    // MARK: Properties
    //
    let CityList = [
        "Gongju", "Gwangju", "Gumi", "Gunsan", "Daegu", "Daejeon",
        "Mokpo", "Busan", "Seosan", "Seoul", "Sokcho", "suwon", "Iksan", "Suncheon",
        "Ulsan", "Jeonju", "Jeju", "Cheonan", "Cheongju", "Chuncheon"
    ]
    var dataSource: [String] = ["jake1", "jake iOS", "jake iOS 앱", "jake iOS 앱 개발", "jake iOS 앱 개발 알아가기", "jake1", "jake iOS", "jake iOS 앱", "jake iOS 앱 개발", "jake iOS 앱 개발 알아가기","jake1", "jake iOS", "jake iOS 앱", "jake iOS 앱 개발", "jake iOS 앱 개발 알아가기"]

    var testArray: [String] = []
    
    // MARK: Views
    //
    var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print("viewDidAppear")
//
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        print("viewDidDisappear")
//        ListViewController().reloadTableView()
//    }
    
    
    // MARK: Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(CheckboxCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
//        tableView.isScrollEnabled = false
        
        tableView.backgroundColor = .green

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true
        
        let realmDatas = RealmManager.shared.realm.objects(Region.self)
        for cityName in realmDatas {
            let cityName = cityName.name
            testArray.append(cityName)
        }
    }
    
    // MARK: functions
    //
//    @objc func buttonAction(_ cityName: String) {
//        print("Button tapped")
//        if testArray.contains(cityName) {
//            // remove
//        } else {
//            // add
//        }
//
//        if let userinfo = RealmManager.shared.realm.objects(Region.self).filter(NSPredicate(format: "name = %@", cityName)).first {
//            RealmManager.shared.delete(userinfo)
//
////            weatherModelList.remove(at: indexPath.row)
////            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
}


extension AddRegionViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CityKoreaListDic.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CheckboxCell else { fatalError(#function) }
        cell.testArray = testArray
        cell.model = CityKoreaListDic[indexPath.row].values.first
        cell.koreanModel = CityKoreaListDic[indexPath.row].keys.first
        print("??? \(CityKoreaListDic[indexPath.row].keys.first!)")
        print("testArray \(testArray)")
        
        if testArray.contains(CityKoreaListDic[indexPath.row].keys.first!) {
            print("if isCheck")
            cell.isCheck = true
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        buttonAction(CityKoreaListDic[indexPath.row].keys.first!)
    }
}
