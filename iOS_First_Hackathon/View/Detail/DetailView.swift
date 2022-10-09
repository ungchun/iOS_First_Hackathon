import Foundation
import UIKit
import SpriteKit

class DetailView: UIView {
    
    // MARK: Properties
    //
    var detailCityWeatherModel: WeatherModel?
    
    // MARK: Views
    //
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
    
    // 도시이름, 현재온도, 설명, 최고, 최저기온
    private let koreaCityNameLabel: UILabel = {
        let label = UILabel()
        label.text = "중구"
        label.font = .systemFont(ofSize: 40)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "30"
        label.textColor = .white
        label.font = .systemFont(ofSize: 80)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "대체로 흐림"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    private let temp_maxLabel: UILabel = {
        let label = UILabel()
        label.text = "최고"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let temp_minLabel: UILabel = {
        let label = UILabel()
        label.text = "최저"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 최고 + 최저기온
    private let tempMinMaxStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    // 위에 정보 전부 다 합친 도시 정보
    private let topTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    // 아이콘 title + value + 스택 뷰
    private let iconTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "아이콘"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    private let iconValueIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let iconStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.layer.borderWidth = 2
        stackView.layer.cornerRadius = 30
        stackView.layer.borderColor = UIColor (red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2).cgColor
        return stackView
    }()
    
    // 체감기온 title + value + 스택 뷰
    private let feels_likeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "체감기온"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    private let feels_likeValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 35)
        label.text = "체감기온"
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    private let feels_likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.layer.borderWidth = 2
        stackView.layer.cornerRadius = 30
        stackView.layer.borderColor = UIColor (red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2).cgColor
        return stackView
    }()
    
