import UIKit
import CoreLocation
import Lottie
import SnapKit
import RealmSwift

final class SplashViewController: UIViewController {
    
    // MARK: Properties
    //
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    
    // MARK: Views
    //
    private let lottieAnimationView: AnimationView = {
        let lottieView = AnimationView(name: "weather_splash")
        lottieView.loopMode = .repeat(1)
        lottieView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return lottieView
    }()
    
    // MARK: Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addSubviews()
        makeConstraints()
        
        let ud = UserDefaults.standard
        if ud.bool(forKey: UserInfo.FirstRunCheckKey) == false {
            UserDefaults.standard.set(true, forKey: UserInfo.FirstRunCheckKey)
            let region = Region()
            region.name = "Daegu"
            RealmManager.shared.create(region)
        }
        
        lottieAnimationView.play { [weak self] (finish) in
            guard let self = self else { return }
            
            self.requestAuthorization()
            
            let listVC = ListViewController()
            let navEditorViewController: UINavigationController = UINavigationController(rootViewController: listVC)
            navEditorViewController.modalPresentationStyle = .fullScreen
            self.present(navEditorViewController, animated: false, completion: nil)
        }
    }
    
    // MARK: functions
    //
    private func addSubviews() {
        view.addSubview(lottieAnimationView)
    }
    private func makeConstraints() {
        lottieAnimationView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.height.equalTo(300)
        }
    }
}

extension SplashViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            setMyCoordinate()
            break
        case .authorizedAlways:
            setMyCoordinate()
            break
        default:
            break
        }
    }
    
    private func requestAuthorization() {
        locationManager = CLLocationManager()
        guard let locationManager else { return }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManagerDidChangeAuthorization(locationManager)
    }
    
    private func setMyCoordinate() {
        guard let locationManager else { return }
        currentLocation = locationManager.location?.coordinate
        guard let currentLocation else { return }
        UserInfo.shared.longitude = currentLocation.longitude
        UserInfo.shared.latitude = currentLocation.latitude
    }
}

extension SplashViewController {
    private func testCityInit() {
        let CityList = [
            "Gongju", "Gwangju", "Gumi", "Gunsan", "Daegu", "Daejeon",
            "Mokpo", "Busan", "Seoul", "Sokcho", "Suwon-si", "Iksan", "Suncheon",
            "Ulsan", "Jeonju", "Cheonan", "Cheongju-si", "Chuncheon"
        ]
        CityList.forEach { value in
            let region = Region()
            region.name = value
            RealmManager.shared.create(region)
        }
        //        try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!)
    }
}
