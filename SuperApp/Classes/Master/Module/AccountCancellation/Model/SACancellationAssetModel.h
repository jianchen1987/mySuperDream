//
//  SACancellationAssetModel.h
//  SuperApp
//
//  Created by Tia on 2022/6/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACancellationAssetModel : SAModel
/// 建议
@property (nonatomic, copy) NSString *suggest;
/// 原因
@property (nonatomic, copy) NSString *reason;
///跳转链接-ios
@property (nonatomic, copy) NSString *iosLink;
/// 是否可注销：0-否、1-是
@property (nonatomic, assign) BOOL canCancellation;

@end

NS_ASSUME_NONNULL_END
