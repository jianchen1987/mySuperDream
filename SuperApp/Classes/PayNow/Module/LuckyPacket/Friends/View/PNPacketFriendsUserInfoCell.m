//
//  PNPacketFriendsUserInfoCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketFriendsUserInfoCell.h"
#import "PNPacketFriendsUserModel.h"


@interface PNPacketFriendsUserInfoCell ()
@property (nonatomic, strong) HDUIButton *selectBtn;
@property (nonatomic, strong) UIImageView *userIconImgView;
@property (nonatomic, strong) SALabel *tagLabel;
@property (nonatomic, strong) SALabel *nameLabel;
///
@property (nonatomic, strong) SALabel *contentLabel;
@property (nonatomic, strong) HDUIButton *moreBtn;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) UIBezierPath *maskPath;
@end


@implementation PNPacketFriendsUserInfoCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.selectBtn];
    [self.bgView addSubview:self.userIconImgView];
    [self.bgView addSubview:self.tagLabel];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.contentLabel];
    [self.bgView addSubview:self.moreBtn];
    [self.bgView addSubview:self.line];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    if (!self.selectBtn.hidden) {
        [self.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
            make.centerY.mas_equalTo(self.userIconImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kRealWidth(32), kRealWidth(32)));
        }];
    }

    [self.userIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(12));
        if (!self.selectBtn.hidden) {
            make.left.mas_equalTo(self.selectBtn.mas_right).offset(kRealWidth(4));
        } else {
            make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        }
        make.size.mas_equalTo(CGSizeMake(kRealWidth(40), kRealWidth(40)));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-kRealWidth(12));
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userIconImgView.mas_right).offset(kRealWidth(8));
        make.top.mas_equalTo(self.userIconImgView.mas_top).offset(kRealWidth(4));
        if (self.tagLabel.hidden) {
            make.right.mas_equalTo(self.bgView.mas_right);
        } else {
            make.right.mas_equalTo(self.tagLabel.mas_left).offset(-kRealWidth(12));
        }
    }];

    if (!self.tagLabel.hidden) {
        [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(kRealWidth(12));
            make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
            make.top.mas_equalTo(self.nameLabel.mas_top);
        }];

        [self.tagLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.tagLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }

    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(6));
        if (!self.moreBtn.hidden) {
            make.right.mas_equalTo(self.moreBtn.mas_left).offset(-kRealWidth(8));
        } else {
            make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        }
    }];
    [self.contentLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    if (!self.moreBtn.hidden) {
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bgView.mas_right);
            make.centerY.mas_equalTo(self.contentLabel.mas_centerY);
        }];

        [self.moreBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userIconImgView.mas_left);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-1);
        make.right.mas_equalTo(self.bgView.mas_right);
        if (self.isLastCell) {
            make.height.equalTo(@(0));
        } else {
            make.height.equalTo(@(1));
        }
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNPacketFriendsUserModel *)model {
    _model = model;

    if (!self.isSingle) {
        self.selectBtn.hidden = NO;
        self.selectBtn.selected = model.isSelected;
    } else {
        self.selectBtn.hidden = YES;
    }

    self.nameLabel.text = model.userName ?: @" ";

    if ([self.friendsSectionFlag isEqualToString:kSelectedFlag]) {
        self.moreBtn.hidden = YES;
        self.tagLabel.hidden = YES;

        if (!WJIsArrayEmpty(model.otherUser)) {
            NSString *str = @"";
            if (model.otherUser.count == 1) {
                str = self.model.userPhone;
            } else {
                for (int i = 0; i < model.otherUser.count; i++) {
                    PNPacketFriendsUserModel *itemModel = [model.otherUser objectAtIndex:i];
                    if (i == 0) {
                        str = [str stringByAppendingFormat:@"(%@),", [self maskMobile:itemModel.userPhone]];
                    } else {
                        str = [str stringByAppendingFormat:@"%@(%@),", itemModel.userName ?: @"", [self maskMobile:itemModel.userPhone]];
                    }
                }

                str = [str stringByReplacingCharactersInRange:NSMakeRange(str.length - 1, 1) withString:@""];
            }
            self.contentLabel.text = str;
        } else {
            self.contentLabel.text = self.model.userPhone;
        }

    } else {
        if (!WJIsArrayEmpty(model.otherUser)) {
            NSString *str = @"";
            if (model.otherUser.count == 1) {
                str = self.model.userPhone;
                self.moreBtn.hidden = YES;
            } else {
                for (int i = 0; i < model.otherUser.count; i++) {
                    PNPacketFriendsUserModel *itemModel = [model.otherUser objectAtIndex:i];
                    if (i == 0) {
                        str = [str stringByAppendingFormat:@"(%@),", [self maskMobile:itemModel.userPhone]];
                    } else {
                        str = [str stringByAppendingFormat:@"%@(%@),", itemModel.userName ?: @"", [self maskMobile:itemModel.userPhone]];
                    }
                }

                str = [str stringByReplacingCharactersInRange:NSMakeRange(str.length - 1, 1) withString:@""];

                self.moreBtn.hidden = NO;
            }
            self.contentLabel.text = str;
        } else {
            self.contentLabel.text = self.model.userPhone;
            self.moreBtn.hidden = YES;
        }

        self.tagLabel.hidden = NO;
        if (model.isMe && model.otherUser.count == 1) {
            self.tagLabel.text = PNLocalizedString(@"pn_me", @"Me");
            self.tagLabel.textColor = [UIColor hd_colorWithHexString:@"#0085FF"];
            self.tagLabel.layer.borderColor = [UIColor hd_colorWithHexString:@"#0085FF"].CGColor;
        } else {
            self.tagLabel.text = PNLocalizedString(@"pn_recent_send", @"最近发过红包");
            self.tagLabel.textColor = HDAppTheme.PayNowColor.mainThemeColor;
            self.tagLabel.layer.borderColor = HDAppTheme.PayNowColor.mainThemeColor.CGColor;
        }
    }

    [HDWebImageManager setImageWithURL:self.model.headUrl placeholderImage:[UIImage imageNamed:@"pn_default_user_neutral"] imageView:self.userIconImgView];

    [self setNeedsUpdateConstraints];
}

