//
//  CMSTitleCardConfig.h
//  SuperApp
//
//  Created by Chaos on 2021/7/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CMSTitleCardStyle) {
    CMSTitleCardStyleLeft = 1,   // 左对齐
    CMSTitleCardStyleMiddle = 2, // 居中
    CMSTitleCardStyleRight = 3,  // 右对齐
};


@interface CMSTitleItemConfig : SAModel

@property (nonatomic, copy) NSString *leftIcon;
@property (nonatomic, copy) NSString *rightIcon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *titleColor;
@property (nonatomic, assign) NSUInteger titleFont;
@property (nonatomic, assign) CMSTitleCardStyle style;
@property (nonatomic, copy) NSString *link; ///< 跳转地址

@end

NS_ASSUME_NONNULL_END
