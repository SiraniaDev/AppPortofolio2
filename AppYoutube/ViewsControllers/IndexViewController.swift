//
//  IndexViewController.swift
//  AppYoutube
//
//  Created by Nadia Mettioui on 20/06/2020.
//  Copyright © 2020 Nadia Mettioui. All rights reserved.
//

import UIKit
//import WMSegmentControl
import BetterSegmentedControl
import AVKit
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase


class IndexViewController: UIViewController,LoginButtonDelegate,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding, GIDSignInDelegate{
    
    
    
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var videoPlayer:AVPlayer?
    
    var videoPlayerLayer:AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//setUpVideo()
        setupElements()
        setupappleStyledControl()
        setupGoogleButton()
        setupIDAppleButton()
        setupFacebookButton()
        view.translatesAutoresizingMaskIntoConstraints = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpVideo()
    }
    func setupElements(){
        //Hide the error label
        //      errorLabel.alpha = 0
        //      // style element
        //      Utilities.styleTextField(emailTextField)
        //      Utilities.styleTextField(passwordTextField)
//        Utilities.styleFilledButton(loginButton)
//        Utilities.styleFilledButton(signUpButton)
    }
    //    override func viewWillAppear(_ animated: Bool) {
    //
    //           // Set up video in the background
    //           setUpVideo()
    //       }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC" ) as? ViewController
     self.view.window?.rootViewController = homeVC
       // self.view.window?.makeKeyAndVisible()
       // return self.view.window.ViewController()
        return self.view.window!
        //self.view.window? = ViewController
        
    }
    
   
    func setupappleStyledControl(){
        
        let appleStyledControl: BetterSegmentedControl = .appleStyled(frame: CGRect(x: 20,
                                                                                    y: 200,
                                                                                    width: view.bounds.width - 32.0,
                                                                                    height: 32.0),
                                                                      titles: ["First", "Second", "Third"])
        view.addSubview(appleStyledControl)
        appleStyledControl.setIndex(1, animated: true)
    }
    //    func indexChanged(_ sender: Any) {
    //        let index = self.appleStyledControl.selectedSegmentIndex()
    //    }
    
    
    func setUpVideo() {
        
        // Get the path to the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "ketnet", ofType: "mp4")
        
        //print (bundlePath)
        guard bundlePath != nil else  {
            return  //debugPrint("video not found")
        }
        
        // Create a URL from it
        let url = URL(fileURLWithPath: bundlePath!)
        
        // Create the video player item
        let item = AVPlayerItem(url: url)
        //print(item)
        // Create the player
        videoPlayer = AVPlayer(playerItem: item)
        //print(videoPlayer)
        // Create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        // Adjust the size and frame
        videoPlayerLayer?.frame = CGRect(
            x: -self.view.frame.size.width*1.5,
            y: 50,
            width: self.view.frame.size.width*4,
            height: self.view.frame.size.height)
        
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        // Add it to the view and play it
        videoPlayer?.playImmediately(atRate: 0.3)
    }
    
    fileprivate func setupGoogleButton(){
        
        
        
        // Add CustomGoogleBuuton
        let customGoogleButton = UIButton(type: .system)
        customGoogleButton.frame = CGRect(x: 20, y: 390, width: view.frame.width-30, height: 50)
        customGoogleButton.backgroundColor = .purple
        customGoogleButton.setTitleColor(.white, for: .normal)
        customGoogleButton.setTitle("Custom  Google Sign In ", for: .normal)
        customGoogleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        customGoogleButton.addTarget(self, action: #selector(sign), for: .touchUpInside)
        view.addSubview(customGoogleButton)
        
        
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func setupIDAppleButton() {
        let appleIDButton = ASAuthorizationAppleIDButton()
        // appleIDButton.translatesAutoresizingMaskInConstraints = false
        appleIDButton.frame = CGRect(x: 20, y: 320, width: view.frame.width-30, height: 50)
        view.addSubview(appleIDButton)
        appleIDButton.addTarget(self, action: #selector(handleAppleIDButtonPress), for: .touchUpInside)
        // self.loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    @objc
    func handleAppleIDButtonPress() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName,.email]
        
        // authorization
        
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        authAppleID()
       
    }
     func authAppleID() {
           
           let accessToken = AccessToken.current
           guard let accessTokenString = accessToken?.tokenString else {
               return
           }
       
           let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                     accessToken: accessTokenString)
           // Sign in with Firebase.
           Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error != nil) {
               // Error. If error.code == .MissingOrInvalidNonce, make sure
               // you're sending the SHA256-hashed nonce as a hex string with
               // your request to Apple.
                print(error!.localizedDescription)
               return
             }
             // User is signed in to Firebase with Apple.
             // ...
           }
       }
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        print("successfully logged with facebook")
        authFacebook()
    }
    fileprivate func setupFacebookButton() {
        let loginButton = FBLoginButton()
        //loginButton.center = view.center
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 20, y: 250, width: view.frame.width - 30, height: 28)
        // loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
       loginButton.permissions = ["email","public_profile"]
       
        
    }
    func authFacebook() {
        
        let accessToken = AccessToken.current
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        //let accessToken = AccessToken.current()
        
        Auth.auth().signIn(with: credentials,completion:  { (user, error) in
            if error != nil {
                print("something wrong with FB user", error!)
                return
            }
            print("Successfully with login FB user", user ?? "")
        })
        GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            if err != nil {
                print("Failed to start graph request", err!)
                return
            }
            print(result!)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did log out of facebook")
    }
    
    @objc func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        print("Ok google")
        GIDSignIn.sharedInstance()?.signIn() // message pour se loger via google
        if let err = error {

            print("Failed to log into Google", err)
            return
        }
        print("Succesfully logged into Google", user!)

        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
     print("okokokokokokoko")
                //This is where you should add the functionality of successful login
                //i.e. dismissing this view or push the home view controller etc
            }





            let fullName = user.profile.name

            let familyName = user.profile.familyName

            print(fullName!)
            print(familyName!)

        }


    }
    
    
}
