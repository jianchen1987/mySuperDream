//
//  TNStoreSceneCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"
#import "TNStoreSceneModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNStoreSceneCell : TNCollectionViewCell
/// 模型
@property (strong, nonatomic) TNStoreSceneModel *model;
/// 点击更多回调
@property (nonatomic, copy) void (^moreClickCallBack)(BOOL isShowMore);
/// 获取图片高度后的回调  目前是需要根据图片的真实高度展示
@property (nonatomic, copy) void (^getRealImageSizeCallBack)(void);

@end

NS_ASSUME_NONNULL_END
