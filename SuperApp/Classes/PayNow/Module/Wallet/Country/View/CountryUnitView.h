//
//  CountryUnitView.h
//  customer
//
//  Created by 谢 on 2019/1/4.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNView.h"
@class CountryModel;

NS_ASSUME_NONNULL_BEGIN


@interface CountryUnitView : PNView

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) CountryModel *model; ///< 模型
@end

NS_ASSUME_NONNULL_END
