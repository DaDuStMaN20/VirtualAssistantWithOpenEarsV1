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
    var hypothesis: [String] = []           //Stores the hypotheses from the database
    var recognitionScore: [String] = []     //Stores the recognition score from the database
    var resultAfterSplit: [String] = []     //The results after the hypothesis is split into an array of separate words
    var expression: String = ""             //The expression that is to be calculated
    var result: Double = 0.0                //the result of the expression. Is also used to carry the result of the previous expressions
    
    
    
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
        
        //Trims and converts string to lowercase
        for i in 0 ..< resultAfterSplit.count{
            resultAfterSplit[i] = resultAfterSplit[i].trimmingCharacters(in: .whitespaces)
            resultAfterSplit[i] = resultAfterSplit[i].lowercased()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Main Functions
    
    func math(){
        //look for math terms
        for i in 0 ..< resultAfterSplit.count{
            
            //MARK Math Functions
            //safety check to stop null pointer exceptions.
            //look for someting before and after resultsAfterSplit[i]
            if i+1 < resultAfterSplit.count && i-1 >= 0{
                
                //Addition
                
                
                //Subtraction
                
                //Multiplication
                
                //Division
                
            }
            
            
        }

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
