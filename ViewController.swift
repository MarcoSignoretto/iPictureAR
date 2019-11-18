//
//  ViewController.swift
//  iPictureAR
//
//  Created by Marco Signoretto on 18/11/2019.
//  Copyright © 2019 Marco Signoretto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FrameExtractorDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    func captured(image: UIImage) {
        imageView.image = image
    }
    
    
    var frameExtractor: FrameExtractor!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.frameExtractor = FrameExtractor()
        self.frameExtractor.delegate = self
        
        
        print("I'm here!!!!!")

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
