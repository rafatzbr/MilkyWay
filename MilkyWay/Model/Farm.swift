//
//  Farm.swift
//  MilkyWay
//
//  Created by Zanetti, Rafael on 24/05/18.
//  Copyright © 2018 Zanetti, Rafael. All rights reserved.
//

import Foundation

struct Farm : Codable {
    var name: String
    var gallons: Int
    var produceHour: Date
    var address: String
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("farms").appendingPathExtension("plist")
    
    static func loadFarms() -> [Farm]? {
        guard let codedFarms = try? Data(contentsOf: ArchiveURL)
            else { return nil }
        
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Farm>.self, from: codedFarms)
    }
    
    static func saveFarms(_ farms: [Farm]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedFarms = try? propertyListEncoder.encode(farms)
        try? codedFarms?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadSampleFarms() -> [Farm] {
        let farm1 = Farm(name: "Fazenda Feliz", gallons: 10, produceHour: Date(),
                         address: "BR-116, 311 - Jardim dos Lagos, Guaíba - RS, 92500-000")
        let farm2 = Farm(name: "Fazenda Triste", gallons: 20, produceHour: Date().addingTimeInterval(200),
                         address: "Estrada Hernesto Costa Gama, 8005 - Bom Retiro, Guaíba - RS, 92500-000")
        let farm3 = Farm(name: "Fazenda Deprimida", gallons: 15, produceHour: Date().addingTimeInterval(360),
                         address: "Av. Frederico Augusto Ritter, 5518-5784 - Distrito Industrial, Cachoeirinha - RS")
        let farm4 = Farm(name: "Fazenda Eufórica", gallons: 50, produceHour: Date().addingTimeInterval(600),
                         address: "R. Tiradentes, 248 - Centro, Canoas - RS, 92010-260")
        return [farm1, farm2, farm3, farm4]
    }
    
    static let produceHourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}
