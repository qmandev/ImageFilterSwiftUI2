//
//  HomeViewModel.swift
//  ImageFilterSwiftUI2
//
//  Created by Qiang Ma on 10/4/20.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class HomeViewModel : ObservableObject {
    
    @Published var imagePicker = false
    
    @Published var imageData = Data(count: 0)
    
    @Published var allImages: [FilteredImage] = []
    
    // Main Editing Image...
    @Published var mainView : FilteredImage!
    
    // Slider for Intensity and Radius, etc
    @Published var value : CGFloat = 1.0
    
    // Loading FilterOption Whenever Image is Selected...
    
    // add different filters
    let filters : [CIFilter] = [
        CIFilter.sepiaTone(), CIFilter.comicEffect(), CIFilter.colorInvert(), CIFilter.photoEffectFade(),
        CIFilter.colorMonochrome(), CIFilter.photoEffectChrome(), CIFilter.gaussianBlur(), CIFilter.bloom(),
        CIFilter.gammaAdjust()
    ]
    
    func loadFilter() {
        
        let context = CIContext()
        
        filters.forEach { (filter) in
            
            // To Avoid lag do it in the background queue ...
            // loading image into filter
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                let CiImage = CIImage(data: self.imageData)
                
                filter.setValue(CiImage!, forKey: kCIInputImageKey)
                
                // retreving image ...
                guard let newImage = filter.outputImage else { return }
                
                // creating UIImage
                let cgimage = context.createCGImage(newImage, from: newImage.extent)
                
                let isEditable = filter.inputKeys.count > 1
                
                let filteredData = FilteredImage(image: UIImage(cgImage: cgimage!), filter: filter, isEditable: isEditable)
                
                DispatchQueue.main.async {
                    self.allImages.append(filteredData)
                    
                    // default image is the First Filter...
                    
                    if self.mainView == nil {
                        self.mainView = self.allImages.first
                    }
                }
            }
        }
    }
    
    func updateEffect() {
        
        let context = CIContext()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let CiImage = CIImage(data: self.imageData)
            
            let filter = self.mainView.filter
            
            filter.setValue(CiImage!, forKey: kCIInputImageKey)
            
            // retreving image ...
            // reading inputKeys...
            // print(filter.inputKeys)
            
            // there are lot of custom options are available, only using radius and intensity here,
            // lot more to choose from
            
            if filter.inputKeys.contains("inputRadius") {
                // radius can give up to 100, only use 10 here
                filter.setValue(self.value * 10, forKey: kCIInputRadiusKey)
            }
            
            if filter.inputKeys.contains("inputIntensity") {
                filter.setValue(self.value, forKey: kCIInputIntensityKey)
            }
            
            
            guard let newImage = filter.outputImage else { return }
            
            // creating UIImage
            let cgimage = context.createCGImage(newImage, from: newImage.extent)
            
            DispatchQueue.main.async {

                // updating view...
                
                self.mainView.image = UIImage(cgImage: cgimage!)
            }
        }

        
    }
}
