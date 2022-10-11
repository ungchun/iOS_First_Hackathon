import UIKit
import SpriteKit

final class ListTableViewCell: UITableViewCell {
    
    // MARK: Properties
    //
    static let reuseIdentifier = String(describing: ListTableViewCell.self)
    var weatherModel: WeatherModel? {
        didSet { bind() }
    }
    
    // MARK: Views
    //
    private let activityIndicatorView =  UIActivityIndicatorView(style: .medium)
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
    private let cityName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    private let koreaCityName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 35)
        label.textColor = .white
        return label
    }()
    private let humidity: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    private let temperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    private let iconImage: UIImageView = {
        let img = UIImageView()
        return img
    }()
    private let iconHumidityTempstackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    private let cityNameStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: init
    //
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: functions
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10.0, left: 10, bottom: 10, right: 10))
    }
    
    override func prepareForReuse() {
        activityIndicatorView.startAnimating()
        iconHumidityTempstackView.isHidden = true
        cityNameStackView.isHidden = true
        
        contentView.addSubview(backgroundImageView)
        backgroundImageView.image = nil
        backgroundImageView.removeAllSubviews(type: SKView.self)
        backgroundImageView.addSubview(activityIndicatorView)
    }
    
    private func addSubviews() {
        activityIndicatorView.startAnimating()
        
        iconHumidityTempstackView.addArrangedSubview(activityIndicatorView)
        
        backgroundImageView.addSubview(activityIndicatorView)
        backgroundImageView.addSubview(iconHumidityTempstackView)
        backgroundImageView.addSubview(cityNameStackView)
        
        contentView.addSubview(backgroundImageView)
    }
    
    private func makeConstraints() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.heightAnchor.constraint(equalToConstant: 150),
            backgroundImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            cityNameStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40),
            cityNameStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            iconHumidityTempstackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            iconHumidityTempstackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    private func bind() {
        guard let weatherModel else { return }
        koreaCityName.text = String(describing: KoreaCityNameListDic.filter {$0.keys.contains(weatherModel.name)}.first!.first!.value)
        cityName.text = String(describing: weatherModel.name)
        humidity.text =  "\(String(describing: weatherModel.main.humidity)) %"
        temperature.text = "\(String(describing: Int(weatherModel.main.temp)))°"
        
        guard let imgStringValue = weatherModel.weather.first?.icon else { return }
        let url = "https://openweathermap.org/img/wn/\(imgStringValue).png"
        
        iconImage.setImageUrl(url)
        
        if weatherModel.weather.first!.main.contains("Clouds") {
            self.backgroundImageView.image = UIImage(named: "cloud.jpg")
        }
        else if weatherModel.weather.first!.main.contains("Snow"){
            self.backgroundImageView.image = UIImage(named: "cloud.jpg")
            self.backgroundImageView.addSubview(snowView)
            snowView.translatesAutoresizingMaskIntoConstraints = false
            snowView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            snowView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            snowView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            snowView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
        else if weatherModel.weather.first!.main.contains("Rain") ||  weatherModel.weather.first!.main.contains("thunderstorm"){
            self.backgroundImageView.image = UIImage(named: "cloud.jpg")
            self.backgroundImageView.addSubview(rainView)
            rainView.translatesAutoresizingMaskIntoConstraints = false
            rainView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            rainView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            rainView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            rainView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
        else {
            self.backgroundImageView.image = UIImage(named: "sun.jpg")
        }
        
        iconHumidityTempstackView.removeArrangedSubview(activityIndicatorView)
        
        iconHumidityTempstackView.addArrangedSubview(iconImage)
        iconHumidityTempstackView.addArrangedSubview(humidity)
        iconHumidityTempstackView.addArrangedSubview(temperature)
        
        cityNameStackView.addArrangedSubview(koreaCityName)
        cityNameStackView.addArrangedSubview(cityName)
        
        koreaCityName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        cityName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        humidity.rightAnchor.constraint(equalTo: self.temperature.leftAnchor, constant: -20).isActive = true
        
        iconHumidityTempstackView.isHidden = false
        cityNameStackView.isHidden = false
        
        activityIndicatorView.stopAnimating()
    }
}
