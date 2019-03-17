//
//  ChartLayerWrapper.swift
//  TelegramCharts
//
//  Created by Alexander Ivlev on 15/03/2019.
//  Copyright © 2019 CFT. All rights reserved.
//

import Foundation
import UIKit

internal final class ChartLayerWrapper
{
    internal var visibleAABB: AABB {
        return chartViewModel?.visibleaabb?.copyWithPadding(date: 0, value: 0.1) ?? AABB.empty
    }
    
    private var chartViewModel: ChartViewModel? = nil
    private var polygonLineLayers: [PolygonLineLayerWrapper] = []
    private weak var parentLayer: CALayer?
    
    internal init() {
    }
    
    internal func setParentLayer(_ layer: CALayer) {
        parentLayer = layer
        
        polygonLineLayers.forEach { $0.layer.removeFromSuperlayer() }
        for polygonLineLayer in polygonLineLayers {
            polygonLineLayer.layer.frame = layer.bounds
            layer.addSublayer(polygonLineLayer.layer)
        }
    }
    
    internal func setChart(_ chartViewModel: ChartViewModel) {
        self.chartViewModel = chartViewModel
        
        polygonLineLayers.forEach { $0.layer.removeFromSuperlayer() }
        polygonLineLayers.removeAll()
        for polygonLine in chartViewModel.polygonLines {
            let polygonLineLayer = PolygonLineLayerWrapper(polygonLineViewModel: polygonLine)
            polygonLineLayers.append(polygonLineLayer)
        }
        
        if let layer = parentLayer {
            setParentLayer(layer)
        }
    }
    
    internal func update(aabb: AABB?, animated: Bool) {
        let aabb = aabb ?? AABB.empty
        for polygonLineLayer in polygonLineLayers {
            polygonLineLayer.update(aabb: aabb, animated: animated)
        }
    }
}
