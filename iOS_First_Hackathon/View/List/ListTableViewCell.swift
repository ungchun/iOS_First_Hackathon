import UIKit
import SpriteKit

class ListTableViewCell: UITableViewCell {
    
    // MARK: Properties
    //
    static let reuseIdentifier = String(describing: ListTableViewCell.self)
    var weatherModel: WeatherModel? {
        didSet { bind() } // API로 들어오는 weatherModel의 갱신된 값을 갱신될때마다 cell에 보여줘야함 -> didset, willset
    }
    
    // MARK: Views
    //
    let activityIndicatorView =  UIActivityIndicatorView(style: .medium)
        lazy var snowView: SKView = {
            let view = SKView()
            view.backgroundColor = .clear
            let scene = SnowScene()
            view.presentScene(scene)
            return view
        }()

        lazy var rainView: SKView = {
            let view = SKView()
            view.backgroundColor = .clear
            let scene = RainScene()
            view.presentScene(scene)
            return view
        }()
    
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
    
    private lazy var backgroundImageView: UIImageView = {
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
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.addSubview(activityIndicatorView)
        backgroundImageView.addSubview(stackView)
        backgroundImageView.addSubview(cityStackView)
        
//        addSubview(activityIndicatorView)
//        addSubview(stackView)
//        addSubview(cityStackView)
        
        contentView.addSubview(backgroundImageView)
        
        stackView.addArrangedSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.heightAnchor.constraint(equalToConstant: 150),
            backgroundImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            cityStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40),
            cityStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10.0, left: 10, bottom: 10, right: 10))

    }
    
    override func prepareForReuse() {
        activityIndicatorView.startAnimating()
        stackView.isHidden = true
        cityStackView.isHidden = true

        contentView.addSubview(backgroundImageView)
        backgroundImageView.image = nil
        backgroundImageView.removeAllSubviews(type: SKView.self)
        backgroundImageView.addSubview(activityIndicatorView)
    }
    
    // MARK: functions
    //
    private func bind() {
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
            self.backgroundImageView.image = UIImage(named: "cloud.jpg")
//            self.backgroundView = UIImageView(image: UIImage(named: "cloud.jpg"))
        }
        // 눈
        else if weatherModel!.weather.first!.main.contains("Snow"){
            self.backgroundImageView.image = UIImage(named: "cloud.jpg")
            self.backgroundImageView.addSubview(snowView)
            snowView.translatesAutoresizingMaskIntoConstraints = false
            snowView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            snowView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            snowView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            snowView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
        // 비 or 천둥번개
        else if weatherModel!.weather.first!.main.contains("Rain") ||  weatherModel!.weather.first!.main.contains("thunderstorm"){
            self.backgroundImageView.image = UIImage(named: "cloud.jpg")
            self.backgroundImageView.addSubview(rainView)
            rainView.translatesAutoresizingMaskIntoConstraints = false
            rainView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            rainView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            rainView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            rainView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
        // 그 외
        else {
            self.backgroundImageView.image = UIImage(named: "sun.jpg")
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
        
        stackView.isHidden = false
        cityStackView.isHidden = false

        activityIndicatorView.stopAnimating()
    }
}
// https://stackoverflow.com/questions/24312760/how-to-remove-all-subviews-of-a-view-in-swift
// subview remove
extension UIView {
    /// Remove all subview
    func removeAllSubviews() { // subView 전체 삭제
        subviews.forEach { $0.removeFromSuperview() }
    }

    /// Remove all subview with specific type
    func removeAllSubviews<T: UIView>(type: T.Type) { // 원하는 type의 subView만 삭제
        subviews
            .filter { $0.isMember(of: type) }
            .forEach { $0.removeFromSuperview() }
    }
}
