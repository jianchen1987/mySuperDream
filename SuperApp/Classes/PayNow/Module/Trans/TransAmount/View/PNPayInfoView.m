//
//  InfoView.m
//  SuperApp
//
//  Created by Quin on 2021/11/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNPayInfoView.h"


@implementation PNPayInfoView
- (void)hd_setupViews {
}
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
#pragma mark - layout
- (void)updateConstraints {
    for (int i = 0; i < self.arr.count; i++) {
        PNTypeModel *model = self.arr[i];
        UILabel *nameLB = UILabel.new;
        nameLB.text = model.name;
        nameLB.font = [HDAppTheme.font forSize:15];
        ;
        nameLB.textColor = HDAppTheme.PayNowColor.c9599A2;
        nameLB.textAlignment = NSTextAlignmentLeft;

        UILabel *valueLB = UILabel.new;
        valueLB.text = model.value;
        valueLB.font = [HDAppTheme.font boldForSize:15];
        ;
        valueLB.textColor = HDAppTheme.PayNowColor.c343B4D;
        [self addSubview:nameLB];
        [self addSubview:valueLB];
        [nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            if (i == 0) {
                make.top.equalTo(self);
            } else {
                make.top.equalTo(self.lastLB.mas_bottom).offset(kRealWidth(10));
            }
        }];
        [valueLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(nameLB);
        }];
        self.lastLB = nameLB;
    }
    [super updateConstraints];
}

#pragma mark - lazy load
- (NSMutableArray<PNTypeModel *> *)arr {
    if (!_arr) {
        _arr = [NSMutableArray arrayWithCapacity:0];
    }
    return _arr;
}
@end
