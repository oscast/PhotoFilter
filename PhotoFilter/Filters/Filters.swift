//
//  Filters.swift
//  PhotoFilter
//
//  Created by Oscar Castillo on 3/10/24.
//

import Foundation

enum FilterType: CaseIterable {
    case sepia
    case vignette
    case colorMonochrome
    case photoEffectNoir
    case photoEffectChrome
    case photoEffectInstant
    case gaussianBlur
    case motionBlur
    case bloom
    case tonalEffect
    
    var filterService: ImageFilterable {
        switch self {
        case .sepia:
            return SepiaToneFilterService()
        case .vignette:
            return VignetteFilterService()
        case .colorMonochrome:
            return ColorMonochromeFilterService()
        case .photoEffectNoir:
            return PhotoEffectNoirService()
        case .photoEffectChrome:
            return PhotoEffectChromeService()
        case .photoEffectInstant:
            return PhotoEffectInstantService()
        case .gaussianBlur:
            return GaussianBlurFilterService()
        case .motionBlur:
            return MotionBlurFilterService()
        case .bloom:
            return BloomFilterService()
        case .tonalEffect:
            return TonalEffectFilterService()
        }
    }
    
    var displayName: String {
        switch self {
        case .sepia: return "Sepia"
        case .vignette: return "Vignette"
        case .colorMonochrome: return "Monochrome"
        case .photoEffectNoir: return "Noir"
        case .photoEffectChrome: return "Chrome"
        case .photoEffectInstant: return "Instant"
        case .gaussianBlur: return "Gaussian Blur"
        case .motionBlur: return "Motion Blur"
        case .bloom: return "Bloom"
        case .tonalEffect: return "Tonal Effect"
        }
    }
    
    static var availableFilters: [ImageFilterable] {
        self.allCases.map { $0.filterService }
    }
}
