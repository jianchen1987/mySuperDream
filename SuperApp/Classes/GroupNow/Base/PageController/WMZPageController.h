//
//  WMZPageController.h
//  WMZPageController
//
//  Created by wmz on 2019/9/22.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "GNViewController.h"
#import "WMZPageView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMZPageController : GNViewController <WMZPageScrollProcotol>
/// pageView
@property (nonatomic, strong) WMZPageView *pageView;

@end

NS_ASSUME_NONNULL_END
