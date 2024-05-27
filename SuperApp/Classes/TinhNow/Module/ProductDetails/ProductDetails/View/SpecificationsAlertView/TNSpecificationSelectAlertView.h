//
//  TNSpecificationSelectAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2022/7/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNItemModel.h"
#import "TNSkuSpecModel.h"
#import <HDUIKit/HDUIKit.h>
// 规格选择类型
typedef NS_ENUM(NSUInteger, TNSpecificationType) {
    ///单买
    TNSpecificationTypeSingle = 0,
    ///批量
    TNSpecificationTypeBatch = 1,
    ///单买和批量一起
    TNSpecificationTypeMix = 2
};

NS_ASSUME_NONNULL_BEGIN


@interface TNSpecificationSelectAlertView : HDActionAlertView
/// 初始化一个批发商品弹窗
/// @param specType 弹窗类型
/// @param model 批发数据
/// @param buyType 立即购买 or  加入购物车
- (instancetype)initWithSpecType:(TNSpecificationType)specType specModel:(TNSkuSpecModel *)model buyType:(TNProductBuyType)buyType;
/// 立即购买回调
@property (nonatomic, copy) void (^buyNowCallBack)(TNItemModel *item, TNSalesType salesType);
/// 加入购物车回调
@property (nonatomic, copy) void (^addToCartCallBack)(TNItemModel *item, TNSalesType salesType);
@end

NS_ASSUME_NONNULL_END
