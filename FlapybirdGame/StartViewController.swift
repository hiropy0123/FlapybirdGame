//
//  StartViewController.swift
//  FlapybirdGame
//
//  Created by Hiroki Nakashima on 2018/09/18.
//  Copyright © 2018年 Hiroki Nakashima. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    var timeString = String()

    @IBOutlet var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ud = UserDefaults.standard
        
        if ud.object(forKey: "saveData") == nil {
            ud.set("0", forKey: "saveData")
        }
        
        self.timeString = ud.object(forKey: "saveData") as! String
        
        UIView.animate(withDuration: 2.0, animations: {
            self.logoImageView.frame = CGRect(x: 16, y: 143, width: 343, height: 343)
        }, completion: nil)
        
        
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
