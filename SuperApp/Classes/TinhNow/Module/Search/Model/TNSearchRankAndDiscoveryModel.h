//
//  TNSearchRankAndDiscoveryModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/10/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNSearchRankAndDiscoveryItemModel : TNModel
/// 值的显示
@property (nonatomic, copy) NSString *value;
/// logo
@property (nonatomic, copy) NSString *imageName;
/// 背景颜色
@property (nonatomic, strong) UIColor *bgColor;
/// 值的字体颜色
@property (nonatomic, strong) UIColor *valueColor;
/// 跳转链接
@property (nonatomic, copy) NSString *pageLinkApp;
/// 关键字  搜索发现有这个字段
@property (nonatomic, copy) NSString *keyWord;
/// 是否可以跳转
@property (nonatomic, assign) BOOL pageLink;
@end


@interface TNSearchRankAndDiscoveryModel : TNModel
@property (nonatomic, strong) NSArray<TNSearchRankAndDiscoveryItemModel *> *rspList;
@end

NS_ASSUME_NONNULL_END