    // 현재습도 title + value + 스택 뷰
    private let humidityTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "현재습도"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    private let humidityValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "현재습도"
        label.font = .systemFont(ofSize: 35)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    private let humidityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.layer.borderWidth = 2
        stackView.layer.cornerRadius = 30
        stackView.layer.borderColor = UIColor (red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2).cgColor
        return stackView
    }()
    
    // 기압 title + value + 스택 뷰
    private let pressureTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "기압"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    private let pressureValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "기압"
        label.font = .systemFont(ofSize: 35)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    private let pressureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.layer.borderWidth = 2
        stackView.layer.cornerRadius = 30
        stackView.layer.borderColor = UIColor (red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2).cgColor
        return stackView
    }()
    
    // 풍속 title + value + 스택 뷰
    private let speedTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "풍속"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    private let speedValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "풍속"
        label.font = .systemFont(ofSize: 35)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    private let speedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.layer.borderWidth = 2
        stackView.layer.cornerRadius = 30
        stackView.layer.borderColor = UIColor (red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2).cgColor
        return stackView
    }()
    
    // 시정 title + value + 스택 뷰
    private let visibilityTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "시정"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    private let visibilityValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "시정"
        label.font = .systemFont(ofSize: 35)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    private let visibilityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.layer.borderWidth = 2
        stackView.layer.cornerRadius = 30
        stackView.layer.borderColor = UIColor (red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2).cgColor
        return stackView
    }()
    
    // 아이콘 스택뷰 + 체감기온 스택뷰 + 현재습도 스택뷰
    private let anotherFirstLineDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // 기압 스택뷰 + 풍속 스택뷰 + 시정 스택뷰
    private let anotherSecondLineDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // anotherFirstLineDetailStackView + anotherSecondLineDetailStackView
    private let anotherLineDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return stackView
    }()
    
    // 도시정보 + anotherLineDetailStackView
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 60
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: init
    //
    required init(frame: CGRect, detailCityWeatherModel: WeatherModel) {
        super.init(frame: frame)
        self.detailCityWeatherModel = detailCityWeatherModel // 도시 정보를 담은 model
        
        setBackgroundView()
        setCityData()
        setAddArrangedSubview()
        
        self.addSubview(entireStackView)
        
        // autolayout
        NSLayoutConstraint.activate([
            iconTitleLabel.leftAnchor.constraint(equalTo: self.iconStackView.leftAnchor, constant: 10),
            iconValueIcon.rightAnchor.constraint(equalTo: self.iconStackView.rightAnchor, constant: 20),
            // 첫번째 스택뷰의 첫번째 요소에 width, height 값 지정해서 뒤에 요소들까지 같이 width, height 세팅
            iconStackView.widthAnchor.constraint(equalToConstant: 150),
            iconStackView.heightAnchor.constraint(equalToConstant: 150),
            
            feels_likeTitleLabel.leftAnchor.constraint(equalTo: self.feels_likeStackView.leftAnchor, constant: 10),
            feels_likeValueLabel.rightAnchor.constraint(equalTo: self.feels_likeStackView.rightAnchor, constant: -10),
            
            humidityTitleLabel.leftAnchor.constraint(equalTo: self.humidityStackView.leftAnchor, constant: 10),
            humidityValueLabel.rightAnchor.constraint(equalTo: self.humidityStackView.rightAnchor, constant: -10),
            
            pressureTitleLabel.leftAnchor.constraint(equalTo: self.pressureStackView.leftAnchor, constant: 10),
            pressureValueLabel.rightAnchor.constraint(equalTo: self.pressureStackView.rightAnchor, constant: -10),
            // 두번째 스택뷰의 첫번째 요소에 width, height 값 지정해서 뒤에 요소들까지 같이 width, height 세팅
            pressureStackView.widthAnchor.constraint(equalToConstant: 150),
            pressureStackView.heightAnchor.constraint(equalToConstant: 150),
            
            speedTitleLabel.leftAnchor.constraint(equalTo: self.speedStackView.leftAnchor, constant: 10),
            speedValueLabel.rightAnchor.constraint(equalTo: self.speedStackView.rightAnchor, constant: -10),
            
            visibilityTitleLabel.leftAnchor.constraint(equalTo: self.visibilityStackView.leftAnchor, constant: 10),
            visibilityValueLabel.rightAnchor.constraint(equalTo: self.visibilityStackView.rightAnchor, constant: -10),
            
            anotherLineDetailStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            anotherLineDetailStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            
            entireStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            entireStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: functions
    //
    func bringBackgroundImage(_ main: String) -> UIImageView {
        let background: UIImage
        if main == "Clear" {
            background = UIImage(named: "sun.jpg")!
        } else {
            background = UIImage(named: "cloud.jpg")!
        }
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = self.center
        return imageView
    }
    
    func setBackgroundView() {
        // 흐림
        if detailCityWeatherModel!.weather.first!.main.contains("Clouds") {
            // image 를 backgroud 에 세팅하기
            let imageView = bringBackgroundImage("Clouds")
            self.addSubview(imageView)
            self.sendSubviewToBack(imageView)
        }
        // 눈
        else if detailCityWeatherModel!.weather.first!.main.contains("Snow") {
            let imageView = bringBackgroundImage("Clouds")
            self.addSubview(imageView)
            self.sendSubviewToBack(imageView)

//            self.addSubview(snowView)
//            snowView.translatesAutoresizingMaskIntoConstraints = false
//            snowView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//            snowView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//            snowView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//            snowView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
        // 비 or 천둥번개
        else if detailCityWeatherModel!.weather.first!.main.contains("Rain") || detailCityWeatherModel!.weather.first!.main.contains("thunderstorm") {
            let imageView = bringBackgroundImage("Clouds")
            self.addSubview(imageView)
            self.sendSubviewToBack(imageView)

//            self.addSubview(rainView)
//            rainView.translatesAutoresizingMaskIntoConstraints = false
//            rainView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//            rainView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//            rainView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//            rainView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
        // 그 외
        else {
            let imageView = bringBackgroundImage("Clear")
            self.addSubview(imageView)
            self.sendSubviewToBack(imageView)
        }
    }
    
    func setCityData() {
        
        // 도시이름
        koreaCityNameLabel.text = String(describing: CityKoreaListDic.filter {$0.keys.contains(detailCityWeatherModel!.name)}.first!.first!.value)
//        koreaCityNameLabel.text = "대구"
        
        // 현재온도
        let intTemperatureValue = Int(detailCityWeatherModel!.main.temp)
        tempLabel.text = "\(String(describing: intTemperatureValue))°"
        
        // 날씨설명
        descriptionLabel.text = String(describing: DescriptionListDic.filter {$0.values.contains((detailCityWeatherModel!.weather[0].description))}.first!.first!.key)
//        descriptionLabel.text = "날씨 설명"
        
        // 최고, 최저기온
        let intTemperatureMaxValue = Int(detailCityWeatherModel!.main.temp_max)
        temp_maxLabel.text = "최고:\(String(describing: intTemperatureMaxValue))°"
        let intTemperatureMinValue = Int(detailCityWeatherModel!.main.temp_min)
        temp_minLabel.text = "최저:\(String(describing: intTemperatureMinValue))°"
        
        // 아이콘
        let url = "https://openweathermap.org/img/wn/\(detailCityWeatherModel!.weather[0].icon).png"
        let cacheKey = String(describing: url) // 캐시에 사용될 Key 값
        let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey as NSString)
        iconValueIcon.image = cachedImage
        
        // 체감기온
        let intFeels_likeValue = Int(detailCityWeatherModel!.main.feels_like)
        feels_likeValueLabel.text = "\(String(describing: intFeels_likeValue))°"
        
        // 현재습도
        let intHumidityValue = Int(detailCityWeatherModel!.main.humidity)
        humidityValueLabel.text = "\(String(describing: intHumidityValue))%"
        
        // 기압
        let intPressureValue = Int(detailCityWeatherModel!.main.pressure/10)
        pressureValueLabel.text = "\(String(describing: intPressureValue))"
        
        // 풍속
        let intSpeedValue = Int(detailCityWeatherModel!.wind.speed)
        speedValueLabel.text = "\(String(describing: intSpeedValue))"
        
        // 시정
        let intVisibilityValue = Int(detailCityWeatherModel!.visibility/100)
        visibilityValueLabel.text = "\(String(describing: intVisibilityValue))"
    }
    
    func setAddArrangedSubview() {
        // 최고 + 최저기온
        tempMinMaxStackView.addArrangedSubview(temp_maxLabel)
        tempMinMaxStackView.addArrangedSubview(temp_minLabel)
        
        // 도시정보
        topTextStackView.addArrangedSubview(koreaCityNameLabel)
        topTextStackView.addArrangedSubview(tempLabel)
        topTextStackView.addArrangedSubview(descriptionLabel)
        topTextStackView.addArrangedSubview(tempMinMaxStackView)
        
        // 아이콘
        iconStackView.addArrangedSubview(iconTitleLabel)
        iconStackView.addArrangedSubview(iconValueIcon)
        // 체감기온
        feels_likeStackView.addArrangedSubview(feels_likeTitleLabel)
        feels_likeStackView.addArrangedSubview(feels_likeValueLabel)
        // 현재습도
        humidityStackView.addArrangedSubview(humidityTitleLabel)
        humidityStackView.addArrangedSubview(humidityValueLabel)
        // 아이콘 + 체감기온 + 현재습도
        anotherFirstLineDetailStackView.addArrangedSubview(iconStackView)
        anotherFirstLineDetailStackView.addArrangedSubview(feels_likeStackView)
        anotherFirstLineDetailStackView.addArrangedSubview(humidityStackView)
        
        // 기압
        pressureStackView.addArrangedSubview(pressureTitleLabel)
        pressureStackView.addArrangedSubview(pressureValueLabel)
        // 풍속
        speedStackView.addArrangedSubview(speedTitleLabel)
        speedStackView.addArrangedSubview(speedValueLabel)
        // 시정
        visibilityStackView.addArrangedSubview(visibilityTitleLabel)
        visibilityStackView.addArrangedSubview(visibilityValueLabel)
        // 기압 + 풍속 + 시정
        anotherSecondLineDetailStackView.addArrangedSubview(pressureStackView)
        anotherSecondLineDetailStackView.addArrangedSubview(speedStackView)
        anotherSecondLineDetailStackView.addArrangedSubview(visibilityStackView)
        
        anotherLineDetailStackView.addArrangedSubview(anotherFirstLineDetailStackView)
        anotherLineDetailStackView.addArrangedSubview(anotherSecondLineDetailStackView)
        
        entireStackView.addArrangedSubview(topTextStackView)
        entireStackView.addArrangedSubview(anotherLineDetailStackView)
        
    }
    
}
