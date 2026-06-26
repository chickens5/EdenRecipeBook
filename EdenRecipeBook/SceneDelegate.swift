//
//  SceneDelegate.swift
//  EdenRecipeBook
//
//  Created by Gabriel Jackson on 6/24/26.
//
//This file is really important because we can "delegate" a scenes lifecycle here, which is how we display our LoadingScreen before the root view.

import UIKit

//Our SceneDelegate class confroms to UIResponder and UIWindowSceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    //Declares UIWindow or nil
    var window: UIWindow?
    
    //This method below, allows us to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //double check here
        //Since we're using a storyboard,  we auto initialize the window
        guard let windowScene = scene as? UIWindowScene else { return }
        //We manually create the app window
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        //End check

        //We load Main.storyboard once and reuse it for both the loading scene and the nav controller.
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    //Then, we can pull the LoadingScreen scene out of Main.storyboard by its storyboard ID (Our loading label and spinner is there)
        let loadingVC = mainStoryboard.instantiateViewController(withIdentifier: "LoadingScreen")

        //Shows the loading scene immediately so the user never sees a flash of black/white.
        window.rootViewController = loadingVC
        window.makeKeyAndVisible()

        //After a short delay, we swap to the navigation controller (the storyboard's initial VC).
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            //We assign mainVC to the results of our mainStoryboard calling the instantiateInitialViewController() function to return the nav controller marked "Is Initial" in Main.storyboard.
            let mainVC = mainStoryboard.instantiateInitialViewController()!
            // Cross-dissolve so the transition from loading → app feels intentional, not jarring.
            UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve) {
                window.rootViewController = mainVC
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

