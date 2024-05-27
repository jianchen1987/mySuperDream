//
//  TNBargainRuleModel.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainRuleModel.h"
#import "TNAdaptImageModel.h"


@implementation TNBargainRuleModel
- (void)setGuidePics:(NSString *)guidePics {
    _guidePics = guidePics;
    if (HDIsStringNotEmpty(guidePics)) {
        NSData *data = [guidePics dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (!HDIsArrayEmpty(arr)) {
            self.rulePics = [TNAdaptImageModel getAdaptImageModelsByImagesStrs:arr];
        }
    }
}

@end
