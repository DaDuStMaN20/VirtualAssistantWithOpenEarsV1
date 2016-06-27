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
    
    let modelPath: String = NSBundle.mainBundle().pathForResource("AcousticModelEnglish", ofType: "bundle")!
    
    
    @IBOutlet weak var talkButton: UIButton!
    
    
    

    override func viewDidLoad() {
        
      
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Actions
    @IBAction func talkButtonAction(sender: UIButton) {
        startRecognition()
    }
    
    
    
    func startRecognition(){
        
        self.openEarsEventsObserver = OEEventsObserver()
        self.openEarsEventsObserver.delegate = self
        
        
        
        //MARK: Language Model Creation
        
        super.viewDidLoad()
        
        //convert the dictionary file
        do{
            let dictionaryFile = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("MyCustomDictionary", ofType: "txt")!, encoding: NSUTF8StringEncoding)
            words = dictionaryFile.componentsSeparatedByString("\n")
        }
        catch let e as NSError{
            print("Something went wrong with the dictionary file: " + e.description)
        }
        
        //words = ["HELLO", "WORLD", "I", "THE DICTIONARY FILE"]
        
        name = "InitialLanguageModelFile"
        
        
        
        err = lmGenerator.generateLanguageModelFromArray(words, withFilesNamed:name, forAcousticModelAtPath: modelPath)
        
        
        
        if (err == nil) {
            lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName(name)
            dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName(name)
        } else {
            print("Error: " + err.localizedDescription)
        }
        
        
        //MARK: Speech Recognition Setup
        do{
            try OEPocketsphinxController.sharedInstance().setActive(true)
            
        } catch {
            print("Error with recogniton")
        }
        
        //MARK: Start Recognition
        
        OEPocketsphinxController.sharedInstance().startListeningWithLanguageModelAtPath(lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: modelPath, languageModelIsJSGF: false)
        
        
        
    }
    
    func stopListening(){
        OEPocketsphinxController.sharedInstance().stopListening
    }
    
    
    
    func pocketsphinxDidReceiveHypothesis(hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        print("Received Hypothesis: " + hypothesis + " with a recognition score of " + recognitionScore + " and an ID of ", utteranceID)
    }
    
    func pocketsphinxDidStartListening() {
        print("I Started to listen")
    }
    
    func pocketsphinxDidDetectSpeech() {
        print("Speech Detected")
    }
    
    func pocketsphinxDidDetectFinishedSpeech() {
        print("Utterance Concluded")
        var timer = NSTimer()
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(stopListening), userInfo: nil, repeats: false)
    }
 
    func pocketsphinxDidStopListening() {
        print("I stopped listening")
    }
    
    func pocketsphinxDidSuspendRecognition() {
        print("suspended recogniton")
    }
    
    func pocketsphinxDidResumeRecognition() {
        print("Resuming recognition")
    }
    
    func pocketsphinxDidChangeLanguageModelToFile(newLanguageModelPathAsString: String!, andDictionary newDictionaryPathAsString: String!) {
        print("Pocketsphinx is now using the following language model: " + newLanguageModelPathAsString + "\n and the following dictionary: ", newDictionaryPathAsString)
    }
    
    func pocketSphinxContinuousSetupDidFailWithReason(reasonForFailure: String!) {
        print("Listening setup wasn't successful and returned the failure reason: ", reasonForFailure)
    }
    
    func pocketSphinxContinuousTeardownDidFailWithReason(reasonForFailure: String!) {
        print("Listening teardown wasn't successful and returned the falure reason: ", reasonForFailure)
    }
    
    func pocketsphinxTestRecognitionCompleted() {
        print("A test file that was submitted for recognition is now complete")
    }

    

}

