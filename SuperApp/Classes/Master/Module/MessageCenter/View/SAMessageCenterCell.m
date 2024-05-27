//
//  SAMessageCenterCell.m
//  SuperApp
//
//  Created by Tia on 2023/4/23.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAMessageCenterCell.h"
#import "SAGeneralUtil.h"
#import "NSDate+SAExtension.h"
#import <HDWebImageManager.h>


@interface SAMessageCenterTableHeaderFooterView ()

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) SALabel *numberLabel;

@end


@implementation SAMessageCenterTableHeaderFooterView

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.numberLabel];
    [self.bgView addSubview:self.arrowView];
    [self.contentView addSubview:self.btn];
}

#pragma mark - layout
- (void)updateConstraints {
    CGFloat margin = 12;

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(margin * 4);
    }];

    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.centerY.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(4);
        make.centerY.equalTo(self.bgView);
    }];

    [self.arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-margin);
        make.centerY.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];

    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowView.mas_left).offset(-2);
        make.centerY.equalTo(self.bgView);
        make.height.mas_equalTo(16);
        make.width.greaterThanOrEqualTo(self.numberLabel.mas_height);
    }];

    [self.btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setNumber:(NSInteger)number {
    _number = number;
    if (number == 0) {
        self.numberLabel.hidden = YES;
    } else {
        self.numberLabel.hidden = NO;
        self.numberLabel.text = number > 99 ? @"99+" : [NSString stringWithFormat:@"%ld", number];
    }
}

- (void)setSection:(NSInteger)section {
    _section = section;
    if (section == 0) {
        self.iconView.image = [UIImage imageNamed:@"msg_section_action"];
        self.titleLabel.text = SALocalizedString(@"mc_Promotions", @"活动优惠");
    } else if (section == 1) {
        self.iconView.image = [UIImage imageNamed:@"msg_section_info"];
        self.titleLabel.text = SALocalizedString(@"mc_Personal_information", @"个人信息");
    } else if (section == 2) {
        self.iconView.image = [UIImage imageNamed:@"msg_section_chat"];
        self.titleLabel.text = SALocalizedString(@"mc_Chat_conversation", @"聊天消息");
    }
}

#pragma mark - lazy load
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:12];
        };
    }
    return _bgView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_section_action"]];
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.textColor = HDAppTheme.color.sa_C333;
        _titleLabel.font = HDAppTheme.font.sa_standard16SB;
    }
    return _titleLabel;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_detail_title_arrow"]];
    }
    return _arrowView;
}

- (SALabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = SALabel.new;
        _numberLabel.backgroundColor = HDAppTheme.color.sa_C1;
        _numberLabel.textColor = UIColor.whiteColor;
        _numberLabel.font = HDAppTheme.font.sa_standard11;
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.hd_edgeInsets = UIEdgeInsetsMake(1.5, 4, 1.5, 4);
        _numberLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5];
        };
    }
    return _numberLabel;
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        @HDWeakify(self);
        [_btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(headerViewClick:)]) {
                [self.delegate headerViewClick:self];
            }
        }];
    }
    return _btn;
}

@end


@implementation SAMessageCenterCell

- (void)hd_setupViews {
    self.backgroundColor = self.contentView.backgroundColor = UIColor.clearColor;

    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.detailLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.redPoint];
    [self.bgView addSubview:self.line];

    //设置抗压缩
    [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)updateConstraints {
    CGFloat margin = 12;

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.centerY.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(8);
        make.top.equalTo(self.iconView).offset(2);
        make.height.mas_equalTo(20);
    }];


    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.iconView);
        make.height.mas_equalTo(18);
        make.right.mas_equalTo(-38);
    }];

    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-margin);
        make.centerY.equalTo(self.titleLabel);
        make.left.mas_greaterThanOrEqualTo(self.titleLabel.mas_right).offset(margin);
    }];

    [self.redPoint mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeLabel);
        make.centerY.equalTo(self.detailLabel);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.top.equalTo(self.bgView);
        make.height.mas_equalTo(0.5);
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    NSInteger section = indexPath.section;
    if (section == 0)
        self.iconView.image = [UIImage imageNamed:@"msg_row_action"];
    if (section == 1)
        self.iconView.image = [UIImage imageNamed:@"msg_row_info"];
}

