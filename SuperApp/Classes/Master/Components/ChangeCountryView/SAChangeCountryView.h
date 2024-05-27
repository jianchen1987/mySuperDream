//
//  SAChangeCountryView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class SACountryModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAChangeCountryView : SAView <HDCustomViewActionViewProtocol>
/// 选择了 item 回调
@property (nonatomic, copy) void (^selectedItemHandler)(SACountryModel *model);

@end

NS_ASSUME_NONNULL_END
