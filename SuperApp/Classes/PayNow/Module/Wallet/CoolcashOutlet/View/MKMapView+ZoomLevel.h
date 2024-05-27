//
//  MKMapView+ZoomLevel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface MKMapView (ZoomLevel)
/// MapView 上所有的annotation 一屏幕显示，入参coordinate 固定在中间
- (void)zoomToFitMapAnnotationsWithCenterCoordinate:(CLLocationCoordinate2D)coordinate;

/// 根据数据源annotations 一屏幕显示，入参coordinate 固定在中间
- (void)zoomToFitMapAnnotationsWithCenterCoordinate:(CLLocationCoordinate2D)coordinate annotations:(NSArray *)annotations;

/// MapView 上面 annotation 一屏幕显示 , 没有固定的中心点
- (void)zoomToFitMapAnnotations;

@end

NS_ASSUME_NONNULL_END
