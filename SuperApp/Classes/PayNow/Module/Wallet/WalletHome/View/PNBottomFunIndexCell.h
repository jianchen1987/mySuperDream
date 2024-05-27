//
//  PNBottomFunIndexCell.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNCollectionViewCell.h"
#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNBottomFunIndexCell : PNCollectionViewCell

@property (nonatomic, strong) NSMutableArray *dataArray;

- (CGFloat)collectionViewSizeHeight;

@end

NS_ASSUME_NONNULL_END
