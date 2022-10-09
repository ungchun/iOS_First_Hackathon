import UIKit
import CoreLocation
import Lottie
import SnapKit
import RealmSwift

final class SplashViewController: UIViewController {
    
    // MARK: Properties
    //
    let CityList = [
        "Gongju", "Gwangju", "Gumi", "Gunsan", "Daegu", "Daejeon",
        "Mokpo", "Busan", "Seoul", "Sokcho", "Suwon-si", "Iksan", "Suncheon",
        "Ulsan", "Jeonju", "Cheonan", "Cheongju-si", "Chuncheon"
    ]
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D!
    
    // MARK: Views
    //
    private let lottieAnimationView: AnimationView = {
        let lottieView = AnimationView(name: "weather_splash")
        lottieView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return lottieView
    }()
    
    // MARK: Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        let a = RealmManager.shared.realm.objects(Region.self)
        a.forEach { region in
            print("@@@@ \(region.name)")
        }
        print("@@@@ RealmManager.shared.realm \(RealmManager.shared.realm.objects(Region.self))")
//        CityList.forEach { value in
//            let region = Region()
//            region.name = value
//            RealmManager.shared.create(region)
//        }
//        try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!)

        let ud = UserDefaults.standard
        if ud.bool(forKey: UserInfo.FirstRunCheckKey) == false {
            UserDefaults.standard.set(true, forKey: UserInfo.FirstRunCheckKey)
//            let region = Region()
//            region.name = "Daegu"
//            RealmManager.shared.create(region)
//
//            let region2 = Region()
//            region2.name = "Seoul"
//            RealmManager.shared.create(region2)
        }
        setupView()
    }
    
    // MARK: functions
    //
    private func setupView() {
        view.addSubview(lottieAnimationView)
        
        lottieAnimationView.loopMode = .repeat(1)
        
        lottieAnimationView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.height.equalTo(300)
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
}

extension SplashViewController: CLLocationManagerDelegate {
    
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
