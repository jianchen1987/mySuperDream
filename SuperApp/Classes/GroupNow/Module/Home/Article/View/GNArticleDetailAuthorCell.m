//
//  GNArticleDetailAuthorCell.m
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNArticleDetailAuthorCell.h"
#import "GNArticleModel.h"
#import "SAGeneralUtil.h"


@interface GNArticleDetailAuthorCell ()
/// title
@property (nonatomic, strong) HDLabel *titleLB;
/// detailLB
@property (nonatomic, strong) HDLabel *detailLB;
/// iconIV
@property (nonatomic, strong) UIImageView *iconIV;

@end


@implementation GNArticleDetailAuthorCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.detailLB];
    [self.contentView addSubview:self.iconIV];
}

- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV).offset(-kRealWidth(2));
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(2));
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(2));
        make.left.right.equalTo(self.titleLB);
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(32), kRealWidth(32)));
        make.top.left.mas_equalTo(kRealWidth(12));
        make.bottom.mas_equalTo(-kRealWidth(12));
    }];

    [super updateConstraints];
}

- (void)setGNModel:(GNArticleModel *)data {
    if ([data isKindOfClass:GNArticleModel.class]) {
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:data.headUrl] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(32), kRealWidth(32)) logoWidth:kRealWidth(16)]];
        self.titleLB.text = GNFillEmpty(data.nickName);
        self.detailLB.text = [SAGeneralUtil getDateStrWithTimeInterval:data.createTime / 1000 format:@"dd/MM/yyyy"];
    }
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = kRealWidth(16);
            view.clipsToBounds = YES;
        };
    }
    return _iconIV;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_333Color;
        la.font = [HDAppTheme.font gn_boldForSize:14];
        _titleLB = la;
    }
    return _titleLB;
}

- (HDLabel *)detailLB {
    if (!_detailLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_999Color;
        la.font = [HDAppTheme.font gn_ForSize:11];
        _detailLB = la;
    }
    return _detailLB;
}

@end
