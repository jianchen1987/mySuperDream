//
//  GNStoreViewCell.m
//  SuperApp
//
//  Created by wmz on 2021/5/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreViewCell.h"
#import "GNStoreView.h"
#import "HDMediator+GroupOn.h"


@interface GNStoreViewCell ()

@property (nonatomic, strong) GNStoreView *view;

@end


@implementation GNStoreViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.view];
}

- (void)updateConstraints {
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [super updateConstraints];
}

- (void)setGNModel:(GNStoreCellModel *)data {
    self.view.model = data;
    self.contentView.backgroundColor = HDAppTheme.color.gn_whiteColor;
}

- (void)storeClickz:(UITapGestureRecognizer *)ta {
    [self.viewController.view endEditing:YES];
    [HDMediator.sharedInstance navigaveToGNStoreDetailViewController:@{@"storeNo": GNFillEmpty(self.view.model.storeNo), @"source": self.view.model.source}];
}

#pragma mark - lazy load
- (GNStoreView *)view {
    if (!_view) {
        _view = GNStoreView.new;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeClickz:)];
        [_view addGestureRecognizer:tap];
    }
    return _view;
}

#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    CGFloat margin = kRealWidth(8);
    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
    r0.skeletonCornerRadius = kRealWidth(8);
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(kRealHeight(80));
        make.width.hd_equalTo(kRealWidth(80));
        make.top.hd_equalTo(kRealWidth(12));
        make.left.hd_equalTo(kRealWidth(12));
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(kRealWidth(200));
        make.height.hd_equalTo(kRealWidth(24));
        make.left.hd_equalTo(r0.hd_right + margin);
        make.top.hd_equalTo(r0.hd_top - kRealWidth(4));
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.width.hd_equalTo(kRealWidth(150));
        make.top.hd_equalTo(r1.hd_bottom + margin);
        make.height.hd_equalTo(kRealWidth(20));
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.width.hd_equalTo(kRealWidth(120));
        make.top.hd_equalTo(r3.hd_bottom + margin);
        make.height.hd_equalTo(r3.hd_height);
    }];
    return @[r0, r1, r3, r4];
}

+ (CGFloat)skeletonViewHeight {
    return kRealWidth(104);
}

@end
