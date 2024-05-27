//
//  TNCutomerServicePopCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNCutomerServicePopCell : SATableViewCell
/// 点击客服回调
@property (nonatomic, copy) void (^chatClickCallBack)(void);
/// 点击电话回调
@property (nonatomic, copy) void (^phoneClickCallBack)(void);
/// 点击sms回调
@property (nonatomic, copy) void (^smsClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END
