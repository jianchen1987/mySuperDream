//
//  WMSpecialSignturesMoreCell.m
//  SuperApp
//
//  Created by wmz on 2021/7/1.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMSpecialSignturesMoreCell.h"
#import "NSString+SA_Extension.h"


@implementation WMViewMoreCollectionViewCellModel

@end


@interface WMSpecialSignturesMoreCell ()
/// 容器
@property (nonatomic, strong) UIView *containerView;
/// 名称
@property (nonatomic, strong) HDUIButton *titleLB;

@end


@implementation WMSpecialSignturesMoreCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.titleLB];
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(6)];
    };
    self.containerView.backgroundColor = HDAppTheme.WMColor.F1F1F1;
}

- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.containerView.mas_width).multipliedBy(2);
        make.left.top.equalTo(self.contentView);
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (UIView *)containerView {
    return _containerView ?: ({ _containerView = UIView.new; });
}

- (HDUIButton *)titleLB {
    if (!_titleLB) {
        HDUIButton *label = [HDUIButton buttonWithType:UIButtonTypeCustom];
        label.userInteractionEnabled = NO;
        label.titleLabel.font = HDAppTheme.font.standard4;
        [label setTitleColor:HDAppTheme.color.G3 forState:UIControlStateNormal];
        [label setImage:[UIImage imageNamed:@"yn_search_more"] forState:UIControlStateNormal];
        [label setTitle:WMLocalizedString(@"search_more", @"更多") forState:UIControlStateNormal];
        label.spacingBetweenImageAndTitle = kRealWidth(5);
        label.imagePosition = HDUIButtonImagePositionTop;
        _titleLB = label;
    }
    return _titleLB;
}
@end
