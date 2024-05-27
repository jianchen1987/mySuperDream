//
//  SAOrderListFilterCollectionTimeRangeReusableView.h
//  SuperApp
//
//  Created by Tia on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderListFilterCollectionTimeRangeReusableView : UICollectionReusableView

@property (nonatomic, copy) void (^chooseDateBlock)(BOOL isEndDate);

- (void)updateStartDate:(NSString *)startDate endDate:(NSString *)endDate;

@end

NS_ASSUME_NONNULL_END
