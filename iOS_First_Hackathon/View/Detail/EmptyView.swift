import Foundation
import UIKit
import SnapKit

class EmptyView: UIView {
    
    // MARK: Views
    //
    let label: UILabel = {
        let label = UILabel()
        label.text = "위치 권한이 꺼져있습니다. 권한을 설정해주세요."
       return label
    }()
    
    // MARK: init
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: functions
    //
    private func setup() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
