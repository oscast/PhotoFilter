//
//  Filters.swift
//  PhotoFilter
//
//  Created by Oscar Castillo on 3/10/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var offset: CGFloat = 0
    @State private var isScrolling = false
    @State private var viewModel = ImageProcessingViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = viewModel.processedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                } else {
                    Text("Select an Image")
                        .padding()
                }
                
                Button("Choose Image") {
                    viewModel.isShowingPhotoPicker = true
                }
                .buttonStyle(BlueButtonStyle())
                
                if viewModel.filterPreviews.isEmpty == false {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        ZStack {
                            ScrollViewOffsetReader(onScrollingStarted: {
                                isScrolling = true
                            }, onScrollingFinished: {
                                isScrolling = false
                                for photoIndex in viewModel.filtersToApplyIndex {
                                    viewModel.appliedFilterIndexes.append(photoIndex)
                                    if let index = viewModel.filtersToApplyIndex.firstIndex(where: { $0 == photoIndex }) {
                                        viewModel.filtersToApplyIndex.remove(at: index)
                                    }
                                    viewModel.applyFilter(to: viewModel.filterPreviews[photoIndex], at: photoIndex)
                                }
                            })
                            
                            LazyHStack(spacing: 10) {
                                ForEach(FilterType.allCases.indices, id: \.self) { index in
                                    VStack {
                                        Image(uiImage: viewModel.filterPreviews[index])
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(10)
                                            .onTapGesture {
                                                viewModel.applyFilter(index: index)
                                            }
                                            .onAppear {
                                                if viewModel.appliedFilterIndexes.contains(index) == false {
                                                    if isScrolling == false {
                                                        viewModel.applyFilter(to: viewModel.filterPreviews[index], at: index)
                                                    }  else {
                                                        viewModel.filtersToApplyIndex.append(index)
                                                    }
                                                }
                                            }
                                        
                                        Text(FilterType.allCases[index].displayName)
                                            .foregroundColor(.white)
                                            .padding(5)
                                            .background(Color.blue)
                                            .cornerRadius(5)
                                    }
                                    .padding(.vertical)
                                }
                            }
                            .padding(.horizontal)
                            
                        }
                        
                    }.coordinateSpace(name: "scroll")
                    
                }
                
                Spacer()
            }
            .navigationTitle("Image Filter")
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        viewModel.checkPermissionsAndSaveImage()
                    }
                    .disabled(viewModel.processedImage != nil)
                }
            }
            .sheet(isPresented: $viewModel.isShowingPhotoPicker) {
                PhotoPicker(selectedImage: $viewModel.originalImage) {
                    viewModel.originalImage = viewModel.originalImage
                    viewModel.processedImage = viewModel.originalImage
                    viewModel.generateFilterPreviews()
                    
                    if viewModel.filterServices.isEmpty == false {
                        viewModel.applyFilter(index: 0)
                    }
                }
            }
        }
    }
}

struct ScrollViewOffsetReader: View {
    private let onScrollingStarted: () -> Void
    private let onScrollingFinished: () -> Void
    
    private let detector: CurrentValueSubject<CGFloat, Never>
    private let publisher: AnyPublisher<CGFloat, Never>
    @State private var scrolling: Bool = false
    
    @State private var lastValue: CGFloat = 0
    
    init() {
        self.init(onScrollingStarted: {}, onScrollingFinished: {})
    }
    
    init(
        onScrollingStarted: @escaping () -> Void,
        onScrollingFinished: @escaping () -> Void
    ) {
        self.onScrollingStarted = onScrollingStarted
        self.onScrollingFinished = onScrollingFinished
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        self.publisher = detector
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
        self.detector = detector
    }
    
    var body: some View {
        GeometryReader { g in
            Rectangle()
                .frame(width: 0, height: 0)
                .onChange(of: g.frame(in: .global).origin.x) { _, offset in
                    if !scrolling {
                        scrolling = true
                        onScrollingStarted()
                    }
                    detector.send(offset)
                }
                .onReceive(publisher) {
                    scrolling = false
                    
                    guard lastValue != $0 else { return }
                    lastValue = $0
                    
                    onScrollingFinished()
                }
        }
    }
    
    func onScrollingStarted(_ closure: @escaping () -> Void) -> Self {
        .init(
            onScrollingStarted: closure,
            onScrollingFinished: onScrollingFinished
        )
    }
    
    func onScrollingFinished(_ closure: @escaping () -> Void) -> Self {
        .init(
            onScrollingStarted: onScrollingStarted,
            onScrollingFinished: closure
        )
    }
}
