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
    var expression: String = ""
    var result: Double = 0.0
    
    
    
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
        //look for math terms
        for i in 0 ..< resultAfterSplit.count{
            
            //MARK Math Functions
            //safety check to stop null pointer exceptions.
            //look for someting before and after resultsAfterSplit[i]
            if resultAfterSplit[i+1] != nil && resultAfterSplit[i-1] != nil{
                
                //Addition
                
                //Subtraction
                
                //Multiplication
                
                //Division
                
            }
            
            
        }

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