- (NSString *)maskMobile:(NSString *)mobile {
    if (mobile.length < 4) {
        return mobile;
    } else {
        NSString *newMobile = [mobile stringByReplacingCharactersInRange:NSMakeRange(0, mobile.length - 3) withString:@"***"];

        return newMobile;
    }
}

- (void)setIsLastCell:(BOOL)isLastCell {
    _isLastCell = isLastCell;

    //    [self setRadius];
    [self setNeedsUpdateConstraints];
}

//- (void)setRadius {
//    if (self.isLastCell) {
//        CGRect rect = self.bounds;
//        self.maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(kRealWidth(10), kRealWidth(10))];
//        self.maskLayer.frame = rect;
//        self.maskLayer.path = self.maskPath.CGPath;
////        self.maskLayer.masksToBounds = YES;
////        self.maskLayer.strokeColor = HDAppTheme.PayNowColor.cFFFFFF.CGColor;
////        self.maskLayer.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF.CGColor;
////        self.maskLayer.borderColor = HDAppTheme.PayNowColor.cFFFFFF.CGColor;
////        self.maskLayer.shadowColor = HDAppTheme.PayNowColor.cFFFFFF.CGColor;
//        [self.bgView.layer insertSublayer:self.maskLayer atIndex:0];
////        self.bgView.layer.mask = self.maskLayer;
//    } else {
//        [self.maskLayer removeFromSuperlayer];
//    }
//}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;

        _bgView = view;
    }
    return _bgView;
}

- (HDUIButton *)selectBtn {
    if (!_selectBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"pn_friends_select_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pn_friends_select_select"] forState:UIControlStateSelected];

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            @HDStrongify(self);
            btn.selected = !btn.selected;

            self.model.isSelected = btn.selected;

            !self.selectBlock ?: self.selectBlock(self.model);
        }];

        _selectBtn = button;
    }
    return _selectBtn;
}

- (UIImageView *)userIconImgView {
    if (!_userIconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _userIconImgView = imageView;
    }
    return _userIconImgView;
}

- (SALabel *)nameLabel {
    if (!_nameLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14M;
        _nameLabel = label;
    }
    return _nameLabel;
}

- (SALabel *)tagLabel {
    if (!_tagLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.font = HDAppTheme.PayNowFont.standard11;
        label.layer.cornerRadius = kRealWidth(2);
        label.layer.borderWidth = 1;
        label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(2), kRealWidth(8), kRealWidth(2), kRealWidth(8));
        _tagLabel = label;
    }
    return _tagLabel;
}

- (SALabel *)contentLabel {
    if (!_contentLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard11;
        _contentLabel = label;
    }
    return _contentLabel;
}

- (HDUIButton *)moreBtn {
    if (!_moreBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];

        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:PNLocalizedString(@"VIEW_TITLE_DESCRIBE", @"详情")];
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, title.length)];
        [button setAttributedTitle:title forState:UIControlStateNormal];

        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard12;
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(8), kRealWidth(kRealWidth(4)), kRealWidth(12));
        button.hidden = YES;
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            [HDMediator.sharedInstance navigaveToLuckPacketRecordsVC:@{
                @"index": @(1),
            }];
        }];

        _moreBtn = button;
    }
    return _moreBtn;
}

- (UIView *)line {
    if (!_line) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _line = view;
    }
    return _line;
}

- (UIBezierPath *)maskPath {
    if (!_maskPath) {
        _maskPath = [[UIBezierPath alloc] init];
    }
    return _maskPath;
}

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
    }
    return _maskLayer;
}
@end
