//
//  SAAnnotation.h
//  SuperApp
//
//  Created by VanJay on 2020/4/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SAAnnotationType) {
    SAAnnotationTypeMerchant,    ///< 商户
    SAAnnotationTypeDeliveryMan, ///< 骑手
    SAAnnotationTypeConsignee,   ///< 收货人
    SAAnnotationTypeCustom,      ///< 自定义
};


@interface SAAnnotation : NSObject <MKAnnotation>
/// 类型
@property (nonatomic, assign) SAAnnotationType type;
/// 图片
@property (nonatomic, strong) UIImage *logoImage;
/// 网络图片 URL，优先级高于 image
@property (nonatomic, copy) NSString *logoImageURL;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 副标题
@property (nonatomic, copy) NSString *subTitle;
/// 坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/// 提示
@property (nonatomic, copy) NSString *tipTitle;
@end

NS_ASSUME_NONNULL_END
