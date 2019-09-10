//
//  MapViewController.swift
//  TestProject
//
//  Created by alina.golubeva on 04/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    private let mapView = MKMapView()
    
    private var flightpathPolyline: MKGeodesicPolyline!
    private var planeAnnotation: MKPointAnnotation!
    private var planeAnnotationPosition = 0
    private var planeDirection: CLLocationDirection!
    private var annotationView: MKAnnotationView?
    
    private let viewModel: MapViewModelProtocol
    
    init(viewModel: MapViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        mapView.addAnnotations(viewModel.coordinates)
        mapView.showAnnotations(viewModel.coordinates, animated: true)
        
        mapView.delegate = self
        let coordinates = viewModel.coordinates.map{ $0.coordinate }
        flightpathPolyline = MKGeodesicPolyline(coordinates: coordinates,
                                                count: viewModel.coordinates.count)
        
        mapView.addOverlay(flightpathPolyline)
        
        let annotation = MKPointAnnotation()
        mapView.addAnnotation(annotation)
        self.planeAnnotation = annotation
        updatePlanePosition()
    }
    
    private func updatePlanePosition() {
        let step = viewModel.moveStep()
        
        guard planeAnnotationPosition + step < flightpathPolyline.pointCount else { return }
        let points = flightpathPolyline.points()
        let previousMapPoint = points[planeAnnotationPosition]
        planeAnnotationPosition += step
        
        let nextMapPoint = points[planeAnnotationPosition]
        planeAnnotation.coordinate = nextMapPoint.coordinate
        planeDirection = viewModel.directionBetweenPoints(sourcePoint: previousMapPoint, nextMapPoint)
        planeAnnotation.coordinate = nextMapPoint.coordinate
        annotationView?.transform = mapView.transform.rotated(by: CGFloat(viewModel.degreesToRadians(degrees: planeDirection)))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
            self.updatePlanePosition()
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.1
        renderer.strokeColor = UIColor.blue
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let planeIdentifier = "Plane"
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: planeIdentifier)
                ?? MKAnnotationView(annotation: annotation, reuseIdentifier: planeIdentifier)
            
            annotationView.image = UIImage(named: "plane")
            
            
            self.annotationView = annotationView
            return annotationView
        }
        return mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
    }
}

extension MapViewController {
    private func setupUI() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
