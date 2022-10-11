import Foundation
import UIKit
import SpriteKit

final class DetailView: UIView {
    
    // MARK: Properties
    //
    var detailCityWeatherModel: WeatherModel?
    var myRegionCheck: Bool?
    
    // MARK: Views
    //
    private lazy var snowView: SKView = {
        let view = SKView()
        view.backgroundColor = .clear
        let scene = SnowScene()
        view.presentScene(scene)
        return view
    }()
    private lazy var rainView: SKView = {
        let view = SKView()
        view.backgroundColor = .clear
        let scene = RainScene()
        view.presentScene(scene)
        return view
    }()
    private let koreaCityNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 80)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    private let temp_maxLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let temp_minLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let tempMinMaxStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    private let cityWeatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
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
        stackView.backgroundColor = UIColor (red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        return stackView
    }()
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
        stackView.backgroundColor = UIColor (red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        return stackView
    }()
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
        stackView.backgroundColor = UIColor (red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        return stackView
    }()
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
        stackView.backgroundColor = UIColor (red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        return stackView
    }()
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
        stackView.backgroundColor = UIColor (red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        return stackView
    }()
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
        stackView.backgroundColor = UIColor (red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        return stackView
    }()
    private let anotherFirstLineDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let anotherSecondLineDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let anotherAllLineDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return stackView
    }()
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
    required init(frame: CGRect, detailCityWeatherModel: WeatherModel, myRegionCheck: Bool) {
        super.init(frame: frame)
        
        self.detailCityWeatherModel = detailCityWeatherModel
        self.myRegionCheck = myRegionCheck
        
        setupViews()
        addSubviews()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: functions
    //
    private func addSubviews() {
        self.addSubview(entireStackView)
        addArrangedSubviews()
    }
    
    private func addArrangedSubviews() {
        tempMinMaxStackView.addArrangedSubview(temp_maxLabel)
        tempMinMaxStackView.addArrangedSubview(temp_minLabel)
        
        cityWeatherStackView.addArrangedSubview(koreaCityNameLabel)
        cityWeatherStackView.addArrangedSubview(temperatureLabel)
        cityWeatherStackView.addArrangedSubview(descriptionLabel)
        cityWeatherStackView.addArrangedSubview(tempMinMaxStackView)
        
        iconStackView.addArrangedSubview(iconTitleLabel)
        iconStackView.addArrangedSubview(iconValueIcon)
        
        feels_likeStackView.addArrangedSubview(feels_likeTitleLabel)
        feels_likeStackView.addArrangedSubview(feels_likeValueLabel)
        
        humidityStackView.addArrangedSubview(humidityTitleLabel)
        humidityStackView.addArrangedSubview(humidityValueLabel)
        
        anotherFirstLineDetailStackView.addArrangedSubview(iconStackView)
        anotherFirstLineDetailStackView.addArrangedSubview(feels_likeStackView)
        anotherFirstLineDetailStackView.addArrangedSubview(humidityStackView)
        
        pressureStackView.addArrangedSubview(pressureTitleLabel)
        pressureStackView.addArrangedSubview(pressureValueLabel)
        
        speedStackView.addArrangedSubview(speedTitleLabel)
        speedStackView.addArrangedSubview(speedValueLabel)
        
        visibilityStackView.addArrangedSubview(visibilityTitleLabel)
        visibilityStackView.addArrangedSubview(visibilityValueLabel)
        
        anotherSecondLineDetailStackView.addArrangedSubview(pressureStackView)
        anotherSecondLineDetailStackView.addArrangedSubview(speedStackView)
        anotherSecondLineDetailStackView.addArrangedSubview(visibilityStackView)
        
        anotherAllLineDetailStackView.addArrangedSubview(anotherFirstLineDetailStackView)
        anotherAllLineDetailStackView.addArrangedSubview(anotherSecondLineDetailStackView)
        
        entireStackView.addArrangedSubview(cityWeatherStackView)
        entireStackView.addArrangedSubview(anotherAllLineDetailStackView)
    }
    
    private func setupViews() {
        setupBackgroundView()
        setupCityData()
    }
    
    private func setupBackgroundView() {
        guard let detailCityWeatherModel else { return }
        if detailCityWeatherModel.weather.first!.main.contains("Clouds") {
            let imageView = bringBackgroundImage("Clouds")
            self.addSubview(imageView)
            self.sendSubviewToBack(imageView)
        }
        else if detailCityWeatherModel.weather.first!.main.contains("Snow") {
            let imageView = bringBackgroundImage("Clouds")
            self.addSubview(imageView)
            self.sendSubviewToBack(imageView)
            self.addSubview(snowView)
            snowView.translatesAutoresizingMaskIntoConstraints = false
            snowView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            snowView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            snowView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            snowView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
        else if detailCityWeatherModel.weather.first!.main.contains("Rain") || detailCityWeatherModel.weather.first!.main.contains("thunderstorm") {
            let imageView = bringBackgroundImage("Clouds")
            self.addSubview(imageView)
            self.sendSubviewToBack(imageView)
            self.addSubview(rainView)
            rainView.translatesAutoresizingMaskIntoConstraints = false
            rainView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            rainView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            rainView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            rainView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
        else {
            let imageView = bringBackgroundImage("Clear")
            self.addSubview(imageView)
            self.sendSubviewToBack(imageView)
        }
    }
    
    private func setupCityData() {
        guard let detailCityWeatherModel else { return }
        guard let myRegionCheck else { return }
        
        koreaCityNameLabel.text = myRegionCheck ? "나의 위치 \(detailCityWeatherModel.name)" :String(describing: KoreaCityNameListDic.filter {$0.keys.contains(detailCityWeatherModel.name)}.first!.first!.value)
        temperatureLabel.text = "\(String(describing: Int(detailCityWeatherModel.main.temp)))°"
        descriptionLabel.text = String(describing: DescriptionListDic.filter {$0.values.contains((detailCityWeatherModel.weather[0].description))}.first!.first!.key)
        temp_maxLabel.text = "최고:\(String(describing: Int(detailCityWeatherModel.main.temp_max)))°"
        temp_minLabel.text = "최저:\(String(describing: Int(detailCityWeatherModel.main.temp_min)))°"
        feels_likeValueLabel.text = "\(String(describing: Int(detailCityWeatherModel.main.feels_like)))°"
        humidityValueLabel.text = "\(String(describing: Int(detailCityWeatherModel.main.humidity)))%"
        pressureValueLabel.text = "\(String(describing: Int(detailCityWeatherModel.main.pressure/10)))"
        speedValueLabel.text = "\(String(describing: Int(detailCityWeatherModel.wind.speed)))"
        visibilityValueLabel.text = "\(String(describing: Int(detailCityWeatherModel.visibility/100)))"
        
        let url = "https://openweathermap.org/img/wn/\(detailCityWeatherModel.weather[0].icon).png"
        let cacheKey = String(describing: url)
        let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey as NSString)
        iconValueIcon.image = cachedImage
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            iconTitleLabel.leftAnchor.constraint(equalTo: self.iconStackView.leftAnchor, constant: 10),
            iconValueIcon.rightAnchor.constraint(equalTo: self.iconStackView.rightAnchor, constant: 20),
            
            iconStackView.widthAnchor.constraint(equalToConstant: 150),
            iconStackView.heightAnchor.constraint(equalToConstant: 150),
            
            feels_likeTitleLabel.leftAnchor.constraint(equalTo: self.feels_likeStackView.leftAnchor, constant: 10),
            feels_likeValueLabel.rightAnchor.constraint(equalTo: self.feels_likeStackView.rightAnchor, constant: -10),
            
            humidityTitleLabel.leftAnchor.constraint(equalTo: self.humidityStackView.leftAnchor, constant: 10),
            humidityValueLabel.rightAnchor.constraint(equalTo: self.humidityStackView.rightAnchor, constant: -10),
            
            pressureTitleLabel.leftAnchor.constraint(equalTo: self.pressureStackView.leftAnchor, constant: 10),
            pressureValueLabel.rightAnchor.constraint(equalTo: self.pressureStackView.rightAnchor, constant: -10),
            
            pressureStackView.widthAnchor.constraint(equalToConstant: 150),
            pressureStackView.heightAnchor.constraint(equalToConstant: 150),
            
            speedTitleLabel.leftAnchor.constraint(equalTo: self.speedStackView.leftAnchor, constant: 10),
            speedValueLabel.rightAnchor.constraint(equalTo: self.speedStackView.rightAnchor, constant: -10),
            
            visibilityTitleLabel.leftAnchor.constraint(equalTo: self.visibilityStackView.leftAnchor, constant: 10),
            visibilityValueLabel.rightAnchor.constraint(equalTo: self.visibilityStackView.rightAnchor, constant: -10),
            
            anotherAllLineDetailStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            anotherAllLineDetailStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            
            entireStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            entireStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    private func bringBackgroundImage(_ main: String) -> UIImageView {
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
}
