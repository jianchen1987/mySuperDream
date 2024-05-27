//
//  SAImFeedbackOptionModel.m
//  SuperApp
//
//  Created by Tia on 2023/3/3.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAImFeedbackOptionModel.h"


@implementation SAImFeedbackOptionModel

- (void)setName:(SAInternationalizationModel *)name {
    self.width = [name.desc boundingAllRectWithSize:CGSizeMake(MAXFLOAT, kRealWidth(28)) font:[UIFont systemFontOfSize:12 weight:UIFontWeightMedium] lineSpacing:0].width + 32;

    [super setName:name];
}


@end
