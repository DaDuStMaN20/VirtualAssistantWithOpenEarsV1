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
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        let appDel: AppDelegate = UIApplication.shared().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
        
        do{
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recognizion")
            let results = try context.fetch(request)
            
            if results.count > 0{
                for item in results as! [NSManagedObject]{
                    let hypothesisResult = item.value(forKey: "hypothesis")
                    let recognitionScoreResult = item.value(forKey: "recognitionScore")
                    
                    hypothesis.append(String(hypothesisResult))
                    recognitionScore.append(String(recognitionScoreResult))
                    
                }
            }
            
            
            
        } catch {
            
        }
        
        
        
        
        
        
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
