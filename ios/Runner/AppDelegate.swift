import Flutter
import UIKit
import Foundation
import flutter_downloader
import awesome_notifications
import UnityFramework


@main
@objc class AppDelegate: FlutterAppDelegate {
    // Define the Unity view controller variable
    var unityViewController: UnityViewController?
    var methodChannel: FlutterMethodChannel?

    private var isUnityActive = false
    private let unityPresentationOrientation: UIInterfaceOrientation = .landscapeRight
    private let flutterDefaultOrientation: UIInterfaceOrientation = .portrait

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Register plugins first to ensure native backends are ready
        GeneratedPluginRegistrant.register(with: self)

        SwiftAwesomeNotificationsPlugin.setPluginRegistrantCallback { registry in
                  SwiftAwesomeNotificationsPlugin.register(
                    with: registry.registrar(forPlugin: "io.flutter.plugins.awesomenotifications.AwesomeNotificationsPlugin")!)
              }
    
        let controller: FlutterViewController = window?.rootViewController as? FlutterViewController ?? FlutterViewController()
        let channel = FlutterMethodChannel(name: "unity_launcher_channel", binaryMessenger: controller.binaryMessenger)
        self.methodChannel = channel
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "openUnityViewController" {
                if let args = call.arguments as? [String: Any],
                   let contentCode = args["contentCode"] as? String {
                    
                    
                    // Call the method to open Unity ViewController with the content code
                    self?.openUnityViewController(contentCode: contentCode)
                    result(nil)
                } else {
                    result(FlutterError(code: "ERROR", message: "Content code missing", details: nil))
                }
            }else if call.method == "getAvailableStorage" {
                let fileURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
                if let values = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityKey]),
                   let freeSpace = values.volumeAvailableCapacity {
                    result(freeSpace)
                } else {
                    result(FlutterError(code: "UNAVAILABLE", message: "Could not fetch storage info", details: nil))
                }
            }  else {
                result(FlutterMethodNotImplemented)
            }
        }
     
        FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
  
    
    private func unity(){
        var methodChannel: FlutterMethodChannel?
         //Set up the FlutterMethodChannel
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "unity_launcher_channel", binaryMessenger: controller.binaryMessenger)
        methodChannel = channel
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "openUnityViewController" {
                if let args = call.arguments as? [String: Any],
                   let contentCode = args["contentCode"] as? String {

                    // Open Unity ViewController with the provided content code
                    self?.openUnityViewController(contentCode: contentCode)
                    result(nil)
                } else {
                    result(FlutterError(code: "ERROR", message: "Content code missing", details: nil))
                }
            }
             else  if call.method == "getAvailableStorage" {
                let fileURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
                if let values = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityKey]),
                   let freeSpace = values.volumeAvailableCapacity {
                    result(freeSpace)
                } else {
                    result(FlutterError(code: "UNAVAILABLE", message: "Could not fetch storage info", details: nil))
                }
            }
            else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func pathChannel(){
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
            
            // Define the channel that corresponds to the path_provider_foundation MethodChannel
            let pathProviderChannel = FlutterMethodChannel(name: "plugins.flutter.io/path_provider_foundation",
                                                           binaryMessenger: controller.binaryMessenger)
            
            // Listen for method calls from Dart
            pathProviderChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
              // Handle the 'initialize' method or any other methods you want to support
              if call.method == "getApplicationDocumentsDirectory" {
                // For example, respond with the application's documents directory path
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
                result(documentsPath)  // Return the directory path back to Flutter
              } else {
                result(FlutterMethodNotImplemented)  // Handle unimplemented methods
              }
            }
    }
    
    private func flutterDownloaderChannel(channelName: String){
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
            
            // Define the channel that corresponds to the Flutter MethodChannel
            let pathProviderChannel = FlutterMethodChannel(name: channelName,
                                                           binaryMessenger: controller.binaryMessenger)
            
            // Listen for method calls from Dart
            pathProviderChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
              // Check the method name from the Flutter side
              if call.method == "initialize" {
                // Handle the 'initialize' method
                print("Path provider initialized")
                result("iOS path provider initialized")  // Respond back to Dart
              } else {
                result(FlutterMethodNotImplemented)  // Handle unimplemented methods
              }
            }

    }

    private func openUnityViewController(contentCode: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if self.unityViewController == nil {
                let unityVC = UnityViewController()
                unityVC.modalPresentationStyle = .fullScreen
                unityVC.modalTransitionStyle = .crossDissolve
                self.unityViewController = unityVC
            }

            guard let unityVC = self.unityViewController else { return }

            // If Unity view is already active, update it with the new content code
            if unityVC.presentingViewController != nil {
                unityVC.receiveContentCode(contentCode)
                return
            }

            self.prepareForUnityPresentation { [weak self] in
                guard
                    let self = self,
                    let rootViewController = self.window?.rootViewController,
                    let unityViewController = self.unityViewController
                else { return }

                rootViewController.present(unityViewController, animated: true) {
                    unityViewController.receiveContentCode(contentCode)
                }
            }
        }
    }

    func callFlutterMethod(arguments: [String: Any]) {
        self.methodChannel?.invokeMethod("flutterMethod", arguments: arguments)
    }
    override func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    private func setInterfaceOrientation(_ orientation: UIInterfaceOrientation) {
        let performChange = { [weak self] in
            guard let self = self else { return }
            let mask: UIInterfaceOrientationMask = orientation.isLandscape ? .landscape : .portrait

            if #available(iOS 16.0, *), let windowScene = self.window?.windowScene {
                let preferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: mask)
                do {
                    try windowScene.requestGeometryUpdate(preferences)
                } catch {
                    print("⚠️ Failed to request geometry update: \(error)")
                }
            } else {
                UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
            }

            //self.window?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        }

        if Thread.isMainThread {
            performChange()
        } else {
            DispatchQueue.main.async(execute: performChange)
        }
    }

    private func prepareForUnityPresentation(completion: @escaping () -> Void) {
        isUnityActive = true
        setInterfaceOrientation(unityPresentationOrientation)

        // Allow UIKit a short moment to settle the orientation before presenting Unity.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: completion)
    }

    fileprivate func handleUnityDismissal() {
        isUnityActive = false
        setInterfaceOrientation(flutterDefaultOrientation)
    }
}

