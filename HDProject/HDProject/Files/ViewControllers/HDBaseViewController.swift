import UIKit
import FittedSheets

open class HDBaseViewController: UIViewController {
    @IBOutlet public weak var adsView: UIView!
    public var window: UIWindow? { return HDAppDelegateHelper.window }
    
    public var viewDidLoadClosure:       () -> () = { }
    public var viewWillAppearClosure:    () -> () = { }
    public var viewDidAppearClosure:     () -> () = { }
    public var viewWillDisappearClosure: () -> () = { }
    public var viewDidDisappearClosure:  () -> () = { }
    
    deinit {
        HDBaseViewController.removeObservers(viewController: self)
        print("_____deinit:", type(of: self).className)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad:", type(of: self).className)
        
        viewDidLoadClosure()
        HDBaseViewController.addRefreshAdsSettingObservers(viewController: self)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearClosure()
        setupAdsView()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearClosure()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisappearClosure()
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewDidDisappearClosure()
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateOverlayColorForSheetViewController()
    }
    
    open func updateOverlayColorForSheetViewController() {
        sheetViewController?.overlayColor = UIColor.getOverlayColor(with: traitCollection)
    }
}

public extension HDBaseViewController {
    @objc func showSettings() {
        SettingsTableViewController.show(from: self)
    }
}

public extension HDBaseViewController {
    static func removeObservers(viewController: UIViewController) {
        NotificationCenter.default.removeObserver(viewController)
    }
    
    static func addRefreshAdsSettingObservers(viewController: UIViewController) {
        NotificationCenter.default.addObserver(viewController,
                                               selector: #selector(refreshAdsSettings),
                                               name: HDNotificationName.refreshAdsSettings,
                                               object: nil)
    }
}

extension HDBaseViewController: AdsDelegate {
    @objc open func setupAdsView() { }
    @objc open func refreshAdsSettings() { }
}

// -------------------------------------- //

public protocol AdsDelegate: class {
    func setupAdsView()
    func refreshAdsSettings()
}
