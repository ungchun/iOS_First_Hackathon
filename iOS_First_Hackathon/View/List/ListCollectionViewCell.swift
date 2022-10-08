import UIKit
import SpriteKit

class ListCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    //
    static let reuseIdentifier = String(describing: ListCollectionViewCell.self)
    var weatherModel: WeatherModel? {
        didSet { bind() } // API로 들어오는 weatherModel의 갱신된 값을 갱신될때마다 cell에 보여줘야함 -> didset, willset
    }
    //    var weatherModel: WeatherModel?
    
    // MARK: Views
    //
    let activityIndicatorView =  UIActivityIndicatorView(style: .medium)
    //    lazy var snowView: SKView = {
    //        let view = SKView()
    //        view.backgroundColor = .clear
    //        let scene = SnowScene()
    //        view.presentScene(scene)
    //        return view
    //    }()
    //
    //    lazy var rainView: SKView = {
    //        let view = SKView()
    //        view.backgroundColor = .clear
    //        let scene = RainScene()
    //        view.presentScene(scene)
    //        return view
    //    }()
    
    private lazy var cityName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "위치 권한 설정"
        label.textColor = .white
        return label
    }()
    private lazy var koreaCityName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = .systemFont(ofSize: 35)
        label.textColor = .white
        return label
    }()
    private lazy var humidity: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    private lazy var temperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    private lazy var iconImage: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var cityStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var tempView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    // MARK: init
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(activityIndicatorView)
        addSubview(stackView)
        addSubview(cityStackView)
        
        stackView.addArrangedSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            cityStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            cityStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        //        if  UserInfo.shared.longitude != 0 {
        //            activityIndicatorView.startAnimating()
        //            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        //
        //            addSubview(activityIndicatorView)
        //            addSubview(stackView)
        //            addSubview(cityStackView)
        //
        //            stackView.addArrangedSubview(activityIndicatorView)
        //
        //            NSLayoutConstraint.activate([
        //                activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        //                activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        //
        //                cityStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
        //                cityStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        //
        //                stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
        //                stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        //            ])
        //        } else {
        //            print("else else")
        //            addSubview(stackView)
        //            addSubview(cityStackView)
        //
        //            NSLayoutConstraint.activate([
        //
        //                cityStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
        //                cityStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        //
        //                stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
        //                stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        //            ])
        //        }
        
        //        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: functions
    //
    private func bind() {
        
        print("call bind")
        print("weatherModel! \(weatherModel!)")
        koreaCityName.text = String(describing: CityKoreaListDic.filter {$0.keys.contains(weatherModel!.name)}.first!.first!.value)
        
        guard let cityNameValue = weatherModel?.name else { return }
        cityName.text = String(describing: cityNameValue)
        
        guard let humidityValue = weatherModel?.main.humidity else { return }
        humidity.text =  "\(String(describing: humidityValue)) %"
        
        guard let temperatureValue = weatherModel?.main.temp else { return }
        let intTemperatureValue = Int(temperatureValue)
        temperature.text = "\(String(describing: intTemperatureValue))°"
        
        guard let imgStringValue = weatherModel?.weather.first?.icon else { return }
        let url = "https://openweathermap.org/img/wn/\(imgStringValue).png"
        
        iconImage.setImageUrl(url) // 캐시 이미지 set
        
        // cell backgroundImage
        // 흐림
        if weatherModel!.weather.first!.main.contains("Clouds") {
            self.backgroundView = UIImageView(image: UIImage(named: "cloud.jpg"))
        }
        // 눈
        else if weatherModel!.weather.first!.main.contains("Snow"){
            self.backgroundView = UIImageView(image: UIImage(named: "cloud.jpg"))
            //                self.backgroundView!.addSubview(snowView)
            //                snowView.translatesAutoresizingMaskIntoConstraints = false
            //                snowView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            //                snowView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            //                snowView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            //                snowView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
        // 비 or 천둥번개
        else if weatherModel!.weather.first!.main.contains("Rain") ||  weatherModel!.weather.first!.main.contains("thunderstorm"){
            self.backgroundView = UIImageView(image: UIImage(named: "cloud.jpg"))
            //                self.backgroundView!.addSubview(rainView)
            //                rainView.translatesAutoresizingMaskIntoConstraints = false
            //                rainView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            //                rainView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            //                rainView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            //                rainView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
        // 그 외
        else {
            self.backgroundView = UIImageView(image: UIImage(named: "sun.jpg"))
        }
        
        stackView.removeArrangedSubview(activityIndicatorView)
        
        stackView.addArrangedSubview(iconImage)
        stackView.addArrangedSubview(humidity)
        stackView.addArrangedSubview(temperature)
        
        cityStackView.addArrangedSubview(koreaCityName)
        cityStackView.addArrangedSubview(cityName)
        
        koreaCityName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        cityName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        humidity.rightAnchor.constraint(equalTo: self.temperature.leftAnchor, constant: -20).isActive = true
        
        
        activityIndicatorView.stopAnimating()
    }
}

