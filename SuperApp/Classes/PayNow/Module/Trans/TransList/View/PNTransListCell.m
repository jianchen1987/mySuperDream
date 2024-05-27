//
//  TransListCell.m
//  SuperApp
//
//  Created by Quin on 2021/11/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNTransListCell.h"
#import "PNCommonUtils.h" //工具
#import "PNUtilMacro.h"
#import "SAAppEnvManager.h"


@implementation PNTransListCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TransListCell";
    PNTransListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 去除选中样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 初始化子控件
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImg];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.accountLabel];
    [self.bgView addSubview:self.collecButton];
    [self.bgView addSubview:self.lineView];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.bottom.equalTo(self.lineView.mas_bottom);
    }];
    [self.iconImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(15));
        make.width.mas_equalTo(kRealWidth(45));
        make.height.mas_equalTo(kRealWidth(45));
    }];

    if (!self.titleLabel.hidden) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.iconImg.mas_centerY).offset(-kRealWidth(2));
            make.left.equalTo(self.iconImg.mas_right).offset(kRealWidth(10));
            make.right.equalTo(self.collecButton.mas_left).offset(-kRealWidth(10));
        }];
    }

    [self.accountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.titleLabel.hidden) {
            make.top.equalTo(self.iconImg.mas_centerY).offset(kRealWidth(2));
        } else {
            make.centerY.mas_equalTo(self.iconImg.mas_centerY);
        }
        make.left.equalTo(self.iconImg.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.collecButton.mas_left).offset(-kRealWidth(10));
    }];
    [self.collecButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(15));
        make.width.mas_equalTo(kRealWidth(22));
        make.height.mas_equalTo(kRealWidth(22));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom);
        make.left.equalTo(self.accountLabel.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.collecButton.mas_right);
        if (self.isLastCell) {
            make.height.mas_equalTo(0);
        } else {
            make.height.mas_equalTo(HDAppTheme.value.pixelOne);
        }
    }];

    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)collecTap {
    !self.collecBlock ?: self.collecBlock(self.model);
}

#pragma mark - getters and setters
- (void)setModel:(PNTransListModel *)model {
    _model = model;
    // 1001-转账到个人 1002-转账到bakong 1003-转账到银行
    PNTransferType type = model.bizEntity;
    if ([type isEqualToString:PNTransferTypeToCoolcash]) {
        [_iconImg sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"CoolCash"]];
    } else if ([type isEqualToString:PNTransferTypePersonalToBaKong]) {
        [_iconImg sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"toBakong"]];
    } else if ([type isEqualToString:PNTransferTypePersonalToBank]) {
        [_iconImg sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"toBank1"]];
    } else if ([type isEqualToString:PNTransferTypeToPhone]) {
        [_iconImg sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"pn_trans_to_phone"]];
    } else {
        [_iconImg sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"toBank1"]];
    }

    _titleLabel.text = [NSString stringWithFormat:@"%@ %@", model.realNameFirst.length > 0 ? model.realNameFirst : @"", model.realNameEnd.length > 0 ? model.realNameEnd : @""];
    _accountLabel.text = [PNCommonUtils deSensitiveString:model.mobilePhone];

    if (model.flag == 1) { ///已收藏
        [self.collecButton setImage:[UIImage imageNamed:@"SelectStars"] forState:UIControlStateNormal];
    } else {
        [self.collecButton setImage:[UIImage imageNamed:@"noSelectStars"] forState:UIControlStateNormal];
    }

    if (WJIsStringEmpty(model.realNameFirst) && WJIsStringEmpty(model.realNameEnd)) {
        self.titleLabel.hidden = YES;
        self.accountLabel.font = [HDAppTheme.font boldForSize:15];
        ;
        self.accountLabel.textColor = HDAppTheme.PayNowColor.c343B4D;
    } else {
        self.titleLabel.hidden = NO;
        self.accountLabel.font = [HDAppTheme.font forSize:14];
        self.accountLabel.textColor = HDAppTheme.PayNowColor.c9599A2;
    }

    [self setNeedsUpdateConstraints];
}
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = UIView.new;
        view.backgroundColor = [UIColor whiteColor];
        _bgView = view;
    }
    return _bgView;
}
- (UIImageView *)iconImg {
    if (!_iconImg) {
        UIImageView *imageView = UIImageView.new;
        _iconImg = imageView;
    }
    return _iconImg;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:15];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.numberOfLines = 0;
        _titleLabel = label;
    }
    return _titleLabel;
}
- (SALabel *)accountLabel {
    if (!_accountLabel) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font forSize:14];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.numberOfLines = 0;
        _accountLabel = label;
    }
    return _accountLabel;
}
- (UIButton *)collecButton {
    if (!_collecButton) {
        UIButton *btn = UIButton.new;
        [btn addTarget:self action:@selector(collecTap) forControlEvents:UIControlEventTouchUpInside];
        _collecButton = btn;
    }
    return _collecButton;
}
- (UIView *)lineView {
    if (!_lineView) {
        UIView *view = UIView.new;
        view.backgroundColor = HDAppTheme.PayNowColor.cECECEC;
        _lineView = view;
    }
    return _lineView;
}
@end
