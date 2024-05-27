//
//  HDDealCommonInfoRowViewModel.m
//  customer
//
//  Created by VanJay on 2019/5/2.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDDealCommonInfoRowViewModel.h"
#import "HDAppTheme.h"
#import "HDCommonDefines.h"


@implementation HDDealCommonInfoRowViewModel

+ (instancetype)modelWithKey:(NSString *)key value:(NSString *)value {
    HDDealCommonInfoRowViewModel *model = [[HDDealCommonInfoRowViewModel alloc] init];
    model.key = key;
    model.value = value;
    return model;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置默认值
        _keyFont = [HDAppTheme.font standard3];
        _keyColor = [HDAppTheme.color G3];
        _keyTextAlignment = NSTextAlignmentLeft;
        _valueFont = [HDAppTheme.font standard3];
        _valueColor = [HDAppTheme.color G2];
        _valueTextAlignment = NSTextAlignmentRight;
        _minimumMargin = kRealWidth(10);
        _needRightArrow = NO;
    }
    return self;
}
@end
