import Foundation
import UIKit

class CheckboxCell: BaseTableViewCell<String> {
    
    var testArray: [String]?
    
    var isCheck: Bool = false {
        didSet {
            let imageName = isCheck ? "checkmark.square.fill" : "checkmark.square"
            checkBoxButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
//        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //        isCheck.toggle()
    //        print("selected \(selected)")
    //    }
    
    override func bind(_ model: String?, _ koreanModel: String?) {
        super.bind(model, koreanModel)
        
//        if testArray!.contains(model) {
//            print("bind if")
//            isCheck = true
//            let imageName = isCheck ? "checkmark.square.fill" : "checkmark.square"
//            checkBoxButton.setImage(UIImage(systemName: imageName), for: .normal)
//        }
        titleLabel.text = model
    }
    
    override func configure() {
        super.configure()
        
        addSubviews()
        makeConstraints()
    }
    
    @objc func buttonAction() {
        ListViewController.isChangeRegion = true
        if testArray!.contains(self.koreanModel!) {
            // remove
            if let userinfo = RealmManager.shared.realm.objects(Region.self).filter(NSPredicate(format: "name = %@", self.koreanModel!)).first {
                RealmManager.shared.delete(userinfo)
                print("remove if let")
                self.isCheck = false
                checkBoxButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                
                if let index = testArray!.firstIndex(where: {$0 == self.koreanModel!}) {
                    testArray!.remove(at: index)
                }
            }
        } else {
            // add
            let regin = Region()
            regin.name = self.koreanModel!
            RealmManager.shared.create(regin)
            
            print("create else")
            self.isCheck = true
            checkBoxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            testArray?.append(self.koreanModel!)
        }
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
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepareForReuse")
        checkBoxButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
//        let imageName = isCheck ? "checkmark.square.fill" : "checkmark.square"
//        checkBoxButton.setImage(UIImage(systemName: imageName), for: .normal)
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
