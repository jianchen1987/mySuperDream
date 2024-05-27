//
//  GNReserveViewModel.h
//  SuperApp
//
//  Created by wmz on 2022/9/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNReserveRspModel.h"
#import "GNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNReserveViewModel : GNViewModel
///门店No
@property (nonatomic, copy) NSString *storeNo;
/// orderNo
@property (nonatomic, copy) NSString *orderNo;
///预约model
@property (nonatomic, strong) GNReserveRspModel *reserveModel;

@end

NS_ASSUME_NONNULL_END
