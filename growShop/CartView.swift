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
        NavigationStack {
            ZStack{
                Color.green.opacity(0.5)
                    .ignoresSafeArea(edges: .all)
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(Array(store.cart), id: \.key) { key,item in
                        List {
                            Text("\(key) = \(item)")
                                .font(.subheadline)
                        }
                    }
                }
                VStack{
                    Spacer()
                    PurchaseButton()
                }
                .padding(.horizontal, 35)
            }
            .navigationTitle(Text("Your Cart\nAren't you Forgeting Something?"))
            .toolbarRole(ToolbarRole.navigationStack)
            .toolbar {
                Image(systemName: "square.and.arrow.up.fill")
            }
        }
    }
}

struct PurchaseButton: View {
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: 200/7)
                .fill(.clear)
            HStack(alignment: .bottom){
                Text("CheckOut")
            }
            .labelStyle(26)
            .frame(alignment: .bottom)
        }
        .frame(maxWidth: .infinity,maxHeight: 61,alignment: .bottom)
        .background(
            ContainerRelativeShape()
                .fill(Color.white)
        )
        
    }
}


#Preview {
    CartView()
        .environment(GroceryStore())
}
