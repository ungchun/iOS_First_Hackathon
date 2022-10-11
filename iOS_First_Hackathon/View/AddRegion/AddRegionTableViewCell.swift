import Foundation
import UIKit

final class CheckboxCell: BaseTableViewCell<String> {
    
    // MARK: Properties
    //
    static let reuseIdentifier = String(describing: CheckboxCell.self)
    var regionArray: [String]?
    
    // MARK: Views
    //
    private lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(checkBoxTapAction), for: .touchUpInside)
        return button
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: functions
    //
    override func prepareForReuse() {
        super.prepareForReuse()
        if koreanModel != nil {
            guard let koreanModel else { return }
            if RealmManager.shared.realm.objects(Region.self).filter(NSPredicate(format: "name = %@", koreanModel)).first != nil {
                checkBoxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            } else {
                checkBoxButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            }
        }
    }
    
    override func configure() {
        super.configure()
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(checkBoxButton)
        contentView.addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        checkBoxButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        checkBoxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        checkBoxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: checkBoxButton.centerYAnchor).isActive = true
    }
    
    override func bind(_ model: String?, _ koreanModel: String?) {
        super.bind(model, koreanModel)
        titleLabel.text = model
        if koreanModel != nil {
            guard let koreanModel else { return }
            if RealmManager.shared.realm.objects(Region.self).filter(NSPredicate(format: "name = %@", koreanModel)).first != nil {
                checkBoxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            } else {
                checkBoxButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            }
        }
    }
    
    @objc private func checkBoxTapAction() {
        guard let regionArray else { return }
        guard let koreanModel else { return }
        if regionArray.contains(koreanModel) {
            if regionArray.count > 1 {
                if let userinfo = RealmManager.shared.realm.objects(Region.self).filter(NSPredicate(format: "name = %@", koreanModel)).first {
                    RealmManager.shared.delete(userinfo)
                    checkBoxButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                    
                    if let index = regionArray.firstIndex(where: {$0 == koreanModel}) {
                        self.regionArray!.remove(at: index)
                    }
                }
                ListViewController.isChangeRegion = true
            }
        } else {
            let regin = Region()
            regin.name = koreanModel
            RealmManager.shared.create(regin)
            
            checkBoxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            self.regionArray!.append(koreanModel)
            ListViewController.isChangeRegion = true
        }
    }
}

class BaseTableViewCell<T>: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        selectionStyle = .none
    }
    
    var model: T? {
        didSet {
            if let model = model {
                bind(model, koreanModel)
            }
        }
    }
    var koreanModel: T? {
        didSet {
            if let koreanModel = koreanModel {
                bind(model, koreanModel)
            }
        }
    }
    
    func bind(_ model: T?, _ koreanModel: T?) {}
}
