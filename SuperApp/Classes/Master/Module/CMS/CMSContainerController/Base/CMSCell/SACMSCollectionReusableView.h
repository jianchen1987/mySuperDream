//
//  SACMSCollectionReusableView.h
//  SuperApp
//
//  Created by seeu on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACollectionReusableView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACMSCollectionReusableView : SACollectionReusableView
///< 自定义视图
@property (nonatomic, strong) UIView *customeView;
@end

NS_ASSUME_NONNULL_END
