//
//  TNExpressDetailsItemCell.h
//  SuperApp
//
//  Created by xixi on 2021/1/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNExpressDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNExpressDetailsItemCell : SATableViewCell

///
@property (nonatomic, strong) TNExpressEventInfoModel *eventInfoModel;
///
@property (nonatomic, assign) BOOL isFirst;
///
@property (nonatomic, assign) BOOL isLast;
@end

NS_ASSUME_NONNULL_END
