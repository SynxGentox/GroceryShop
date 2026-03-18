// Example usage within a View



import SwiftUI
//import UIKit
import Observation


//
//  ContentView.swift
//  growShop
//
//  Created by Aryan Verma on 13/03/26.
//

struct GroceryItem: Identifiable {
    var id: UUID = UUID()
    var name: String
    var price: Int
    var category: String
    var imageName: String
}

enum Categories: String {
    case fruits     = "Fruits"
    case veggies  = "Veggies"
    case dairy      = "Dairy"
}

@Observable
class GroceryStore {
    var allItems: [GroceryItem] = [
        GroceryItem(
            name: "Apple",
            price: 1,
            category: Categories.fruits.rawValue,
            imageName: "image 1"
        ),
        GroceryItem(
            name: "Apple",
            price: 1,
            category: Categories.fruits.rawValue,
            imageName: "image 2"
        ),
        GroceryItem(
            name: "Banana",
            price: 2,
            category: Categories.fruits.rawValue,
            imageName: "image 3"
        ),
        GroceryItem(
            name: "Banana",
            price: 2,
            category: Categories.fruits.rawValue,
            imageName: "image 4"
        ),
        GroceryItem(
            name: "Banana",
            price: 2,
            category: Categories.fruits.rawValue,
            imageName: "image 5"
        ),
        GroceryItem(
            name: "Potato",
            price: 2,
            category: Categories.veggies.rawValue,
            imageName: "image 6"
        ),
        GroceryItem(
            name: "Potato",
            price: 2,
            category: Categories.veggies.rawValue,
            imageName: "image 7"
        ),
        GroceryItem(
            name: "Potato",
            price: 2,
            category: Categories.veggies.rawValue,
            imageName: "image 8"
        ),
        GroceryItem(
            name: "Potato",
            price: 2,
            category: Categories.veggies.rawValue,
            imageName: "image 9"
        ),
        GroceryItem(
            name: "Potato",
            price: 2,
            category: Categories.veggies.rawValue,
            imageName: "image 10"
        ),
        GroceryItem(
            name: "Milk",
            price: 3,
            category: Categories.dairy.rawValue,
            imageName: "image 11"
        ),
        GroceryItem(
            name: "Milk",
            price: 3,
            category: Categories.dairy.rawValue,
            imageName: "image 12"
        ),
        GroceryItem(
            name: "Milk",
            price: 3,
            category: Categories.dairy.rawValue,
            imageName: "image 13"
        ),
        GroceryItem(
            name: "Milk",
            price: 3,
            category: Categories.dairy.rawValue,
            imageName: "image 14"
        ),
        GroceryItem(
            name: "Milk",
            price: 3,
            category: Categories.dairy.rawValue,
            imageName: "image 15"
        )
    ]

    var fruits: [GroceryItem] {
        allItems.filter { $0.category == Categories.fruits.rawValue }
    }
    var veggies: [GroceryItem] {
        allItems.filter { $0.category == Categories.veggies.rawValue }
    }
    var dairy: [GroceryItem] {
        allItems.filter { $0.category == Categories.dairy.rawValue }
    }
    
    private(set) var cart: [UUID: Int] = [:]
    private(set) var purchased: [UUID: Int] = [:]
    
    func addToCart(item: GroceryItem) {
        cart[item.id, default: 0] += 1
    }
    
    func removeFromCart(item: GroceryItem) {
        guard let qty = cart[item.id] else {return}
        if qty <= 1{
            cart.removeValue(forKey: item.id)
        } else {
            cart[item.id] = qty - 1
        }
    }
    
    func toPurchased(item: GroceryItem) {
        purchased[item.id, default: 0] += 1
    }
    
    func quantity(of item: GroceryItem) -> Int {    //to show total number of items in cart
        cart[item.id, default: 0]
    }
    
    func isInCart(_ item: GroceryItem) -> Bool {// to show if the item is in cart already or not on item view
        cart[item.id] != nil
    }
    
}

