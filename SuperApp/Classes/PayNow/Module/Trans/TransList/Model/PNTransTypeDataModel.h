//
//  TransTypeDataModel.h
//  SuperApp
//
//  Created by Quin on 2021/11/30.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNTransTypeDataModel : PNModel
@property (nonatomic, strong) PNTransferType bizType;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *logoPath;
@end

NS_ASSUME_NONNULL_END
