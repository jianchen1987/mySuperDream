//
//  TNNotReviewGoodCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNMyNotReviewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNNotReviewGoodCell : SATableViewCell
/// 数据源
@property (strong, nonatomic) TNMyNotReviewGoodInfo *info;
@end

NS_ASSUME_NONNULL_END
