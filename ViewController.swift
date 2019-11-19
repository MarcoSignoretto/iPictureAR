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
    
    private var img_0p : UIImage!
    private var img_1p : UIImage!
    private var img_0m : UIImage!
    private var img_1m : UIImage!
    
    func captured(image: UIImage) {
        imageView.image = IPictureARWrapper.applyAR(self.img_0p, and: self.img_1p, and: self.img_0m, and: self.img_1m, frame: image)
    }
    
    
    var frameExtractor: FrameExtractor!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.frameExtractor = FrameExtractor()
        self.frameExtractor.delegate = self
        
        self.img_0p = UIImage(named: "img_0p")!
        self.img_1p = UIImage(named: "img_1p")!
        self.img_0m = UIImage(named: "img_0m")!
        self.img_1m = UIImage(named: "img_1m")!
        
        
        
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
