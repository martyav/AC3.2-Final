//
//  DataManager.swift
//  AC3.2-Final
//
//  Created by Marty Avedon on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class DataManager {
    
    static let dataManager = DataManager()
    private init() {}
    
    func getImage(fromUrl: String, completionhandler: @escaping  ((UIImage?) -> Void) ) {
        guard let url = URL(string: fromUrl) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("ERROR OCCURED WHILE GETTING IMAGE \(error!)")
            }
            
            if let validData = data {
                let validImage = UIImage(data: validData)
                completionhandler(validImage)
            }
            
            }.resume()
    }
}
