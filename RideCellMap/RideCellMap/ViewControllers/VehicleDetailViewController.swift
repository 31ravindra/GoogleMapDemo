//
//  VehicleDetailViewController.swift
//  RideCellMap
//
//  Created by Ravindra Patidar on 29/06/21.
//

import UIKit
import GoogleMaps

class VehicleDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var viewContentInside: UIView!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var widthInsideView: NSLayoutConstraint!
    
    var slides = [SlideView]()
    var arrVehicles:[Vehicle]?
    var markerVehicle = [Int:GMSMarker]()
    let img = UIImage(named: "makerIcon")
    
    let viewModel = DataViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        getDataFromFile()
        // Do any additional setup after loading the view.
    }
    
    func getDataFromFile() {
        let fileName = "vehicles_data"
        viewModel.getDataFromFile(fileName: fileName, completionSuccess: {[weak self](vehicleData) in
            self?.arrVehicles = vehicleData
            self?.callAfterParsing()
        }, completionError: {[weak self](errorMsg) in
            DispatchQueue.main.async {
                self?.alert(message: errorMsg, title: "Error!")
            }
        })
    }
    
    func callAfterParsing() {
        slides = createSlides(count: arrVehicles?.count ?? 0)
        addMarkerInMap()
        addSlides()
    }
    
    func addMarkerInMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 11.7)
        
        mapView.camera = camera
        
        // Configure map with style.json settings
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        mapView.delegate = self
        
        // Creates markers in on the map.
        if let arrV = arrVehicles {
            for car in arrV {
                let position = CLLocationCoordinate2DMake(car.lat ?? 0.0, car.lng ?? 0.0)
                let marker = GMSMarker(position: position)
                
                // Assign each marker the licence plate of the car
                marker.title = car.license_plate_number
                let size = CGSize(width: 30, height: 35)
                if let img = img {
                    marker.icon = img.imageWithImage(scaledToSize: size)
                }
                
                // Get the approximate address of each marker
                GMSGeocoder().reverseGeocodeCoordinate(position, completionHandler: { (res, err) in
                    if let address = res?.firstResult(){
                        let lines = address.lines! as [String]
                        // Assign it to each marker
                        marker.snippet = lines.joined()
                    } else{
                        // The veicle will be in the center on the map on (0 latitude, 0 longtitude) if i didn't have longtitude and latitude
                        marker.snippet = "This vehicle is missing coordinates"
                    }
                })
                
                // Display marker on the map
                marker.map = mapView
                markerVehicle[car.id ?? 0] = marker
            }
        }
    }
    
    
    func addSlides() {
        scrollView.delegate  = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        widthInsideView.constant =  self.view.layer.bounds.width * 3
        scrollView.backgroundColor = .clear
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: self.view.layer.bounds.width * CGFloat(i), y: 0,
                                     width: self.view.layer.bounds.width, height: contentView.frame.height)
            slides[i].backgroundColor = .clear
            scrollView.addSubview(slides[i])
        }
    }
    func createSlides(count:Int) -> [SlideView] {
        var s = [SlideView]()
        for i in 0..<count {
            let slide:SlideView = Bundle.main.loadNibNamed("SlideView", owner: self, options: nil)?.first as! SlideView
            if let arr = arrVehicles {
                slide.insertAndUpdate(vehicle: arr[i])
                s.append(slide)
            }
        }
        return s
    }
    
    
}

extension VehicleDetailViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let infoView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        let lblPlate = UILabel()
        let lblLocation = UILabel()
        let verticalStack = UIStackView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        let size = CGSize(width: 40, height: 47)
        if let img = img {
            marker.icon = img.imageWithImage(scaledToSize: size)
        }
        
        // Drawing the bubble over the marker on the on click
        infoView.layer.cornerRadius = 8
        infoView.backgroundColor = .white
        infoView.alpha = 0.9
        infoView.addSubview(verticalStack)
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant:5 ).isActive = true
        verticalStack.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant:-5 ).isActive = true
        verticalStack.topAnchor.constraint(equalTo: infoView.topAnchor, constant:5 ).isActive = true
        verticalStack.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant:-5 ).isActive = true
        
        verticalStack.addSubview(lblPlate)
        lblPlate.text = marker.title
        lblPlate.font = UIFont(name: "HelveticaNeue", size: 11)
        lblPlate.translatesAutoresizingMaskIntoConstraints = false
        lblPlate.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor).isActive = true
        lblPlate.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor).isActive = true
        lblPlate.topAnchor.constraint(equalTo: verticalStack.topAnchor).isActive = true
        
        verticalStack.addSubview(lblLocation)
        lblLocation.text = marker.snippet
        lblLocation.font = UIFont(name: "HelveticaNeue-Thin", size: 11)
        lblLocation.translatesAutoresizingMaskIntoConstraints = false
        lblLocation.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor).isActive = true
        lblLocation.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor).isActive = true
        lblLocation.topAnchor.constraint(equalTo: lblPlate.bottomAnchor).isActive = true
        lblLocation.bottomAnchor.constraint(equalTo: verticalStack.bottomAnchor).isActive = true
        lblLocation.contentMode = .scaleToFill
        lblLocation.numberOfLines = 0
        
        
        return infoView
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        let size = CGSize(width: 30, height: 35)
        if let img = img {
            marker.icon = img.imageWithImage(scaledToSize: size)
        }
    }
}


extension VehicleDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        if let arrV = arrVehicles {
            print("animatedto: ", markerVehicle[arrV[Int(pageIndex)].id ?? 0]!.position)
            mapView.animate(toLocation: markerVehicle[arrV[Int(pageIndex)].id ?? 0]!.position)
        }
    }
}
