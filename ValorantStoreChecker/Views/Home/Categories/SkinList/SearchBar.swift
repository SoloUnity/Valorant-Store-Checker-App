//
//  SearchBar.swift
//  ValorantStoreChecker
//
//  Created by Gordon Ng on 2022-07-18.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    @Binding var isEditing :  Bool
 
    var body: some View {
        HStack {
 
            TextField(LocalizedStringKey("Search"), text: $text)
                .disableAutocorrection(true)
                .padding(7)
                .padding(.horizontal, 25)
                .accentColor(.pink)
                .background(Blur(radius: 25, opaque: true))
                .cornerRadius(10)
                .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white, lineWidth: 3)
                        .offset(y: -1)
                        .offset(x: -1)
                        .blendMode(.overlay)
                        .blur(radius: 0)
                        .mask {
                            RoundedRectangle(cornerRadius: 10)
                        }
                }
                .submitLabel(.search)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                 
                        if isEditing {
                            Button(action: {
                                // Dismiss keyboard
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                
                                withAnimation(.easeOut(duration: 0.15)) {
                                    self.isEditing = false
                                }

                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    withAnimation(.easeIn(duration: 0.15)) {
                        self.isEditing = true
                    }
                    
                }
                
                
            
        }
    }
}


