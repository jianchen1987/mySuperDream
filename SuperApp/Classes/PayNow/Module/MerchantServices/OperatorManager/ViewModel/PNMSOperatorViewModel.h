//
//  PNMSOperatorViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOperatorInfoModel.h"
#import "PNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSOperatorViewModel : PNViewModel

@property (nonatomic, assign) BOOL refreshFlag;

/// 编辑的时候
@property (nonatomic, copy) NSString *operatorMobile;

@property (nonatomic, strong) PNMSOperatorInfoModel *operatorInfoModel;

@property (nonatomic, strong) NSMutableArray<PNMSOperatorInfoModel *> *dataSource;

/// 反查是否成功
@property (nonatomic, assign) BOOL isSuccess;

/// 获取操作员列表
- (void)getNewData:(BOOL)isNeedShowLoading;

/// 获取操作员详情
- (void)getOperatorDetail;

//// 重置交易密码
- (void)resetPwdWithOperatorMobile:(NSString *)operatorMobile;

/// 解除绑定
- (void)unBindWithOperatorMobile:(NSString *)operatorMobile;

/// 新增/编辑 操作员信息
- (void)saveOrUpdateOperatorInfo;

- (void)getCoolCashAccountName;
@end

NS_ASSUME_NONNULL_END
