//
//  SAMCChatListCell.m
//  SuperApp
//
//  Created by Tia on 2023/4/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAMCChatListCell.h"
#import "NSDate+SAExtension.h"
#import <HDWebImageManager.h>


@interface SAMCChatListCell ()

@property (nonatomic, strong) UIImageView *headImageView; ///< 头像
@property (nonatomic, strong) SALabel *bubbleLabel;       ///< 气泡
@property (nonatomic, strong) UILabel *titleLabel;        ///< 标题
@property (nonatomic, strong) UILabel *contentLabel;      ///< 内容
@property (nonatomic, strong) UILabel *timeLabel;         ///< 时间

@property (nonatomic, strong) UIView *container; ///< 容器

@end


@implementation SAMCChatListCell

- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;

    [self.contentView addSubview:self.container];

    [self.container addSubview:self.headImageView];
    [self.container addSubview:self.bubbleLabel];
    [self.container addSubview:self.titleLabel];
    [self.container addSubview:self.contentLabel];
    [self.container addSubview:self.timeLabel];
}

- (void)updateConstraints {
    CGFloat margin = 12;

    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(margin);
        make.right.equalTo(self.contentView).offset(-margin);
        make.bottom.equalTo(self.contentView);
    }];

    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(margin);
        make.bottom.mas_equalTo(-margin);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];


    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView);
        make.left.equalTo(self.headImageView.mas_right).offset(8);
        make.right.equalTo(self.timeLabel.mas_left).offset(-8);
    }];

    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.container).offset(-44);
        make.bottom.equalTo(self.headImageView);
    }];

    if (!self.bubbleLabel.isHidden) {
        [self.bubbleLabel sizeToFit];
        [self.bubbleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            //            make.centerY.equalTo(self.contentLabel);
            make.height.mas_equalTo(16);
            make.width.greaterThanOrEqualTo(self.bubbleLabel.mas_height);
            make.right.mas_equalTo(-margin);
            make.bottom.mas_equalTo(-14);
        }];
    }

    [self.timeLabel sizeToFit];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.container).offset(-margin);
        make.size.mas_equalTo(self.timeLabel.frame.size);
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(SAMessageModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.headImgUrl
                      placeholderImage:model.headPlaceholderImage ? model.headPlaceholderImage : [HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(50), kRealWidth(50))]
                             imageView:self.headImageView];
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
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

    if (model.bubble > 99) {
        self.bubbleLabel.hidden = NO;
        self.bubbleLabel.text = @"99+";
    } else if (model.bubble > 0) {
        self.bubbleLabel.hidden = NO;
        self.bubbleLabel.text = [NSString stringWithFormat:@"%zd", model.bubble];
    } else {
        self.bubbleLabel.hidden = YES;
    }
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
- (SALabel *)bubbleLabel {
    if (!_bubbleLabel) {
        _bubbleLabel = SALabel.new;
        _bubbleLabel.backgroundColor = HDAppTheme.color.sa_C1;
        _bubbleLabel.textColor = UIColor.whiteColor;
        _bubbleLabel.font = HDAppTheme.font.sa_standard11;
        _bubbleLabel.textAlignment = NSTextAlignmentCenter;
        _bubbleLabel.hd_edgeInsets = UIEdgeInsetsMake(1.5, 4, 1.5, 4);
        _bubbleLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5];
        };
    }
    return _bubbleLabel;
}
/** @lazy titlelabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.font.sa_standard14SB;
        _titleLabel.textColor = HDAppTheme.color.sa_C333;
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}
/** @lazy contentlabel */
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = HDAppTheme.font.sa_standard12;
        _contentLabel.textColor = HDAppTheme.color.sa_C999;
        _contentLabel.numberOfLines = 1;
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
