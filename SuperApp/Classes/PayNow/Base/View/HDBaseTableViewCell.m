//
//  HDBaseTableViewCell.m
//  customer
//
//  Created by 陈剑 on 2018/7/4.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDBaseTableViewCell.h"
#import "HDKitCore/HDFrameLayout.h"
#import <Masonry/Masonry.h>


@implementation HDBaseTableViewCellModel

@end


@interface HDBaseTableViewCell ()
@end


@implementation HDBaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 新建标识
    static NSString *ID = @"HDBaseTableViewCell";

    // 创建cell
    HDBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return true;
}

#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
    const CGFloat iconW = 60;
    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(iconW);
        make.height.hd_equalTo(iconW);
        make.top.hd_equalTo(15);
        make.left.hd_equalTo(15);
    }];
    circle.skeletonCornerRadius = iconW * 0.5;

    CGFloat margin = 10;
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(150);
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(circle.hd_right + margin);
        make.top.hd_equalTo(circle.hd_top + 5);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(kScreenWidth - r1.hd_left - 15);
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(r1.hd_left);
        make.top.hd_equalTo(r1.hd_bottom + 8);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.width.hd_equalTo(60);
        make.top.hd_equalTo(r2.hd_bottom + 8);
        make.height.hd_equalTo(20);
    }];
    return @[circle, r1, r2, r3];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

#pragma mark - public methods
+ (CGFloat)skeletonViewHeight {
    return kRealWidth(110);
}
@end
