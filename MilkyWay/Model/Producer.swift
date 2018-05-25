//
//  Farm.swift
//  MilkyWay
//
//  Created by Zanetti, Rafael on 24/05/18.
//  Copyright © 2018 Zanetti, Rafael. All rights reserved.
//

import Foundation

struct Producer : Codable {
    var name: String
    var address: String
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("producer").appendingPathExtension("plist")
    
    static func loadProducer() -> Producer? {
        guard let codedProducer = try? Data(contentsOf: ArchiveURL)
            else { return nil }
        
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Producer.self, from: codedProducer)
    }
    
    static func saveProducer(_ producer: Producer) {
        let propertyListEncoder = PropertyListEncoder()
        let codedProducer = try? propertyListEncoder.encode(producer)
        try? codedProducer?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadSampleProducer() -> Producer {
        let producer = Producer(name: "Leite com Cloro Ltda.", address: "BR-116, 311 - Jardim dos Lagos, Guaíba - RS, 92500-000")
        
        return producer
    }
}
