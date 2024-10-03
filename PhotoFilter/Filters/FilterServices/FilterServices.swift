//
//  FilterServices.swift
//  PhotoFilter
//
//  Created by Oscar Castillo on 3/10/24.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

protocol ImageFilterable {
    func applyFilter(to inputImage: UIImage, completion: @escaping (UIImage?) -> Void)
}

class SepiaToneFilterService: ImageFilterable {
    func applyFilter(to inputImage: UIImage, completion: @escaping (UIImage?) -> Void) {
        let filter = CIFilter.sepiaTone()
        filter.intensity = 0.8
        processImage(filter: filter, inputImage: inputImage, completion: completion)
    }
}

class VignetteFilterService: ImageFilterable {
    func applyFilter(to inputImage: UIImage, completion: @escaping (UIImage?) -> Void) {
        let filter = CIFilter.vignette()
        filter.intensity = 1
        filter.radius = 2
        processImage(filter: filter, inputImage: inputImage, completion: completion)
    }
}

class ColorMonochromeFilterService: ImageFilterable {
    func applyFilter(to inputImage: UIImage, completion: @escaping (UIImage?) -> Void) {
        let filter = CIFilter.colorMonochrome()
        filter.color = CIColor(color: .gray)
        filter.intensity = 1.0
        processImage(filter: filter, inputImage: inputImage, completion: completion)
    }
}

class PhotoEffectNoirService: ImageFilterable {
    func applyFilter(to inputImage: UIImage, completion: @escaping (UIImage?) -> Void) {
        let filter = CIFilter.photoEffectNoir()
        processImage(filter: filter, inputImage: inputImage, completion: completion)
    }
}

class PhotoEffectChromeService: ImageFilterable {
    func applyFilter(to inputImage: UIImage, completion: @escaping (UIImage?) -> Void) {
        let filter = CIFilter.photoEffectChrome()
        processImage(filter: filter, inputImage: inputImage, completion: completion)
    }
}

class PhotoEffectInstantService: ImageFilterable {
    func applyFilter(to inputImage: UIImage, completion: @escaping (UIImage?) -> Void) {
        let filter = CIFilter.photoEffectInstant()
        processImage(filter: filter, inputImage: inputImage, completion: completion)
    }
}

class GaussianBlurFilterService: ImageFilterable {
    func applyFilter(to inputImage: UIImage, completion: @escaping (UIImage?) -> Void) {
        let filter = CIFilter.gaussianBlur()
        filter.radius = 10.0
        processImage(filter: filter, inputImage: inputImage, completion: completion)
    }
}

class MotionBlurFilterService: ImageFilterable {
    func applyFilter(to inputImage: UIImage, completion: @escaping (UIImage?) -> Void) {
        let filter = CIFilter.motionBlur()
        filter.radius = 20.0
        filter.angle = 0.0
        processImage(filter: filter, inputImage: inputImage, completion: completion)
    }
}

class BloomFilterService: ImageFilterable {
    func applyFilter(to inputImage: UIImage, completion: @escaping (UIImage?) -> Void) {
        let filter = CIFilter.bloom()
        filter.intensity = 0.5
        filter.radius = 10.0
        processImage(filter: filter, inputImage: inputImage, completion: completion)
    }
}

class TonalEffectFilterService: ImageFilterable {
    func applyFilter(to inputImage: UIImage, completion: @escaping (UIImage?) -> Void) {
        guard let filter = CIFilter(name: "CIPhotoEffectTonal") else {
            completion(nil)
            return
        }
        processImage(filter: filter, inputImage: inputImage, completion: completion)
    }
}

private func processImage(filter: CIFilter, inputImage: UIImage, completion: @escaping (UIImage?) -> Void) {
    guard let ciInputImage = CIImage(image: inputImage) else {
        completion(nil)
        return
    }
    filter.setValue(ciInputImage, forKey: kCIInputImageKey)
    let context = CIContext()
    guard let outputImage = filter.outputImage,
          let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
        completion(nil)
        return
    }
    completion(UIImage(cgImage: cgImage))
}
