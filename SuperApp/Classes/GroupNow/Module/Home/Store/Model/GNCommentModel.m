//
//  GNCommentModel.m
//  SuperApp
//
//  Created by wmz on 2021/9/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCommentModel.h"


@implementation GNCommentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ids": @"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"reply": GNReviewModel.class,
    };
}

- (instancetype)init {
    if (self = [super init]) {
        self.num = 0;
    }
    return self;
}

- (NSString *)customerNameStr {
    if (!_customerNameStr) {
        _customerNameStr = self.customerName;
        if (self.customerName) {
            if (self.customerName.length > 1) {
                NSMutableString *mstr = [[NSMutableString alloc] initWithString:self.customerName];
                for (int i = 1; i < mstr.length; i++) {
                    [mstr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
                }
                _customerNameStr = mstr;
            }
        }
    }

    return _customerNameStr ?: @" ";
}

@end


@implementation GNReviewModel

@end
