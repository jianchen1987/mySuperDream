//
//  SAChangeLanguageViewPresenter.h
//  SuperApp
//
//  Created by VanJay on 2020/4/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASelectableTableViewCellModel.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SAChangeLanguageViewChoosedItemHandler)(SASelectableTableViewCellModel *_Nullable model);


@interface SAChangeLanguageViewPresenter : NSObject
/// 展示语言选择弹窗
+ (void)showChangeLanguageView;

/// 展示语言选择弹窗
/// @param choosedItemHandler 选择了语言回调，也可能用户取消选择，直接 dismiss，即 model 可为空
+ (void)showChangeLanguageViewWithChoosedItemHandler:(SAChangeLanguageViewChoosedItemHandler _Nullable)choosedItemHandler;

@end

NS_ASSUME_NONNULL_END
