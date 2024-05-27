//
//  SASystemMessageTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/5/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASystemMessageTableViewCell.h"
#import "SAGeneralUtil.h"


@interface SASystemMessageTableViewCell ()
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 时间
@property (nonatomic, strong) SALabel *timeLB;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
/// 箭头
@property (nonatomic, strong) UIImageView *arrowIV;
/// 线条
@property (nonatomic, strong) UIView *bottomLine;
/// 图标
@property (nonatomic, strong) UIImageView *iconIV;
@end


@implementation SASystemMessageTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.descLB];
    [self.contentView addSubview:self.timeLB];
    [self.contentView addSubview:self.arrowIV];
    [self.contentView addSubview:self.bottomLine];

    [self.titleLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.timeLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - setter
- (void)setModel:(SASystemMessageModel *)model {
    _model = model;

    NSString *imageName = @"message_icon_order";
    if (model.messageType == SAMessageTypeSystem || model.messageType == SAMessageTypeNotice) {
        imageName = @"message_icon_update";
    } else if (model.messageType == SAMessageTypeCoupon) {
        imageName = @"message_icon_coupon";
    } else {
        imageName = @"message_icon_order";
    }

    UIImage *originalImage = [UIImage imageNamed:imageName];
    if (model.readStatus == SAStationLetterReadStatusUnread) {
        UIImage *dotImage = [UIImage imageNamed:@"red_dot"];
        // 计算绘制点，原图右上角，原图 icon 不垂直居中，上移一点
        CGPoint point = CGPointMake((originalImage.size.width * 0.5 - dotImage.size.width) * 0.5 + originalImage.size.width * 0.5, (originalImage.size.height * 0.5 - dotImage.size.height) * 0.5 - 3);
        // 合成
        originalImage = [originalImage hd_imageWithImageAbove:dotImage atPoint:point];
    }
    self.iconIV.image = originalImage;

    self.titleLB.text = model.messageName.desc;
    self.descLB.text = model.messageContent.desc;
    // 系统消息最多显示一行
    self.descLB.numberOfLines = [model.bizNo isEqualToString:SAStationLetterTypeSystem] ? 1 : 0;

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.sendTime.integerValue / 1000.0];
    NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"HH:mm"];
    self.timeLB.text = dateStr;
    self.bottomLine.hidden = !model.showBottomLine;

    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    const CGFloat imageH = kRealWidth(22);
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(imageH, imageH));
        make.left.mas_equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
        make.top.equalTo(self.contentView).offset(kRealWidth(18));
    }];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(8));
        make.right.lessThanOrEqualTo(self.timeLB.mas_left).offset(-kRealWidth(8));
        make.top.equalTo(self.iconIV.mas_centerY).offset(-imageH * 0.5);
    }];
    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        make.centerY.equalTo(self.iconIV);
    }];
    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self.iconIV.mas_bottom).offset(kRealWidth(10));
        make.top.greaterThanOrEqualTo(self.titleLB.mas_bottom).offset(kRealWidth(10));
        make.left.mas_equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.arrowIV.mas_left).offset(-kRealWidth(8));
        if (self.bottomLine.isHidden) {
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-kRealWidth(20));
        }
    }];
    [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowIV.image.size);
        make.right.mas_equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        make.centerY.equalTo(self.descLB);
        if (self.bottomLine.isHidden) {
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-kRealWidth(20));
        }
    }];
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomLine.isHidden) {
            make.top.greaterThanOrEqualTo(self.descLB.mas_bottom).offset(kRealWidth(20));
            make.top.greaterThanOrEqualTo(self.arrowIV.mas_bottom).offset(kRealWidth(20));
            make.height.mas_equalTo(PixelOne);
            make.left.mas_equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
            make.right.mas_equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
            make.bottom.equalTo(self.contentView);
        }
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)timeLB {
    if (!_timeLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 1;
        _timeLB = label;
    }
    return _timeLB;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 0;
        label.hd_lineSpace = SAMultiLanguageManager.isCurrentLanguageCN ? 7 : 5;
        _descLB = label;
    }
    return _descLB;
}

- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"black_arrow"];
        _arrowIV = imageView;
    }
    return _arrowIV;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
    }
    return _iconIV;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}
@end
