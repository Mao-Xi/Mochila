//
//  Bundle.swift
//  Mochila
//
//  Created by Victor Zhu on 2021/2/20.
//

import Foundation

extension Bundle {

    func loadJSONFile<T: Decodable>(named name: String) -> T {
        let path = Bundle.main.path(forResource: name, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("Invalid JSON structure.")
        }
    }
}
