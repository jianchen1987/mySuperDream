//
//  TNStoreView.h
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN
@class TNStoreInfoRspModel;


@interface TNStoreInfoView : TNView
/// model
@property (nonatomic, strong) TNStoreInfoRspModel *model;
/// 更换menu回调
@property (nonatomic, copy) void (^changeMenuCallBack)(BOOL showAllProduct);
@end

NS_ASSUME_NONNULL_END
