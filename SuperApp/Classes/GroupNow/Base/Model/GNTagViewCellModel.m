//
//  GNTagViewCellModel.m
//  SuperApp
//
//  Created by wmz on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNTagViewCellModel.h"
#import "GNTheme.h"


@implementation GNTagViewCellModel
- (instancetype)init {
    if (self = [super init]) {
        self.userEnable = YES;
        self.cornerRadius = kRealWidth(6);
        self.bgColor = HDAppTheme.color.gn_grayBgColor;
        self.bgSelectColor = HDAppTheme.color.gn_mainColor;
        self.textColor = HDAppTheme.color.gn_333Color;
        self.textSelectColor = HDAppTheme.color.gn_whiteColor;
        self.space = kRealWidth(32);
        self.collectionViewBgColor = HDAppTheme.color.gn_mainBgColor;
        self.contentInset = UIEdgeInsetsMake(HDAppTheme.value.gn_marginT, HDAppTheme.value.gn_marginL, HDAppTheme.value.gn_marginT, HDAppTheme.value.gn_marginL);
        self.minimumLineSpacing = HDAppTheme.value.gn_marginT;
        self.minimumInteritemSpacing = HDAppTheme.value.gn_marginT;
        self.itemSizeH = kRealHeight(26);
        self.textAligment = UIControlContentHorizontalAlignmentCenter;
    }
    return self;
}
- (NSArray *)tagArr {
    if (!_tagArr) {
        _tagArr = NSArray.new;
    }
    return _tagArr;
}
@end
