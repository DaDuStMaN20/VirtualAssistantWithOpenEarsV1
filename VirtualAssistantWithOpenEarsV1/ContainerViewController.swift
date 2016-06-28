//
//  ContainerViewController.swift
//  VirtualAssistantWithOpenEarsV1
//
//  Created by Dustin Wasserman on 6/27/16.
//  Copyright © 2016 Dustin Wasserman. All rights reserved.
//

import Foundation
import UIKit

class ContainerViewController: UIViewController{
    
    //MARK: Properties
    
    @IBOutlet weak var waitLabel: UILabel!
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
        ]
        
        microphoneImageView.animationDuration = 0.5
        microphoneImageView.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
