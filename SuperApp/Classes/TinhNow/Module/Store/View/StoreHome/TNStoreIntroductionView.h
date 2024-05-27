//
//  TNStoreIntroductionView.h
//  SuperApp
//
//  Created by 张杰 on 2021/7/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN
@class TNStoreInfoRspModel;


@interface TNStoreIntroductionView : TNView
/// 店铺信息
@property (nonatomic, strong) TNStoreInfoRspModel *storeInfo;
//隐藏收藏按钮
- (void)hiddenFavoriteButton;
@end

NS_ASSUME_NONNULL_END
