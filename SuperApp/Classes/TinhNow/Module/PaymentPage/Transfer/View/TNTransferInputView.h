//
//  TNTransferInputView.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNTransferInputView : TNView
/// 电话号码  供外部获取
@property (nonatomic, copy, readonly) NSString *phoneNum;
/// 是否禁用输入功能
@property (nonatomic, assign) BOOL disableEdit;
/// 左边文案 默认是联系电话
@property (nonatomic, copy) NSString *leftText;
/// 是否隐藏右边视图
@property (nonatomic, assign) BOOL hiddenRightView;
/// 是否隐藏底部分割线
@property (nonatomic, assign) BOOL hiddenBottomLineView;
/// 已有的电话号码
@property (nonatomic, copy) NSString *mobile;
@end

NS_ASSUME_NONNULL_END
