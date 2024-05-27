//
//  TNExpressContactCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/8/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNExpressContactCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNLeftCircleImageButton.h"
#import <HDServiceKit/HDSystemCapabilityUtil.h>


@interface TNExpressContactCell ()
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
/// 号码子标题
@property (strong, nonatomic) UILabel *phoneSubTitleLabel;
/// 号码标签
@property (nonatomic, strong) HDFloatLayoutView *phoneFloatLayoutView;
/// tg子标题
@property (strong, nonatomic) UILabel *tgSubTitleLabel;
/// tg标签
@property (nonatomic, strong) HDFloatLayoutView *tgFloatLayoutView;
@end


@implementation TNExpressContactCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.phoneSubTitleLabel];
    [self.contentView addSubview:self.phoneFloatLayoutView];
    [self.contentView addSubview:self.tgSubTitleLabel];
    [self.contentView addSubview:self.tgFloatLayoutView];
}
- (void)setModel:(TNExpressContactCellModel *)model {
    _model = model;
    if (!HDIsArrayEmpty(model.phones)) {
        self.phoneSubTitleLabel.hidden = NO;
        self.phoneFloatLayoutView.hidden = NO;
        [self.phoneFloatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (NSString *tag in model.phones) {
            TNLeftCircleImageButton *tagBtn = [self getTagWithTitle:tag image:[UIImage imageNamed:@"tn_express_phone"] backgroundColor:[UIColor colorWithRed:255 / 255.0 green:136 / 255.0
                                                                                                                                                        blue:24 / 255.0
                                                                                                                                                       alpha:0.2000]];
            tagBtn.size = [tagBtn getSizeFits];
            tagBtn.addTouchUpInsideHandler = ^(TNLeftCircleImageButton *_Nonnull btn) {
                if (HDIsStringNotEmpty(tag) && [tag hd_isPureDigitCharacters]) {
                    [HDSystemCapabilityUtil makePhoneCall:tag];
                }
            };
            [self.phoneFloatLayoutView addSubview:tagBtn];
        }
    } else {
        self.phoneSubTitleLabel.hidden = YES;
        self.phoneFloatLayoutView.hidden = YES;
    }

    if (!HDIsArrayEmpty(model.telegrams)) {
        self.tgSubTitleLabel.hidden = NO;
        self.tgFloatLayoutView.hidden = NO;
        [self.tgFloatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (NSString *tag in model.telegrams) {
            TNLeftCircleImageButton *tagBtn = [self getTagWithTitle:tag image:[UIImage imageNamed:@"tn_express_tg"] backgroundColor:[UIColor colorWithRed:24 / 255.0 green:148 / 255.0 blue:255 / 255.0
                                                                                                                                                    alpha:0.2000]];
            tagBtn.size = [tagBtn getSizeFits];
            tagBtn.addTouchUpInsideHandler = ^(TNLeftCircleImageButton *_Nonnull btn) {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://t.me/%@", tag]];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            };
            [self.tgFloatLayoutView addSubview:tagBtn];
        }
    } else {
        self.tgSubTitleLabel.hidden = YES;
        self.tgFloatLayoutView.hidden = YES;
    }
}
- (TNLeftCircleImageButton *)getTagWithTitle:(NSString *)title image:(UIImage *)image backgroundColor:(UIColor *)backgroundColor {
    TNLeftCircleImageButton *btn = [[TNLeftCircleImageButton alloc] init];
    btn.text = title;
    btn.textColor = HDAppTheme.TinhNowColor.G1;
    btn.textFont = HDAppTheme.TinhNowFont.standard12;
    btn.leftCircleImage = image;
    btn.backgroundColor = backgroundColor;
    btn.leftSpace = 5;
    btn.rightSpace = 8;
    return btn;
}
- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    if (!self.phoneFloatLayoutView.isHidden) {
        [self.phoneSubTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }];
        [self.phoneFloatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneSubTitleLabel.mas_bottom).offset(kRealWidth(5));
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
            //            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.size.mas_equalTo([self.phoneFloatLayoutView sizeThatFits:CGSizeMake(kScreenWidth - kRealWidth(30), MAXFLOAT)]);
            if (self.tgFloatLayoutView.isHidden) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
            }
        }];
    }
    if (!self.tgFloatLayoutView.isHidden) {
        [self.tgSubTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!self.phoneFloatLayoutView.isHidden) {
                make.top.equalTo(self.phoneFloatLayoutView.mas_bottom).offset(kRealWidth(15));
            } else {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
            }
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }];
        [self.tgFloatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tgSubTitleLabel.mas_bottom).offset(kRealWidth(5));
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
            //            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.size.mas_equalTo([self.tgFloatLayoutView sizeThatFits:CGSizeMake(kScreenWidth - kRealWidth(30), MAXFLOAT)]);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        }];
    }
    [super updateConstraints];
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:14];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.text = TNLocalizedString(@"mU9bFepw", @"物流联系方式");
    }
    return _titleLabel;
}
/** @lazy phoneSubTitleLabel */
- (UILabel *)phoneSubTitleLabel {
    if (!_phoneSubTitleLabel) {
        _phoneSubTitleLabel = [[UILabel alloc] init];
        _phoneSubTitleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:12];
        _phoneSubTitleLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _phoneSubTitleLabel.text = TNLocalizedString(@"tn_tf_contact", @"联系电话");
    }
    return _phoneSubTitleLabel;
}
/** @lazy tgSubTitleLabel */
- (UILabel *)tgSubTitleLabel {
    if (!_tgSubTitleLabel) {
        _tgSubTitleLabel = [[UILabel alloc] init];
        _tgSubTitleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:12];
        _tgSubTitleLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _tgSubTitleLabel.text = @"Telegram";
    }
    return _tgSubTitleLabel;
}
- (HDFloatLayoutView *)phoneFloatLayoutView {
    if (!_phoneFloatLayoutView) {
        _phoneFloatLayoutView = [[HDFloatLayoutView alloc] init];
        _phoneFloatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 20);
    }
    return _phoneFloatLayoutView;
}
- (HDFloatLayoutView *)tgFloatLayoutView {
    if (!_tgFloatLayoutView) {
        _tgFloatLayoutView = [[HDFloatLayoutView alloc] init];
        _tgFloatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 20);
    }
    return _tgFloatLayoutView;
}
@end


@implementation TNExpressContactCellModel

@end
