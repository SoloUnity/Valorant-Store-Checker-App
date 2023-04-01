//
//  VideoView.swift
//  ValorantStoreChecker
//
//  Created by Gordon on 2022-12-22.
//

import SwiftUI
import AZVideoPlayer
import AVKit

struct VideoView: View {
    
    @EnvironmentObject var skinModel:SkinModel
    @ObservedObject var skin:Skin
    @AppStorage("autoPlay") var autoPlay = true

    @State var noVideo = false
    @Binding var selectedLevel : Int
    @Binding var selectedChroma : Int
    @State private var player = AVPlayer()
    
    var body: some View {
        
        ZStack {
            
            AZVideoPlayer(player: player)
                .cornerRadius(10)
                .onAppear{
                    
                    let url  = skin.levels![selectedLevel].streamedVideo
                    if player.currentItem == nil && (url != nil) {
                        
                        self.noVideo = false
                        let item = AVPlayerItem(url: URL(string: url!)!)
                        player.replaceCurrentItem(with: item)
                        
                    }
                    else if url == nil {
                        self.noVideo = true
                    }
                    
                    if autoPlay {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            player.play() // Autoplay
                        })
                    }
                }
                .onChange(of: selectedLevel) { level in
                    
                    let url  = skin.levels![selectedLevel].streamedVideo
                    if url == nil {
                        self.noVideo = true
                        player.replaceCurrentItem(with: nil)
                    }
                    else {
                        self.noVideo = false
                        let item = AVPlayerItem(url: URL(string: url!)!)
                        player.replaceCurrentItem(with: item)
                    }
                    
                    if autoPlay {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            player.play() // Autoplay
                        })
                    }
                    
                }
                .onChange(of: selectedChroma) { chroma in
                                        
                    if selectedChroma != 0 {
                        
                        let url = skin.chromas![selectedChroma].streamedVideo
                        
                        if url != nil{
                            self.noVideo = false
                            let item = AVPlayerItem(url: URL(string: url!)!)
                            player.replaceCurrentItem(with: item)
                            
                            if autoPlay {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                    player.play() // Autoplay
                                })
                            }
                        }
                    }
                    else if skin.chromas!.count > 1 && skin.chromas![1].streamedVideo != nil {
                        let url = skin.levels![selectedLevel].streamedVideo
                        
                        if url == nil {
                            self.noVideo = true
                            player.replaceCurrentItem(with: nil)
                        }
                        else {
                            self.noVideo = false
                            let item = AVPlayerItem(url: URL(string: url!)!)
                            player.replaceCurrentItem(with: item)
                        }
                        
                        if autoPlay {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                player.play() // Autoplay
                            })
                        }
                    }
                    
                }
                .overlay {
                    if noVideo {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
            
            
            
            
        }
        .aspectRatio(CGSize(width: 1920, height: 1080), contentMode: .fit)
        
    }
}

