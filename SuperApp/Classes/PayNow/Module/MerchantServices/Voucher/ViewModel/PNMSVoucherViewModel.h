//
//  PNMSVoucherViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSFilterModel.h"
#import "PNViewModel.h"

@class PNMSVoucherInfoModel;
@class PNMSVoucherRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSVoucherViewModel : PNViewModel

@property (nonatomic, assign) BOOL refreshFlag;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *voucherId;
@property (nonatomic, strong) PNMSVoucherInfoModel *voucherInfoModel;
@property (nonatomic, strong) PNMSFilterModel *filterModel;

@property (nonatomic, assign) NSInteger currentPage;

- (void)getNewData:(BOOL)isShowLoading success:(void (^)(PNMSVoucherRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

- (void)saveVoucher:(NSDictionary *)paramDic success:(void (^)(PNMSVoucherInfoModel *rspModel))successBlock;

- (void)getVoucherDetail;
@end

NS_ASSUME_NONNULL_END
