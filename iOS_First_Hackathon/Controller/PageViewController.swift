import UIKit
import CoreLocation
import RealmSwift

final class PageViewController: UIViewController {
    
    // MARK: Properties
    //
    var currentIndex: Int?
    var pendingIndex: Int?
    var startIndex: Int?
    let status = CLLocationManager().authorizationStatus
    
    // MARK: Views
    //
    private let toolbar = UIToolbar()
    var dataViewControllers: [UIViewController]!
    let detailVC = DetailViewController()
    
    lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return vc
    }()
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .white.withAlphaComponent(0.5)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = 0
        return pageControl
    }()
    
    // MARK: Life Cycle
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: functions
    //
    private func setupView() {
        guard let dataViewControllers else { return }
        
        checkMyRegion()
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        pageViewController.view.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        pageViewController.didMove(toParent: self)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([dataViewControllers[startIndex!]], direction: .forward, animated: true, completion: nil)
        
        pageControl.numberOfPages = RealmManager.shared.realm.objects(Region.self).count
        pageControl.currentPage = startIndex!
        
        setupToolbar()
    }
    private func setupToolbar() {
        let toolbar = UIToolbar()
        view.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.isTranslucent = true
        toolbar.backgroundColor = .clear
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        toolbar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 0).isActive = true
        toolbar.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 0).isActive = true
        toolbar.trailingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.trailingAnchor, multiplier: 0).isActive = true
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        fixedSpace.width = 6
        let toolbarItemMap = UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(goToTheMyRegion))
        toolbarItemMap.tintColor = .white
        let toolbarItemList = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(goToTheList))
        toolbarItemList.tintColor = .white
        let pageControl = UIBarButtonItem(customView: pageControl)
        toolbar.setItems([fixedSpace, toolbarItemMap, flexibleSpace, pageControl, flexibleSpace, toolbarItemList, fixedSpace], animated: true)
    }
    private func checkMyRegion() {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            WeatherManager(cityName: "Daegu").getWeatherWithLocation { result in
                switch result {
                case .success(let weatherValue):
                    self.detailVC.weatherModel = weatherValue
                    self.detailVC.myRegionCheck = true
                    self.detailVC.receivedModel(weatherModel: weatherValue)
                    print("???? \(weatherValue)")
                case .failure(let networkError):
                    print("\(networkError)")
                }
            }
        }
    }
    @objc private func goToTheMyRegion() {
        print("?????? goToTheMyRegion")
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            print("if if \(self.detailVC)")
            self.present(self.detailVC, animated: true)
        } else {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
    @objc private func goToTheList(sender: UIBarButtonItem) {
        self.dismiss(animated: false)
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return dataViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == dataViewControllers.count {
            return nil
        }
        return dataViewControllers[nextIndex]
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = dataViewControllers.firstIndex(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
    }
}
