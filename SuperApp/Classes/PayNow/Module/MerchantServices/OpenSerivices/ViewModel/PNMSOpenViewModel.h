//
//  PNMSOpenViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSCategoryRspModel.h"
#import "PNMSOpenModel.h"
#import "PNViewModel.h"
#import "SAAddressModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSOpenViewModel : PNViewModel
@property (nonatomic, assign) BOOL refreshFlag;

@property (nonatomic, strong) PNMSCategoryRspModel *categoryRspModel;

@property (nonatomic, strong) PNMSOpenModel *model;

/// 再次申请 会带过来
@property (nonatomic, strong) NSString *merchantNo;

/// 获取数据 【经营品类 + 数据回填】
- (void)getData;

/// 申请开通商户
- (void)sumitApplyOpenMerchantServices;
@end

NS_ASSUME_NONNULL_END
