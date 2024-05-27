//
//  PayOrderTableHeaderView.h
//  SuperApp
//
//  Created by Quin on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNOrderTableHeaderViewModel.h"
#import "PNView.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface PNOrderTableHeaderView : PNView
@property (nonatomic, strong) PNOrderTableHeaderViewModel *model;

@property (nonatomic, assign) PNOrderResultPageType type; // 1结果页 否则详情页
@end

NS_ASSUME_NONNULL_END
