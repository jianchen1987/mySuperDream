//
//  SANewVersionAlertView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SANewVersionAlertView : UIScrollView

@property (nonatomic, strong) UIImageView *logo; ///< logo
@property (nonatomic, strong) UILabel *title;    ///< 标题
@property (nonatomic, strong) UILabel *content;  ///< 内容

@end

NS_ASSUME_NONNULL_END
