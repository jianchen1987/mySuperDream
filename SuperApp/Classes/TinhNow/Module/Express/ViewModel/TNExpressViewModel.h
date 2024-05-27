//
//  TNExpressViewModel.h
//  SuperApp
//
//  Created by xixi on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNViewModel.h"
#import "TNExpressDetailsModel.h"
#import "TNExpressRiderModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNExpressViewModel : TNViewModel
/// 物流数据模型
@property (nonatomic, strong) TNExpressDetailsRspModel *rspModel;
///骑手模型数据
@property (strong, nonatomic) TNExpressRiderModel *riderModel;
/// 第一条物流模型
@property (nonatomic, strong) TNExpressDetailsModel *expModel;
//网络失败回调
@property (nonatomic, copy) void (^networkFailCallBack)(void);

- (void)getNewDataWithOrderNo:(NSString *)orderNo;
- (void)getExpressRiderData:(NSString *)trackingNo;
@end

NS_ASSUME_NONNULL_END
