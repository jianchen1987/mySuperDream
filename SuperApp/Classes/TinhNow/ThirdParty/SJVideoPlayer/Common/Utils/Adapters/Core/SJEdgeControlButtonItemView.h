//
//  SJEdgeControlButtonItemView.h
//  SJVideoPlayer
//
//  Created by 畅三江 on 2018/10/19.
//  Copyright © 2018 畅三江. All rights reserved.
//

#import "SJEdgeControlButtonItem.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SJEdgeControlButtonItemView : UIControl
@property (nonatomic, strong, nullable) SJEdgeControlButtonItem *item;

- (void)reloadItemIfNeeded;
@end
NS_ASSUME_NONNULL_END
