//
//  FlowView.h
//  SuperApp
//
//  Created by Quin on 2021/11/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNTypeModel.h"
#import "PNView.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface PNFlowView : PNView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SALabel *titleLB;
@property (nonatomic, strong) NSMutableArray<PNTypeModel *> *arr;
@property (nonatomic, strong) UIView *lastView;

/// type [0 开通 、 1 激活]
- (instancetype)initWithType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
