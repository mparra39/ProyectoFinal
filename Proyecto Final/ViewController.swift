//
//  ViewController.swift
//  Proyecto Final
//
//  Created by Administrador on 30/12/16.
//  Copyright © 2016 ITESO. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mapaRuta: MKMapView!
    
    let manager = CLLocationManager()
    
    private let imagePicker = UIImagePickerController()
    
    private var origen : MKMapItem!
    private var destino : MKMapItem!
    private var unoMas : MKMapItem!
    private var actual : MKMapItem!
    private var puntoFavorito : MKMapItem!
    
    var lugares : Array<Any>!
    
    var tituloFavorito : String!
    var descripcionFavorito : String!
    var latitudFavorito: Double!
    var longitudFavorito : Double!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapaRuta.delegate = self
        
        self.imagePicker.delegate = self
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        var puntoCoor = CLLocationCoordinate2D(latitude: 19.359727, longitude: -99.257700)
        var puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        origen = MKMapItem(placemark: puntoLugar)
        origen.name = "Tecnológico de Monterrey"
        
        puntoCoor = CLLocationCoordinate2D(latitude: 19.362896, longitude: -99.268856)
        puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        destino = MKMapItem(placemark: puntoLugar)
        destino.name = "Centro Comercial"
        
        puntoCoor = CLLocationCoordinate2D(latitude: 19.358543, longitude: -99.276304)
        puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        unoMas = MKMapItem(placemark: puntoLugar)
        unoMas.name = "Glorieta"
        
        
        self.anotaPunto(punto: origen)
        self.anotaPunto(punto: destino)
        self.anotaPunto(punto: unoMas)
        
        self.obtenerRuta(origen: self.origen!, destino: self.destino!)
        self.obtenerRuta(origen: self.destino!, destino: self.unoMas!)
        
        longPressGesture()
        
        manager.stopUpdatingLocation()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        manager.startUpdatingLocation()
        
        if latitudFavorito != nil && longitudFavorito != nil {
            
            let puntoCoor = CLLocationCoordinate2D(latitude: latitudFavorito, longitude: longitudFavorito)
            let puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
            puntoFavorito = MKMapItem(placemark: puntoLugar)
            puntoFavorito.name = tituloFavorito
            
            //se agrega el punto favorito
            self.anotaPunto(punto: puntoFavorito)
            //agregar el obtenerRuta
//            self.obtenerRuta(origen: self.actual!, destino: self.puntoFavorito!)

        }
        
        manager.stopUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if latitudFavorito != nil && longitudFavorito != nil {
            self.obtenerRuta(origen: self.actual!, destino: self.puntoFavorito!)
        }
        
    }

    //se crea el gesto
    func longPressGesture() {
        
        let lpg = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        lpg.minimumPressDuration = 2.0
        
        self.mapaRuta.addGestureRecognizer(lpg)
    }
    
    //(_ sender: UIGestureRecognizer) es necesario para que reconozca
    func longPressAction(_ sender: UILongPressGestureRecognizer){
        
        print("presiona")
        self.mapaRuta.removeAnnotations(self.mapaRuta.annotations)
        self.mapaRuta.removeOverlays(self.mapaRuta.overlays)
        
        //donde se da el tap
        let myCGPoint = sender.location(in: mapaRuta)
        let myMapPoint = mapaRuta.convert(myCGPoint, toCoordinateFrom: mapaRuta)
        
        //crear la Annotation
        let myAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = myMapPoint
        myAnnotation.title = "Title"
        myAnnotation.subtitle = "Subtitle"
        
        mapaRuta.addAnnotation(myAnnotation)
        
        let puntoCoor = CLLocationCoordinate2D(latitude: myMapPoint.latitude, longitude: myMapPoint.longitude)
        let puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        puntoFavorito = MKMapItem(placemark: puntoLugar)
        
        //agregar el obtenerRuta
        self.obtenerRuta(origen: self.actual!, destino: self.puntoFavorito!)
        
        //guardar ruta self.performSegue(withIdentifier: "GuardarPin", sender: nil)
        
        
    }
    
    
    func anotaPunto(punto : MKMapItem){
        let anota = MKPointAnnotation()
        anota.coordinate = punto.placemark.coordinate
        anota.title = punto.name
        mapaRuta.addAnnotation(anota)
        
    }
    
    func obtenerRuta(origen : MKMapItem, destino: MKMapItem){
        let solicitud = MKDirectionsRequest()
        solicitud.source = origen
        solicitud.destination = destino
        solicitud.transportType = .automobile //forma des transporte
        let indicaciones = MKDirections(request: solicitud)
        indicaciones.calculate(completionHandler: {
            (respuesta: MKDirectionsResponse?, error: Error?) in  //cambio del NSError al Error
            if error != nil {
                print("Error al obtener la ruta")
            } else {
                self.muestraRuta(respuesta: respuesta!)
            }
        })
        
    }
    
    func muestraRuta(respuesta : MKDirectionsResponse){
        for ruta in respuesta.routes{
            mapaRuta.add(ruta.polyline, level: MKOverlayLevel.aboveRoads)
            for paso in ruta.steps {
                print(paso.instructions)
            }
        }
        let centro = origen.placemark.coordinate
        let region = MKCoordinateRegionMakeWithDistance(centro, 3000, 3000)
//        mapaRuta.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0
        return renderer
    }
    
    
    //location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region : MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapaRuta.setRegion(region, animated: true)
        
        self.mapaRuta.showsUserLocation = true
        
        //guardo la posición actual
        let puntoCoor = CLLocationCoordinate2D(latitude: myLocation.latitude, longitude: myLocation.longitude)
        let puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        actual = MKMapItem(placemark: puntoLugar)
        actual.name = "Ubicación actual"
        
    }
    
    @IBAction func guardarRuta(_ sender: Any) {
        self.performSegue(withIdentifier: "GuardarPin", sender: nil)
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "GuardandoRuta" {
            let guardarRutaController:GuardarRutaVC = segue.destination as! GuardarRutaVC
            guardarRutaController.latitudRuta = puntoFavorito.placemark.coordinate.latitude
            guardarRutaController.longitudRuta = puntoFavorito.placemark.coordinate.longitude
        }
        
     }
    

    @IBAction func tomarFoto(_ sender: Any) {
        
        let alert = UIAlertController(title: "Modo de pago", message: "Por favor elija el modo de pago", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { (action) in
            //execute some code when this option is selected
            //            self.skinType = "Dark Skin"
            print("Cámara")
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//            present(self.imagePicker, animated: true, completion: nil)

        }))
        
        alert.addAction(UIAlertAction(title: "Carrete", style: .default, handler: { (action) in
            //execute some code when this option is selected
            //            self.skinType = "Fair Skin"
            print("Carrete")
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//            present(self.imagePicker, animated: true, completion: nil)

        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //execute some code when this option is selected
            //            self.skinType = "Dark Skin"
            print("Cancel")
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    
}