private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
       FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}


class UnityViewController: UIViewController, UnityFrameworkListener {

    private var unityFramework: UnityFramework?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUnity()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .landscapeRight
    }

    private func initializeUnity()
    {
       
        if unityFramework == nil {
            if let frameworkPath = Bundle.main.privateFrameworksPath?.appending("/UnityFramework.framework"),
               let bundle = Bundle(path: frameworkPath) {
                bundle.load()
                unityFramework = bundle.principalClass?.getInstance()
                unityFramework?.setDataBundleId("com.unity3d.framework")
                
                // Register the UnityFrameworkListener
                unityFramework?.register(self)
                unityFramework?.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: nil)
                
            }
        }
    }

    func receiveContentCode(_ contentCode: String) {
        print("Clicked + \(contentCode)")

        // Initialize Unity if it's not already initialized
        if unityFramework == nil
        {
            initializeUnity()
        }
        let messageDict: [String: Any] = ["contentcode": contentCode, "showlogs": true]
            
            // Convert dictionary to JSON string
            if let jsonData = try? JSONSerialization.data(withJSONObject: messageDict, options: []),
               let message = String(data: jsonData, encoding: .utf8) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    // Send the JSON string to Unity
                    self.unityFramework?.sendMessageToGO(withName: "Content Code Receiver", functionName: "ReceiveMessageFromiOS", message: message)
                }
            } else {
                print("Failed to serialize JSON message")
            }
    }

  

    func unityDidUnload(_ notification: Notification!) {
        print("✅ Unity has been unloaded.")

        if presentingViewController != nil {
            dismiss(animated: true) { [weak self] in
                self?.cleanupAfterUnity()
            }
        } else {
            cleanupAfterUnity()
        }
    }

    private func cleanupAfterUnity() {
        print("🧹 Cleaning up Unity framework")
        self.unityFramework?.unregisterFrameworkListener(self)
        self.unityFramework = nil

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        appDelegate.unityViewController = nil

        DispatchQueue.main.async {
            if let flutterVC = appDelegate.window?.rootViewController as? FlutterViewController {
                appDelegate.window?.rootViewController = flutterVC
                appDelegate.window?.makeKeyAndVisible()

                appDelegate.handleUnityDismissal()

                appDelegate.methodChannel?.invokeMethod("unityUnloaded", arguments: nil)
            }
        }
    }
    


}
