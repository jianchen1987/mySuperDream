//
//  CMSThreeImage7x3ItemConfig.h
//  SuperApp
//
//  Created by Chaos on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface CMSThreeImage7x3ItemConfig : SAModel

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *titleColor;
@property (nonatomic, assign) NSUInteger titleFont;
@property (nonatomic, copy) NSString *link;

@end

NS_ASSUME_NONNULL_END
