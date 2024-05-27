//
//  MKMapView+ZoomLevel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDLocationManager.h"
#import "HDLog.h"
#import "MKMapView+ZoomLevel.h"


@implementation MKMapView (ZoomLevel)
/// MapView 上所有的annotation 一屏幕显示，入参coordinate 固定在中间
- (void)zoomToFitMapAnnotationsWithCenterCoordinate:(CLLocationCoordinate2D)coordinate {
    [self zoomToFitMapAnnotationsWithCenterCoordinate:coordinate annotations:self.annotations];
}

/// 根据数据源annotations 一屏幕显示，入参coordinate 固定在中间
- (void)zoomToFitMapAnnotationsWithCenterCoordinate:(CLLocationCoordinate2D)coordinate annotations:(NSArray *)annotations {
    if (self.annotations.count == 0)
        return;

    MKCoordinateRegion region;
    double maxLatitudeDress = 0;
    double maxLongitudeDress = 0;

    HDLog(@"🦋🦋一共：%zd", annotations.count);
    for (id<MKAnnotation> annotation in annotations) {
        double tempMaxLa = fabs(coordinate.latitude - annotation.coordinate.latitude);
        if (tempMaxLa > maxLatitudeDress) {
            maxLatitudeDress = tempMaxLa;
        }
        double tempMaxLo = fabs(coordinate.longitude - annotation.coordinate.longitude);
        if (tempMaxLo > maxLongitudeDress) {
            maxLongitudeDress = tempMaxLo;
        }
    }

    region.center = coordinate;
    region.span.latitudeDelta = maxLatitudeDress * 2 * 1.2;
    region.span.longitudeDelta = maxLongitudeDress * 2 * 1.2;
    //    region = [self regionThatFits:region];
    [self setRegion:region animated:YES];
}

/// MapView 上面 annotation 一屏幕显示 , 没有固定的中心点
- (void)zoomToFitMapAnnotations {
    if (self.annotations.count == 0)
        return;

    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;

    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;

    for (id<MKAnnotation> annotation in self.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }

    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;

    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2;

    region = [self regionThatFits:region];
    [self setRegion:region animated:YES];
}

@end
