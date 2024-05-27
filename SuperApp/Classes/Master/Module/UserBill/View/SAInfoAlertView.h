//
//  SAInfoAlertView.h
//  SuperApp
//
//  Created by seeu on 2022/4/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import <HDUIkit/HDCustomViewActionView.h>

NS_ASSUME_NONNULL_BEGIN

@class SAInfoAlertViewModel;


@interface SAInfoAlertView : SAView <HDCustomViewActionViewProtocol>
///< model
@property (nonatomic, strong) SAInfoAlertViewModel *model;
@end


@interface SAInfoAlertViewModel : SAModel

///< 文本
@property (nonatomic, copy) NSString *text;
///< 文本字体
@property (nonatomic, strong) UIFont *textFont;
///< 文本颜色
@property (nonatomic, strong) UIColor *textColor;
///<
@property (nonatomic, strong) NSAttributedString *attributeString;
///< 标题内边距
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;

@end

NS_ASSUME_NONNULL_END
