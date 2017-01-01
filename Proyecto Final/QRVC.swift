//
//  QRVC.swift
//  Proyecto Final
//
//  Created by Administrador on 30/12/16.
//  Copyright © 2016 ITESO. All rights reserved.
//

import UIKit
import AVFoundation

class QRVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var sesion : AVCaptureSession?
    var capa : AVCaptureVideoPreviewLayer?
    var marcoQR : UIView?
    var urls : String?
    
    override func viewWillAppear(_ animated: Bool) {
        //regarga la vista cada que esta aparece
        sesion?.startRunning()
        marcoQR?.frame = CGRect.zero
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Códigos QR"
        let dipositivo = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do{
            let entrada = try AVCaptureDeviceInput(device: dipositivo)
            sesion = AVCaptureSession()
            sesion?.addInput(entrada)
            let metaDatos = AVCaptureMetadataOutput()
            sesion?.addOutput(metaDatos)
            metaDatos.setMetadataObjectsDelegate(self, queue: DispatchQueue.main) //dispatch_get_main_queue()
            metaDatos.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            capa = AVCaptureVideoPreviewLayer(session: sesion!)
            capa?.videoGravity = AVLayerVideoGravityResizeAspectFill
            capa?.frame = view.layer.bounds
            view.layer.addSublayer(capa!)
            marcoQR = UIView()
            marcoQR?.layer.borderWidth = 3
            marcoQR?.layer.borderColor = UIColor.red.cgColor
            view.addSubview(marcoQR!)
            sesion?.startRunning()
            
        } catch {
            
        }
    }

    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        marcoQR?.frame = CGRect.zero
        
        if (metadataObjects == nil || metadataObjects.count == 0) {
            return
        }
        let objMetadato = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if objMetadato.type == AVMetadataObjectTypeQRCode {
            let objBordes = capa?.transformedMetadataObject(for: objMetadato as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            marcoQR?.frame = objBordes.bounds
            if objMetadato.stringValue != nil {
                self.urls = objMetadato.stringValue
                let navc = self.navigationController
                navc?.performSegue(withIdentifier: "detalleQR", sender: self)
            }
        }
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
