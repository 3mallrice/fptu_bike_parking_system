import UIKit
import Flutter
import zpdk

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Khởi tạo ZaloPay SDK
    ZaloPaySDK.sharedInstance()?.initWithAppId(2553, uriScheme: "demozpdk://app", environment: .sandbox) // NOTE: Nếu muốn sử dụng môi trường production, hãy thay thế .sandbox bằng .production

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return ZaloPaySDK.sharedInstance().application(app, open:url, sourceApplication: "vn.com.vng.zalopay", annotation:nil)
  }
}
