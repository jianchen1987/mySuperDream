//
//  TNSubmitReviewCell.h
//  SuperApp
//
//  Created by xixi on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNSubmitReviewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNSubmitReviewCell : SATableViewCell

///
@property (nonatomic, strong) TNSubmitReviewItemModel *model;

/// 刷新选择图片控件高度
@property (nonatomic, copy) void (^reloadHander)(void);

@end

NS_ASSUME_NONNULL_END
