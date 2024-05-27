//
//  SAMessageListChildViewControllerConfig.h
//  SuperApp
//
//  Created by seeu on 2021/7/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"
#import "SAInternationalizationModel.h"
#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SAMessageCenterListViewController;


@interface SAMessageListChildViewControllerConfig : SACodingModel
/// 标题
@property (nonatomic, strong) SAInternationalizationModel *title;
/// 控制器
@property (nonatomic, strong) id<HDCategoryListContentViewDelegate> vc;

+ (instancetype)configWithTitle:(SAInternationalizationModel *)title vc:(id<HDCategoryListContentViewDelegate>)vc;
@end

NS_ASSUME_NONNULL_END
