//
//  PNMSFunctionCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCollectionViewCell.h"

@class PNFunctionCellModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSFunctionCell : PNCollectionViewCell

@property (nonatomic, strong) PNFunctionCellModel *model;

@end

NS_ASSUME_NONNULL_END
