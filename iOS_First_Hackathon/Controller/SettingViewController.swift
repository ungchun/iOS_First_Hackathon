import UIKit

final class SettingViewController: UIViewController {
    
    // MARK: Views
    //
    var settingView: SettingView!
    
    // MARK: Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        
        let settingView = SettingView(frame: self.view.frame)
        self.settingView = settingView
        self.view.addSubview(settingView)
    }
}
