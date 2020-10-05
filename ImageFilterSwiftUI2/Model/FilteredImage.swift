//
//  FilteredImage.swift
//  ImageFilterSwiftUI2
//
//  Created by Qiang Ma on 10/5/20.
//

import SwiftUI
import CoreImage

struct FilteredImage: Identifiable {
 
    var id = UUID().uuidString
    var image: UIImage
    var filter: CIFilter
    var isEditable: Bool
}
