//
//  HomeViewController.swift
//  Welfar eSupport Foundation
//
//  Created by administrator on 7/3/20.
//  Copyright © 2020 Rushil. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet var destinationButtons: [UIButton]!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 100000
    var pin: AnnotationPin!
    var previousLocation: CLLocation?
    let geoCoder = CLGeocoder()
    var directionsArray: [MKDirections] = []
    var currentLocation: CLLocationCoordinate2D?
   
    override func viewDidLoad() {
        checkLocationServices()
        super.viewDidLoad()

        setUpElements()
        mapView.delegate = self
    }

    @IBAction func hadleSelection(_ sender: UIButton) {
        destinationButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3) {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
            
        }
    }


    @IBAction func placeTapped(_ sender: UIButton) {
    }
    
    @IBAction func destinationTapped(_ sender: UIButton) {
    }
    func setUpElements(){
    Utilities.styleFilledButton(button: goButton)
    goButton.layer.cornerRadius = goButton.frame.size.width/2
    }
        func setUpLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
         //let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
         //mapView.setRegion(region, animated: true)
        }
    }
    func checkLocationServices(){
            if CLLocationManager.locationServicesEnabled(){
                setUpLocationManager()
                checkLocationAuthorization()
            } else{
                //show alert letting them know that they have to turn this on
            }
        }
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            centerViewOnUserLocation()
            startTrackingUserLocation()
            mapView.showsUserLocation = true
            break
        case .denied:
            //Show alert to inform them to turn it on
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //Show an alert to let them know what we are aking for
            break
        case .authorizedAlways:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
            
        }
    }
    func startTrackingUserLocation(){
    mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
        
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation{
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
        
    }
    func getDirections(){
        guard let location = locationManager.location?.coordinate else{
            //TODO: Inform user we do not have their location
            return
        }
        let request = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        directions.calculate{[unowned self] (response, error) in
            guard let response = response else {return}
            for route in response.routes{
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request{
        let destinationCoordinate = getCenterLocation(for: mapView).coordinate
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = false
        return request
    }
    
    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel()}
    }
    
    @IBAction func goButtonTapped(_ sender: Any) {
        getDirections()
    }
}
extension HomeViewController: CLLocationManagerDelegate{
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           checkLocationAuthorization()
        }
}
extension HomeViewController{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else{return}
        
