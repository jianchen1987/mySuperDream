//
//  PNMSHomeViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/5/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNViewModel.h"
#import "SACollectionViewSectionModel.h"

NS_ASSUME_NONNULL_BEGIN
static NSString *const kAccountFlag = @"account";
static NSString *const kTopFunctionFlag = @"top_function";


@interface PNMSHomeViewModel : PNViewModel

@property (nonatomic, copy) NSString *merchantNo;
@property (nonatomic, copy) NSString *operatorNo;

@property (nonatomic, assign) BOOL refreshFlag;
@property (nonatomic, strong) NSMutableArray<SACollectionViewSectionModel *> *dataSource;

/// 获取商户钱包首页信息
- (void)getNewData;

@end

NS_ASSUME_NONNULL_END
