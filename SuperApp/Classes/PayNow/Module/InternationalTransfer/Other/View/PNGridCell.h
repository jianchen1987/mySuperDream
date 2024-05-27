//
//  PNGridCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/7/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"

@class PNGrideModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNGridCell : PNTableViewCell

@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) PNGrideModel *model;
@end

NS_ASSUME_NONNULL_END
