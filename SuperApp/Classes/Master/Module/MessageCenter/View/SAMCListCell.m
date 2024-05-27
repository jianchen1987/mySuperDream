//
//  SAMCListCell.m
//  SuperApp
//
//  Created by Tia on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAMCListCell.h"
#import "SAGeneralUtil.h"
#import "SAInternationalizationModel.h"
#import "SASystemMessageModel.h"
#import "NSDate+SAExtension.h"


@interface SAMCListCell ()

@property (nonatomic, strong) UIImageView *headImageView; ///< 头像
@property (nonatomic, strong) UIView *dotView;            ///< 气泡
@property (nonatomic, strong) UILabel *titleLabel;        ///< 标题
@property (nonatomic, strong) UILabel *contentLabel;      ///< 内容
@property (nonatomic, strong) UILabel *timeLabel;         ///< 时间
@property (nonatomic, strong) UIView *bottomLine;         ///< 底部分割线
@property (nonatomic, strong) UILabel *moreLabel;         ///< 查看更多
@property (nonatomic, strong) UIView *container;          ///< 容器

@end


@implementation SAMCListCell

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
}

- (void)updateConstraints {
    CGFloat margin = 12;
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.left.equalTo(self.contentView.mas_left).offset(margin);
        make.right.equalTo(self.contentView.mas_right).offset(-margin);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];

    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.container).offset(margin);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];

    if (!self.dotView.isHidden) {
        [self.dotView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.headImageView);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
    }
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImageView);
        make.left.equalTo(self.headImageView.mas_right).offset(8);
        make.right.equalTo(self.timeLabel.mas_left).offset(-8);
    }];

    [self.timeLabel sizeToFit];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.container.mas_right).offset(-margin);
        make.size.mas_equalTo(self.timeLabel.frame.size);
        make.centerY.equalTo(self.headImageView);
    }];

    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom).offset(8);
        make.left.equalTo(self.container.mas_left).offset(margin);
        make.right.equalTo(self.container.mas_right).offset(-margin);
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.container.mas_left).offset(margin);
        make.right.equalTo(self.container.mas_right).offset(-margin);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(margin);
        make.height.mas_equalTo(0.5);
    }];

    [self.moreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.container);
        make.top.equalTo(self.bottomLine.mas_bottom).offset(8);
        make.bottom.equalTo(self.container.mas_bottom).offset(-8);
        make.height.mas_equalTo(18);
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
    //    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.sendTime.integerValue / 1000.0];
    //    NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"HH:mm"];
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
                self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.sendTime.integerValue / 1000.0] stringWithFormatStr:@"dd/MM HH:mm"];
            }
        } else {
            // 跨年
            self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.sendTime.integerValue / 1000.0] stringWithFormatStr:@"dd/MM/yyyy HH:mm"];
        }
    } else {
        self.timeLabel.text = @"";
    }

    self.dotView.hidden = model.readStatus == SAStationLetterReadStatusRead;

    self.moreLabel.text = SALocalizedString(@"mc_See_more", @"查看更多");

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
        _dotView = UIView.new;
        _dotView.backgroundColor = HDAppTheme.color.sa_C1;
        _dotView.layer.cornerRadius = 4;
        _dotView.layer.masksToBounds = YES;
    }
    return _dotView;
}
/** @lazy titlelabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.font.sa_standard14SB;
        _titleLabel.textColor = HDAppTheme.color.sa_C333;
        ;
        _titleLabel.numberOfLines = 2;
        _titleLabel.hd_lineSpace = 6;
    }
    return _titleLabel;
}
/** @lazy contentlabel */
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = HDAppTheme.font.sa_standard12;
        _contentLabel.textColor = HDAppTheme.color.sa_C999;
        _contentLabel.numberOfLines = 2;
        _contentLabel.hd_lineSpace = 4;
    }
    return _contentLabel;
}
/** @lazy timeLabel */
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = HDAppTheme.font.sa_standard11;
        _timeLabel.textColor = HDAppTheme.color.sa_C999;
    }
    return _timeLabel;
}
/** @lazy bottomView */
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = HDAppTheme.color.sa_separatorLineColor;
    }
    return _bottomLine;
}

/** @lazy morelabel */
- (UILabel *)moreLabel {
    if (!_moreLabel) {
        _moreLabel = [[UILabel alloc] init];
        _moreLabel.font = HDAppTheme.font.sa_standard12M;
        _moreLabel.textColor = HDAppTheme.color.sa_C333;
        _moreLabel.text = SALocalizedString(@"message_cell_more", @"查看更多");
    }
    return _moreLabel;
}

/** @lazy container */
- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = UIColor.whiteColor;
        _container.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:12];
        };
    }
    return _container;
}
@end
