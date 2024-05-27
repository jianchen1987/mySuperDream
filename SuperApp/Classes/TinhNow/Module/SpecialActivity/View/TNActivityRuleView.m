//
//  TNActivityRuleView.m
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNActivityRuleView.h"


@interface TNActivityRuleView ()
///规则内容
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *ruleImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@end


@implementation TNActivityRuleView
- (instancetype)initWithFrame:(CGRect)frame content:(NSString *)content {
    if (self = [super initWithFrame:frame]) {
        if (HDIsStringNotEmpty(content)) {
            ///将<br/> 替换成换行符
            self.content = [content stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            self.contentLabel.text = self.content;
        }
    }
    return self;
}
- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self addSubview:self.ruleImageView];
    [self addSubview:self.nameLabel];
    [self.scrollViewContainer addSubview:self.contentLabel];
}
- (void)layoutyImmediately {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.scrollView.frame));
}
- (void)updateConstraints {
    [self.ruleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).offset(kRealWidth(20));
        make.size.mas_equalTo(self.ruleImageView.image.size);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ruleImageView);
        make.left.equalTo(self.ruleImageView.mas_right).offset(kRealWidth(5));
        make.right.equalTo(self.mas_right).offset(kRealWidth(15));
    }];
    CGFloat contentHeight = [self.content boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(15) * 2, CGFLOAT_MAX) font:HDAppTheme.TinhNowFont.standard15].height + 40;
    contentHeight = contentHeight > kScreenHeight / 2 ? kScreenHeight / 2 : contentHeight;
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-kRealWidth(25));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(10));
        make.height.mas_equalTo(contentHeight);
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.scrollViewContainer);
        make.bottom.equalTo(self.scrollViewContainer.mas_bottom).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:22];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.text = TNLocalizedString(@"tn_activity_rules", @"活动规则");
    }
    return _nameLabel;
}
- (UIImageView *)ruleImageView {
    if (!_ruleImageView) {
        _ruleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow_activity_rule"]];
    }
    return _ruleImageView;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = HDAppTheme.TinhNowFont.standard15;
        _contentLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
@end
