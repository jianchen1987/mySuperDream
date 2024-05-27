//
//  PNTransferFormCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"
#import "PNTransferFormConfig.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNTransferFormCell : PNTableViewCell
///
@property (strong, nonatomic) PNTransferFormConfig *config;
@end

NS_ASSUME_NONNULL_END
