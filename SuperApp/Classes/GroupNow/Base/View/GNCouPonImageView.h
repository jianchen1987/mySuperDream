//
//  GNCouPonImageView.h
//  SuperApp
//
//  Created by wmz on 2021/7/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface GNCouPonImageView : UIImageView

@property (nonatomic, strong) HDLabel *couponLB;

@property (nonatomic, assign) CGFloat leftOffset;

@property (nonatomic, assign) CGFloat rightOffset;
@end

NS_ASSUME_NONNULL_END
