import Foundation
import CoreLocation
import UIKit

final class SettingView: UIView {
    
    // MARK: Preperties
    //
    let status = CLLocationManager().authorizationStatus
    
    // MARK: Views
    //
    private let locationCheckText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let inquiryText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let InformationText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let developerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = .systemGray3
        return view
    }()
    private lazy var allContentStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [locationCheckText, divider, inquiryText, InformationText, developerName])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 50
        return view
    }()
    
    // MARK: init
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(allContentStackView)
        
        locationCheckText.text = status == .authorizedAlways || status == .authorizedWhenInUse ? "위치정보 사용 중" : "위치정보 사용 안함"
        inquiryText.text = "문의하기"
        InformationText.text = "개인 정보 처리 방침"
        developerName.text = "developer Dal"
        
        NSLayoutConstraint.activate([
            divider.widthAnchor.constraint(equalToConstant: 10),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            allContentStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            allContentStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
