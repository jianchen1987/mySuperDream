//
//  TNProductDetailsBargainBottomView.h
//  SuperApp
//
//  Created by xixi on 2021/2/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNEnum.h"
#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductDetailsBargainBottomView : TNView

/// 点击分享回调
@property (nonatomic, copy) void (^shareButtonClickedHander)(void);
/// 点击客服的回调
@property (nonatomic, copy) void (^customerServiceButtonClickedHander)(NSString *storeNo);
/// 立即购买
@property (nonatomic, copy) void (^buyNowButtonClickedHander)(NSString *productId);
/// create task
@property (nonatomic, copy) void (^createTaskButtonClickedHander)(void);

@end

NS_ASSUME_NONNULL_END
