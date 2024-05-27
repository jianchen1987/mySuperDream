//
//  TNCategoryViewModel.h
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNViewModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SAInternationalizationModel;


@interface TNCategoryViewModel : TNViewModel

/// 一级分类数据源
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *firstLevel;
/// 二级分类数据源
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *secondLevel;
/// 二级分类标题
@property (nonatomic, copy) NSString *secondLevelHeader;
/// 展示广告图
@property (nonatomic, copy) NSString *adImageUrl;
/// 广告图点击url
@property (nonatomic, copy) NSString *adOpenUrl;

- (void)queryCategory;
@end

NS_ASSUME_NONNULL_END
