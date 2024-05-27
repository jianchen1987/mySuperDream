//
//  SAHomePickForYouCell.m
//  SuperApp
//
//  Created by Chaos on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNHomeChoicenessSkeletonCell.h"


@implementation TNHomeChoicenessSkeletonCellModel

@end


@interface TNHomeChoicenessSkeletonCell ()

@property (nonatomic, strong) UIView *emptyView; ///< 占位

@end


@implementation TNHomeChoicenessSkeletonCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.emptyView];
}

- (void)updateConstraints {
    [self.emptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(ChoicenessSkeletonCellHeight);
    }];
    [super updateConstraints];
}

#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *top1 = [[HDSkeletonLayer alloc] init];
    [top1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.top.hd_equalTo(self.contentView.hd_top);
        make.left.hd_equalTo(self.contentView.hd_left);
        make.right.hd_equalTo(self.contentView.hd_right);
        make.height.hd_equalTo(kRealWidth(kRealWidth(150)));
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(kRealWidth(20));
        make.left.hd_equalTo(self.contentView.hd_left + kRealWidth(10));
        make.right.hd_equalTo(self.contentView.hd_right - kRealWidth(10));
        make.top.hd_equalTo(top1.hd_bottom + kRealWidth(10));
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(kRealWidth(28));
        make.left.hd_equalTo(self.contentView.hd_left + kRealWidth(10));
        make.right.hd_equalTo(self.contentView.hd_right - kRealWidth(10));
        make.top.hd_equalTo(r1.hd_bottom + kRealWidth(10));
    }];


    //    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
    //    const CGFloat iconW = 60;
    //    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
    //        make.width.hd_equalTo(iconW);
    //        make.height.hd_equalTo(iconW);
    //        make.top.hd_equalTo(15);
    //        make.left.hd_equalTo(15);
    //    }];
    //    circle.skeletonCornerRadius = iconW * 0.5;
    //
    //    CGFloat margin = 10;
    //    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    //    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
    //        make.width.hd_equalTo(100);
    //        make.height.hd_equalTo(20);
    //        make.left.hd_equalTo(circle.hd_right + margin);
    //        make.top.hd_equalTo(circle.hd_top + 5);
    //    }];
    //
    //    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    //    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
    //        make.width.hd_equalTo(100);
    //        make.height.hd_equalTo(20);
    //        make.left.hd_equalTo(r1.hd_left);
    //        make.top.hd_equalTo(r1.hd_bottom + 8);
    //    }];
    //
    //    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    //    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
    //        make.left.hd_equalTo(r1.hd_left);
    //        make.width.hd_equalTo(60);
    //        make.top.hd_equalTo(r2.hd_bottom + 8);
    //        make.height.hd_equalTo(20);
    //    }];
    //
    //    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    //    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
    //        make.left.hd_equalTo(circle.hd_left);
    //        make.right.hd_equalTo(r1.hd_right);
    //        make.top.hd_equalTo(r3.hd_bottom + 15);
    //        make.height.hd_equalTo(20);
    //    }];
    //
    //    HDSkeletonLayer *r5 = [[HDSkeletonLayer alloc] init];
    //    [r5 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
    //        make.width.hd_equalTo(r4.hd_width);
    //        make.left.hd_equalTo(r4.hd_left);
    //        make.top.hd_equalTo(r4.hd_bottom + 10);
    //        make.height.hd_equalTo(20);
    //    }];

    //    return @[circle, r1, r2, r3, r4, r5];
    return @[top1, r1, r2];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

#pragma mark - lazy load
- (UIView *)emptyView {
    return _emptyView ?: ({ _emptyView = UIView.new; });
}

@end
