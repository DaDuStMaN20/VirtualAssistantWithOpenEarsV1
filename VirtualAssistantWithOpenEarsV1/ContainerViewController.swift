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
    
    func changeToPleaseWait(){
        textLabel.text = "Please Wait . . ."
    }
    
    func changeToListening(){
        textLabel.text = "What Can I Help You With?"
    }
    
}
