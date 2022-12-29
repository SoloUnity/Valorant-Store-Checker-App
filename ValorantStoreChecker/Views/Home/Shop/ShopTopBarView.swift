//
//  ShopTopBarView.swift
//  ValorantStoreChecker
//
//  Created by Gordon Ng on 2022-07-30.
//

import SwiftUI

struct ShopTopBarView: View {
    
    @EnvironmentObject var authAPIModel : AuthAPIModel
    @EnvironmentObject var skinModel : SkinModel
    @EnvironmentObject var updateModel : UpdateModel
    @EnvironmentObject var networkModel : NetworkModel
    @EnvironmentObject var alertModel : AlertModel
    @AppStorage("showUpdate") var showUpdate : Bool = false
    @AppStorage("autoReload") var autoReload: Bool = false
    @AppStorage("clickedReview") var clickedReview : Bool = false
    @State private var nowDate: Date = Date()
    
    let reloadType : String
    let defaults = UserDefaults.standard
    let referenceDate: Date
    
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.nowDate = Date()
        }
    }
    
    var body: some View {
        
        ZStack {
            
            HStack {
                
                // MARK: Countdown timer
                Image(systemName: "clock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                
                let countdown = countDownString(from: referenceDate, nowDate: nowDate)
                
                if countdown == "Reload" && autoReload {
                    
                    // Automatic reloading
                    Text(LocalizedStringKey("Reloading"))
                        .bold()
                        .onAppear {
                            Task {
                                
                                withAnimation(.easeIn) {
                                    authAPIModel.reloading = true
                                }
                                
                                await authAPIModel.reload(skinModel: skinModel, reloadType: reloadType)
                            }
                        }
                        .font(.caption)
                    
                }
                else if countdown == "Reload" {
                    
                    Text(LocalizedStringKey("Reload"))
                        .bold()
                        .font(.caption)
                    
                }
                else {
                    Text(countdown)
                        .bold()
                        .onAppear(perform: {
                            _ = self.timer
                        })
                        .font(.caption)
                    
                }
                
                Spacer()
                
                if reloadType != "nightMarketReload" {
                    
                    // MARK: Store refresh button
                    Button {
                                                
                        if networkModel.isConnected {
                            
                            withAnimation(.easeIn) {
                                authAPIModel.reloading = true
                            }
                            
                            Task{
                                await authAPIModel.reload(skinModel: skinModel, reloadType: reloadType)
                            }
                            
                            if !clickedReview {
                                reloadCounter(alertModel: alertModel)
                            }
                            
                        }
                        else {
                            
                            withAnimation(.easeIn) {
                                alertModel.alertNoNetwork = true
                            }
                            
                            
                        }
                        
                    } label: {

                        if authAPIModel.reloading {
                            ProgressView()
                                .frame(width: 15, height: 15)

                        }
                        else {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, 5)
        }
    }
}

// MARK: Helper function
func countDownString(from date: Date, nowDate: Date) -> String {
    let calendar = Calendar(identifier: .gregorian)
    
    let components = calendar
        .dateComponents([.day, .hour, .minute, .second],
                        from: nowDate,
                        to: date)
    
    if components.day! > 0 && (components.hour! > 0 || components.minute! > 0 || components.second! > 0) {
        return String(format: "%02d:%02d:%02d:%02d",
                      components.day ?? 00,
                      components.hour ?? 00,
                      components.minute ?? 00,
                      components.second ?? 00)
    }
    else if components.hour! > 0 || components.minute! > 0 || components.second! > 0 {
        return String(format: "%02d:%02d:%02d",
                      components.hour ?? 00,
                      components.minute ?? 00,
                      components.second ?? 00)
    }
    else {
        
        return "Reload"
        
    }
    
}

func reloadCounter(alertModel : AlertModel) {
    
    let defaults = UserDefaults.standard
    
    let reloadCount = defaults.integer(forKey: "reloadCounter")
    defaults.set(reloadCount + 1, forKey: "reloadCounter")
    
    if (reloadCount != 0) && (reloadCount % 10) == 0 {
        alertModel.alertPromptReview = true
    }
    
}


