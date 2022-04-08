//
//  DownloadOperation.swift
//  TVSeriesAPI
//
//  Created by Ayşenur Bakırcı on 5.04.2022.
//

import Foundation
import UIKit

public enum ImageRecordStates {
    case ready, succeed, failed
}

public final class ImageRecord {
    public let model: TVSeries
    public var state = ImageRecordStates.ready
    public var image = UIImage(named: "Placeholder")
    
    public init(model: TVSeries) {
        self.model = model
    }
}

public final class PendingOperations {
    
    public init() { }
    
    public lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    public lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

public class ImageDownloader: Operation {
    
    let record: ImageRecord
    
    public init(_ record: ImageRecord) {
        self.record = record
    }
    
    public override func main() {
        guard !isCancelled else { return }
        
        guard let imageData = TVSeriesService().getImageData(with: record.model.posterPath) else { return }
        
        guard !isCancelled else { return }
        
        if !imageData.isEmpty {
            record.image = UIImage(data:imageData)
            record.state = .succeed
        } else {
            record.state = .failed
            record.image = UIImage(named: "Failed")
        }
    }
}
