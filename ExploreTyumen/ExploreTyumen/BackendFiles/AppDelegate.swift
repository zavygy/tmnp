//
//  AppDelegate.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 14/09/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import CoreSpotlight
import MobileCoreServices
import Firebase
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    
    var currentUserLoc: CLLocationCoordinate2D?
    
    var lastPlace:PlaceModel?
    
    
    
    var placesNearby:[PlaceModel]?
    
    
    let locationManager = CLLocationManager()
    
    var tyumen = TyumenApp()
    
    
//    func hanleIncomingDynamicLink(_ dynamicLink: DynamicLink){
//        guard let url = dynamicLink.url else{
//
//            return
//        }
//
//      print("HOOORAY")
//
//    }
    
    func application(_ application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: @escaping ([AnyObject]?) -> Void) -> Bool {
        
        let viewController = window?.rootViewController as! ViewController
         viewController.restoreUserActivityState(userActivity)
        
        return true
    }
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            
        

            self.getNotificationSettings()
        }
        
        
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
//        registerForPushNotifications()
//
//        locationManager.requestAlwaysAuthorization()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.activityType = .other
//        locationManager.showsBackgroundLocationIndicator = false
//        locationManager.pausesLocationUpdatesAutomatically = false
//        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.startMonitoringSignificantLocationChanges()
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
//        registerForPushNotifications()
//
//        locationManager.requestAlwaysAuthorization()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.activityType = .other
//        locationManager.showsBackgroundLocationIndicator = false
//        locationManager.pausesLocationUpdatesAutomatically = false
//        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.startMonitoringSignificantLocationChanges()
//        self.saveContext()
    }
    
    

    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ExploreTyumen")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == CSSearchableItemActionType {
            if let uniqueIdentifier = userActivity.userInfo![CSSearchableItemActivityIdentifier]! as? String {
                if let navigationController = window?.rootViewController as? ViewController {
                    
                    navigationController.awakeDetailedPlace(id: Int(uniqueIdentifier)!)
                }
            }
        }
        
        return true
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil{

            self.tyumen.fillPlaces(escaping: {(success) in
                
                        self.currentUserLoc = manager.location!.coordinate
                        

                        self.placesNearby = self.tyumen.getPlacesNearUser(self.currentUserLoc ?? CLLocationCoordinate2D())
                        
                        if(self.lastPlace?.uniqueId != self.placesNearby?[0].uniqueId){
                                self.lastPlace = self.placesNearby?[0]
                                let uLoc = CLLocation(latitude: self.currentUserLoc?.latitude ?? 50.0, longitude: self.currentUserLoc?.longitude ?? 50.0)
                                
//                                let distance = uLoc.distance(from: CLLocation(latitude: self.lastPlace?.location?.latitude ?? 50.0, longitude: self.lastPlace?.location?.longitude ?? 50.0))
                            //this distance is for under 1000meters )))) Elino4ka - tupaya pizda
                            
                                let content = UNMutableNotificationContent()
                                
                                content.title = "\(self.lastPlace?.title ?? "")"
                                content.body = "\(self.lastPlace?.shortDescription ?? "")"
                                
                                
                                
                                content.badge = 0
                                
                                let triger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                                let request = UNNotificationRequest(identifier: "PlaceNearBy", content: content, trigger: triger)
                                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

                }
            })
            
        }
    }
    
    
    
    
}

