//
//  ItemDetailView.swift
//  growShop
//
//  Created by Aryan Verma on 18/03/26.
//

import SwiftUI

struct ItemDetailView: View {
    @Environment(GroceryStore.self) private var store
    var item: GroceryItem
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
            .ignoresSafeArea()
                
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    Image(
                        systemName: "apple.logo"
                    )     // replace with item.imageName
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    VStack(alignment: .listRowSeparatorLeading){
                        Text("Item Description")
                            .font(.title2.weight(.regular))
                            .foregroundStyle(Color.primary)
                        HStack(alignment: .lastTextBaseline){
                            Text(item.price, format: .currency(code: "USD"))
                                .font(.title.weight(.regular))
                                .foregroundStyle(brandGreen)
                            ZStack{
                                Text(item.price + item.price/2, format: .currency(code: "USD"))
                                    .strikethrough(true, color: .primary)
                                    .foregroundStyle(Color(UIColor.systemGray2))
                                    .font(.title3.weight(.regular))
                            }
                        }
                    }
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 25)
                }
            }
            
            VStack{
                Spacer()
                Text("Add to Cart")
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .glassEffect(
                        .regular
                            .interactive()
                            .tint(brandGreen.opacity(0.3)), in:
                                .rect(cornerRadius: 27, style: .continuous))
                    .onTapGesture {
                        store.addToCart(item: item)
                    }
                    
            }
            .labelStyle(24)
            .frame(alignment: .bottom)
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 7,
                x: 15,
                y: 25
            )
            .padding(.horizontal, 38)
        }
        .navigationTitle(item.name)
        .toolbar {
            Image(systemName: "square.and.arrow.up.fill")
        }
    }
}

#Preview {
    let store = GroceryStore()
    NavigationStack {
        ItemDetailView(item: store.allItems[2])
    }
    .environment(store)
}

