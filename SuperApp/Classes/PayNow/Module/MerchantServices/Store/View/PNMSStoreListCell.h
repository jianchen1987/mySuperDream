//
//  PNMSStoreListCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"

@class PNMSStoreInfoModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSStoreListCell : PNTableViewCell
@property (nonatomic, strong) PNMSStoreInfoModel *model;
@end

NS_ASSUME_NONNULL_END
