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
    
    
    @IBAction func postLine(_ sender: Any) {
        // LINEでシェア
        shareLine()
        
    }
    
    func shareLine() {
        let urlscheme: String = "line://msg/text"
        let message = timeString
        // LINEのURLスキーム "line://msg/text/メッセージ"
        let urlstring = urlscheme + "/" + message
        
        // URLエンコード
        guard let encodedURL = urlstring.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            return
        }
        
        // URL作成
        guard let url = URL(string: encodedURL) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (succes) in
                    // LINEアプリ表示成功
                    
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // LINEアプリがない場合
            let alertController = UIAlertController(title: "エラーが発生しました", message: "LINEアプリがインストールさせれていません", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK?", style: UIAlertActionStyle.default))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        
        self.navigationController?.pushViewController(gameVC, animated: true)
        
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
