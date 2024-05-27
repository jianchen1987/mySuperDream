//
//  TNActivityGoodsView.h
//  SuperApp
//
//  Created by 张杰 on 2021/5/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"
@class TNGoodsModel;
/// 商品专题热销展示样式
typedef NS_ENUM(NSUInteger, TNActivityGoodsDisplayStyle) {
    ///默认 方形 图片在上  文字在下
    TNActivityGoodsDisplayStyleNormal = 0,
    ///横向 图片在左  文字在右
    TNActivityGoodsDisplayStyleHorizontal = 1,
};

NS_ASSUME_NONNULL_BEGIN


@interface TNActivityGoodsView : TNView
/// 显示样式
@property (nonatomic, assign) TNActivityGoodsDisplayStyle style;
/// 单个item宽度
@property (nonatomic, assign) CGFloat goodItemWidth;
/// 单个item高度
@property (nonatomic, assign) CGFloat goodItemHeight;
/// 模型
@property (strong, nonatomic) TNGoodsModel *model;
/// 是否有免邮或者
@property (nonatomic, assign) BOOL hasFreeShippingOrPromotion;
/// 专题埋点前缀
@property (nonatomic, copy) NSString *speciaTrackPrefixName;
@end

NS_ASSUME_NONNULL_END