struct ContentView: View {
    let columns: [GridItem] = [GridItem(.flexible(), spacing: 10),
                               GridItem(.flexible(), spacing: 10)
    ]
    @Environment(GroceryStore.self) private var stock
    @State private var isTapped: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScrollView{
                        LazyVGrid(columns: columns) {
                            ForEach(stock.allItems) { item in
                                NavigationLink(destination: ItemDetailView()) {
                                    ItemCard(
                                        imageName: item.imageName,
                                        name: item.name,
                                        price: item.price
                                    )
                                }
                            }
                        }
                        .padding(.horizontal,10)
                    }
                    .scrollEdgeEffectStyle(.soft, for: .all)
                }
                VStack{
                    VStack {
                        if !isTapped {
                            FilterBar(filter: $isTapped)
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation(.spring){
                                        isTapped.toggle()
                                    }
                                }
                        } else {
                            FilterBar(filter: $isTapped)
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation(.spring){
                                        isTapped.toggle()
                                    }
                                }
                            ExpendedFilter(
                                emoji: "🍎",
                                category: Categories.fruits.rawValue
                            )
                                
                            ExpendedFilter(
                                emoji: "🍆",
                                category: Categories.veggies.rawValue
                            )
                            ExpendedFilter(
                                emoji: "🥛",
                                category: Categories.dairy.rawValue
                            )
                        }
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    Spacer()
                    NavigationLink(destination: CartView()) {
                        CartButton()
                            .foregroundStyle(Color(UIColor.label))
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Grocery Store").background(.green.opacity(0.5))
            
        }
    }
}

struct ItemCard: View {
    let imageName: String
    let name: String
    let price: Int
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 50)
                .fill(Color(UIColor.systemGray6))
            VStack(alignment: .leading) {
                Image(systemName: "apple.logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundStyle(.red)
                    .shadow(radius: 20,x: 10,y: 7)
                    .padding(.top, 200/7)
                Spacer()
                VStack(alignment: .leading) {
                    Text(name)
                        .font(
                            .system(
                                size: 200/9,
                                weight: .semibold,
                                design: .rounded
                            )
                        )
                    Text(price, format: .number)
                }
                .foregroundStyle(Color(UIColor.label))
                .shadow(radius: 10)
                .padding(.leading, 200/7)
                .padding(.vertical, 200/13)
            }
        }
        
        .frame(maxWidth: .infinity,maxHeight: 200*1.25)
    }
}

struct FilterBar: View {
    @Binding var filter: Bool
    var body: some View {
        ZStack{
            if !filter {
                HStack{
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color(UIColor.label))
                        .shadow(radius: 10)
                        .padding([.leading,.vertical])
                    Text("Filter")
                        .font(
                            .system(
                                size: (200*1.333)/13,
                                weight: .semibold,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(Color(UIColor.label))
                        .padding(.trailing,20)
                        .shadow(radius: 10)
                }
                .frame(width: 200/1.618,height: (200*1.333)/5)
                .glassEffect(
                    .regular.interactive().tint(Color.green.opacity(0.5))
                )
                
            }
            else {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 10)
                    .padding()
                    .frame(width: 200/1.618,height: (200*1.333)/5)
                    .glassEffect(
                        .regular.interactive().tint(Color.green.opacity(0.5))
                    )            }
        }
    }
}

struct ExpendedFilter: View {
    let emoji: String
    let category: String
    
    var body: some View {
        ZStack {
            Capsule(style: .continuous)
                .fill(.clear)
            HStack{
                Text(emoji)
                    .shadow(radius: 10)
                    .padding(.top,12)
                    .padding(.bottom,15)
                    .padding(.horizontal)
                    .foregroundStyle(Color(UIColor.label))
                    .shadow(radius: 10)
                Text(category)
                    .font(
                        .system(
                            size: (200*1.333)/13,
                            weight: .semibold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color(UIColor.label))
                    .padding(.trailing, 20)
                    .shadow(radius: 10)
            }
        }
        .frame(width: 200/1.25,height: (200*1.333)/5)
        .glassEffect(.regular.interactive().tint(Color.green.opacity(0.5)))
    }
}

struct CartButton: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 200/7)
                .fill(.clear)
            HStack{
                Image(systemName: "cart.fill")
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 10)
                    .padding(.vertical)
                    .foregroundStyle(Color(UIColor.label))

                    .padding(.leading)
                    .padding(.trailing,8)
                Text("Cart")
                    .font(
                        .system(
                            size: (200*1.333)/11,
                            weight: .semibold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color(UIColor.label))
                    .padding(.trailing,20)
                    .shadow(radius: 10)
            }
        }
        
        .frame(maxWidth: 200/1.25,maxHeight: (200*1.618)/5)
        .glassEffect(
            .clear.interactive().tint(Color.green.opacity(0.5)),
            in: .rect(cornerRadius: 200/7)
        )
    }
}


#Preview {
    ContentView()
        .environment(GroceryStore())
}

