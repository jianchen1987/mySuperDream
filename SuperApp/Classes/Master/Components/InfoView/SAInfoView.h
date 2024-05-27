//
//  SAInfoView.h
//  SuperApp
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInfoViewModel.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAInfoView : SAView

+ (instancetype)infoViewWithModel:(SAInfoViewModel *)model;

/// 模型
@property (nonatomic, strong) SAInfoViewModel *model;
/// 左图
@property (nonatomic, strong, readonly) UIImageView *leftImageView;
/// keyButton
@property (nonatomic, strong, readonly) HDUIButton *keyButton;
/// valueButton
@property (nonatomic, strong, readonly) HDUIButton *valueButton;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

- (void)showRightButton:(BOOL)isShow;

/// 设置完 model 属性后调用此方法告知需要更新内容
- (void)setNeedsUpdateContent;
@end

NS_ASSUME_NONNULL_END
