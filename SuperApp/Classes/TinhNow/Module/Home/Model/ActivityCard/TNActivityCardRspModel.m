//
//  TNActivityCardRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityCardRspModel.h"
#import "HDAppTheme+TinhNow.h"


@implementation TNActivityCardRspModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backGroundColor = HDAppTheme.TinhNowColor.G5;
    }
    return self;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [TNActivityCardModel class]};
}
- (CGFloat)cellHeight {
    CGFloat height = 0;
    if (!HDIsArrayEmpty(self.list)) {
        for (TNActivityCardModel *model in self.list) {
            height += model.cellHeight;
        }
        NSArray *filterArr = [self.list hd_filterWithBlock:^BOOL(TNActivityCardModel *_Nonnull item) {
            return item.cardStyle != TNActivityCardStyleText;
        }];
        if (self.scene == TNActivityCardSceneIndex && filterArr.count > 1) {
            //加上间距线
            height += kRealWidth(10) * (filterArr.count - 1);
        }
    }
    return height;
}
- (void)setIsSpecialStyleVertical:(BOOL)isSpecialStyleVertical {
    _isSpecialStyleVertical = isSpecialStyleVertical;
    if (!HDIsArrayEmpty(self.list)) {
        [self.list enumerateObjectsUsingBlock:^(TNActivityCardModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.isSpecialStyleVertical = isSpecialStyleVertical;
        }];
    }
}
@end
