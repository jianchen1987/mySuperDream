//
//  PNMSCollectionModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSCollectionModel : PNModel
/// usd
@property (nonatomic, strong) NSNumber *usdAmt;
/// khr
@property (nonatomic, strong) NSNumber *khrAmt;
/// usd笔数
@property (nonatomic, assign) NSInteger usdNum;
/// khr笔数
@property (nonatomic, assign) NSInteger khrNum;
@end

NS_ASSUME_NONNULL_END
