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
import MediaPlayer

class RecognizedViewController: UIViewController{
    
    //MARK: Properties
    var hypothesis: [String] = []                                               //Stores the hypotheses from the database
    var recognitionScore: [String] = []                                         //Stores the recognition score from the database
    var resultAfterSplit: [String] = []                                         //The results after the hypothesis is split into an array of separate words
    var equation: String = ""                                                   //The expression that is to be calculated
    var expression: NSExpression!                                               //The calculated expression
    var result: Double = 0.0                                                    //the result of the expression. Is also used to carry the result of the previous expressions
    var musicPlayer = MPMusicPlayerController()                                 //Music Player from Music App

    
    
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
        
        
        //MARK: Data Retrieval
        do{
            
            var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recognition")
            var results = try context.fetch(request)
            
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
            
            request = NSFetchRequest<NSFetchRequestResult>(entityName: "Math")
            results = try context.fetch(request)
            
            //if results isnt empty
            //will only store the last result
            if results.count > 0{
                for item in results as! [NSManagedObject]{
                    result = item.value(forKey: "result") as! Double
                    
                    
                    
                    
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
        
        math()
        
        
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
    
    //MARK: Math Function
    func math(){
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate         //Database stuff
        let context: NSManagedObjectContext = appDel.persistentContainer.viewContext    //Database stuff
        
        //reset the equation
        equation = ""
        
        
        //look for math terms
        for i in 0 ..< resultAfterSplit.count{
            
            
            
            //safety check to stop null pointer exceptions.
            //look for someting before and after resultsAfterSplit[i]
            if i+1 < resultAfterSplit.count && i-1 >= 0{
                
                //Addition
                //check for operator
                if resultAfterSplit[i] == "plus" || resultAfterSplit[i] == "+" {
                    //check for numerics before and after operator
                    if isNumeric(num: resultAfterSplit[i-1]) &&
                        isNumeric(num: resultAfterSplit[i+1]) {
                        
                        //define the equation
                        equation = resultAfterSplit[i-1] + "+" + resultAfterSplit[i+1]
                        
                    }
                    
                    //check for "that" or "this" in i-1
                    if !isNumeric(num: resultAfterSplit[i-1]) &&
                        isNumeric(num: resultAfterSplit[i+1]) &&
                        resultAfterSplit[i-1] == "this" ||
                        resultAfterSplit[i-1] == "that" {
                        
                        //define the equation
                        equation = "\(result)+" + resultAfterSplit[i+1]
                        print(equation)
                    }
                    
                    //check for "that" or "this" in i+1
                    if !isNumeric(num: resultAfterSplit[i+1]) &&
                        isNumeric(num: resultAfterSplit[i-1]) &&
                        resultAfterSplit[i+1] == "this" ||
                        resultAfterSplit[i+1] == "that" {
                        
                        //define the equation
                        equation = resultAfterSplit[i-1] + "+\(result)"
                        print(equation)
                    }
                }
                
                //Subtraction
                
                //check for operator
                if resultAfterSplit[i] == "minus" || resultAfterSplit[i] == "-" {
                    //check for numerics before and after operator
                    if isNumeric(num: resultAfterSplit[i-1]) &&
                        isNumeric(num: resultAfterSplit[i+1]) {
                        
                        //define the equation
                        equation = resultAfterSplit[i-1] + "-" + resultAfterSplit[i+1]
                        
                    }
                    
                    //check for "that" or "this" in i-1
                    if !isNumeric(num: resultAfterSplit[i-1]) &&
                        isNumeric(num: resultAfterSplit[i+1]) &&
                        resultAfterSplit[i-1] == "this" ||
                        resultAfterSplit[i-1] == "that" {
                        
                        //define the equation
                        equation = "\(result)-" + resultAfterSplit[i+1]
                        print(equation)
                    }
                    
                    //check for "that" or "this" in i+1
                    if !isNumeric(num: resultAfterSplit[i+1]) &&
                        isNumeric(num: resultAfterSplit[i-1]) &&
                        resultAfterSplit[i+1] == "this" ||
                        resultAfterSplit[i+1] == "that" {
                        
                        //define the equation
                        equation = resultAfterSplit[i-1] + "-\(result)"
                        print(equation)
                    }
                }

                
                //Multiplication
                
                //check for one word operator
                if resultAfterSplit[i] == "times" || resultAfterSplit[i] == "*" {
                    //check for numerics before and after operator
                    if isNumeric(num: resultAfterSplit[i-1]) &&
                        isNumeric(num: resultAfterSplit[i+1]) {
                        
                        //define the equation
                        equation = resultAfterSplit[i-1] + "*" + resultAfterSplit[i+1]
                        
                    }
                    
                    //check for "that" or "this" in i-1
                    if !isNumeric(num: resultAfterSplit[i-1]) &&
                        isNumeric(num: resultAfterSplit[i+1]) &&
                        resultAfterSplit[i-1] == "this" ||
                        resultAfterSplit[i-1] == "that" {
                        
                        //define the equation
                        equation = "\(result)*" + resultAfterSplit[i+1]
                        print(equation)
                    }
                    
                    //check for "that" or "this" in i+1
                    if !isNumeric(num: resultAfterSplit[i+1]) &&
                        isNumeric(num: resultAfterSplit[i-1]) &&
                        resultAfterSplit[i+1] == "this" ||
                        resultAfterSplit[i+1] == "that" {
                        
                        //define the equation
                        equation = resultAfterSplit[i-1] + "*\(result)"
                        print(equation)
                    }
                }
                
                //check for two word operator
                if i+2 < resultAfterSplit.count && (resultAfterSplit[i] == "multiplied" && resultAfterSplit[i+1] == "by") {
                    //check for numerics before and after operator
                    if isNumeric(num: resultAfterSplit[i-1]) &&
                        isNumeric(num: resultAfterSplit[i+1]) {
                        
                        //define the equation
                        equation = resultAfterSplit[i-1] + "*" + resultAfterSplit[i+2]
                        
                    }
                    
                    //check for "that" or "this" in i-1
                    if !isNumeric(num: resultAfterSplit[i-1]) &&
                        isNumeric(num: resultAfterSplit[i+2]) &&
                        resultAfterSplit[i-1] == "this" ||
                        resultAfterSplit[i-1] == "that" {
                        
                        //define the equation
                        equation = "\(result)*" + resultAfterSplit[i+2]
                        print(equation)
                    }
                    
                    //check for "that" or "this" in i+1
                    if !isNumeric(num: resultAfterSplit[i+2]) &&
                        isNumeric(num: resultAfterSplit[i-1]) &&
                        resultAfterSplit[i+2] == "this" ||
                        resultAfterSplit[i+2] == "that" {
                        
                        //define the equation
                        equation = resultAfterSplit[i-1] + "*\(result)"
                        print(equation)
                    }

                }

                
                //Division
                //check for one word operator
                if resultAfterSplit[i] == "/" {
                    //check for numerics before and after operator
                    if isNumeric(num: resultAfterSplit[i-1]) &&
                        isNumeric(num: resultAfterSplit[i+1]) {
                        
                        //define the equation
                        equation = resultAfterSplit[i-1] + "/" + resultAfterSplit[i+1]
                        
                    }
                    
                    //check for "that" or "this" in i-1
                    if !isNumeric(num: resultAfterSplit[i-1]) &&
                        isNumeric(num: resultAfterSplit[i+1]) &&
                        resultAfterSplit[i-1] == "this" ||
                        resultAfterSplit[i-1] == "that" {
                        
                        //define the equation
                        equation = "\(result)/" + resultAfterSplit[i+1]
                        print(equation)
                    }
                    
                    //check for "that" or "this" in i+1
                    if !isNumeric(num: resultAfterSplit[i+1]) &&
                        isNumeric(num: resultAfterSplit[i-1]) &&
                        resultAfterSplit[i+1] == "this" ||
                        resultAfterSplit[i+1] == "that" {
                        
                        //define the equation
                        equation = resultAfterSplit[i-1] + "/\(result)"
                        print(equation)
                    }
                }
                
                //check for two word operator
                if i+2 < resultAfterSplit.count && (resultAfterSplit[i] == "divided" && resultAfterSplit[i+1] == "by") ||
                    (resultAfterSplit[i] == "out" && resultAfterSplit[i+1] == "of"){
                    //check for numerics before and after operator
                    if isNumeric(num: resultAfterSplit[i-1]) &&
                        isNumeric(num: resultAfterSplit[i+1]) {
                        
                        //define the equation
                        equation = resultAfterSplit[i-1] + "/" + resultAfterSplit[i+2]
                        
                    }
                    
                    //check for "that" or "this" in i-1
                    if !isNumeric(num: resultAfterSplit[i-1]) &&
                        isNumeric(num: resultAfterSplit[i+2]) &&
                        resultAfterSplit[i-1] == "this" ||
                        resultAfterSplit[i-1] == "that" {
                        
                        //define the equation
                        equation = "\(result)/" + resultAfterSplit[i+2]
                        print(equation)
                    }
                    
                    //check for "that" or "this" in i+1
                    if !isNumeric(num: resultAfterSplit[i+2]) &&
                        isNumeric(num: resultAfterSplit[i-1]) &&
                        resultAfterSplit[i+2] == "this" ||
                        resultAfterSplit[i+2] == "that" {
                        
                        //define the equation
                        equation = resultAfterSplit[i-1] + "/\(result)"
                        print(equation)
                    }
                    
                }

                
                
            }
            
            //Calculate the result
            if equation != "" {
                expression = NSExpression(format: equation)
                result = expression.expressionValue(with: nil, context: nil) as! Double
                resultLabel.text = "\nYour Answer is \(result)"
                
                //MARK: Write to database
                let recognition = NSEntityDescription.insertNewObject(forEntityName: "Math", into: context)
                recognition.setValue(result, forKey: "result")
                
                do{
                    try context.save()
                    
                } catch {
                    print("There was a problem saving data")
                }
            }
            
            
            
        }

    }
    
    //MARK: Music Control Function
    func music(){
        
        
        for i in 0 ..< resultAfterSplit.count{
            
            
            
            
            //pause
            //Check to see if Pause was said
            if resultAfterSplit[i] == "pause"{
                //check to see if music is playing to begin with
                if musicPlayer.playbackState == MPMusicPlaybackState.playing{
                    musicPlayer.pause()
                }
            }
                    
                
            //shuffle
            if i+3 < resultAfterSplit.count {
                if (resultAfterSplit[i] == "suffle") || (resultAfterSplit[i] == "shuffle" && resultAfterSplit[i+1] == "my" &&
                    resultAfterSplit[i+2] == "music") || (resultAfterSplit[i] == "play" && resultAfterSplit[i+1] == "my" &&
                    resultAfterSplit[i+2] == "music" && resultAfterSplit[i+3] == "shuffled"){
                    musicPlayer.shuffleMode = .songs
                    musicPlayer.play()
                }
            }
            
            
            //play
            if resultAfterSplit[i] == "play"{
                //check to see if music is playing to begin with
                if musicPlayer.playbackState == MPMusicPlaybackState.paused{
                    musicPlayer.play()
                }
            }

            //ADD RECOGNIZABLE WORDS!!!
            
            //previous
            if resultAfterSplit[i] == "previous"{
                //check to see if music is playing to begin with
                musicPlayer.skipToPreviousItem()
            }
            
            //next
            if resultAfterSplit[i] == "next"{
                //check to see if music is playing to begin with
                musicPlayer.skipToNextItem()
            }

            
            //start over
            if resultAfterSplit[i] == "beginning"{
                //check to see if music is playing to begin with
                musicPlayer.skipToBeginning()
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
