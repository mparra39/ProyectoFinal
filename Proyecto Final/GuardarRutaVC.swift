//
//  GuardarRutaVC.swift
//  Proyecto Final
//
//  Created by Administrador on 01/01/17.
//  Copyright © 2017 ITESO. All rights reserved.
//

import UIKit
import CoreData

class GuardarRutaVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var descripcion: UITextField!
    
    private let imagePicker = UIImagePickerController()
    
    var latitudRuta : Double!
    var longitudRuta : Double!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        self.title = "Guardar Ruta"
    }

    @IBAction func tomarFoto(_ sender: Any) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func guardarDatos(_ sender: Any) {
//        self.performSegue(withIdentifier: "regresaMapa", sender: nil)
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "RutaFavorita", in:context!)
        
        let ruta = NSManagedObject(entity: entity!, insertInto: context)
        
        ruta.setValue(self.nombre.text!, forKey: "title")
        ruta.setValue(self.descripcion.text!, forKey: "descripcion")
        ruta.setValue(self.latitudRuta, forKey: "latitud")
        ruta.setValue(self.longitudRuta, forKey: "longitud")
        
        do {
            try context?.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func backgroundTap(_ sender: UIControl){   //al dar click en cualqueir lado desaparece el teclado
        self.nombre.resignFirstResponder()
        self.descripcion.resignFirstResponder()
    }
    
    @IBAction func textFieldDoneEditing(_ sender: UITextField){   //al darle enter desaparece el teclado
        sender.resignFirstResponder() //desaparece el teclado
    }

}
