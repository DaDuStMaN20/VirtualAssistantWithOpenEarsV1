//
//  ContainerViewController.swift
//  VirtualAssistantWithOpenEarsV1
//
//  Created by Dustin Wasserman on 6/27/16.
//  Copyright © 2016 Dustin Wasserman. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ContainerViewController: UIViewController, OEEventsObserverDelegate {
    
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
    
    var hypothesisData = ""                                 //hypothesis from recognition
    var recognitionScoreData = 0                            //recognition score (the closer to 0 the more accurate
    var correct = false
    
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var microphoneImageView: UIImageView!
    
    
    override func viewDidLoad(){
        
        
        microphoneImageView.animationImages = [
            
            UIImage(named: "microphone.png")!,
            UIImage(named: "microphone_1.png")!,
            UIImage(named: "microphone_2.png")!,
            UIImage(named: "microphone_3.png")!,
            UIImage(named: "microphone_4.png")!,
            UIImage(named: "microphone_5.png")!,
            UIImage(named: "microphone_6.png")!,
            UIImage(named: "microphone_7.png")!,
            UIImage(named: "microphone_8.png")!,
            UIImage(named: "microphone_7.png")!,
            UIImage(named: "microphone_6.png")!,
            UIImage(named: "microphone_5.png")!,
            UIImage(named: "microphone_4.png")!,
            UIImage(named: "microphone_3.png")!,
            UIImage(named: "microphone_2.png")!,
            UIImage(named: "microphone_1.png")!,
            UIImage(named: "microphone.png")!,
        ]
        
        microphoneImageView.animationDuration = 0.6
        microphoneImageView.startAnimating()
        
        //start recognition
        startRecognition()
        changeToListening()
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeToPleaseWait(){
        textLabel.text = "Please Wait . . ."
    }
    
    func changeToListening(){
        textLabel.text = "How Can I HelP?"
    }
    
    //MARK: Recognition Start and Stop Functions
    
    func startRecognition(){
        
        self.openEarsEventsObserver = OEEventsObserver()
        self.openEarsEventsObserver.delegate = self
        
        
        
        //MARK: Language Model Creation
        
        super.viewDidLoad()
        
        //convert the dictionary file
        do{
            let dictionaryFile = try String(contentsOfFile: Bundle.main.path(forResource: "MyCustomDictionary", ofType: "txt")!, encoding: String.Encoding.utf8)
            words = dictionaryFile.components(separatedBy: "\n")
        }
        catch let e as NSError{
            print("Something went wrong with the dictionary file: " + e.description)
        }
        
        //words = ["HELLO", "WORLD", "I", "THE DICTIONARY FILE"]
        
        name = "InitialLanguageModelFile"
        
        
        
        err = lmGenerator.generateLanguageModel(from: words, withFilesNamed:name, forAcousticModelAtPath: modelPath) as NSError!
        
        
        
        if (err == nil) {
            lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModel(withRequestedName: name)
            dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionary(withRequestedName: name)
        } else {
            print("Error: " + err.localizedDescription)
        }
        
        
        //MARK: Speech Recognition Setup
        do{
            try OEPocketsphinxController.sharedInstance().setActive(true)
            
        } catch {
            print("Error with recogniton")
        }
        
        OEPocketsphinxController.sharedInstance().secondsOfSilenceToDetect = 1.1
        
        
        //MARK: Start Recognition
        
        OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: modelPath, languageModelIsJSGF: false)
        
        
        
    }
    
    func stopListening(){
        
        if correct{
            _ = OEPocketsphinxController.sharedInstance().stopListening
            
            let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
            
            //put data in the database
            let recognition = NSEntityDescription.insertNewObject(forEntityName: "Recognition", into: context)
            recognition.setValue(hypothesisData, forKey: "hypothesis")
            recognition.setValue(recognitionScoreData, forKey: "recognitionScore")
            
            do{
                try context.save()
                
            } catch {
                print("There was a problem saving data")
            }
            
            
            //go to the results page
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Recognized") as UIViewController
            self.present(nextViewController, animated:true, completion:nil)
            
        }

        
         //OEPocketsphinxController.sharedInstance().suspendRecognition()
        //_ = OEPocketsphinxController.sharedInstance().stopListening
        
        
    }
    
    
    //MARK: Observer Functions
    
    func pocketsphinxDidReceiveHypothesis(_ hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        print("Received Hypothesis: " + hypothesis + " with a recognition score of " + recognitionScore + " and an ID of ", utteranceID)
        
        hypothesisData = hypothesis
        recognitionScoreData = Int(recognitionScore)!
        
        OEPocketsphinxController.sharedInstance().suspendRecognition()
        
    
        
        
    }
    
    func pocketsphinxDidStartListening() {
        print("I Started to listen")
        
        
    }
    
    func pocketsphinxDidDetectSpeech() {
        print("Speech Detected")
        didDetectSpeech = true
    }
    
    func pocketsphinxDidDetectFinishedSpeech() {
        
        
        print("Utterance Concluded")
  
        
        /* TIMER CODE (NOT NECESSARY, BUT MAY BE USEFUL
         var timer = NSTimer()
         timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(stopListening), userInfo: nil, repeats: false)*/
    }
    
    func pocketsphinxDidStopListening() {
        print("I stopped listening")
        
    }
    
    func pocketsphinxDidSuspendRecognition() {
        print("suspended recogniton")
        
        
        
        //check to see if the word was recognized even remotely accurately.
        //I may need to change this value and fine tune it
        if recognitionScoreData < -100000 {
            let refreshAlert = UIAlertController(title: "Accurate", message: "Did you say " + hypothesisData, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                print("was accurate")
                self.correct = true
                self.stopListening()
                
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                print("was not accurate")
                OEPocketsphinxController.sharedInstance().resumeRecognition()
                self.correct = false
            }))
            
            self.present(refreshAlert, animated: true, completion: nil)
            
            
        } else {
            correct = true
            self.stopListening()
            
        }
        
        
        
        
    }
    
    func pocketsphinxDidResumeRecognition() {
        print("Resuming recognition")
    }
    
    func pocketsphinxDidChangeLanguageModelToFile(newLanguageModelPathAsString: String!, andDictionary newDictionaryPathAsString: String!) {
        print("Pocketsphinx is now using the following language model: " + newLanguageModelPathAsString + "\n and the following dictionary: ", newDictionaryPathAsString)
    }
    
    func pocketSphinxContinuousTeardownDidFail(withReason reasonForFailure: String!) {
        print("Listening setup wasn't successful and returned the failure reason: ", reasonForFailure)
    }
    
    func pocketSphinxContinuousTeardownDidFailWithReason(reasonForFailure: String!) {
        print("Listening teardown wasn't successful and returned the falure reason: ", reasonForFailure)
    }
    
    func pocketsphinxTestRecognitionCompleted() {
        print("A test file that was submitted for recognition is now complete")
    }

    
}
