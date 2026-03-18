//
//  growShopApp.swift
//  growShop
//
//  Created by Aryan Verma on 13/03/26.
//

import SwiftUI

@main
struct growShopApp: App {
    @State private var stock = GroceryStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(stock)
        }
    }
}
