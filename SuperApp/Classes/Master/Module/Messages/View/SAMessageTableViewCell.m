//
//  SAMessageTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2021/1/10.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMessageTableViewCell.h"
#import "NSDate+SAExtension.h"
#import <HDWebImageManager.h>


@interface SAMessageTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView; ///< 头像
@property (nonatomic, strong) HDLabel *bubbleLabel;       ///< 气泡
@property (nonatomic, strong) UILabel *titleLabel;        ///< 标题
@property (nonatomic, strong) UILabel *contentLabel;      ///< 内容
@property (nonatomic, strong) UILabel *timeLabel;         ///< 时间
@property (nonatomic, strong) UIView *bottomLine;         ///< 底部分割线

@end


@implementation SAMessageTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.bubbleLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.bottomLine];
}

- (void)updateConstraints {
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(18));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(18));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(50), kRealWidth(50)));
    }];
    if (!self.bubbleLabel.isHidden) {
        [self.bubbleLabel sizeToFit];
        [self.bubbleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.headImageView.mas_right).offset(-5);
            make.centerY.equalTo(self.headImageView.mas_top).offset(5);
            make.height.mas_equalTo(15);
            make.width.greaterThanOrEqualTo(self.bubbleLabel.mas_height);
        }];
    }
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_top);
        make.left.equalTo(self.headImageView.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.timeLabel.mas_left).offset(-kRealWidth(10));
    }];

    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(5));
        make.left.equalTo(self.headImageView.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.headImageView.mas_bottom);
    }];
    [self.timeLabel sizeToFit];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.size.mas_equalTo(self.timeLabel.frame.size);
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.3);
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
                self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.sendDate] stringWithFormatStr:@"MM/dd HH:mm"];
            }
        } else {
            // 跨年
            self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.sendDate] stringWithFormatStr:@"yyyy/MM/dd HH:mm"];
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
- (HDLabel *)bubbleLabel {
    if (!_bubbleLabel) {
        _bubbleLabel = [[HDLabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _bubbleLabel.font = HDAppTheme.font.standard5;
        _bubbleLabel.textColor = UIColor.whiteColor;
        _bubbleLabel.textAlignment = NSTextAlignmentCenter;
        _bubbleLabel.backgroundColor = [UIColor hd_colorWithHexString:@"#F83E00"];
        _bubbleLabel.hd_edgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _bubbleLabel.layer.borderColor = UIColor.whiteColor.CGColor;
        _bubbleLabel.layer.borderWidth = 1.0f;
        _bubbleLabel.layer.cornerRadius = 15 / 2.0f;
        _bubbleLabel.layer.masksToBounds = YES;
    }
    return _bubbleLabel;
}
/** @lazy titlelabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.font.standard2Bold;
        _titleLabel.textColor = HDAppTheme.color.G1;
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}
/** @lazy contentlabel */
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = HDAppTheme.font.standard3;
        _contentLabel.textColor = HDAppTheme.color.G3;
        _contentLabel.numberOfLines = 1;
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
@end
