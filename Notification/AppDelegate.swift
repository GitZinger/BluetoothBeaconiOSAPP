//
// Please report any problems with this app template to contact@estimote.com
//

import UIKit
import UserNotifications

import EstimoteProximitySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var proximityObserver: ProximityObserver!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            print("notifications permission granted = \(granted), error = \(error?.localizedDescription ?? "(none)")")
        }

  
        let estimoteCloudCredentials = CloudCredentials(appID: "3notification-8il", appToken: "fa4c977e1c373a117478191261e06b6a")

        proximityObserver = ProximityObserver(credentials: estimoteCloudCredentials, onError: { error in
            print("ProximityObserver error: \(error)")
        })

        let zone = ProximityZone(tag: "3notification-8il", range: ProximityRange.near)
        zone.onEnter = { context in
            let content = UNMutableNotificationContent()
            // _ = UNNotificationAttachment()
            content.title = "Special Offer"
            content.body = "You got an exclusive offer"
            content.sound = UNNotificationSound.default
            let request = UNNotificationRequest(identifier: "enter", content: content, trigger: nil)
            notificationCenter.add(request, withCompletionHandler: nil)
        }
        zone.onExit = { context in
            let content = UNMutableNotificationContent()
            content.title = "Bye bye"
            content.body = "welcome back dear customer"
            content.sound = UNNotificationSound.default
            let request = UNNotificationRequest(identifier: "exit", content: content, trigger: nil)
            notificationCenter.add(request, withCompletionHandler: nil)
        }

        proximityObserver.startObserving([zone])

        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    // Needs to be implemented to receive notifications both in foreground and background
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([UNNotificationPresentationOptions.alert, UNNotificationPresentationOptions.sound])
    }
}
