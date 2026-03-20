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

enum Categories: String, CaseIterable {
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
    
    func selectedCategory(cat: String?) -> [GroceryItem] {
        guard let selectedCategory = cat else {
            return allItems
        }
        return allItems.filter { $0.category == selectedCategory }
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
    
    func totalPerItem(item: GroceryItem) -> Int{
        let sum = quantity(of: item) * item.price
        return sum
    }
    
}

struct ContentView: View {
    let columns: [GridItem] = [GridItem(.flexible(), spacing: 10),
                               GridItem(.flexible(), spacing: 10)
    ]
    @Environment(GroceryStore.self) private var store
    @State private var isTapped: Bool = false
    @State var selectedCategory: String? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color(#colorLiteral(red: 0.6839458942, green: 0.7091476917, blue: 0.1566197872, alpha: 1)),Color(UIColor.systemGray6).opacity(0.5), Color(UIColor.systemGray6).opacity(0.5), Color(UIColor.systemGray6).opacity(0.5)], startPoint: .top, endPoint: .bottom)
                    
                    .ignoresSafeArea(edges: .all)
                VStack {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(
                                store.selectedCategory(cat: selectedCategory)
                            ) { item in
                                NavigationLink(
                                    destination: ItemDetailView()
                                ) {
                                    ItemCard(
                                        item: item,
                                        imageName: item.imageName,
                                        name: item.name,
                                        price: item.price
                                    )
                                }
                            }
                        }
                        .padding(.horizontal,10)
                    }
                    .scrollIndicators(.never)
                    .scrollEdgeEffectStyle(.automatic, for: .all)
                }
                    VStack {
                        FilterBar(
                            selectedCategory: $selectedCategory, filter: $isTapped
                        )
                        .contentShape(Capsule())
                        .padding(.horizontal)
                        .onTapGesture {
                            withAnimation(.spring){
                                isTapped.toggle()
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .trailing)
                
                NavigationLink(destination: CartView()) {
                    CartButton()
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottom)
            }
            .toolbar {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
            }
            .navigationTitle("Good Morning ☀️")
            .navigationSubtitle("Wanna have Something?")
        }
    }
}

struct ItemCard: View {
    @Environment(GroceryStore.self) private var store
    let item: GroceryItem
    let imageName: String
    let name: String
    let price: Int
    let brandGreen = Color(red: 0.6839, green: 0.7091, blue: 0.1566)
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 27)
                .fill(brandGreen.opacity(0.4))
            VStack {
                Image(systemName: "apple.logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200, maxHeight: 200)
                    .foregroundStyle(Color(UIColor.systemGray6))
                    .padding(.top, 10)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(name)
                        Text(price, format: .currency(code: "USD"))
                    }
                    .labelStyle(17)
                    .padding(.leading, 18)
                    
                    Spacer()
                }
                .padding(.bottom, 10)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            VStack(alignment: .trailing) {
                
                HStack{
                    Button{
                        store.removeFromCart(item: item)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 26, maxHeight: 46)
                            .foregroundStyle(Color(UIColor.label))
                    }
                    
                    Text(store.quantity(of: item), format: .number)
                        .labelStyle(20)
                        
                    Button{
                        store.addToCart(item: item)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 26, maxHeight: 46)
                            .foregroundStyle(Color(UIColor.label))
                    }
                }
            }
            .labelStyle(17)
            .padding(.trailing, 10)
        }
        .frame(maxWidth: .infinity,maxHeight: 260)
    }
}

struct FilterBar: View {
    @Binding var selectedCategory: String?
    @Environment(GroceryStore.self) private var store
    @Binding var filter: Bool
    
    var body: some View {
        ZStack{
            if !filter {
                HStack{
                    Image(systemName: "slider.horizontal.3")
                    Text("Filter")
                }
                .labelStyle(20)
                .backgroundStyle(width: 115,height: 47)
            }
            else {
                VStack{
                    Image(systemName: "xmark")
                        .labelStyle(20)
                        .backgroundStyle(width: 115,height: 47)
                            
                    Text("All")
                        .onTapGesture {
                            selectedCategory = nil
                            withAnimation(.spring) {
                                filter = false  // close filter panel after selection
                            }
                        }
                        .labelStyle(20)
                        .backgroundStyle(width: 115,height: 47)
                    ForEach(Categories.allCases, id: \.self) { category in
                        Text(category.rawValue)
                            .onTapGesture {
                                selectedCategory = category.rawValue
                                withAnimation(.spring) {
                                    filter = false  // close filter panel after selection
                                }
                            }
                            .labelStyle(20)
                            .backgroundStyle(width: 115,height: 47)
                    }
                }
            }
        }
    }
}

struct CartButton: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 200/7)
                .fill(.clear)
            HStack{
                Image(systemName: "cart.fill")
                Text("Cart")
            }
            .labelStyle(26)
        }
        .backgroundStyle(width: 134,height: 61)
    }
}

struct LabelStyle: ViewModifier {
    let size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(
                .system(
                    size: size,
                    weight: .medium,
                    design: .rounded
                )
            )
            .foregroundStyle(Color(UIColor.label))
    }
}
extension View {
    func labelStyle(_ size: CGFloat) -> some View {
        modifier(LabelStyle(size: size))
    }
}

struct BackgroundStyle: ViewModifier {
    let width: CGFloat
    let height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: width,maxHeight: height)
            .glassEffect(
                .regular
                    .interactive()
                    .tint(Color(UIColor.systemGray6).opacity(0.5)), in: .containerRelative)
            .shadow(color: Color(UIColor.systemGray3).opacity(0.4), radius: 7, x: 0, y: 5)
        
    }
}
extension View {
    func backgroundStyle(width: CGFloat, height: CGFloat) -> some View {
        modifier(BackgroundStyle(width: width, height: height))
    }
}


#Preview {
    ContentView()
        .environment(GroceryStore())
}

