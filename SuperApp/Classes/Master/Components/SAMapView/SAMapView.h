//
//  SAMapView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAnnotation.h"
#import "SAAnnotationView.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class SAMapView;

@protocol SAMapViewDelegate <NSObject>

@optional

/// 用户位置改变
- (void)mapView:(SAMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation;

/// 地图中心改变
- (void)mapView:(SAMapView *)mapView regionDidChangeAnimated:(BOOL)animated;

/// 点击选中的点
- (void)mapView:(SAMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;

/// 取消点击
- (void)mapView:(SAMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view;

@end


@interface SAMapView : SAView
/// 地图
@property (nonatomic, strong) MKMapView *mapView;
/// 代理
@property (nonatomic, weak) id delegate;
@end

NS_ASSUME_NONNULL_END
