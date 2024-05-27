//
//  SAChangeLanguageView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class SASelectableTableViewCellModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAChangeLanguageView : SAView <HDCustomViewActionViewProtocol>
/// 选择了 item 回调
@property (nonatomic, copy) void (^selectedItemHandler)(SASelectableTableViewCellModel *model);
@end

NS_ASSUME_NONNULL_END
