//
//  SAOrderDetailRowView.h
//  SuperApp
//
//  Created by Chaos on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class SAInfoViewModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderDetailRowView : SAView
/// 配置模型
@property (nonatomic, strong, readonly) SAInfoViewModel *model;
/// 设置完 model 属性后调用此方法告知需要更新内容
- (void)setNeedsUpdateContent;

@end

NS_ASSUME_NONNULL_END
