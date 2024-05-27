//
//  SAOptionModel.h
//  SuperApp
//
//  Created by Tia on 2023/2/28.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAOptionModel : SAModel
/// 选项名称
@property (nonatomic, strong) SAInternationalizationModel *name;
/// 选择状态
@property (nonatomic) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
