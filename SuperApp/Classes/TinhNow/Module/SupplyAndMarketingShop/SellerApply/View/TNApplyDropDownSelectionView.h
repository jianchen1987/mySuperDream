//
//  TNApplyDropDownSelectionView.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNApplyDropDownSelectionView : TNView

/// 初始化一个卖家申请  下拉框选择的视图
/// @param keyText 描述文本
/// @param placeHoldText 下拉框占位文本
- (instancetype)initSelectionViewWithKeyText:(NSString *)keyText placeHoldText:(NSString *)placeHoldText;
/// 当前选中值
@property (nonatomic, copy) NSString *currentValueText;
///下拉选择数据
@property (strong, nonatomic) NSArray<NSDictionary *> *keyValueArray;
///选中回调
@property (nonatomic, copy) void (^selectedCallBack)(NSString *key, NSString *value);
@end

NS_ASSUME_NONNULL_END
