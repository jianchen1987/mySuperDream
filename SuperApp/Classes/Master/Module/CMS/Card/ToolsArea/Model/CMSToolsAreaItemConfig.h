//
//  CMSToolsAreaItemConfig.h
//  SuperApp
//
//  Created by Chaos on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SACMSDefine.h"

NS_ASSUME_NONNULL_BEGIN


@interface CMSToolsAreaItemConfig : SAModel

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *titleColor;
@property (nonatomic, assign) NSUInteger titleFont;
@property (nonatomic, copy) NSString *link;

@property (nonatomic, assign) CMSAppCornerIconStyle cornerMarkStyle; ///< 角标样式
@property (nonatomic, copy) NSString *cornerMarkText;                ///< 角标文本

@end

NS_ASSUME_NONNULL_END
