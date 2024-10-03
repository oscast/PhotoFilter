//
//  ImageProcessingViewModel.swift
//  PhotoFilter
//
//  Created by Oscar Castillo on 3/10/24.
//

import SwiftUI
import Photos

@Observable
class ImageProcessingViewModel {
    var originalImage: UIImage?
    var processedImage: UIImage?
    var filterPreviews: [UIImage] = []
    var appliedFilterIndexes: [Int] = []
    var filtersToApplyIndex: [Int] = []
    var isShowingPhotoPicker = false
    
    @ObservationIgnored
    var filterServices: [ImageFilterable] = FilterType.availableFilters
    
    @ObservationIgnored
    var selectedFilterService: ImageFilterable?
    
    func applyFilter(index: Int) {
        selectedFilterService = filterServices[index]
        guard let originalImage = originalImage else { return }
        selectedFilterService?.applyFilter(to: originalImage) { [weak self] filteredImage in
            DispatchQueue.main.async {
                self?.processedImage = filteredImage
            }
        }
    }
    
    func applyFilter() {
        guard let originalImage = originalImage, let selectedFilterService = selectedFilterService else { return }
        selectedFilterService.applyFilter(to: originalImage) { [weak self] result in
            DispatchQueue.main.async {
                self?.processedImage = result
            }
        }
    }
    
    func generateFilterPreviews() {
        guard let originalImage = originalImage else { return }
        filterPreviews = []
        for _ in filterServices {
            self.filterPreviews.append(originalImage)
//            service.applyFilter(to: originalImage) { [weak self] filteredImage in
//                DispatchQueue.main.async {
//                    if let filteredImage = filteredImage {
//                        self?.filterPreviews.append(filteredImage)
//                    }
//                }
//            }
        }
    }
    
    func applyFilter(to image: UIImage, at index: Int) {
        let service = filterServices[index]
        
        service.applyFilter(to: image) { [weak self] filteredImage in
            DispatchQueue.main.async {
                if let filteredImage = filteredImage {
                    self?.filterPreviews[index] = filteredImage
                }
            }
        }
    }
    
    func checkPermissionsAndSaveImage() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            saveImageToPhotos()
        } else {
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                if newStatus == .authorized {
                    self?.saveImageToPhotos()
                }
            }
        }
    }
    
    private func saveImageToPhotos() {
        guard let processedImage = processedImage else { return }
        UIImageWriteToSavedPhotosAlbum(processedImage, nil, nil, nil)
    }
}
