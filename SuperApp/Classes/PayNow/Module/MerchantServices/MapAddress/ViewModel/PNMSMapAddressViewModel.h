//
//  PNMSMapAddressViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNViewModel.h"
#import "SAAddressModel.h"

@class PNMSMapAddressModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSMapAddressViewModel : PNViewModel

@property (nonatomic, assign) BOOL provincesRefreshFlag;
/// 省份数据源
@property (nonatomic, strong) NSArray<PNMSMapAddressModel *> *provincesArray;
/// 当前选中的
@property (nonatomic, copy) NSString *currentSelectProvince;
/// mapAddress
@property (nonatomic, strong) SAAddressModel *addressModel;
/// 地址回调
@property (nonatomic, copy) void (^choosedAddressBlock)(SAAddressModel *);

/// 获取省份数据
- (void)getProvinces;
@end

NS_ASSUME_NONNULL_END
