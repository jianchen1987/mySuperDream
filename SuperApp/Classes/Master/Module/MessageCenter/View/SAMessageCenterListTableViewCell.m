//
//  SAMessageCenterListTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2021/7/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMessageCenterListTableViewCell.h"
#import "SAGeneralUtil.h"
#import "SAInternationalizationModel.h"
#import "SASystemMessageModel.h"


@interface SAMessageCenterListTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;  ///< 头像
@property (nonatomic, strong) UIView *dotView;             ///< 气泡
@property (nonatomic, strong) UILabel *titleLabel;         ///< 标题
@property (nonatomic, strong) UILabel *contentLabel;       ///< 内容
@property (nonatomic, strong) UILabel *timeLabel;          ///< 时间
@property (nonatomic, strong) UIView *bottomLine;          ///< 底部分割线
@property (nonatomic, strong) UILabel *moreLabel;          ///< 查看更多
@property (nonatomic, strong) UIImageView *arrowImageView; ///< 箭头
@property (nonatomic, strong) UIView *container;           ///< 容器

@end


@implementation SAMessageCenterListTableViewCell

- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.container];
    [self.container addSubview:self.headImageView];
    [self.container addSubview:self.dotView];
    [self.container addSubview:self.titleLabel];
    [self.container addSubview:self.contentLabel];
    [self.container addSubview:self.timeLabel];
    [self.container addSubview:self.bottomLine];
    [self.container addSubview:self.moreLabel];
    [self.container addSubview:self.arrowImageView];
}

- (void)updateConstraints {
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealHeight(7.5));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(9));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(9));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealHeight(5));
    }];

    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.container.mas_left).offset(kRealWidth(13));
        make.top.equalTo(self.container.mas_top).offset(kRealWidth(17));
        //        make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-kRealWidth(18));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(30), kRealWidth(30)));
    }];
    if (!self.dotView.isHidden) {
        [self.dotView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.headImageView.mas_right).offset(-5);
            make.centerY.equalTo(self.headImageView.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_top);
        make.left.equalTo(self.headImageView.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.timeLabel.mas_left).offset(-kRealWidth(10));
    }];

    [self.timeLabel sizeToFit];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.container.mas_right).offset(-kRealWidth(15.5));
        make.size.mas_equalTo(self.timeLabel.frame.size);
        make.top.equalTo(self.container.mas_top).offset(kRealHeight(17));
    }];

    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom).offset(kRealWidth(19));
        make.left.equalTo(self.container.mas_left).offset(kRealWidth(19));
        make.right.equalTo(self.container.mas_right).offset(-kRealWidth(19));
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.container.mas_left).offset(kRealWidth(14));
        make.right.equalTo(self.container.mas_right).offset(-kRealWidth(14));
        make.top.equalTo(self.contentLabel.mas_bottom).offset(kRealHeight(11));
        make.height.mas_equalTo(0.3);
    }];

    [self.moreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.container.mas_left).offset(kRealWidth(17));
        make.top.equalTo(self.bottomLine.mas_bottom).offset(kRealHeight(7));
        make.bottom.equalTo(self.container.mas_bottom).offset(-kRealHeight(9));
    }];

    [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.container.mas_right).offset(-kRealWidth(22));
        make.centerY.equalTo(self.moreLabel.mas_centerY);
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(SASystemMessageModel *)model {
    _model = model;

    UIImage *icon = [UIImage imageNamed:[NSString stringWithFormat:@"message_icon_%@", model.businessLine]];
    if ([model.businessLine isEqualToString:SAClientTypeYumNow] && ([model.messageNo isEqualToString:@"MCO025"] || [model.messageNo isEqualToString:@"MCO024"])) {
        icon = [UIImage imageNamed:[NSString stringWithFormat:@"message_icon_%@_address", model.businessLine]];
    } else if ([model.businessLine isEqualToString:SAClientTypeYumNow]
               && ([model.messageNo isEqualToString:@"MCO019"] || [model.messageNo isEqualToString:@"MCO017"] || [model.messageNo isEqualToString:@"MCO018"])) {
        icon = [UIImage imageNamed:[NSString stringWithFormat:@"message_icon_%@_afterSales_%@", model.businessLine, model.messageNo]];
    }
    if (!icon) {
        icon = [UIImage imageNamed:@"message_icon_SuperApp"];
    }
    self.headImageView.image = icon;

    self.titleLabel.text = model.messageName.desc;
    self.contentLabel.text = model.messageContent.desc;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.sendTime.integerValue / 1000.0];
    NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"HH:mm"];
    self.timeLabel.text = dateStr;

    if (model.readStatus == SAStationLetterReadStatusRead) {
        self.dotView.hidden = YES;
        self.contentView.alpha = 0.7;
    } else {
        self.dotView.hidden = NO;
        self.contentView.alpha = 1;
    }

    self.moreLabel.text = SALocalizedString(@"message_cell_more", @"查看更多");

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
/** @lazy headImageView */
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:view.frame.size.height / 2.0];
        };
    }
    return _headImageView;
}
/** @lazy bubbleLabel */
- (UIView *)dotView {
    if (!_dotView) {
        _dotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _dotView.backgroundColor = [UIColor hd_colorWithHexString:@"#CA0000"];
        _dotView.layer.borderWidth = 1.0f;
        _dotView.layer.borderColor = UIColor.whiteColor.CGColor;
        _dotView.layer.cornerRadius = 15 / 2.0f;
        _dotView.layer.masksToBounds = YES;

        //        _dotView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        //            view.layer.borderWidth = 1.0f;
        //            view.layer.borderColor = UIColor.whiteColor.CGColor;
        //            [view setRoundedCorners:UIRectCornerAllCorners radius:view.frame.size.height / 2.0];
        //        };
    }
    return _dotView;
}
/** @lazy titlelabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.font.standard2Bold;
        _titleLabel.textColor = HDAppTheme.color.G1;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}
/** @lazy contentlabel */
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = HDAppTheme.font.standard3;
        _contentLabel.textColor = HDAppTheme.color.G3;
        _contentLabel.numberOfLines = 3;
    }
    return _contentLabel;
}
/** @lazy timeLabel */
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = HDAppTheme.font.standard4;
        _timeLabel.textColor = HDAppTheme.color.G3;
    }
    return _timeLabel;
}
/** @lazy bottomView */
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = HDAppTheme.color.G6;
    }
    return _bottomLine;
}

/** @lazy morelabel */
- (UILabel *)moreLabel {
    if (!_moreLabel) {
        _moreLabel = [[UILabel alloc] init];
        _moreLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
        _moreLabel.textColor = [UIColor hd_colorWithHexString:@"#808080"];
        _moreLabel.text = SALocalizedString(@"message_cell_more", @"查看更多");
    }
    return _moreLabel;
}

/** @lazy imageView */
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down_gray_style2"]];
    }
    return _arrowImageView;
}

/** @lazy container */
- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = UIColor.whiteColor;
        _container.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _container;
}

@end
