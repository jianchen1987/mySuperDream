//
//  SACMSTItleViewConfig.h
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSDefine.h"
#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACMSTitleViewConfig : SACodingModel

@property (nonatomic, copy) NSString *title;        ///< 标题
@property (nonatomic, copy) NSString *subTitle;     ///< 副标题
@property (nonatomic, copy) NSString *subTitleLink; ///< 副标题跳转链接

- (NSString *)getIcon;
- (CMSTitleViewStyle)getStyle;
- (NSString *)getTitle;
- (UIColor *)getTitleColor;
- (UIFont *)getTitleFont;
- (NSString *)getTitleLink;
- (NSString *)getSubTitle;
- (UIColor *)getSubTitleColor;
- (UIFont *)getSubTitleFont;
- (NSString *)getSubTitleLink;
- (UIEdgeInsets)getContentEdgeInsets;

@end

NS_ASSUME_NONNULL_END
