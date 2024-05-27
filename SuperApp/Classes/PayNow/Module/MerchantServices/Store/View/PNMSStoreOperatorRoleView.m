//
//  PNMSStoreOperatorRoleView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreOperatorRoleView.h"


@interface PNMSStoreOperatorRoleView ()
@property (nonatomic, strong) SALabel *titleLabel;
/// 店长
@property (nonatomic, strong) HDUIButton *shopownerBtn;
/// 店员
@property (nonatomic, strong) HDUIButton *clerkBtn;
@property (nonatomic, strong) UIView *line;

@end


@implementation PNMSStoreOperatorRoleView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    [self addSubview:self.titleLabel];
    [self addSubview:self.shopownerBtn];
    [self addSubview:self.clerkBtn];
    [self addSubview:self.line];
}

- (void)updateConstraints {
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.top.bottom.equalTo(self);
        if (!self.shopownerBtn.hidden) {
            make.right.mas_equalTo(self.shopownerBtn.mas_left).offset(kRealWidth(12));
        } else {
            make.right.mas_equalTo(self.clerkBtn.mas_left).offset(kRealWidth(12));
        }
    }];

    if (!self.clerkBtn.hidden) {
        [self.clerkBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }

    if (!self.shopownerBtn.hidden) {
        if (self.clerkBtn.hidden) {
            [self.shopownerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
                make.centerY.mas_equalTo(self.mas_centerY);
            }];
        } else {
            [self.shopownerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.mas_centerY);
                make.right.mas_equalTo(self.clerkBtn.mas_left).offset(-kRealWidth(16));
            }];
        }
    }

    if (!self.shopownerBtn.hidden) {
        [self.shopownerBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }

    if (!self.clerkBtn.hidden) {
        [self.clerkBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(PixelOne));
        make.left.equalTo(self).offset(kRealWidth(12));
        make.right.equalTo(self).offset(-kRealWidth(12));
        make.bottom.equalTo(self).offset(-1);
    }];
    [super updateConstraints];
}

- (void)shopownerBtnAction {
    if (self.shopownerBtn.selected) {
        return;
    }
    self.shopownerBtn.selected = !self.shopownerBtn.selected;
    self.clerkBtn.selected = !self.shopownerBtn.selected;
    !self.selectBlock ?: self.selectBlock(PNMSRoleType_STORE_MANAGER);
}

- (void)clerkBtnAction {
    if (self.clerkBtn.selected) {
        return;
    }
    self.clerkBtn.selected = !self.clerkBtn.selected;
    self.shopownerBtn.selected = !self.clerkBtn.selected;
    !self.selectBlock ?: self.selectBlock(PNMSRoleType_STORE_STAFF);
}

- (void)setRole:(PNMSRoleType)role {
    _role = role;
    if (self.role == PNMSRoleType_STORE_MANAGER) {
        self.shopownerBtn.selected = YES;
        self.clerkBtn.selected = NO;
    } else if (self.role == PNMSRoleType_STORE_STAFF) {
        self.shopownerBtn.selected = NO;
        self.clerkBtn.selected = YES;
    }
}

- (void)setShowDataArray:(NSArray<NSNumber *> *)showDataArray {
    _showDataArray = showDataArray;
    if ([self.showDataArray containsObject:@(PNMSRoleType_STORE_MANAGER)]) {
        self.shopownerBtn.hidden = NO;
    }
    if ([self.showDataArray containsObject:@(PNMSRoleType_STORE_STAFF)]) {
        self.clerkBtn.hidden = NO;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.text = PNLocalizedString(@"pn_Staff_role", @"店员角色");
        label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(16), 0, kRealWidth(16), 0);
        _titleLabel = label;
    }
    return _titleLabel;
}

- (HDUIButton *)shopownerBtn {
    if (!_shopownerBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_store_manager_2", @"店长") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.c333333 forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14M;
        [button setImage:[UIImage imageNamed:@"pn_icon_radio_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pn_icon_radio_select"] forState:UIControlStateSelected];
        button.hidden = YES;
        [button addTarget:self action:@selector(shopownerBtnAction) forControlEvents:UIControlEventTouchUpInside];

        _shopownerBtn = button;
    }
    return _shopownerBtn;
}

- (HDUIButton *)clerkBtn {
    if (!_clerkBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_store_Staff", @"店员") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.c333333 forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14M;
        [button setImage:[UIImage imageNamed:@"pn_icon_radio_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pn_icon_radio_select"] forState:UIControlStateSelected];
        button.spacingBetweenImageAndTitle = kRealWidth(5);
        button.hidden = YES;
        [button addTarget:self action:@selector(clerkBtnAction) forControlEvents:UIControlEventTouchUpInside];

        _clerkBtn = button;
    }
    return _clerkBtn;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _line;
}
@end
