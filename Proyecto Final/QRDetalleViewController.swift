//
//  QRDetalleViewController.swift
//  Proyecto Final
//
//  Created by Administrador on 30/12/16.
//  Copyright © 2016 ITESO. All rights reserved.
//

import UIKit

class QRDetalleViewController: UIViewController {
    
    @IBOutlet weak var direccion: UILabel!
    @IBOutlet weak var vistaWeb: UIWebView!
    
    var urls : String?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        direccion.text = urls!
        let url = URL(string: urls!)
        let peticion = NSURLRequest(url: url!)
        vistaWeb.loadRequest(peticion as URLRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
