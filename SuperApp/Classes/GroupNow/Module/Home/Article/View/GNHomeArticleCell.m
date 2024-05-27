//
//  GNHomeArticleCell.m
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNHomeArticleCell.h"
#import "GNMultiLanguageManager.h"
#import "GNTheme.h"
#import "HDMediator+GroupOn.h"
#import "SAGeneralUtil.h"


@interface GNHomeArticleCell ()
///图片
@property (nonatomic, strong) UIImageView *iconIV;
///名字
@property (nonatomic, strong) SALabel *nameLb;
///作者图片
@property (nonatomic, strong) UIImageView *authorIV;
///作者名字
@property (nonatomic, strong) SALabel *authorLB;
///日期
@property (nonatomic, strong) SALabel *dateLB;

@end


@implementation GNHomeArticleCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.nameLb];
    [self.contentView addSubview:self.authorIV];
    [self.contentView addSubview:self.authorLB];
    [self.contentView addSubview:self.dateLB];
    UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.contentView addGestureRecognizer:ta];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kRealWidth(12));
        make.height.equalTo(self.iconIV.mas_width).multipliedBy(1);
    }];

    [self.nameLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.iconIV);
        make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(8));
        make.height.mas_equalTo(kRealWidth(24));
    }];

    [self.authorIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(32), kRealWidth(32)));
        make.top.equalTo(self.nameLb.mas_bottom).offset(kRealWidth(8));
    }];

    [self.authorLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorIV.mas_right).offset(kRealWidth(8));
        make.right.equalTo(self.iconIV);
        make.top.equalTo(self.authorIV).offset(-kRealWidth(4));
    }];

    [self.dateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorLB);
        make.right.equalTo(self.iconIV);
        make.bottom.equalTo(self.authorIV).offset(kRealWidth(2));
    }];

    [super updateConstraints];
}

- (void)setGNModel:(GNArticleModel *)data {
    self.model = data;
    CGFloat width = (kDeviceWidth - kRealWidth(40)) / 2;
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:data.logo] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(width, width) logoWidth:width / 2]];
    self.nameLb.text = GNFillEmptySpace(data.articleName.desc);
    [self.authorIV sd_setImageWithURL:[NSURL URLWithString:data.headUrl] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(32), kRealWidth(32)) logoWidth:kRealWidth(16)]];
    self.authorLB.text = GNFillEmpty(data.nickName);
    self.dateLB.text = [SAGeneralUtil getDateStrWithTimeInterval:data.createTime / 1000 format:@"dd/MM/yyyy"];
}

- (void)tapAction {
    [self.viewController.view endEditing:YES];
    [HDMediator.sharedInstance navigaveToGNArticleDetailViewController:@{@"id": GNFillEmpty(self.model.articleCode)}];
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.clipsToBounds = YES;
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.layer.cornerRadius = kRealWidth(8);
    }
    return _iconIV;
}

- (UIImageView *)authorIV {
    if (!_authorIV) {
        _authorIV = [UIImageView new];
        _authorIV.clipsToBounds = YES;
        _authorIV.layer.cornerRadius = kRealWidth(16);
    }
    return _authorIV;
}

- (SALabel *)nameLb {
    if (!_nameLb) {
        SALabel *la = SALabel.new;
        la.textColor = HDAppTheme.color.gn_333Color;
        la.font = [HDAppTheme.font gn_boldForSize:16];
        _nameLb = la;
    }
    return _nameLb;
}

- (SALabel *)authorLB {
    if (!_authorLB) {
        SALabel *la = SALabel.new;
        la.textColor = HDAppTheme.color.gn_333Color;
        la.font = [HDAppTheme.font gn_ForSize:14];
        _authorLB = la;
    }
    return _authorLB;
}

- (SALabel *)dateLB {
    if (!_dateLB) {
        SALabel *la = SALabel.new;
        la.textColor = HDAppTheme.color.gn_999Color;
        la.font = [HDAppTheme.font gn_ForSize:11];
        _dateLB = la;
    }
    return _dateLB;
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return kRealWidth(270);
}

- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    CGFloat itemWidth = (kDeviceWidth - kRealWidth(40)) / 2;
    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(itemWidth);
        make.height.hd_equalTo(itemWidth);
        make.top.hd_equalTo(0);
        make.left.hd_equalTo(0);
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(90);
        make.height.hd_equalTo(kRealWidth(17));
        make.top.hd_equalTo(r0.hd_bottom + kRealWidth(8));
        make.left.hd_equalTo(r0.hd_left);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(100);
        make.height.hd_equalTo(kRealWidth(17));
        make.top.hd_equalTo(r1.hd_bottom + kRealWidth(8));
        make.left.hd_equalTo(r0.hd_left);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(100);
        make.height.hd_equalTo(kRealWidth(17));
        make.top.hd_equalTo(r2.hd_bottom + kRealWidth(8));
        make.left.hd_equalTo(r0.hd_left);
    }];

    return @[r0, r1, r2, r3];
}

@end
