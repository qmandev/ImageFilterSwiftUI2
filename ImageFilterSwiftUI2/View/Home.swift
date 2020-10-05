//
//  Home.swift
//  ImageFilterSwiftUI2
//
//  Created by Qiang Ma on 10/4/20.
//

import SwiftUI

struct Home: View {
    
    @StateObject var homeData = HomeViewModel()
    
    var body: some View {
        
        VStack {
            
            if !homeData.allImages.isEmpty && homeData.mainView != nil {
                
                Spacer(minLength: 0)
                
                Image(uiImage: homeData.mainView.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width)
                
                Slider(value: $homeData.value)
                    .padding()
                    .opacity(homeData.mainView.isEditable ? 1 : 0)
                    .disabled(homeData.mainView.isEditable ? false : true)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 20) {
                        
                        ForEach(homeData.allImages) { filtered in
                            
                            Image(uiImage: filtered.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                                .onTapGesture {
                                    // clearing old data...
                                    homeData.value = 1.0
                                    // Updating mainViw whenever Button Tapped
                                    homeData.mainView = filtered
                                }
                        }
                    }.padding()
                }
            }
            else if homeData.imageData.count == 0 {
                Text("Pick An Image to process !")
            }
            else {
                // Loading View...
                ProgressView()
            }
        }
        .onChange(of: homeData.value, perform: { (_) in
            homeData.updateEffect()
        })
        .onChange(of: homeData.imageData, perform: { (_) in
            
            // clearing existing data...
            homeData.allImages.removeAll()
            
            homeData.mainView = nil
            
            // Whenver image is changed Firing loadingImage...
            homeData.loadFilter()
        })
        .toolbar {
            // Image Button...
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                
                Button(action: {homeData.imagePicker.toggle()}) {
                    
                    Image(systemName: "photo")
                        .font(.title2)
                }
            }
            
            // Saving Image...
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                
                Button(action: {
                        
                    UIImageWriteToSavedPhotosAlbum(homeData.mainView.image, nil, nil, nil)
                    
                }) {
                    
                    Image(systemName: "square.and.arrow.up.fill")
                        .font(.title2)
                }
                // disabling on no Image...
                .disabled(homeData.mainView == nil ? true : false)
            }
        }
        .sheet(isPresented: $homeData.imagePicker) {
            
            ImagePicker(picker: $homeData.imagePicker, imageData: $homeData.imageData)
        }
    }
}

