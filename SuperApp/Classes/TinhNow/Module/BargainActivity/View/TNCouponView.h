//
//  TNCouponView.h
//  SuperApp
//
//  Created by xixi on 2021/3/30.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNCouponItemView : TNView
- (instancetype)initWithFrame:(CGRect)frame data:(id)dataModel;
@end


@interface TNCouponView : TNView
///
@property (nonatomic, strong) NSArray *couponArray;

///
@property (nonatomic, assign) CGFloat maxY;
@end

NS_ASSUME_NONNULL_END