- (void)setIsLastCell:(BOOL)isLastCell {
    if (_isLastCell != isLastCell) {
        _isLastCell = isLastCell;
        self.bgView.hd_frameDidChangeBlock(self.bgView, self.bgView.frame);
    }
}

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
    self.iconView.image = icon;

    self.titleLabel.text = model.messageName.desc;
    self.detailLabel.text = model.messageContent.desc;

    //    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.sendTime.integerValue / 1000.0];
    //    NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy HH:mm"];
    //    self.timeLabel.text = dateStr;

    if (model.sendTime) {
        NSString *sendYear = [[NSDate dateWithTimeIntervalSince1970:model.sendTime.integerValue / 1000.0] stringWithFormatStr:@"yyyy"];
        NSString *nowYear = [[NSDate new] stringWithFormatStr:@"yyyy"];
        NSString *sendDay = [[NSDate dateWithTimeIntervalSince1970:model.sendTime.integerValue / 1000.0] stringWithFormatStr:@"yyyyMMdd"];
        NSString *nowDay = [[NSDate new] stringWithFormatStr:@"yyyyMMdd"];
        if ([sendYear isEqualToString:nowYear]) {
            if ([sendDay isEqualToString:nowDay]) {
                //同一天
                self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.sendTime.integerValue / 1000.0] stringWithFormatStr:@"HH:mm"];
            } else {
                // 同一年
                self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.sendTime.integerValue / 1000.0] stringWithFormatStr:@"MM/dd HH:mm"];
            }
        } else {
            // 跨年
            self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.sendTime.integerValue / 1000.0] stringWithFormatStr:@"yyyy/MM/dd HH:mm"];
        }
    } else {
        self.timeLabel.text = @"";
    }

    self.redPoint.hidden = model.readStatus == SAStationLetterReadStatusRead;
}

- (void)setChatModel:(SAMessageModel *)model {
    _chatModel = model;
    //    [HDWebImageManager setImageWithURL:model.headImgUrl
    //                      placeholderImage:model.headPlaceholderImage ? model.headPlaceholderImage : [HDHelper placeholderImageWithSize:CGSizeMake(36, 36)]
    //                             imageView:self.iconView];
    //
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl]
                     placeholderImage:model.headPlaceholderImage ? model.headPlaceholderImage : [HDHelper placeholderImageWithSize:CGSizeMake(36, 36)]];

    self.titleLabel.text = model.title;
    self.detailLabel.text = model.content;
    if (model.sendDate) {
        NSString *sendYear = [[NSDate dateWithTimeIntervalSince1970:model.sendDate] stringWithFormatStr:@"yyyy"];
        NSString *nowYear = [[NSDate new] stringWithFormatStr:@"yyyy"];
        NSString *sendDay = [[NSDate dateWithTimeIntervalSince1970:model.sendDate] stringWithFormatStr:@"yyyyMMdd"];
        NSString *nowDay = [[NSDate new] stringWithFormatStr:@"yyyyMMdd"];
        if ([sendYear isEqualToString:nowYear]) {
            if ([sendDay isEqualToString:nowDay]) {
                //同一天
                self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.sendDate] stringWithFormatStr:@"HH:mm"];
            } else {
                // 同一年
                self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.sendDate] stringWithFormatStr:@"dd/MM HH:mm"];
            }
        } else {
            // 跨年
            self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.sendDate] stringWithFormatStr:@"dd/MM/yyyy HH:mm"];
        }
    } else {
        self.timeLabel.text = @"";
    }

    self.redPoint.hidden = !model.bubble;
}

#pragma mark - lazy load
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = UIColor.whiteColor;
        @HDWeakify(self);
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self);
            if (self.isLastCell) {
                [view setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:12];
            } else {
                [view setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:0];
            }
        };
    }
    return _bgView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = UIImageView.new;
        _iconView.layer.cornerRadius = 22;
        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.textColor = HDAppTheme.color.sa_C333;
        _titleLabel.font = HDAppTheme.font.sa_standard14M;
        //        _titleLabel.text = @"我是标题2222";
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = UILabel.new;
        _detailLabel.textColor = HDAppTheme.color.sa_C999;
        _detailLabel.font = HDAppTheme.font.sa_standard12;
    }
    return _detailLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.new;
        _timeLabel.textColor = HDAppTheme.color.sa_C999;
        _timeLabel.font = HDAppTheme.font.sa_standard11;
    }
    return _timeLabel;
}

- (UIImageView *)redPoint {
    if (!_redPoint) {
        _redPoint = UIImageView.new;
        _redPoint.layer.cornerRadius = 3;
        _redPoint.backgroundColor = HDAppTheme.color.sa_C1;
    }
    return _redPoint;
}

- (UIImageView *)line {
    if (!_line) {
        _line = UIImageView.new;
        _line.backgroundColor = HDAppTheme.color.sa_separatorLineColor;
    }
    return _line;
}

@end
