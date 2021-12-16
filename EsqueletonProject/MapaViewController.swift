//
//  MapaViewController.swift
//  EsqueletonProject
//
//  Created by Mac18 on 13/12/21.
//

import UIKit
import MapKit
import CoreLocation

class MapaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var latitude: CLLocationDegrees?
    var direccion: String?
    @IBOutlet weak var mapMK: MKMapView!
    var longitude: CLLocationDegrees?
    
    private let locationManager = CLLocationManager()
    var altitude: Double?
    
    var manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        mapMK.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        //mejorar la precision de la ubicacion
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //    con este metodo se ira actualizando la ubicacion del usuario
        manager.startUpdatingLocation()
        mapMK.mapType = .standard
       // Do any additional setup after loading the view.
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
 
    
  
    @IBAction func UbicacionBtn(_ sender: Any) {
        ubi()
        let location = CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0)
        
        let spanMap = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let region = MKCoordinateRegion(center: location, span: spanMap)
        
        mapMK.setRegion(region, animated: true)
        
        mapMK.showsUserLocation = true
    }
  
   
    
   
    private func ubi(){
        let direction: String? = direccion
        let geocoder = CLGeocoder()
        
        if let direction = direction{
            geocoder.geocodeAddressString(direction) { (places: [CLPlacemark]?, error: Error?) in
                
                guard let destinationRoute = places?.first?.location else {
                    return
                }
                
                if error == nil {
                    let place = places?.first
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = (place?.location?.coordinate)!
                    annotation.title = direction
                    
                    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    
                    let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
                    
                    self.mapMK.setRegion(region, animated: true)
                    
                    self.mapMK.addAnnotation(annotation)
                    
                    self.mapMK.selectAnnotation(annotation, animated: true)
                    let overlays = self.mapMK.overlays

                    let annotations = self.mapMK.annotations
                    
                    	
                    self.mapMK.removeOverlays(overlays)
                    self.mapMK.removeAnnotations(annotations)
                    self.makeRoute(destinationCoordinates: destinationRoute.coordinate)
                    
                } else {
                    print("Error al encontrar la dirección: \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    func makeRoute(destinationCoordinates: CLLocationCoordinate2D) {
        guard let originCoordinates = manager.location?.coordinate else {
            return
        }
        //crear un lugar de origen destino
        let originPlaceMark = MKPlacemark(coordinate: originCoordinates)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationCoordinates)
        //crear un obj mapkit item
        let originItem = MKMapItem(placemark: originPlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        //solicitud de ruta
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = originItem
        destinationRequest.destination = destinationItem
        //aqui nos trazara la ruta dependiendo de como va a viajar, en este caso lo definimos como automobile
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let secureResponse = response else {
                if let error = error {
                    print("Error al calcular la ruta \(error.localizedDescription)")
                }
                return
            }
            
            let route = secureResponse.routes[0]
    
            self.mapMK.addOverlay(route.polyline)
            self.mapMK.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
     
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        altitude = location.altitude
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("se obtuvo la ubicacion del usuario")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("hubo error al obtener la ubicacion")
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

 
