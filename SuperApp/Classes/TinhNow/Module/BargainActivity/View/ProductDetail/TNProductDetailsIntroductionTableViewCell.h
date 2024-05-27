//
//  TNProductDetailsIntroductionTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/7/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductDetailsIntroductionTableViewCellModel : TNModel
/// 店铺id   暂时要处理京东的商品详情样式   因为京东自定义了样式  展示有问题
@property (nonatomic, copy) NSString *storeId;
/// 商品详情
@property (nonatomic, copy) NSString *htmlStr;
/// 记录获取到web高度
@property (nonatomic, assign) CGFloat webViewHeight;
@end


@interface TNProductDetailsIntroductionTableViewCell : SATableViewCell
/// model
@property (nonatomic, strong) TNProductDetailsIntroductionTableViewCellModel *model;
/// 获取到web高度回调
@property (nonatomic, copy) void (^getWebViewHeightCallBack)(void);
@end

NS_ASSUME_NONNULL_END
