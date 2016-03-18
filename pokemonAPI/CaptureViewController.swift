//
//  CaptureViewController.swift
//  pokemonAPI
//
//  Created by Dylan Sharkey on 3/15/16.
//  Copyright © 2016 Dylan Sharkey. All rights reserved.
//

import Alamofire
import RealmSwift
import UIKit

class CaptureViewController: UIViewController {
    
    var pokemonNum: Int?
    @IBOutlet weak var captureLabel: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        captureLabel.hidden = true
        myImage.hidden = true
    }
    
    @IBAction func captureButtonPressed(sender: UIButton) {
        //Reset view and establish it for the loading phase
        sender.setTitle("", forState: UIControlState.Disabled)
        sender.enabled = false
        captureLabel.hidden = true
        myImage.hidden = true
        
        //Build fancy activity meter thing
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        sender.addSubview(activityIndicator)
        activityIndicator.frame = sender.bounds
        activityIndicator.startAnimating()
        
        //randomize pokemon number
        pokemonNum = Int(arc4random_uniform(151)+1)
        
        let requestURL = "http://pokeapi.co/api/v2/pokemon/" + String(pokemonNum!)
        let imageURL = "http://pokeapi.co/media/sprites/pokemon/" + String(pokemonNum!) + ".png"
        
        
        /*********************************************************
        **********     Beginning of API Request Code    **********
        *********************************************************/
        //First request to get all for for the pokemon number
        Alamofire.request(.GET, requestURL).validate() .responseJSON { response in
            
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.result)   // result of response serialization
            
            //Check if error on request, if so print error and break
            guard response.result.isSuccess else {
                print("Error while fetching remote information: \(response.result.error)")
                activityIndicator.removeFromSuperview()
                sender.enabled = true
                return
            }
            
            //Second embedded request to get the image sprite for the pokemon number
            Alamofire.request(.GET, imageURL).response() {
                (res, req, data, error) in
                
                
                //Handle JSON data and get name of pokemon from first request
                var pokeName: String?
                if let JSON = response.result.value {
                    print(JSON)
                    //Make use of JSON data
                    if let info = JSON as? [String: AnyObject]{
                        pokeName = String(info["name"]!)
                    }
                }
                
                //Handle Image data from second request
                let image = UIImage(data: data!)
                self.myImage.image = image
                self.myImage.hidden = false
                
                
                //Create Pokemon Realm Object
                let pokeman = Pokemon()
                pokeman.image = UIImagePNGRepresentation(image!)
                pokeman.name = pokeName!
                
                
                //Save new pokemon object to Realm
                let realm = try! Realm()
                try! realm.write {
                    realm.add(pokeman)
                }
                
                //Update UI
                activityIndicator.removeFromSuperview()
                sender.enabled = true
                self.captureLabel.text = "You Captured a " + pokeName!
                self.captureLabel.hidden = false
                
            }
        }
    }
}
