//
//  CartView.swift
//  growShop
//
//  Created by Aryan Verma on 18/03/26.
//

import SwiftUI

struct CartView: View {
    @Environment(GroceryStore.self) private var store
    let brandGreen = Color(red: 0.6839, green: 0.7091, blue: 0.1566)
    
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [
                    brandGreen,
                    Color(UIColor.systemGray6).opacity(0.3),
                    Color(UIColor.systemGray6).opacity(0.3),
                    Color(UIColor.systemGray6).opacity(0.3)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .all)
            ScrollView {
                VStack{
                    if !store.cart.isEmpty {
                        ForEach (
                            store.allItems.filter{ store.isInCart($0)
                            } )  { item in
                                ListItemCard(
                                    item: item,
                                    name: item.name,
                                    price: item.price,
                                    quantity: store.quantity(of: item),
                                    imageName: item.imageName
                                )
                            }
                    } else {
                        Text("Nothing's Here  ):")
                            .labelStyle(36)
                            .padding(.top, 250)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            VStack {
                Spacer()
                PurchaseButton()
                    .foregroundStyle(Color(UIColor.label))
            }
        }
        .navigationTitle(Text("Your Cart"))
        .navigationSubtitle("Aren't you Forgeting Something?")
        .toolbar {
            Image(systemName: "square.and.arrow.up.fill")
        }
    }
}

struct PurchaseButton: View {
    let brandGreen = Color(red: 0.6839, green: 0.7091, blue: 0.1566)
    var body: some View {
        ZStack{
            Capsule()
                .fill(.clear)
            Text("Check Out")
                .labelStyle(26)
        }
        .frame(maxWidth: .infinity, maxHeight: 61)
        .glassEffect(
            .regular
                .interactive()
                .tint(brandGreen.opacity(0.7)), in: .capsule)
        .shadow(
            color: Color(UIColor.systemGray4).opacity(0.7),
            radius: 7,
            x: 15,
            y: 25
        )
        //        .shadow(Color(UIColor.systemBackground) == Color.black ??  Color(UIColor.systemGray4).opacity(0.7), radius: 7, x: 15, y: 25 : .opacity(0) )
        .padding(.horizontal, 38)
    }
}

struct ListItemCard: View {
    @Environment(GroceryStore.self) private var store
    let item: GroceryItem
    let name: String
    let price: Int
    let quantity: Int
    let imageName: String
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color(UIColor.systemGray4).opacity(0.3))
                .frame(maxWidth: .infinity, maxHeight: 200)
                
            HStack{
                Image(systemName: "apple.logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 88, maxHeight: 88, alignment: .leading)
                    .foregroundStyle(.black)
                    .background(.white)
                VStack(alignment: .leading) {
                    Text(name)
                        .labelStyle(23)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: 53,
                            alignment: .topLeading
                        )
                        .padding(.top, 3)
                    Text("In Stock")
                        .labelStyle(17)
                    HStack{
                        Text("Quality")
                        Image(systemName: "checkmark.seal.fill")
                    }
                    .labelStyle(13)
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 130)
        
        .overlay(alignment: .bottomTrailing) {
            VStack(alignment: .trailing) {
                Spacer()
                Text(
                    store.totalPerItem(item: item),
                    format: .currency(code: "USD")
                )
                    
                Spacer()
                HStack{
                    Button{
                        store.removeFromCart(item: item)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 30, maxHeight: 44)
                            .foregroundStyle(Color(UIColor.label))
                    }
                    .padding(.trailing, 7)
                    
                    Text(store.quantity(of: item), format: .number)
                        
                    Button{
                        store.addToCart(item: item)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 30, maxHeight: 44)
                            .foregroundStyle(Color(UIColor.label))
                    }
                    .padding(.leading, 7)
                }
            }
            .labelStyle(20)
            .padding(.trailing, 10)
        }
    }
}

#Preview {
    let store = GroceryStore()
    store.addToCart(item: store.allItems[0])
    store.addToCart(item: store.allItems[1])
    return NavigationStack {  // ← only for preview
        CartView()
    }
    .environment(store)
}