        guard center.distance(from: previousLocation) > 100 else {return}
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemark, error) in
            guard let self = self else {return}
            if let _ = error{
                //TODO: Show alert informing the user
                return
            }
            guard let placemark = placemark?.first else{
                //Todo: Show alert informing the user
                return
            }
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare  ?? ""
            
            DispatchQueue.main.async{
                self.addressLabel.text = "\(streetNumber) \(streetName)"
            }
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .black
        
        return renderer
    }
           @IBAction func nonprofitButtonTapped(_ sender: Any) {
     // hospitalAnnotations()
            annotations()
            
            
    }
   // func hospitalAnnotations() {
        //let hospitalAnnotation = MKPointAnnotation()
                //hospitalAnnotation.title = "Nonprofit Hospital"
    
    func annotations(){
        
    let locations = [
        ["title": "Nonprofit Hospital", "latitude": 30.624670, "longitude": -88.177711], ["title": "Nonprofit Hospital", "latitude": 30.635250, "longitude": -87.897476],  ["title": "Nonprofit Hospital", "latitude": 32.491960, "longitude": -88.295640], ["title": "Nonprofit Hospital", "latitude": 33.440066, "longitude": -86.090865],["title": "Nonprofit Hospital", "latitude": 32.534053, "longitude": -85.912363], ["title": "Nonprofit Hospital", "latitude": 32.367105, "longitude": -86.285016],["title": "Nonprofit Hospital", "latitude": 31.291971, "longitude": -86.254516],["title": "Nonprofit Hospital", "latitude": 30.696948, "longitude": -88.080416], ["title": "Nonprofit Hospital", "latitude": 30.902162, "longitude": -87.783986],  ["title": "Nonprofit Hospital", "latitude": 32.930810, "longitude": -85.969882], ["title": "Nonprofit Hospital", "latitude": 33.252621, "longitude": -86.813098],["title": "Nonprofit Hospital", "latitude": 33.507311, "longitude": -86.788889], ["title": "Nonprofit Hospital", "latitude":  33.595728, "longitude":-86.667345],["title": "Nonprofit Hospital", "latitude": 30.519406, "longitude":  -87.889304],["title": "Nonprofit Hospital", "latitude": 33.842833, "longitude":  -87.236009],
        
        ["title": "Nonprofit Hospital", "latitude": 64.831375, "longitude": -147.740447], ["title": "Nonprofit Hospital", "latitude": 60.493421, "longitude": -151.078470],["title": "Nonprofit Hospital", "latitude": 59.000485, "longitude": -158.536513], ["title": "Nonprofit Hospital", "latitude":  59.652502, "longitude":  -151.550199], ["title": "Nonprofit Hospital", "latitude": 33.364119, "longitude":-111.939070], ["title": "Nonprofit Hospital", "latitude": 33.411239, "longitude": -111.687806], ["title": "Nonprofit Hospital", "latitude": 33.483084, "longitude": -112.257770], ["title": "Nonprofit Hospital", "latitude": 33.406083, "longitude": -110.826221], ["title": "Nonprofit Hospital", "latitude": 31.417819, "longitude": -109.883054], ["title": "Nonprofit Hospital", "latitude": 33.569384, "longitude":  -112.070926], ["title": "Nonprofit Hospital", "latitude": 34.136403, "longitude":-114.285258], ["title": "Nonprofit Hospital", "latitude": 35.035742, "longitude":  -110.692561], ["title": "Nonprofit Hospital", "latitude": 34.202792, "longitude": -110.017734], ["title": "Nonprofit Hospital", "latitude":  33.978376, "longitude": -112.739773], ["title": "Nonprofit Hospital", "latitude":34.559532, "longitude": -112.481387], ["title": "Nonprofit Hospital", "latitude":  32.682647, "longitude":  -114.635034], ["title": "Nonprofit Hospital", "latitude": 36.051649,  "longitude": -110.017734],
        
        ["title": "Nonprofit Hospital", "latitude":  33.978376, "longitude": -90.498746], ["title": "Nonprofit Hospital", "latitude":34.744257, "longitude":-92.381287], ["title": "Nonprofit Hospital", "latitude":  34.122896, "longitude":  -93.088810], ["title": "Nonprofit Hospital", "latitude":34.359114, "longitude":  -92.785769], ["title": "Nonprofit Hospital", "latitude":  36.342318,"longitude":  -92.396768], ["title": "Nonprofit Hospital", "latitude":33.610413, "longitude":-92.059368], ["title": "Nonprofit Hospital", "latitude":  35.054460,"longitude":   -93.387631],  ["title": "Nonprofit Hospital", "latitude": 34.750428, "longitude":-92.339154], ["title": "Nonprofit Hospital", "latitude": 35.085344, "longitude":  -92.457256],   ["title": "Nonprofit Hospital", "latitude": 33.873230,"longitude":  -91.480472], ["title": "Nonprofit Hospital", "latitude": 33.610750, "longitude":  -91.816628], ["title": "Nonprofit Hospital", "latitude":34.509985, "longitude":  -93.057324], ["title": "Nonprofit Hospital", "latitude": 33.618380, "longitude":  -91.392659], ["title": "Nonprofit Hospital", "latitude": 35.139812,"longitude": -93.935416 ], ["title": "Nonprofit Hospital", "latitude":  35.355496,"longitude":  -94.352871], ["title": "Nonprofit Hospital", "latitude":35.485663, "longitude": -93.833632], ["title": "Nonprofit Hospital", "latitude": 34.894524,"longitude":  -94.105893], ["title": "Nonprofit Hospital", "latitude":35.866769, "longitude": -90.636622], ["title": "Nonprofit Hospital", "latitude":33.575780,"longitude":   -92.836592], ["title": "Nonprofit Hospital", "latitude":35.836411,"longitude": -90.702653], ["title": "Nonprofit Hospital", "latitude":  35.856718,"longitude": -92.082912], ["title": "Nonprofit Hospital", "latitude":34.876549,"longitude":  -92.394612], ["title": "Nonprofit Hospital", "latitude": 36.109233, "longitude":-94.159945], ["title": "Nonprofit Hospital", "latitude": 35.251866, "longitude":-91.697162],
        
       ["title": "Nonprofit Hospital", "latitude": 35.383386, "longitude":-119.020552],["title": "Nonprofit Hospital", "latitude": 38.542145, "longitude":  -122.474658], ["title": "Nonprofit Hospital", "latitude": 38.117971, "longitude": -122.249054], ["title": "Nonprofit Hospital", "latitude": 33.848064,"longitude":  -117.933584],["title": "Nonprofit Hospital", "latitude": 37.821607,"longitude": -122.263091], ["title": "Nonprofit Hospital", "latitude": 34.014979, "longitude": -118.100924], ["title": "Nonprofit Hospital", "latitude": 36.839199, "longitude": -119.660258], ["title": "Nonprofit Hospital", "latitude": 34.833096,"longitude":  -114.617465], ["title": "Nonprofit Hospital", "latitude": 33.789520,"longitude": -118.145637], ["title": "Nonprofit Hospital", "latitude": 34.131167, "longitude": -117.320477], ["title": "Nonprofit Hospital", "latitude":36.578881,"longitude":  -121.913175], ["title": "Nonprofit Hospital", "latitude":34.274471,"longitude": -119.257895], ["title": "Nonprofit Hospital", "latitude":  36.742839, "longitude": -119.784526], ["title": "Nonprofit Hospital", "latitude": 34.132801, "longitude":-117.871392], ["title": "Nonprofit Hospital", "latitude":  39.741999,"longitude":  -121.850404], ["title": "Nonprofit Hospital", "latitude":34.397725,"longitude": -118.553864], ["title": "Nonprofit Hospital", "latitude":  33.624375, "longitude":-117.929746], ["title": "Nonprofit Hospital", "latitude": 36.842525,  "longitude": -119.780604], ["title": "Nonprofit Hospital", "latitude":  33.852009,"longitude": -117.844312], ["title": "Nonprofit Hospital", "latitude": 38.746126,"longitude": -121.249902], ["title": "Nonprofit Hospital", "latitude": 34.170624, "longitude":  -118.589956], ["title": "Nonprofit Hospital", "latitude":32.791644,"longitude":   -117.095144], ["title": "Nonprofit Hospital", "latitude":   34.072195,"longitude": -117.432030], ["title": "Nonprofit Hospital", "latitude":34.049209,"longitude": -117.214333], ["title": "Nonprofit Hospital", "latitude":   34.049428,"longitude":  -117.264059],  ["title": "Nonprofit Hospital", "latitude": 33.614740,"longitude": -117.169077], ["title": "Nonprofit Hospital", "latitude": 37.064064,"longitude":   -120.859200],   ["title": "Nonprofit Hospital", "latitude": 37.668603,"longitude":  -120.974000], ["title": "Nonprofit Hospital", "latitude": 33.609115, "longitude": -117.709204], ["title": "Nonprofit Hospital", "latitude": 37.461621,"longitude": -122.159166], ["title": "Nonprofit Hospital", "latitude": 38.670325,"longitude":  -121.145854], ["title": "Nonprofit Hospital", "latitude": 37.339907,"longitude":  -120.467319], ["title": "Nonprofit Hospital", "latitude":40.571580,"longitude": -122.395801],
       
     ["title": "Nonprofit Hospital", "latitude": 37.592346, "longitude": -122.382572],["title": "Nonprofit Hospital", "latitude": 33.561629, "longitude":   -117.664980], ["title": "Nonprofit Hospital", "latitude": 34.078754, "longitude":-117.695991], ["title": "Nonprofit Hospital", "latitude": 34.442951, "longitude":-119.264338],["title": "Nonprofit Hospital", "latitude":39.367625,"longitude":  -121.689537], ["title": "Nonprofit Hospital", "latitude":  39.506309, "longitude": -121.541212], ["title": "Nonprofit Hospital", "latitude": 33.926955, "longitude": -117.439170], ["title": "Nonprofit Hospital", "latitude":33.969479,"longitude": -118.049040], ["title": "Nonprofit Hospital", "latitude":34.077035, "longitude":-117.750659], ["title": "Nonprofit Hospital", "latitude":34.030924, "longitude": -118.479679], ["title": "Nonprofit Hospital", "latitude":34.170402,"longitude": -118.531955], ["title": "Nonprofit Hospital", "latitude": 34.430010,"longitude": -119.723186], ["title": "Nonprofit Hospital", "latitude":40.582351, "longitude": -124.136396], ["title": "Nonprofit Hospital", "latitude": 38.443731, "longitude": -122.701677], ["title": "Nonprofit Hospital", "latitude":34.160216,"longitude": -118.449408], ["title": "Nonprofit Hospital", "latitude":36.069030,"longitude":  -119.027387], ["title": "Nonprofit Hospital", "latitude":40.784079, "longitude":-124.142355], ["title": "Nonprofit Hospital", "latitude":37.970523,"longitude": -121.288322], ["title": "Nonprofit Hospital", "latitude":  34.542029,"longitude": -117.265685], ["title": "Nonprofit Hospital", "latitude":38.350508,"longitude": -120.764401], ["title": "Nonprofit Hospital", "latitude": 38.562533, "longitude":-121.770645], ["title": "Nonprofit Hospital", "latitude":37.982553,"longitude": -121.803022], ["title": "Nonprofit Hospital", "latitude":38.571228,"longitude": -121.469779], ["title": "Nonprofit Hospital", "latitude":37.744305,"longitude": -121.433966], ["title": "Nonprofit Hospital", "latitude":34.528033,"longitude": -117.293375],
     
     ["title": "Nonprofit Hospital", "latitude":38.865951, "longitude": -104.822324],["title": "Nonprofit Hospital", "latitude":  38.455160, "longitude":    -105.230838], ["title": "Nonprofit Hospital", "latitude":40.016729, "longitude":-105.235291], ["title": "Nonprofit Hospital", "latitude":40.182410,  "longitude":-105.126195],["title": "Nonprofit Hospital", "latitude":39.768181,"longitude":-105.090483], ["title": "Nonprofit Hospital", "latitude":  40.413437,"longitude": -105.051549], ["title": "Nonprofit Hospital", "latitude": 40.415930, "longitude": -104.997089], ["title": "Nonprofit Hospital", "latitude":37.173508,"longitude":  -104.487841], ["title": "Nonprofit Hospital", "latitude": 39.739501,"longitude": -104.942082], ["title": "Nonprofit Hospital", "latitude":40.414640,  "longitude":-104.709084], ["title": "Nonprofit Hospital", "latitude":39.863359, "longitude": -104.985582], ["title": "Nonprofit Hospital", "latitude": 39.548172, "longitude":-104.770764], ["title": "Nonprofit Hospital", "latitude":38.281671,"longitude": -104.612608], ["title": "Nonprofit Hospital", "latitude": 39.964367,  "longitude":-104.768329], ["title": "Nonprofit Hospital", "latitude":40.571723, "longitude": -105.056933], ["title": "Nonprofit Hospital", "latitude": 39.746270, "longitude":-104.971511], ["title": "Nonprofit Hospital", "latitude":37.472095,  "longitude":-105.882765], ["title": "Nonprofit Hospital", "latitude":37.262912,"longitude":  -105.965624], ["title": "Nonprofit Hospital", "latitude":  37.362199,"longitude":  -108.574154], ["title": "Nonprofit Hospital", "latitude":39.955297, "longitude":-104.991231], ["title": "Nonprofit Hospital", "latitude": 40.612449,"longitude": -103.220641], ["title": "Nonprofit Hospital", "latitude":39.532801,"longitude": -107.321420], ["title": "Nonprofit Hospital", "latitude":39.078333, "longitude":-108.521640],
     
     ["title": "Nonprofit Hospital", "latitude":41.189676,"longitude": -73.166156],["title": "Nonprofit Hospital", "latitude": 41.676230, "longitude":     -72.935700], ["title": "Nonprofit Hospital", "latitude":41.906333, "longitude":-71.913790], ["title": "Nonprofit Hospital", "latitude":41.404996,  "longitude":-73.445942],["title": "Nonprofit Hospital", "latitude":41.791609,"longitude": -73.133229], ["title": "Nonprofit Hospital", "latitude":  41.034426, "longitude": -73.630264], ["title": "Nonprofit Hospital", "latitude": 41.754454, "longitude":  -72.679571], ["title": "Nonprofit Hospital", "latitude":41.802869,"longitude":  -72.728710], ["title": "Nonprofit Hospital", "latitude": 41.979488, "longitude": -72.391191], ["title": "Nonprofit Hospital", "latitude":41.336563,"longitude": -72.104822], ["title": "Nonprofit Hospital", "latitude":41.781571,"longitude":  -72.525621], ["title": "Nonprofit Hospital", "latitude":41.463758,"longitude": -72.835643], ["title": "Nonprofit Hospital", "latitude":41.554550, "longitude": -72.647251], ["title": "Nonprofit Hospital", "latitude":41.549377, "longitude":-72.801298], ["title": "Nonprofit Hospital", "latitude":41.216390, "longitude":  -73.065364], ["title": "Nonprofit Hospital", "latitude": 41.740540, "longitude":-72.198442 ], ["title": "Nonprofit Hospital", "latitude":41.740540,  "longitude": -72.198442], ["title": "Nonprofit Hospital", "latitude":41.111402, "longitude": -73.422114], ["title": "Nonprofit Hospital", "latitude":  41.054915, "longitude":  -73.552308], ["title": "Nonprofit Hospital", "latitude":41.717059, "longitude":-72.225655], ["title": "Nonprofit Hospital", "latitude": 41.304466, "longitude":-72.935478],
     
     ["title": "Nonprofit Hospital", "latitude": 39.151221,"longitude": -75.523571], ["title": "Nonprofit Hospital", "latitude":38.886719, "longitude": -75.391699], ["title": "Nonprofit Hospital", "latitude":38.772597,"longitude": -75.144285], ["title": "Nonprofit Hospital", "latitude":39.686808,"longitude": -75.670839 ], ["title": "Nonprofit Hospital", "latitude":38.641768, "longitude":-75.604715], ["title": "Nonprofit Hospital", "latitude": 39.750189, "longitude":-75.566980],
     
     ["title": "Nonprofit Hospital", "latitude": 28.575152,"longitude": -81.369719], ["title": "Nonprofit Hospital", "latitude":28.070570, "longitude": -82.423124], ["title": "Nonprofit Hospital", "latitude":28.195577,"longitude":  -82.350949], ["title": "Nonprofit Hospital", "latitude":28.566573,"longitude": -81.434481], ["title": "Nonprofit Hospital", "latitude":25.969977, "longitude": -80.145414], ["title": "Nonprofit Hospital", "latitude":30.429452, "longitude": -87.231166],["title": "Nonprofit Hospital", "latitude": 25.684127,"longitude":  -80.338966], ["title": "Nonprofit Hospital", "latitude":30.315413, "longitude": -81.664542], ["title": "Nonprofit Hospital", "latitude":27.763268,"longitude": -82.642315], ["title": "Nonprofit Hospital", "latitude":26.504533,"longitude":  -80.070211], ["title": "Nonprofit Hospital", "latitude": 26.358615, "longitude":-80.102372], ["title": "Nonprofit Hospital", "latitude": 30.458710, "longitude":-85.050128],["title": "Nonprofit Hospital", "latitude": 28.359900,"longitude": -80.623131], ["title": "Nonprofit Hospital", "latitude":27.495805, "longitude": -82.495912], ["title": "Nonprofit Hospital", "latitude":27.227363,"longitude":  -81.850867], ["title": "Nonprofit Hospital", "latitude":30.120367,"longitude":  -83.593276], ["title": "Nonprofit Hospital", "latitude":29.862698, "longitude":-81.317062], ["title": "Nonprofit Hospital", "latitude": 28.087635, "longitude":-80.614374],["title": "Nonprofit Hospital", "latitude": 25.479678, "longitude":-80.430007],["title": "Nonprofit Hospital", "latitude": 26.922429,"longitude": -80.096748], ["title": "Nonprofit Hospital", "latitude":30.183567, "longitude": -82.687826], ["title": "Nonprofit Hospital", "latitude":28.060942,"longitude":  -81.954044], ["title": "Nonprofit Hospital", "latitude":25.868632,"longitude":  -80.312279], ["title": "Nonprofit Hospital", "latitude":26.615860, "longitude":-81.659440], ["title": "Nonprofit Hospital", "latitude": 28.807767, "longitude": -81.868275],
     
     ["title": "Nonprofit Hospital", "latitude": 28.836798,"longitude":-81.895357], ["title": "Nonprofit Hospital", "latitude":27.200037, "longitude":-80.242805], ["title": "Nonprofit Hospital", "latitude":28.038899,"longitude":  -82.708055], ["title": "Nonprofit Hospital", "latitude":28.013418,"longitude": -82.782758], ["title": "Nonprofit Hospital", "latitude":27.952691, "longitude":  -82.803193], ["title": "Nonprofit Hospital", "latitude":28.254205, "longitude": -82.714450],["title": "Nonprofit Hospital", "latitude": 25.812969,"longitude": -80.139878], ["title": "Nonprofit Hospital", "latitude":26.274216, "longitude": -81.788809], ["title": "Nonprofit Hospital", "latitude": 30.735288,"longitude": -86.562341], ["title": "Nonprofit Hospital", "latitude":28.200305,"longitude":   -82.323850], ["title": "Nonprofit Hospital", "latitude": 28.525469, "longitude":-81.377124], ["title": "Nonprofit Hospital", "latitude": 30.475983, "longitude":-87.212520],["title": "Nonprofit Hospital", "latitude": 30.193054,"longitude": -82.632675], ["title": "Nonprofit Hospital", "latitude":28.015497, "longitude":-82.138998], ["title": "Nonprofit Hospital", "latitude":25.701644,"longitude": -80.294319], ["title": "Nonprofit Hospital", "latitude":28.530082,"longitude": -82.484413], ["title": "Nonprofit Hospital", "latitude":30.307915, "longitude":-81.690099], ["title": "Nonprofit Hospital", "latitude": 28.335258, "longitude":-80.722782],["title": "Nonprofit Hospital", "latitude": 30.457793, "longitude":-84.260985],["title": "Nonprofit Hospital", "latitude": 27.938162,"longitude": -82.459205], ["title": "Nonprofit Hospital", "latitude":30.348417, "longitude": -81.664612], ["title": "Nonprofit Hospital", "latitude":29.640003,"longitude":  -82.343538], ["title": "Nonprofit Hospital", "latitude": 25.788650,"longitude":  -80.216181], ["title": "Nonprofit Hospital", "latitude":28.234417, "longitude":-80.708127], ["title": "Nonprofit Hospital", "latitude": 28.950255, "longitude": -81.958303],["title": "Nonprofit Hospital", "latitude": 28.028093, "longitude":  -81.725278],
        
     ["title": "Nonprofit Hospital", "latitude":34.200835,"longitude": -84.795238], ["title": "Nonprofit Hospital", "latitude":  32.847226, "longitude":-83.618735], ["title": "Nonprofit Hospital", "latitude": 33.790227, "longitude":-84.281525],["title": "Nonprofit Hospital", "latitude": 32.294742,"longitude": -84.030481], ["title": "Nonprofit Hospital", "latitude":34.789735, "longitude":-84.984977], ["title": "Nonprofit Hospital", "latitude":32.616647,"longitude":-83.631042], ["title": "Nonprofit Hospital", "latitude":31.373375,"longitude":  -84.945897], ["title": "Nonprofit Hospital", "latitude":33.452659, "longitude":-84.508166], ["title": "Nonprofit Hospital", "latitude": 33.452659, "longitude":-84.508166],["title": "Nonprofit Hospital", "latitude": 33.357279, "longitude":-84.755157],["title": "Nonprofit Hospital", "latitude":33.601341,"longitude":  -83.848118], ["title": "Nonprofit Hospital", "latitude":33.908601, "longitude": -84.349444], ["title": "Nonprofit Hospital", "latitude":33.579132,"longitude":  -84.389709], ["title": "Nonprofit Hospital", "latitude": 32.506106,"longitude":  -84.961084], ["title": "Nonprofit Hospital", "latitude":31.985429, "longitude": -81.154933], ["title": "Nonprofit Hospital", "latitude":33.947242, "longitude": -83.405220],["title": "Nonprofit Hospital", "latitude": 34.440416, "longitude":   -83.131721],
        
      ["title": "Nonprofit Hospital", "latitude":21.321775,"longitude": -157.857190], ["title": "Nonprofit Hospital", "latitude": 20.022196, "longitude":-155.664462], ["title": "Nonprofit Hospital", "latitude": 21.307887, "longitude":-157.853537],["title": "Nonprofit Hospital", "latitude": 21.498842,"longitude": -158.026246], ["title": "Nonprofit Hospital", "latitude":43.193424, "longitude":-112.346845], ["title": "Nonprofit Hospital", "latitude":42.534852,"longitude": -113.781871], ["title": "Nonprofit Hospital", "latitude":46.487094,"longitude":  -116.259781], ["title": "Nonprofit Hospital", "latitude":46.728458, "longitude":-117.000660], ["title": "Nonprofit Hospital", "latitude": 42.921007, "longitude":114.709668],["title": "Nonprofit Hospital", "latitude": 46.416612, "longitude":-117.024402],["title": "Nonprofit Hospital", "latitude":43.138690,"longitude":-115.693116], ["title": "Nonprofit Hospital", "latitude":42.590405, "longitude": 114.496261], ["title": "Nonprofit Hospital", "latitude":44.909083,"longitude":  -116.110210], ["title": "Nonprofit Hospital", "latitude":43.612547,"longitude":  -116.192447],
      
["title": "Nonprofit Hospital", "latitude": 40.153679,"longitude":89.389842], ["title": "Nonprofit Hospital", "latitude":41.681008, "longitude": -88.084202], ["title": "Nonprofit Hospital", "latitude":41.805654,"longitude":  -87.921234], ["title": "Nonprofit Hospital", "latitude":42.274626,"longitude": -87.956873], ["title": "Nonprofit Hospital", "latitude": 38.736628, "longitude":  -89.946141], ["title": "Nonprofit Hospital", "latitude":39.937183, "longitude": -91.399295],["title": "Nonprofit Hospital", "latitude":42.275507,"longitude":  -88.400888], ["title": "Nonprofit Hospital", "latitude":41.729518, "longitude":-88.269514], ["title": "Nonprofit Hospital", "latitude": 41.886569,"longitude": -88.343595], ["title": "Nonprofit Hospital", "latitude":41.760839,"longitude":-88.150139], ["title": "Nonprofit Hospital", "latitude":38.381229, "longitude":-88.375236], ["title": "Nonprofit Hospital", "latitude": 40.478733, "longitude":-88.369662],["title": "Nonprofit Hospital", "latitude": 42.295097,"longitude":-89.639122], ["title": "Nonprofit Hospital", "latitude":37.815580, "longitude": -88.442036], ["title": "Nonprofit Hospital", "latitude":40.552792,"longitude": -90.039224], ["title": "Nonprofit Hospital", "latitude":37.422287,"longitude": -88.351579], ["title": "Nonprofit Hospital", "latitude": 39.405511, "longitude":-88.807667], ["title": "Nonprofit Hospital", "latitude": 41.328785, "longitude":-89.124323],["title": "Nonprofit Hospital", "latitude": 41.607501, "longitude":-87.659537],["title": "Nonprofit Hospital", "latitude": 40.766160,"longitude":  -87.731677], ["title": "Nonprofit Hospital", "latitude":41.844413, "longitude": -89.479244], ["title": "Nonprofit Hospital", "latitude":41.961269,"longitude":  -88.723027], ["title": "Nonprofit Hospital", "latitude": 41.758897,"longitude":  -88.156482], ["title": "Nonprofit Hospital", "latitude":41.910845, "longitude":-87.843182], ["title": "Nonprofit Hospital", "latitude": 41.858231, "longitude": -87.834899],["title": "Nonprofit Hospital", "latitude": 38.025237, "longitude":  -89.236134],
        
["title": "Nonprofit Hospital", "latitude":38.549118,"longitude": -90.021916], ["title": "Nonprofit Hospital", "latitude": 40.407959, "longitude":-91.113321], ["title": "Nonprofit Hospital", "latitude":37.727723,"longitude":   -89.219781], ["title": "Nonprofit Hospital", "latitude":39.809599,"longitude": -89.656570], ["title": "Nonprofit Hospital", "latitude": 42.298469, "longitude": -89.099073], ["title": "Nonprofit Hospital", "latitude":40.700734, "longitude": -89.595316],["title": "Nonprofit Hospital", "latitude":41.369454,"longitude": -88.426428], ["title": "Nonprofit Hospital", "latitude":42.068187, "longitude":-87.992281], ["title": "Nonprofit Hospital", "latitude": 41.894699,"longitude": -87.621084], ["title": "Nonprofit Hospital", "latitude":40.922304,"longitude":-90.658360], ["title": "Nonprofit Hospital", "latitude":41.669338, "longitude":-87.812594], ["title": "Nonprofit Hospital", "latitude": 39.746349, "longitude":-90.260496],["title": "Nonprofit Hospital", "latitude": 40.563021,"longitude":89.632430], ["title": "Nonprofit Hospital", "latitude":41.120634, "longitude": -87.872126], ["title": "Nonprofit Hospital", "latitude":40.753048,"longitude":  -89.597653], ["title": "Nonprofit Hospital", "latitude":38.736500,"longitude": -88.077328], ["title": "Nonprofit Hospital", "latitude": 41.124714, "longitude":-87.881656], ["title": "Nonprofit Hospital", "latitude":42.070457, "longitude":-88.330840],["title": "Nonprofit Hospital", "latitude": 41.544449, "longitude":-87.983054],["title": "Nonprofit Hospital", "latitude": 37.773782,"longitude":  -89.324173], ["title": "Nonprofit Hospital", "latitude":41.328725, "longitude": -89.193017], ["title": "Nonprofit Hospital", "latitude":39.827502,"longitude": -88.931601], ["title": "Nonprofit Hospital", "latitude":40.117116,"longitude":-88.214864], ["title": "Nonprofit Hospital", "latitude":39.296722, "longitude":-90.412808], ["title": "Nonprofit Hospital", "latitude":38.570070, "longitude": -90.108422],

        ["title": "Nonprofit Hospital", "latitude":39.900907,"longitude": -86.040674], ["title": "Nonprofit Hospital", "latitude": 40.130521, "longitude": -85.693311], ["title": "Nonprofit Hospital", "latitude":40.447106,"longitude":-86.125206], ["title": "Nonprofit Hospital", "latitude":37.984012,"longitude":  -87.570723], ["title": "Nonprofit Hospital", "latitude": 40.762339, "longitude":  -86.362958], ["title": "Nonprofit Hospital", "latitude":40.934350, "longitude": -87.138860],["title": "Nonprofit Hospital", "latitude":41.563364,"longitude":  -85.830506], ["title": "Nonprofit Hospital", "latitude":39.485571, "longitude":-87.411035], ["title": "Nonprofit Hospital", "latitude": 39.775693,"longitude": -86.176693], ["title": "Nonprofit Hospital", "latitude":40.400445,"longitude":-86.806385], ["title": "Nonprofit Hospital", "latitude":40.196774, "longitude":-85.414560], ["title": "Nonprofit Hospital", "latitude": 38.859959, "longitude":-86.513024],["title": "Nonprofit Hospital", "latitude": 40.468016,"longitude":-85.372730], ["title": "Nonprofit Hospital", "latitude":40.269656, "longitude": -86.511261], ["title": "Nonprofit Hospital", "latitude":39.959355,"longitude": -86.159635], ["title": "Nonprofit Hospital", "latitude":39.159869,"longitude": -86.540369], ["title": "Nonprofit Hospital", "latitude":38.792460, "longitude": -85.364370], ["title": "Nonprofit Hospital", "latitude":41.610694, "longitude":-86.725130],["title": "Nonprofit Hospital", "latitude": 40.571185, "longitude":-83.129133],["title": "Nonprofit Hospital", "latitude":41.684137,"longitude":  -86.252014], ["title": "Nonprofit Hospital", "latitude":41.599627, "longitude": -87.357670], ["title": "Nonprofit Hospital", "latitude":41.372465,"longitude": -85.030371], ["title": "Nonprofit Hospital", "latitude":41.603568,"longitude": -85.839072], ["title": "Nonprofit Hospital", "latitude":41.448379, "longitude":-85.296242], ["title": "Nonprofit Hospital", "latitude":41.187730, "longitude": -85.101643],["title": "Nonprofit Hospital", "latitude": 41.489313, "longitude":-87.053383],["title": "Nonprofit Hospital", "latitude":41.463269,"longitude":  -87.363374], ["title": "Nonprofit Hospital", "latitude":39.864228, "longitude": -84.883740], ["title": "Nonprofit Hospital", "latitude":41.707066,"longitude":-86.174247], ["title": "Nonprofit Hospital", "latitude":41.635047,"longitude": -87.448672], ["title": "Nonprofit Hospital", "latitude":39.528785, "longitude":-87.111553], ["title": "Nonprofit Hospital", "latitude":37.964831, "longitude": -87.504033],["title": "Nonprofit Hospital", "latitude":39.485643, "longitude":-87.406774],
        
        ["title": "Nonprofit Hospital", "latitude":41.268656,"longitude": -95.839242], ["title": "Nonprofit Hospital", "latitude":42.496190, "longitude": -90.686119], ["title": "Nonprofit Hospital", "latitude":40.625753,"longitude":-91.384288], ["title": "Nonprofit Hospital", "latitude":41.542088,"longitude":  -90.557143], ["title": "Nonprofit Hospital", "latitude": 40.809371, "longitude": -91.173863], ["title": "Nonprofit Hospital", "latitude":42.968414, "longitude": -91.809587],["title": "Nonprofit Hospital", "latitude":41.602068,"longitude":-93.609580], ["title": "Nonprofit Hospital", "latitude":41.840143, "longitude":-90.213568], ["title": "Nonprofit Hospital", "latitude": 43.150174,"longitude": -93.216838], ["title": "Nonprofit Hospital", "latitude":41.268501,"longitude":-95.834422], ["title": "Nonprofit Hospital", "latitude":40.752711, "longitude":-95.369450], ["title": "Nonprofit Hospital", "latitude": 41.703133, "longitude": -93.051367],["title": "Nonprofit Hospital", "latitude": 42.056582,"longitude":-94.866697], ["title": "Nonprofit Hospital", "latitude":41.985402, "longitude": -91.660357], ["title": "Nonprofit Hospital", "latitude":42.519537,"longitude":-96.405832], ["title": "Nonprofit Hospital", "latitude":42.265323,"longitude": -94.750038], ["title": "Nonprofit Hospital", "latitude":41.433031, "longitude":  -91.054646], ["title": "Nonprofit Hospital", "latitude":40.407136, "longitude":-91.387303],["title": "Nonprofit Hospital", "latitude": 42.048502, "longitude": -92.906607],
        
        ["title": "Nonprofit Hospital", "latitude":39.536143,"longitude":   -95.128646], ["title": "Nonprofit Hospital", "latitude":39.565562, "longitude":  -97.673602], ["title": "Nonprofit Hospital", "latitude":39.325973,"longitude": -95.270264], ["title": "Nonprofit Hospital", "latitude":39.852113,"longitude":-95.530954], ["title": "Nonprofit Hospital", "latitude":38.024453, "longitude":-97.333186], ["title": "Nonprofit Hospital", "latitude":38.851478, "longitude":-94.825094],["title": "Nonprofit Hospital", "latitude": 39.307277, "longitude":-94.918324],["title": "Nonprofit Hospital", "latitude":38.833227,"longitude":-97.610060], ["title": "Nonprofit Hospital", "latitude": 38.466837, "longitude":-100.903738], ["title": "Nonprofit Hospital", "latitude": 37.969851,"longitude":-100.868493], ["title": "Nonprofit Hospital", "latitude":39.052364,"longitude":  -95.696156],
        
        ["title": "Nonprofit Hospital", "latitude":38.394878,"longitude": -85.376022], ["title": "Nonprofit Hospital", "latitude": 38.238020, "longitude": -85.638782], ["title": "Nonprofit Hospital", "latitude":37.730802,"longitude":-84.292420], ["title": "Nonprofit Hospital", "latitude":38.082723,"longitude": -84.497845], ["title": "Nonprofit Hospital", "latitude": 37.643980, "longitude":-84.773199], ["title": "Nonprofit Hospital", "latitude":37.861590, "longitude":-85.523822],["title": "Nonprofit Hospital", "latitude":37.277920,"longitude":  -83.228168], ["title": "Nonprofit Hospital", "latitude":37.242889, "longitude":-85.494726], ["title": "Nonprofit Hospital", "latitude": 36.861098,"longitude": -87.495815], ["title": "Nonprofit Hospital", "latitude":38.248427,"longitude":-85.749773], ["title": "Nonprofit Hospital", "latitude":38.209224, "longitude":-85.235807], ["title": "Nonprofit Hospital", "latitude": 38.471243, "longitude":-82.634332],["title": "Nonprofit Hospital", "latitude": 37.263032,"longitude":-88.228412], ["title": "Nonprofit Hospital", "latitude":37.706179, "longitude": -83.977301], ["title": "Nonprofit Hospital", "latitude":37.456688,"longitude": -82.747139], ["title": "Nonprofit Hospital", "latitude":36.606199,"longitude": -83.739980], ["title": "Nonprofit Hospital", "latitude":37.919974, "longitude": -83.265447], ["title": "Nonprofit Hospital", "latitude":38.315309, "longitude":-85.575868],["title": "Nonprofit Hospital", "latitude": 38.389898, "longitude":-82.712418],["title": "Nonprofit Hospital", "latitude":37.196271,"longitude":-87.189590], ["title": "Nonprofit Hospital", "latitude":37.779161, "longitude": -87.063882], ["title": "Nonprofit Hospital", "latitude":37.471188,"longitude": -82.522194], ["title": "Nonprofit Hospital", "latitude":37.357206,"longitude":-84.286273], ["title": "Nonprofit Hospital", "latitude":37.999443, "longitude": -84.439334], ["title": "Nonprofit Hospital", "latitude":38.076896, "longitude": -83.945224],["title": "Nonprofit Hospital", "latitude": 36.762718, "longitude": -83.707629],["title": "Nonprofit Hospital", "latitude":39.016396,"longitude":  -84.630326], ["title": "Nonprofit Hospital", "latitude":38.235554, "longitude":-85.627476], ["title": "Nonprofit Hospital", "latitude":41.707066,"longitude":-86.174247], ["title": "Nonprofit Hospital", "latitude":41.635047,"longitude": -87.448672], ["title": "Nonprofit Hospital", "latitude":36.995724, "longitude":-86.429991], ["title": "Nonprofit Hospital", "latitude": 36.866231, "longitude":-87.821752],["title": "Nonprofit Hospital", "latitude":38.249058, "longitude": -85.745357]        ]
    for location in locations{
   let annotation = MKPointAnnotation()
    annotation.title = location["title"] as? String
    annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
   mapView.addAnnotation(annotation)
       }}

}

extension HomeViewController{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil{
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        if let title = annotation.title, title == "Nonprofit Hospital"{
            annotationView?.image = UIImage(named: "HospitalPin")
            let transform = CGAffineTransform(scaleX: 0.08, y: 0.08)
            annotationView?.transform = transform
     } else if annotation === mapView.userLocation {
            annotationView?.image = UIImage(named: "UserPin")
            let transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            annotationView?.transform = transform
            mapView.showsUserLocation = true
                }
        annotationView?.canShowCallout = true
        return annotationView
}
}

