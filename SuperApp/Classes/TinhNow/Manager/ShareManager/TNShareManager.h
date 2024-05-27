//
//  TNShareManager.h
//  SuperApp
//
//  Created by 张杰 on 2021/2/26.
//  Copyright © 2021 chaos network technology. All rights reserved.
//  电商分享管理中心

#import "TNShareModel.h"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNShareManager : NSObject
+ (instancetype)sharedInstance;
/// 展示分享
/// @param shareModel 分享模型
- (void)showShareWithShareModel:(TNShareModel *)shareModel;
@end

NS_ASSUME_NONNULL_END
