import UIKit

final class DetailViewController: UIViewController {
    
    private var detailView: DetailView!
    
    var weatherModel: WeatherModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailView = DetailView(frame: self.view.frame, detailCityWeatherModel: weatherModel!)
        self.detailView = detailView
        self.view.addSubview(detailView)
    }
    
    func receivedModel(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
    }
}
