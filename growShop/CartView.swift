//
//  CartView.swift
//  growShop
//
//  Created by Aryan Verma on 18/03/26.
//

import SwiftUI

struct CartView: View {
    @Environment(GroceryStore.self) private var store
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [
                    brandGreen.opacity(0.6),
                    Color(UIColor.systemBackground),
                    Color(UIColor.systemBackground),
                    Color(UIColor.systemBackground)
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
                        Text("Nothing's Here  :(")
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
    @Environment(GroceryStore.self) private var store
    @State private var isPresented: Bool = false
    
    var body: some View {
        ZStack{
            if !store.cart.isEmpty {
                VStack{
                    Spacer()
                    ConcentricRectangle(corners: .concentric, isUniform: true)
                        .fill(Color(UIColor.systemGray6))
                        .shadow(
                            color: .black.opacity(0.1),
                            radius: 7,
                            x: 0,
                            y: -7
                        )
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .overlay(alignment: .topLeading) {
                            HStack{
                                VStack(alignment: .listRowSeparatorLeading){
                                    Text("Address:")
                                        .labelStyle(20)
                                    Text("House No. 3, ABC Colony, ABC City ")
                                        .labelStyle(17)
                                }
                                .frame(
                                    maxWidth: .infinity,
                                    maxHeight: 65,
                                    alignment: .topLeading
                                )
                                .padding(.leading, 37)
                                Spacer()
                                VStack(alignment: .listRowSeparatorTrailing){
                                    Text("Cart Total")
                                    Text(
                                        store.cartTotal,
                                        format: .currency(code: "USD")
                                    )
                                    .foregroundStyle(.primary)
                                }
                                .labelStyle(20)
                                .padding(.trailing, 37)
                                .padding(.leading, 17)
                            }
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: 80,
                                alignment: .top
                            )
                            .padding(.top, 26)
                        }
                }
            } else {
                
                VStack{
                    Spacer()
                    RoundedRectangle(cornerRadius: 60, style: .continuous)
                        .fill(Color(UIColor.systemGray6))
                        .shadow(
                            color: .black.opacity(0.1),
                            radius: 7,
                            x: 0,
                            y: -7
                        )
                        .frame(maxWidth: .infinity, maxHeight: 134)
                }
            }
            
            VStack{
                Spacer()
                Text(!store.cart.isEmpty ? "Check Out" : ":(")
                    
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .glassEffect(
                        .clear
                            .interactive().tint(brandGreen.opacity(0.4)))
                    
            }
            .labelStyle(26)
            .frame(alignment: .bottom)
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 7,
                x: 15,
                y: 25
            )
            .padding(.bottom, 34)
            .padding(.horizontal, 38)
            .onTapGesture {
                isPresented.toggle()
            }
            .alert("Order Placed",isPresented: $isPresented) {
            } message: {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.green)
            }
        }
        .ignoresSafeArea()
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
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color(UIColor.systemGray6))
                .frame(maxWidth: .infinity, maxHeight: 200)
                .shadow(color: .black.opacity(0.1), radius: 7)
            HStack{
                Image(systemName: "apple.logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 88, maxHeight: 88, alignment: .leading)
                    .foregroundStyle(brandGreen.opacity(0.6))
                    .padding(.leading, 14)
                    .padding(.vertical, 7)
                VStack(alignment: .leading) {
                    Text(name)
                        .labelStyle(20)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: 53,
                            alignment: .topLeading
                        )
                        .padding(.top, 7)
                    Text("In Stock")
                        .labelStyle(17)
                    HStack{
                        Text("Quality")
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Color(UIColor.label))
                    }
                    .labelStyle(13)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 7)
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
                            .foregroundStyle(Color.primary)
                    }
                    .padding(.trailing, 7)
                    
                    Text(store.quantity(of: item), format: .number)
                        .labelStyle(17)
                    
                    Button{
                        store.addToCart(item: item)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 30, maxHeight: 44)
                            .foregroundStyle(Color.primary)
                    }
                    .padding(.leading, 7)
                }
            }
            .labelStyle(20)
            .padding(.trailing, 14)
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
