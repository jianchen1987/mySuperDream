//
//  SAUserBillDetailsHeaderView.m
//  SuperApp
//
//  Created by seeu on 2022/4/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAUserBillDetailsHeaderView.h"


@interface SAUserBillDetailsHeaderView ()

///< icon
@property (nonatomic, strong) UIImageView *iconImageView;
///< merchantName
@property (nonatomic, strong) SALabel *nameLabel;
///< amount
@property (nonatomic, strong) SALabel *amountLabel;
/// line
@property (nonatomic, strong) UIView *line;

@end


@implementation SAUserBillDetailsHeaderView

- (void)hd_setupViews {
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.amountLabel];
    [self addSubview:self.line];
}

- (void)updateConstraints {
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(HDAppTheme.value.padding.top);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.nameLabel sizeToFit];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(kRealHeight(20));
        make.left.equalTo(self.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
    }];
    [self.amountLabel sizeToFit];
    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealHeight(30));
        make.left.equalTo(self.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(PixelOne);
    }];

    [super updateConstraints];
}

- (void)updateWithBusinessLine:(NSString *)businessLine merchantName:(NSString *_Nullable)merName paymentAmount:(NSString *_Nullable)amount {
    if ([businessLine isEqualToString:SAClientTypeYumNow]) {
        self.iconImageView.image = [UIImage imageNamed:@"order_list_yumnow"];
    } else if ([businessLine isEqualToString:SAClientTypeTinhNow]) {
        self.iconImageView.image = [UIImage imageNamed:@"order_list_tinhnow"];
    } else if ([businessLine isEqualToString:SAClientTypePhoneTopUp]) {
        self.iconImageView.image = [UIImage imageNamed:@"order_list_top_up_icon"];
    } else if ([businessLine isEqualToString:SAClientTypeGroupBuy]) {
        self.iconImageView.image = [UIImage imageNamed:@"order_list_groupbuy"];
    } else if ([businessLine isEqualToString:SAClientTypeBillPayment]) {
        self.iconImageView.image = [UIImage imageNamed:@"order_list_billPayment"];
    } else if ([businessLine isEqualToString:SAClientTypeGame]) {
        self.iconImageView.image = [UIImage imageNamed:@"message_icon_GameChannel"];
    } else if ([businessLine isEqualToString:SAClientTypeHotel]) {
        self.iconImageView.image = [UIImage imageNamed:@"message_icon_HotelChannel"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"business_outsize"];
    }
    self.nameLabel.text = merName;
    self.amountLabel.text = amount;

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [HDHelper placeholderImageWithSize:CGSizeMake(60, 60)];
        _iconImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height / 2.0];
        };
    }
    return _iconImageView;
}

- (SALabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = SALabel.new;
        _nameLabel.font = HDAppTheme.font.standard2;
        _nameLabel.textColor = HDAppTheme.color.G1;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 2;
        _nameLabel.text = @"- -";
    }
    return _nameLabel;
}

- (SALabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = SALabel.new;
        _amountLabel.font = HDAppTheme.font.amountOnly;
        _amountLabel.textColor = HDAppTheme.color.G1;
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        _amountLabel.text = @"--.--";
    }
    return _amountLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.new;
        _line.backgroundColor = HDAppTheme.color.G5;
    }
    return _line;
}

@end
