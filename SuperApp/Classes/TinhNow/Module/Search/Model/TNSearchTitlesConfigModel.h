//
//  TNSearchTitlesConfigModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/8/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNSearchTitlesConfigModel : TNModel
/// 标题
@property (nonatomic, copy) NSString *title;
/// 是否需要更新数据
@property (nonatomic, assign) BOOL isNeedRefresh;
/// 搜索范围  默认全部商城
@property (nonatomic, assign) TNSearchScopeType scopeType;
@end

NS_ASSUME_NONNULL_END
