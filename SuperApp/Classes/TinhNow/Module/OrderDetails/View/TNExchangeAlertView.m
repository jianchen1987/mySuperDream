//
//  TNExchangeAlertView.m
//  SuperApp
//
//  Created by seeu on 2020/8/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNExchangeAlertView.h"
#import "SAImageLeftFillButton.h"
#import "TNQueryExchangeOrderExplainRspModel.h"


@interface TNExchangeAlertView ()

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 内容
@property (nonatomic, strong) UILabel *contentLabel;
/// 电话按钮
@property (nonatomic, strong) SAImageLeftFillButton *phoneButton;
/// 模型
@property (nonatomic, strong) TNQueryExchangeOrderExplainRspModel *model;

@end


@implementation TNExchangeAlertView

- (instancetype)initWithFrame:(CGRect)frame model:(TNQueryExchangeOrderExplainRspModel *)model {
    self.model = model;
    self = [super initWithFrame:frame];
    return self;
}

- (void)hd_setupViews {
    CGFloat maxWith = CGRectGetWidth(self.frame) - kRealWidth(30);
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = HDAppTheme.TinhNowFont.standard17B;
    self.titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = TNLocalizedString(@"tn_exchange_info", @"换货说明");
    CGRect titleLabelRect = [self.titleLabel textRectForBounds:CGRectMake(0, 0, maxWith, CGFLOAT_MAX) limitedToNumberOfLines:1];
    self.titleLabel.frame = CGRectMake(kRealWidth(15), kRealHeight(42), maxWith, titleLabelRect.size.height);
    [self addSubview:self.titleLabel];

    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = HDAppTheme.TinhNowFont.standard15;
    self.contentLabel.textColor = HDAppTheme.TinhNowColor.G1;
    self.contentLabel.numberOfLines = 0;
    NSString *content = @"";
    for (int i = 0; i < self.model.instructions.count; i++) {
        content = [content stringByAppendingFormat:@"%d.%@; ", i + 1, self.model.instructions[i]];
    }
    self.contentLabel.text = content;
    CGRect contentLabelRect = [self.contentLabel textRectForBounds:CGRectMake(0, 0, maxWith, CGFLOAT_MAX) limitedToNumberOfLines:999];
    self.contentLabel.frame = CGRectMake(kRealWidth(15), self.titleLabel.bottom + kRealHeight(20), maxWith, CGRectGetHeight(contentLabelRect));
    [self addSubview:self.contentLabel];

    self.phoneButton =
        [[SAImageLeftFillButton alloc] initWithFrame:CGRectMake(kRealWidth(60), self.contentLabel.bottom + kRealHeight(20), CGRectGetWidth(self.frame) - kRealWidth(120), kRealHeight(40))];
    [self.phoneButton setImage:[UIImage imageNamed:@"left_filled_image_phoneCall"] forState:UIControlStateNormal];
    [self.phoneButton setTitle:self.model.servicePhones.firstObject forState:UIControlStateNormal];
    self.phoneButton.layer.borderColor = HDAppTheme.TinhNowColor.G4.CGColor;
    self.phoneButton.titleLabel.font = HDAppTheme.TinhNowFont.standard15;
    [self.phoneButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
    self.phoneButton.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(12), kRealWidth(15));
    [self.phoneButton addTarget:self action:@selector(makePhoneCall) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.phoneButton];
}

- (void)layoutyImmediately {
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.phoneButton.bottom + kRealHeight(30));
}

- (void)makePhoneCall {
    [HDSystemCapabilityUtil makePhoneCall:self.model.servicePhones.firstObject];
}

@end
