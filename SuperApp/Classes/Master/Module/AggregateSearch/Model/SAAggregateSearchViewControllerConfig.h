//
//  SAAggregateSearchViewControllerConfig.h
//  SuperApp
//
//  Created by seeu on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAAggregateSearchResultViewController;


@interface SAAggregateSearchViewControllerConfig : SAModel
/// 标题
@property (nonatomic, strong) SAInternationalizationModel *title;
/// 控制器
@property (nonatomic, strong) SAAggregateSearchResultViewController *vc;

+ (instancetype)configWithTitle:(SAInternationalizationModel *)title vc:(SAAggregateSearchResultViewController *)vc;

@end

NS_ASSUME_NONNULL_END
