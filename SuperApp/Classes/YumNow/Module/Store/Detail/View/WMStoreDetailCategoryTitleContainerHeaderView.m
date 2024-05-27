//
//  WMStoreDetailCategoryTitleContainerHeaderView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreDetailCategoryTitleContainerHeaderView.h"


@implementation WMStoreDetailCategoryTitleContainerHeaderView
#pragma mark - life cycle
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.whiteColor;
        self.contentView.backgroundColor = UIColor.whiteColor;
    }
    return self;
}
@end
