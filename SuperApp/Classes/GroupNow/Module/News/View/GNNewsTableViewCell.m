//
//  GNNewsTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNNewsTableViewCell.h"
#import "GNView.h"


@interface GNNewsTableViewCell ()

/// 图片
@property (nonatomic, strong) UIImageView *iconIV;
/// 标题
@property (nonatomic, strong) HDLabel *titleLB;
/// 时间
@property (nonatomic, strong) HDLabel *timeLB;
/// 内容
@property (nonatomic, strong) HDLabel *contentLB;
/// 更多
@property (nonatomic, strong) UIImageView *moreIV;
/// 背景
@property (nonatomic, strong) GNView *view;

@end


@implementation GNNewsTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.view];
    [self.view addSubview:self.iconIV];
    [self.view addSubview:self.titleLB];
    [self.view addSubview:self.timeLB];
    [self.view addSubview:self.contentLB];
    [self.view addSubview:self.moreIV];
}

- (void)updateConstraints {
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
        make.top.mas_equalTo(HDAppTheme.value.gn_marginT);
        make.bottom.mas_equalTo(0);
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(20)));
    }];

    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-HDAppTheme.value.gn_marginL);
        make.centerY.equalTo(self.iconIV);
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(HDAppTheme.value.gn_marginL);
        make.centerY.equalTo(self.iconIV);
        make.right.equalTo(self.timeLB.mas_left).offset(-3);
    }];

    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.right.mas_equalTo(-kRealWidth(38));
        make.top.equalTo(self.iconIV.mas_bottom).offset(HDAppTheme.value.gn_marginL);
        make.bottom.mas_equalTo(-HDAppTheme.value.gn_marginL);
    }];

    [self.moreIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(12), kRealWidth(12)));
        make.bottom.equalTo(self.contentLB.mas_bottom);
    }];

    [super updateConstraints];
}

- (void)setGNModel:(GNNewsCellModel *)data {
    self.model = data;
    self.contentView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    if ([self.model isKindOfClass:GNNewsCellModel.class]) {
        self.titleLB.text = data.messageName.desc;
        self.timeLB.text = [SAGeneralUtil getDateStrWithTimeInterval:data.sendTime.integerValue / 1000 format:@"dd/MM/yyyy HH:mm:ss"];
        self.contentLB.text = data.messageContent.desc;
        if (data.messageType == SAMessageTypeGroup) {
            self.iconIV.image = [UIImage imageNamed:@"gn_news_off"];
        } else {
            self.iconIV.image = [UIImage imageNamed:@"message_icon_GroupBuy"];
        }
        if (data.readStatus == SAStationLetterReadStatusRead) {
            self.titleLB.textColor = self.timeLB.textColor = self.contentLB.textColor = [UIColor hd_colorWithHexString:@"#B5B5B5"];
        } else {
            self.titleLB.textColor = self.timeLB.textColor = self.contentLB.textColor = [UIColor hd_colorWithHexString:@"#333333"];
        }
    }
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = HDLabel.new;
        _titleLB.font = [HDAppTheme.font gn_boldForSize:16];
    }
    return _titleLB;
}

- (HDLabel *)timeLB {
    if (!_timeLB) {
        _timeLB = HDLabel.new;
        _timeLB.font = HDAppTheme.font.gn_14;
        _timeLB.textAlignment = NSTextAlignmentRight;
    }
    return _timeLB;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
    }
    return _iconIV;
}

- (HDLabel *)contentLB {
    if (!_contentLB) {
        _contentLB = HDLabel.new;
        _contentLB.numberOfLines = 0;
        _contentLB.font = HDAppTheme.font.gn_14;
    }
    return _contentLB;
}

- (UIImageView *)moreIV {
    if (!_moreIV) {
        _moreIV = UIImageView.new;
        _moreIV.image = [UIImage imageNamed:@"gn_order_more"];
    }
    return _moreIV;
}

- (GNView *)view {
    if (!_view) {
        _view = GNView.new;
        _view.backgroundColor = HDAppTheme.color.gn_whiteColor;
    }
    return _view;
}

@end
