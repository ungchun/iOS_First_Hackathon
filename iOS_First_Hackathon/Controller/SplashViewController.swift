import UIKit
import CoreLocation
import Lottie
import SnapKit

final class SplashViewController: UIViewController {
    
    // MARK: Properties
    //
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
            
            let ud = UserDefaults.standard
            
            if ud.bool(forKey: UserInfo.FirstRunCheckKey) == false {
                print("처음 접속 -> 팝업 띄워서 도시 선택 ")
                UserDefaults.standard.set(true, forKey: UserInfo.FirstRunCheckKey)
            } else {
                print("처음 접속 아님 -> 바로 디테일뷰로 이동")
            }
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
        
        let listVC = ListViewController()
        listVC.modalPresentationStyle = .fullScreen
        self.present(listVC, animated: false)
    }
}
