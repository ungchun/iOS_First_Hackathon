import UIKit
import CoreLocation

final class DetailViewController: UIViewController {
    
    // MARK: Properties
    //
    var weatherModel: WeatherModel?
    
    // MARK: Views
    //
    private var detailView: DetailView!
    
    // MARK: Life Cycle
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let detailView = DetailView(frame: self.view.frame, detailCityWeatherModel: weatherModel!)
        self.detailView = detailView
        self.view.addSubview(detailView)
        
//        if CLLocationManager().authorizationStatus == CLAuthorizationStatus.denied || CLLocationManager().authorizationStatus == CLAuthorizationStatus.restricted {
//            let emptyView = EmptyView(frame: self.view.frame)
//            self.view.addSubview(emptyView)
//        } else {
//            let detailView = DetailView(frame: self.view.frame, detailCityWeatherModel: weatherModel!)
//            self.detailView = detailView
//            self.view.addSubview(detailView)
//        }
    }
    
    // MARK: functions
    //
    func receivedModel(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
    }
}
