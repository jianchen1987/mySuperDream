//
//  TNBargainStrategyCell.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainStrategyCell.h"
#import "TNAdaptHeightImagesView.h"


@interface TNBargainStrategyCell ()
/// 背景视图
@property (strong, nonatomic) TNAdaptHeightImagesView *bgView;
@end


@implementation TNBargainStrategyCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
}
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(20));
    }];
    [super updateConstraints];
}
- (void)setRulePics:(NSArray<TNAdaptImageModel *> *)rulePics {
    _rulePics = rulePics;
    if (!HDIsArrayEmpty(rulePics)) {
        self.bgView.images = rulePics;
        @HDWeakify(self);
        self.bgView.getRealImageSizeAndIndexCallBack = ^(NSInteger index, CGFloat imageHeight) {
            @HDStrongify(self);
            if (self.getRealImageSizeCallBack) {
                self.getRealImageSizeCallBack(index, imageHeight);
            }
        };
    }
    [self setNeedsUpdateConstraints];
}

/** @lazy bigView */
- (TNAdaptHeightImagesView *)bgView {
    if (!_bgView) {
        _bgView = [[TNAdaptHeightImagesView alloc] init];
    }
    return _bgView;
}
@end
