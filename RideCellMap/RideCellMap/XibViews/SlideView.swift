//
//  SlideView.swift
//  RideCellMap
//
//  Created by Ravindra Patidar on 29/06/21.
//

import UIKit

class SlideView: UIView {
    
    @IBOutlet weak var lblAvailability: UILabel!
    
    @IBOutlet weak var lblMilageRemaining: UILabel!
    
    @IBOutlet weak var lblVehicleType: UILabel!
    
    @IBOutlet weak var lblPlate: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var btnResCar: UIButton!
    
    private var vehicle = Vehicle()
    
    @IBAction func btnResCarClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Successful Reservation",
                                      message: "You have reserve the \(vehicle.vehicle_type ?? "") sucessfuly",
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func insertAndUpdate(vehicle: Vehicle){
        self.insert(vehicle: vehicle)
        self.updateView(withInfoOf: vehicle)
    }
    
    func insert(vehicle: Vehicle){
        self.vehicle = vehicle
    }
    
    func updateView(withInfoOf v : Vehicle) {
        
        do {
            let iconUrl =  try Data(contentsOf: URL(string:  v.vehicle_pic_absolute_url ?? "")!)
            self.imgView.image = UIImage(data: iconUrl)
        }catch{
            print("error parsing image")
        }
        lblAvailability.text = v.is_available ?? false ? "Available" : "Not Avaialbe"
        lblAvailability.textColor = v.is_available ?? false ?  UIColor(hex: "#2ba527") : UIColor(hex: "#a01919")
        lblMilageRemaining.text = "\(v.remaining_mileage ?? 0)"
        lblVehicleType.text = v.vehicle_make
        lblPlate.text = v.license_plate_number
        self.btnResCar.layer.cornerRadius = 8
        btnResCarClicked(v)
    }
    
}
