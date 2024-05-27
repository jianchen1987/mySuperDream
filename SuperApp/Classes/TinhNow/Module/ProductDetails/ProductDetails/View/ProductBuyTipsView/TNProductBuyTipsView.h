//
//  TNProductBuyTipsView.h
//  SuperApp
//
//  Created by 张杰 on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>
#import "TNEnum.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNProductBuyTipsView : HDActionAlertView

/// 初始化
/// @param buyType 类型
/// @param storeNo 店铺id
/// @param tips 提示文本


/// 初始化
/// @param buyType 类型
/// @param storeNo 店铺id
/// @param storePhone 商品电话
/// @param tips 提示文本
/// @param title 商品卡片标题
/// @param content 商品卡片内容
/// @param image 商品卡片图片
- (instancetype)initTipsType:(TNProductBuyType)buyType
                     storeNo:(NSString *)storeNo
                  storePhone:(NSString *)storePhone
                        tips:(NSString *)tips
                       title:(NSString *)title
                     content:(NSString *)content
                       image:(NSString *)image;

/// 点击确定按钮回调
@property (nonatomic, copy) void (^doneClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END
