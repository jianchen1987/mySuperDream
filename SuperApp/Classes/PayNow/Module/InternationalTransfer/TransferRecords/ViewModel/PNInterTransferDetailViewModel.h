//
//  PNInterTransferDetailViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransRecordModel.h"
#import "PNViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferDetailViewModel : PNViewModel
/// 详情信息数据源
@property (strong, nonatomic) NSMutableArray<HDTableViewSectionModel *> *dataArr;
/// 记录模型数据
@property (strong, nonatomic) PNInterTransRecordModel *recordModel;

- (void)initDataArr;
@end

NS_ASSUME_NONNULL_END
