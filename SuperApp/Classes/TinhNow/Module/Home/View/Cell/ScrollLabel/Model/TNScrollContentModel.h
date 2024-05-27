//
//  TNScrollContentModel.h
//  SuperApp
//
//  Created by Chaos on 2020/7/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SAInternationalizationModel;


@interface TNScrollContentModel : TNModel

/// 内容
@property (nonatomic, strong) SAInternationalizationModel *text;
/// 图标
@property (nonatomic, copy) NSString *iconUrl;

@end

NS_ASSUME_NONNULL_END
