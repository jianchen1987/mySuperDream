//
//  TNReviceMethodView.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNTransferRspModel.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNReviceMethodView : TNView
/// 数据源
@property (strong, nonatomic) TNTransferItemModel *item;
/// 进入按钮点击回调
@property (nonatomic, copy) void (^enterClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END
