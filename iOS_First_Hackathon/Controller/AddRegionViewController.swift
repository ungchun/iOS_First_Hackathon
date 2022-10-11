import UIKit

final class AddRegionViewController: UIViewController {
    
    // MARK: Properties
    //
    var regionArray: [String] = []
    
    // MARK: Views
    //
    var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allowsMultipleSelection = true
        return view
    }()
    
    // MARK: Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        
        addSubviews()
        makeConstraints()
        setupValues()
    }
    
    // MARK: functions
    //
    private func addSubviews() {
        tableView.register(CheckboxCell.self, forCellReuseIdentifier: CheckboxCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    private func makeConstraints() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
    }
    
    private func setupValues() {
        let realmDatas = RealmManager.shared.realm.objects(Region.self)
        for cityName in realmDatas {
            let cityName = cityName.name
            regionArray.append(cityName)
        }
    }
}

extension AddRegionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KoreaCityNameListDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckboxCell.reuseIdentifier) as? CheckboxCell else { fatalError(#function) }
        cell.regionArray = regionArray
        cell.model = KoreaCityNameListDic[indexPath.row].values.first
        cell.koreanModel = KoreaCityNameListDic[indexPath.row].keys.first
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
