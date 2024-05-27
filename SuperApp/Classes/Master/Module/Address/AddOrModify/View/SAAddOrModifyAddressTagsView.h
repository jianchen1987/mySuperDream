//
//  SAAddOrModifyAddressTagsView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressBaseView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAddOrModifyAddressTagsView : SAAddOrModifyAddressBaseView
/// 选中的按钮
@property (nonatomic, strong, readonly) HDUIButton *selectedBTN;
/// 标签
@property (nonatomic, copy) NSArray<NSString *> *tags;
@end

NS_ASSUME_NONNULL_END
