//
//  WMHomeAddressView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddressModel.h"
#import "SACacheManager.h"
#import "SANotificationConst.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    AddressViewStyleBlack = 0,
    AddressViewStyleWhite,
    AddressViewStyleNew,
} AddressViewStyle;


@interface WMHomeAddressView : SAView
/// 笼统地址
@property (nonatomic, strong, readonly) SALabel *generalAddressLB;
/// 详细地址
@property (nonatomic, strong, readonly) SALabel *detailAddressLB;
/// 点击事件
@property (nonatomic, copy) void (^clickedHandler)(void);
/// 隐藏右边箭头，默认不隐藏
@property (nonatomic, assign) BOOL hideArrowImage;
/// 显示样式
@property (nonatomic, assign) AddressViewStyle style;

/// 更新当前地址
- (void)updateCurrentAdddress;
@end

NS_ASSUME_NONNULL_END
