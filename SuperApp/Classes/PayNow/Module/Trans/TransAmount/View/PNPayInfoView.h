//
//  InfoView.h
//  SuperApp
//
//  Created by Quin on 2021/11/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNTypeModel.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPayInfoView : PNView
@property (nonatomic, strong) NSMutableArray<PNTypeModel *> *arr;
@property (nonatomic, strong) UILabel *lastLB;
@end

NS_ASSUME_NONNULL_END
