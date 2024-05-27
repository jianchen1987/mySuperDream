//
//  TNReviewViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNViewModel.h"
#import "TNSubmitReviewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNReviewViewModel : TNViewModel

/// 刷新标记
@property (nonatomic, assign) BOOL refreshFlag;
///
@property (nonatomic, strong) TNSubmitReviewModel *dataModel;
/// 公告刷新标记
@property (nonatomic, assign) BOOL noticeRefreshFlag;
/// 公告内容
@property (nonatomic, copy) NSString *noticeContent;

- (void)getOrderDetailWithOrderNo:(NSString *)orderNo;

- (void)postReviewAction;

- (void)getReviewNotice;
@end

NS_ASSUME_NONNULL_END
