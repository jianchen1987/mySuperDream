//
//  SAStorkeColorLabel.m
//  SuperApp
//
//  Created by VanJay on 2020/7/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAStorkeColorLabel.h"
#import "SAView.h"


@interface SAStorkeColorLabel ()
/// 内边距
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
/// 角标
@property (nonatomic, strong) SALabel *badgeNumberLB;
@end


@implementation SAStorkeColorLabel
- (instancetype)initWidthContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    if (self = [super init]) {
        self.userInteractionEnabled = false;
        self.backgroundColor = UIColor.whiteColor;
        self.contentEdgeInsets = contentEdgeInsets;
        [self addSubview:self.badgeNumberLB];
        self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5];
        };
    }
    return self;
}

#pragma mark - override
- (CGSize)sizeThatFits:(CGSize)size {
    CGSize badgeNumberLBSize =
        [self.badgeNumberLB sizeThatFits:CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets), size.height - UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets))];
    if (badgeNumberLBSize.width < badgeNumberLBSize.height) {
        badgeNumberLBSize.width = badgeNumberLBSize.height;
    }
    self.badgeNumberLB.size = badgeNumberLBSize;
    CGSize fittingSize = CGSizeMake(badgeNumberLBSize.width + UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets), badgeNumberLBSize.height + UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets));
    return fittingSize;
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];

    if (CGRectIsEmpty(self.frame))
        return;

    self.badgeNumberLB.frame = (CGRect){self.contentEdgeInsets.left, self.contentEdgeInsets.top, self.badgeNumberLB.size};
}

#pragma mark - lazy load
- (SALabel *)badgeNumberLB {
    if (!_badgeNumberLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4Bold;
        label.textColor = UIColor.whiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor hd_colorWithHexString:@"#FF2323"];
        label.hd_edgeInsets = UIEdgeInsetsMake(1.5, 4, 1.5, 4);
        label.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5];
        };
        label.numberOfLines = 1;
        _badgeNumberLB = label;
    }
    return _badgeNumberLB;
}
@end
