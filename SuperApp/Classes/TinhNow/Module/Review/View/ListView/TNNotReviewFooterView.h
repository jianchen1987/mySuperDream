//
//  TNNotReviewFooterView.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableHeaderFooterView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNNotReviewFooterView : SATableHeaderFooterView
/// 评价回调
@property (nonatomic, copy) void (^reviewClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END
