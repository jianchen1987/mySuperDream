//
//  PNInfoView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/10/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInfoViewModel.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNInfoView : PNView

+ (instancetype)infoViewWithModel:(PNInfoViewModel *)model;

/// 模型
@property (nonatomic, strong) PNInfoViewModel *model;
/// 左图
@property (nonatomic, strong, readonly) UIImageView *leftImageView;
/// keyButton
@property (nonatomic, strong, readonly) HDUIButton *keyButton;
/// valueButton
@property (nonatomic, strong, readonly) HDUIButton *valueButton;

- (void)showRightButton:(BOOL)isShow;

/// 设置完 model 属性后调用此方法告知需要更新内容
- (void)setNeedsUpdateContent;
@end

NS_ASSUME_NONNULL_END
