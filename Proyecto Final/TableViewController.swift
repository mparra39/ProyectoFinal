//
//  TableViewController.swift
//  Proyecto Final
//
//  Created by Administrador on 01/01/17.
//  Copyright © 2017 ITESO. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    @IBOutlet var tablaFavoritos: UITableView!
    
    var rutasFavoritas = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tablaFavoritos.dataSource = self
        tablaFavoritos.delegate = self
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RutaFavorita")
        
        do {
            let results = try context?.fetch(fetchRequest)
            rutasFavoritas = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rutasFavoritas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CeldaTableViewCell
        
        let rutaFavorita = rutasFavoritas[indexPath.row]
        cell.titulo.text = rutaFavorita.value(forKey: "title") as? String
        cell.descripcion.text = rutaFavorita.value(forKey: "descripcion") as? String

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let detalleController:ViewController = segue.destination as! ViewController
        detalleController.tituloFavorito = rutasFavoritas[tablaFavoritos.indexPathForSelectedRow!.row].value(forKey: "title") as? String
        detalleController.descripcionFavorito = rutasFavoritas[tablaFavoritos.indexPathForSelectedRow!.row].value(forKey: "descripcion") as? String
        detalleController.latitudFavorito = rutasFavoritas[tablaFavoritos.indexPathForSelectedRow!.row].value(forKey: "latitud") as? Double
        detalleController.longitudFavorito = rutasFavoritas[tablaFavoritos.indexPathForSelectedRow!.row].value(forKey: "longitud") as? Double
        
    }
 

}
