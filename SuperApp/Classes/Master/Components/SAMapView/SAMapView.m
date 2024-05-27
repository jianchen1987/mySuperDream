//
//  SAMapView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMapView.h"
#import "SAAnnotation.h"
#import "SAAnnotationView.h"
#import "WMAnnotaionView.h"
#import <MapKit/MapKit.h>


@interface SAMapView () <MKMapViewDelegate>
///< 当前的弧度
@property (nonatomic, assign) CLLocationDegrees curLatDegrees;
///< 当前的弧度
@property (nonatomic, assign) CLLocationDegrees curLonDegrees;
@end


@implementation SAMapView

- (void)hd_setupViews {
    [self addSubview:self.mapView];

    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.mapView addGestureRecognizer:pinch];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 2;
    [self.mapView addGestureRecognizer:tap];
}

- (void)updateConstraints {
    [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.curLatDegrees = self.mapView.region.span.latitudeDelta;
        self.curLonDegrees = self.mapView.region.span.longitudeDelta;

    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CLLocationCoordinate2D currentCenter = self.mapView.region.center;
//        HDLog(@"center: %f, %f", currentCenter.latitude, currentCenter.longitude);
        CGFloat fixScale = sender.scale; // 防止变化过快，加个减速
        // 最大130  最小 0.001
        CLLocationDegrees latDegress = self.curLatDegrees / fixScale > 130.0 ? 130 : (self.curLatDegrees / fixScale < 0.002 ? 0.002 : self.curLatDegrees / fixScale);
        CLLocationDegrees lngDegress = self.curLonDegrees / fixScale > 130.0 ? 130 : (self.curLonDegrees / fixScale < 0.002 ? 0.002 : self.curLonDegrees / fixScale);

        [self.mapView setRegion:MKCoordinateRegionMake(currentCenter, MKCoordinateSpanMake(latDegress, lngDegress))];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    self.curLatDegrees = self.mapView.region.span.latitudeDelta;
    self.curLonDegrees = self.mapView.region.span.longitudeDelta;
    CLLocationCoordinate2D currentCenter = self.mapView.region.center;
    CGFloat fixScale = 3;
    // 最大130  最小 0.001
    CLLocationDegrees latDegress = self.curLatDegrees / fixScale > 130.0 ? 130 : (self.curLatDegrees / fixScale < 0.002 ? 0.002 : self.curLatDegrees / fixScale);
    CLLocationDegrees lngDegress = self.curLonDegrees / fixScale > 130.0 ? 130 : (self.curLonDegrees / fixScale < 0.002 ? 0.002 : self.curLonDegrees / fixScale);

    [self.mapView setRegion:MKCoordinateRegionMake(currentCenter, MKCoordinateSpanMake(latDegress, lngDegress)) animated:YES];
}

#pragma mark - WKMapViewDelegate
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([NSStringFromClass(annotation.class) isEqualToString:@"SAAnnotation"]) {
        SAAnnotationView *view = (SAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(SAAnnotationView.class)];
        if (!view) {
            view = [[SAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass(SAAnnotationView.class)];
        }
        view.annotation = annotation;
        return view;
    } else if ([NSStringFromClass(annotation.class) isEqualToString:@"WMAnnotation"]) {
        WMAnnotaionView *view = (WMAnnotaionView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(SAAnnotationView.class)];
        if (!view) {
            view = [[WMAnnotaionView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass(SAAnnotationView.class)];
        }
        view.annotation = annotation;
        return view;
    }
    return nil;
}

/// 加个动画
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    for (MKAnnotationView *annotationView in views) {
        CGRect targetRect = annotationView.frame;
        annotationView.frame = CGRectMake(targetRect.origin.x, 0, targetRect.size.width, targetRect.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            annotationView.frame = targetRect;
        }];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didUpdateUserLocation:)]) {
        [self.delegate mapView:self didUpdateUserLocation:userLocation];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    // 方法节流
    [HDFunctionThrottle throttleWithInterval:0.3 key:@"mapViewRegionDidChangeAnimated" handler:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:regionDidChangeAnimated:)]) {
            [self.delegate mapView:self regionDidChangeAnimated:animated];
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didSelectAnnotationView:)]) {
        [self.delegate mapView:self didSelectAnnotationView:view];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didDeselectAnnotationView:)]) {
        [self.delegate mapView:self didDeselectAnnotationView:view];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - lazy load
- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        _mapView.delegate = self;
        _mapView.rotateEnabled = NO;
        _mapView.pitchEnabled = NO;
        _mapView.zoomEnabled = NO;
    }
    return _mapView;
}

@end
