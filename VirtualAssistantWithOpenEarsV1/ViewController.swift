//
//  ViewController.swift
//  VirtualAssistantWithOpenEarsV1
//
//  Created by Dustin Wasserman on 6/25/16.
//  Copyright © 2016 Dustin Wasserman. All rights reserved.
//

import UIKit


class ViewController: UIViewController, OEEventsObserverDelegate {
    
    //MARK: Properties
    var lmGenerator = OELanguageModelGenerator()        //The Language Model Generator
    var words: [String] = [""]                          //The variable to store the dictionary
    var name: String = ""                               //The variable to store the name of the of the language model
    var err: NSError! = nil                             //Stores the result of a test for errors
    var lmPath: String = ""                             //The path of the language model
    var dicPath: String = ""                            //Path to the dictionary
    var openEarsEventsObserver: OEEventsObserver! = nil //The Open Ears Observer
    var didDetectSpeech: Bool = false                   //Keeps track of if speech is detected (for utterance end purposes)
    
    
    
    
    //create the model path using the pathForResource (which will get the path of the files on the device
    let modelPath: String = Bundle.main.path(forResource: "AcousticModelEnglish", ofType: "bundle")!
    
    
    @IBOutlet weak var talkButton: UIButton!
    
    
    

    override func viewDidLoad() {
        
      
        
        
        
        
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Actions
    @IBAction func talkButtonAction(_ sender: UIButton) {
        
        /*
        stopListening()
        startRecognition()
         */
        
        
    }
    
   
}

