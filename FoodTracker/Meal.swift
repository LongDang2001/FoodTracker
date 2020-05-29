//
//  Meal.swift
//  FoodTracker
//
//  Created by admin on 3/16/20.
//  Copyright © 2020 Long. All rights reserved.
//

import UIKit
// Ghi Nhật kí khi thay đổi cell
import os.log
class Meal: NSObject, NSCoding {
    
    // MARK: properties
    var photo: UIImage?
    var name: String
    var rating: Int
    
    // To implement a coding key structure
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    // MARK: Init
    init?(name: String, photo: UIImage?, rating: Int) {
        
        // the name must not empty
        guard !name.isEmpty else {
            return nil
        }
        
        // the rating must be 0 and 5 inclusively
        guard (rating >= 0 && rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties
            self.name = name
            self.photo = photo
            self.rating = rating
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(photo, forKey: PropertyKey.photo)
        coder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = coder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = coder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)
    }
    //MARK: Archiving Paths, Đường dẫn lưu trữ
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
}
