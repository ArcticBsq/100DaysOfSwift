//
//  ViewController.swift
//  Project16
//
//  Created by Илья Москалев on 19.04.2021.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "The capital of Great Britain")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over 1000 years ago")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.85, longitude: 2.3508), info: "Often called City of Light")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it")
        let washington = Capital(title: "Washington", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(chooseMapStyle))
    }
    
    @objc func chooseMapStyle() {
        let ac = UIAlertController(title: "Choose your map", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standart", style: .default, handler: { (alert: UIAlertAction!) in
            self.mapView.mapType = .standard
        }))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { (alert: UIAlertAction!) in
            self.mapView.mapType = .hybrid
        }))
        ac.addAction(UIAlertAction(title: "Hybrid fly over", style: .default, handler: { (alert: UIAlertAction!) in
            self.mapView.mapType = .hybridFlyover
        }))
        ac.addAction(UIAlertAction(title: "Muted standart", style: .default, handler: { (alert: UIAlertAction!) in
            self.mapView.mapType = .mutedStandard
        }))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { (alert: UIAlertAction!) in
            self.mapView.mapType = .satellite
        }))
        ac.addAction(UIAlertAction(title: "Satellite fly over", style: .default, handler: { (alert: UIAlertAction!) in
            self.mapView.mapType = .satelliteFlyover
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let idetifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: idetifier)
        
        if annotationView == nil {
            
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: idetifier)
            pin.canShowCallout = true
            
            annotationView = pin
            
            pin.pinTintColor = UIColor.systemTeal
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else {return}
        
        let placeName = capital.title
//        let placeInfo = capital.info
//
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
        let vc = WebViewController()
        vc.wikiWord = placeName!
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

