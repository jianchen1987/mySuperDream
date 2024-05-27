//
//  GNTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/1.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNTableViewCell.h"


@implementation GNTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *_Nullable)identifier {
    if (HDIsStringEmpty(identifier)) {
        identifier = NSStringFromClass(self);
    }
    // 创建 cell
    GNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.contentView.clipsToBounds = YES;
    return cell;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HDAppTheme.color.gn_lineColor;
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(HDAppTheme.value.gn_line);
            make.left.mas_equalTo(HDAppTheme.value.gn_marginL);
            make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
        }];
    }
    return _lineView;
}

- (CAGradientLayer *)addShadom:(CGRect)rect {
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = rect;
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[
        (__bridge id)[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.0].CGColor,
        (__bridge id)[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.8].CGColor
    ];
    gl.locations = @[@(0), @(1.0f)];
    return gl;
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    const CGFloat iconW = 80;
    CGFloat margin = 10;

    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(100);
        make.height.hd_equalTo(20);
        make.top.hd_equalTo(15);
        make.left.hd_equalTo(15);
    }];

    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
    circle.skeletonCornerRadius = 8;
    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(iconW);
        make.height.hd_equalTo(iconW);
        make.top.hd_equalTo(r0.hd_bottom + margin);
        make.left.hd_equalTo(15);
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.right.hd_equalTo(self.hd_width - 60);
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(circle.hd_right + margin);
        make.top.hd_equalTo(circle.hd_top);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.right.hd_equalTo(self.hd_width - 60);
        make.top.hd_equalTo(r1.hd_bottom + margin);
        make.height.hd_equalTo(20);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.right.hd_equalTo(self.hd_width - 60);
        make.top.hd_equalTo(r2.hd_bottom + margin);
        make.height.hd_equalTo(20);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(circle.hd_left);
        make.width.hd_equalTo(150);
        make.top.hd_equalTo(circle.hd_bottom + margin);
        make.height.hd_equalTo(r3.hd_height);
    }];
    return @[r0, circle, r1, r2, r3, r4];
}

+ (CGFloat)skeletonViewHeight {
    return 165;
}

@end
