//
//  PNMSFilterBaseView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSBillFilterModel.h"
#import "PNMSFilterModel.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSFilterBaseView : PNView
/// 门店数据源 - UI 显示的那个
@property (nonatomic, strong) NSMutableArray<PNMSBillFilterModel *> *storeArray;
@property (nonatomic, strong) NSMutableArray<PNMSBillFilterModel *> *operatorArray;
@property (nonatomic, strong) PNMSFilterModel *filterModel;

/// 获取全部的数据
- (void)getStoreAllOperatorData:(void (^)(void))successBlock;
/// 获取当前门店的操作员
- (void)getCurrentStoreOperatorData:(void (^)(void))successBlock;

@end

NS_ASSUME_NONNULL_END
