//
//  DataViewModel.swift
//  RideCellMap
//
//  Created by Ravindra Patidar on 29/06/21.
//

import Foundation

protocol DataViewModelProtocol {
    func getDataFromFile(fileName: String, completionSuccess: @escaping (_ result: [Vehicle]) -> Void, completionError: @escaping (_ errorMessage: String)->Void )
}

class DataViewModel: DataViewModelProtocol {
    
    func getDataFromFile(fileName: String, completionSuccess: @escaping (_ result: [Vehicle]) -> Void, completionError: @escaping (_ errorMessage: String)->Void ) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let decoder = JSONDecoder()
                
                if let vehicleData = try? decoder.decode([Vehicle].self, from: data) {
                    completionSuccess(vehicleData)
                } else {
                    completionError("Something went wrong")
                }
                
            } catch {
                completionError("Error while parsing the data from json")
                print("Error while parsing the data from json")
            }
        }
    }
    
    
    
    
}
