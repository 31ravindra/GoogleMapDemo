//
//  Vehicle.swift
//  RideCellMap
//
//  Created by Ravindra Patidar on 29/06/21.
//

import Foundation

struct Vehicle: Codable {
    var id : Int?
    var is_active: Bool?
    var is_available: Bool?
    var lat: Double?
    var license_plate_number : String?
    var lng : Double?
    var pool : String?
    var remaining_mileage :Int?
    var remaining_range_in_meters : Int?
    var transmission_mode : String?
    var vehicle_make : String?
    var vehicle_pic :String?
    var vehicle_pic_absolute_url : String?
    var vehicle_type : String?
    var vehicle_type_id : Int?
}

