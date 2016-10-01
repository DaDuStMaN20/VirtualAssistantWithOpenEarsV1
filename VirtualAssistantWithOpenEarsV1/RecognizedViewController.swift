//
//  RecognizedViewController.swift
//  VirtualAssistantWithOpenEarsV1
//
//  Created by Dustin Wasserman on 8/1/16.
//  Copyright © 2016 Dustin Wasserman. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RecognizedViewController: UIViewController{
    
    //MARK: Properties
    var hypothesis: [String] = []
    var recognitionScore: [String] = []
    
    var resultAfterSplit: [String] = []
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
        
        
        //MARK: Data Retrieval
        do{
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recognition")
            let results = try context.fetch(request)
            
            //if results isnt empty
            if results.count > 0{
                for item in results as! [NSManagedObject]{
                    let hypothesisResult = item.value(forKey: "hypothesis") as! String
                    let recognitionScoreResult = item.value(forKey: "recognitionScore") as! NSNumber
                    
                    hypothesis.append(hypothesisResult)
                    recognitionScore.append(String(describing: recognitionScoreResult))
                    print(hypothesisResult)
                    
                }
            }
            
            
            
        } catch {
            print("something went wrong with the retrieval of the data")
        }
        
        //MARK: String Manipulation
        
        //split the hypothesis
        //the last hypothesis in the array is the most recent one
        
        resultAfterSplit = hypothesis[hypothesis.count-1].characters.split{$0 == " "}.map(String.init)
        
        
        for i in 0 ..< resultAfterSplit.count{
            //Try the math functions without the check to isNumeric, but do it in a do catch loop. if it hits the catch block, just continue and do nothing
            //Only put a "I did not understand what you said" at the last one. 
            //Or you could do a try catch inside of the catch to see if there was a two word operation (divided by)
        }
        
        
        //add text to the results page
        //Will be modified once other methods are made. This is for testing purposes.
        resultLabel.text = "\nYou said: " + hypothesis[hypothesis.count-1]
        
        
        
        
    }
    
    //Redo orientation lock
    
    /*
    func shouldAutorotate() -> Bool {
        return false
    }
    
    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
     */
    
    //MARK: Main Functions
    
    func math(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Additional Functions
    
    func isNumeric(num: String)-> Bool{
        var result = false
        if Int(num) != nil{
            result = true
            return result
        }
        return result
    }
    

}
