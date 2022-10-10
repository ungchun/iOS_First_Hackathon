import UIKit
import CoreLocation

final class DetailViewController: UIViewController {
    
    // MARK: Properties
    //
    var weatherModel: WeatherModel?
    var myRegionCheck: Bool?
    
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
        print("@@@ \(weatherModel)")
        print("@@@ \(myRegionCheck)")
        let detailView = DetailView(frame: self.view.frame, detailCityWeatherModel: weatherModel!, myRegionCheck: myRegionCheck!)
        self.detailView = detailView
        self.view.addSubview(detailView)
    }
    
    // MARK: functions
    //
    func receivedModel(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
    }
}
