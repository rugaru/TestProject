//
//  MapViewController.swift
//  TestProject
//
//  Created by alina.golubeva on 04/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import UIKit
import MapKit

class Location: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

class MapViewController: UIViewController {
    private let mapView = MKMapView()
    var locations: [Location] = []

    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updatePlanePosition()
    }
    
    func updatePlanePosition() {
        
        guard let first = viewModel.coordinates.first, let second = viewModel.coordinates.last else { return }
        let step: Int = Int(CLLocation(latitude: first.coordinate.latitude, longitude: first.coordinate.longitude).distance(from: CLLocation(latitude: second.coordinate.latitude, longitude: second.coordinate.longitude)) / 1000000)
        
        guard planeAnnotationPosition + step < flightpathPolyline.pointCount
            else { return }
        
        let points = flightpathPolyline.points()
        let previousMapPoint = points[planeAnnotationPosition]
        self.planeAnnotationPosition += step
        let nextMapPoint = points[planeAnnotationPosition]
        
        self.planeAnnotation.coordinate = nextMapPoint.coordinate
        
        self.planeDirection = directionBetweenPoints(sourcePoint: previousMapPoint, nextMapPoint)
        self.planeAnnotation.coordinate = nextMapPoint.coordinate
        annotationView?.transform = mapView.transform.rotated(by: CGFloat(degreesToRadians(degrees: planeDirection)))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
            self.updatePlanePosition()
        }
    }
    
    private func directionBetweenPoints(sourcePoint: MKMapPoint, _ destinationPoint: MKMapPoint) -> CLLocationDirection {
        let x = destinationPoint.x - sourcePoint.x
        let y = destinationPoint.y - sourcePoint.y
        
        return radiansToDegrees(radians: atan2(y, x)).truncatingRemainder(dividingBy: 360)  + 90
    }
    
    private func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / .pi
    }
    
    private func degreesToRadians(degrees: Double) -> Double {
        return degrees * .pi / 180
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
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
        return mapView.dequeueReusableAnnotationView(withIdentifier: "an")
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
