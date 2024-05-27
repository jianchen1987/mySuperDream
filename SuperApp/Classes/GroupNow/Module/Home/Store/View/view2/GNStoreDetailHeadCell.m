//
//  GNStoreDetailHeadCell.m
//  SuperApp
//
//  Created by wmz on 2022/6/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNStoreDetailHeadCell.h"
#import "GNStarView.h"
#import "GNTagViewCell.h"


@interface GNStoreDetailHeadCell () <UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>
///背景
@property (nonatomic, strong) UIImageView *bgIV;
///图标
@property (nonatomic, strong) UIImageView *iconIV;
/// name
@property (nonatomic, strong) HDLabel *nameLB;
///评分
@property (nonatomic, strong) HDLabel *rateLB;
/// 评分图标
@property (nonatomic, strong) GNStarView *rateView;
/// 人均
@property (nonatomic, strong) HDLabel *perCapitaLB;
///营业时间
@property (nonatomic, strong) HDLabel *businessTipLB;
///营业时间
@property (nonatomic, strong) HDLabel *businessLB;
///商圈
@property (nonatomic, strong) HDLabel *areaLB;
/// 标签
@property (nonatomic, strong) GNCollectionView *tagCollectionView;
/// detailBTN
@property (nonatomic, strong) HDUIButton *rightBTN;
/// addressBTN
@property (nonatomic, strong) HDUIButton *addressBTN;
/// callBTN
@property (nonatomic, strong) HDUIButton *callBTN;
///地址
@property (nonatomic, strong) HDLabel *addressLB;
///电话
@property (nonatomic, strong) HDLabel *callLB;
/// line1
@property (nonatomic, strong) UIView *line1;
/// line2
@property (nonatomic, strong) UIView *line2;
/// buinessView
@property (nonatomic, strong) UIView *buinessView;
/// addressView
@property (nonatomic, strong) UIView *addressView;
/// callView
@property (nonatomic, strong) UIView *callView;
@end


@implementation GNStoreDetailHeadCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgIV];
    [self.contentView.layer addSublayer:[self addShadom:CGRectMake(0, kRealWidth(160), kScreenWidth, kRealWidth(100))]];
    [self.contentView addSubview:self.buinessView];
    [self.contentView addSubview:self.addressView];
    [self.contentView addSubview:self.callView];
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.rateLB];
    [self.contentView addSubview:self.rateView];
    [self.contentView addSubview:self.perCapitaLB];
    [self.buinessView addSubview:self.businessTipLB];
    [self.buinessView addSubview:self.businessLB];
    [self.buinessView addSubview:self.areaLB];
    [self.buinessView addSubview:self.tagCollectionView];
    [self.buinessView addSubview:self.rightBTN];
    [self.addressView addSubview:self.addressBTN];
    [self.addressView addSubview:self.addressLB];
    [self.callView addSubview:self.callBTN];
    [self.callView addSubview:self.callLB];
    [self.contentView addSubview:self.line1];
    [self.contentView addSubview:self.line2];
}

- (void)updateConstraints {
    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.height.mas_equalTo(kRealWidth(260));
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(52), kRealWidth(52)));
        make.left.mas_equalTo(kRealWidth(12));
        make.bottom.lessThanOrEqualTo(self.bgIV.mas_bottom).offset(-kRealWidth(20));
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV).offset(-kRealWidth(8));
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(8));
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(30));
    }];

    [self.rateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.perCapitaLB.isHidden) {
            make.right.equalTo(self.nameLB);
        } else {
            make.right.equalTo(self.perCapitaLB.mas_left).offset(-kRealWidth(5));
        }
        if (!self.rateView.isHidden) {
            make.left.equalTo(self.rateView.mas_right).offset(kRealWidth(4));
            make.centerY.equalTo(self.rateView);
        } else {
            make.left.equalTo(self.nameLB);
            make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(9));
            make.bottom.lessThanOrEqualTo(self.bgIV.mas_bottom).offset(-kRealWidth(20));
        }
    }];

    [self.rateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rateView.isHidden) {
            make.left.equalTo(self.nameLB);
            make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(9));
            make.bottom.lessThanOrEqualTo(self.bgIV.mas_bottom).offset(-kRealWidth(20));
        }
    }];

    [self.perCapitaLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.perCapitaLB.isHidden) {
            make.centerY.equalTo(self.rateLB);
            make.right.equalTo(self.nameLB);
        }
    }];

    [self.buinessView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.bgIV.mas_bottom);
    }];

    [self.businessTipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(20));
    }];

    [self.businessLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.businessTipLB.mas_right).offset(kRealWidth(2));
        make.centerY.equalTo(self.businessTipLB);
        make.right.equalTo(self.rightBTN.mas_left).offset(-kRealWidth(8));
    }];

    [self.areaLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.businessTipLB);
        make.right.equalTo(self.businessLB);
        make.top.equalTo(self.businessTipLB.mas_bottom).offset(kRealWidth(8));
        if (self.tagCollectionView.isHidden) {
            make.bottom.mas_equalTo(-kRealWidth(20));
        }
    }];

    [self.tagCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tagCollectionView.isHidden) {
            make.top.equalTo(self.areaLB.mas_bottom).offset(kRealWidth(8));
            make.left.right.equalTo(self.areaLB);
            make.height.mas_equalTo(kRealWidth(22));
            make.bottom.mas_equalTo(-kRealWidth(20));
        }
    }];

    [self.rightBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(24), kRealWidth(24)));
        make.centerY.mas_equalTo(0);
    }];

    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.buinessView.mas_bottom);
        make.height.mas_equalTo(HDAppTheme.value.gn_line);
    }];

    [self.addressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.line1.mas_bottom);
    }];

    [self.addressLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kRealWidth(12));
        make.right.equalTo(self.addressBTN.mas_left).offset(-kRealWidth(8));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.top.mas_greaterThanOrEqualTo(kRealWidth(8));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(8));
        make.centerY.mas_equalTo(0);
    }];

    [self.addressBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(14));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(28), kRealWidth(28)));
        make.top.mas_greaterThanOrEqualTo(kRealWidth(14));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(14));
    }];

    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.line1);
        make.top.equalTo(self.addressView.mas_bottom);
    }];

    [self.callView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.line2.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];

    [self.callBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(14));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(28), kRealWidth(28)));
        make.top.mas_equalTo(kRealWidth(14));
        make.bottom.mas_equalTo(-kRealWidth(14));
    }];

    [self.callLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.equalTo(self.callBTN.mas_left).offset(-kRealWidth(8));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.centerY.equalTo(self.callBTN);
    }];

    [self.rateView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.rateLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.businessTipLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.areaLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];

    [super updateConstraints];
}

- (void)setGNModel:(GNStoreDetailModel *)data {
    if ([data isKindOfClass:GNStoreDetailModel.class]) {
        self.model = data;
        [self.bgIV sd_setImageWithURL:[NSURL URLWithString:data.signboardPhoto]
                     placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(375), kRealWidth(260)) logoWidth:kRealWidth(130)]];
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:data.logo] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(52), kRealWidth(52)) logoWidth:kRealWidth(26)]];
        self.nameLB.text = GNFillEmpty(data.storeName.desc);
        self.rateView.score = [data.score floatValue];
        self.rateView.hidden = (data.score.floatValue == 0);
        self.rateLB.text = data.score.floatValue > 0 ? [NSString stringWithFormat:@"%.1f", data.score.doubleValue] : GNLocalizedString(@"gn_no_ratings_yet", @"暂无评分");
        self.perCapitaLB.text = [NSString stringWithFormat:@"%@/%@", GNFillMonEmpty(data.perCapita), GNLocalizedString(@"gn_per_capita", @"人均")];
        if (GNStringNotEmpty(data.shortBusinessStr)) {
            self.businessLB.text = [NSString stringWithFormat:@" • %@", data.shortBusinessStr];
        } else {
            self.businessLB.text = @"";
        }
        self.perCapitaLB.hidden = (data.perCapita.doubleValue == 0);
        self.areaLB.text = [NSString stringWithFormat:@"%@ • %@", GNFillEmpty(data.commercialDistrictName.desc), GNFillEmpty(data.classificationName.desc)];
        [self.tagCollectionView successGetNewDataWithNoMoreData:NO];

        self.tagCollectionView.hidden = !data.inServiceName.count;
        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:GNLocalizedString(@"gn_reverve_phone", @"Call")];
        [GNStringUntils attributedString:mstr color:HDAppTheme.color.gn_333Color colorRange:mstr.string font:[HDAppTheme.font gn_boldForSize:16] fontRange:mstr.string];
        [GNStringUntils attributedString:mstr lineSpacing:kRealWidth(4) colorRange:mstr.string];
        self.callLB.attributedText = mstr;

        NSMutableAttributedString *addressMstr = [[NSMutableAttributedString alloc] initWithString:GNFillEmpty(data.address)];
        [GNStringUntils attributedString:addressMstr color:HDAppTheme.color.gn_333Color colorRange:addressMstr.string font:[HDAppTheme.font gn_boldForSize:16] fontRange:addressMstr.string];
        [GNStringUntils attributedString:addressMstr lineSpacing:kRealWidth(4) colorRange:addressMstr.string];
        self.addressLB.attributedText = addressMstr;
        self.addressLB.lineBreakMode = NSLineBreakByTruncatingTail;
        [self setNeedsUpdateConstraints];
    }
}

#pragma mark datasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GNTagCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.layer.backgroundColor = HDAppTheme.color.gn_whiteColor.CGColor;
    [cell.nameLb setTitleColor:HDAppTheme.color.gn_666Color forState:UIControlStateNormal];
    cell.nameLb.titleLabel.font = [HDAppTheme.font gn_ForSize:12];
    cell.contentView.layer.cornerRadius = kRealWidth(2);
    cell.contentView.layer.backgroundColor = HDAppTheme.color.gn_mainBgColor.CGColor;
    [cell.nameLb setTitle:GNFillEmpty(self.model.inServiceName[indexPath.row].title) forState:UIControlStateNormal];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(3, self.model.inServiceName.count);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNInternationalizationModel *model = self.model.inServiceName[indexPath.row];
    if (!model.width) {
        model.width = ceilf([model.title boundingRectWithSize:CGSizeMake(MAXFLOAT, kRealWidth(22)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                   attributes:@{NSFontAttributeName: [HDAppTheme.font gn_ForSize:12]}
                                                      context:nil]
                                .size.width);
    }
    return CGSizeMake(MIN(self.tagCollectionView.hd_width, model.width + kRealWidth(16)), kRealWidth(22));
}

///营业时间详情
- (void)buinessAction {
    [GNEvent eventResponder:self target:self.buinessView key:@"buinessDetailAction" indexPath:self.model.indexPath];
}

///跳转地图
- (void)mapAction {
    [GNEvent eventResponder:self target:self.buinessView key:@"mapAction" indexPath:self.model.indexPath];
}

- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = UIImageView.new;
        _bgIV.contentMode = UIViewContentModeScaleAspectFill;
        _bgIV.clipsToBounds = YES;
    }
    return _bgIV;
}

- (UIView *)buinessView {
    if (!_buinessView) {
        _buinessView = UIView.new;
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buinessAction)];
        [_buinessView addGestureRecognizer:ta];
    }
    return _buinessView;
}

- (UIView *)addressView {
    if (!_addressView) {
        _addressView = UIView.new;
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapAction)];
        [_addressView addGestureRecognizer:ta];
    }
    return _addressView;
}

- (UIView *)callView {
    if (!_callView) {
        _callView = UIView.new;
    }
    return _callView;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.clipsToBounds = YES;
            view.layer.cornerRadius = kRealWidth(4);
        };
    }
    return _iconIV;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_whiteColor;
        la.font = [HDAppTheme.font gn_boldForSize:20];
        la.numberOfLines = 0;
        _nameLB = la;
    }
    return _nameLB;
}

- (GNStarView *)rateView {
    if (!_rateView) {
        _rateView = GNStarView.new;
        _rateView.defaultImage = @"gn_storeinfo_pentagram_to";
        _rateView.selectImage = @"gn_storeinfo_pentagram_sel";
        _rateView.maxValue = 5;
        _rateView.space = 1;
        _rateView.font = [HDAppTheme.font gn_ForSize:12 weight:UIFontWeightHeavy];
    }
    return _rateView;
}

- (HDLabel *)rateLB {
    if (!_rateLB) {
        _rateLB = HDLabel.new;
        _rateLB.textColor = HDAppTheme.color.gn_mainColor;
        _rateLB.font = [HDAppTheme.font gn_ForSize:14 weight:UIFontWeightHeavy];
    }
    return _rateLB;
}

- (HDLabel *)perCapitaLB {
    if (!_perCapitaLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_whiteColor;
        la.font = [HDAppTheme.font gn_ForSize:12];
        la.layer.cornerRadius = kRealWidth(5);
        la.layer.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.3].CGColor;
        la.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(kRealWidth(6)), kRealWidth(6), kRealWidth(6), kRealWidth(6));
        _perCapitaLB = la;
    }
    return _perCapitaLB;
}

- (HDLabel *)businessTipLB {
    if (!_businessTipLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_mainColor;
        la.font = [HDAppTheme.font gn_boldForSize:14];
        la.text = GNLocalizedString(@"gn_store_businessTime", @"营业时间");
        _businessTipLB = la;
    }
    return _businessTipLB;
}

- (HDLabel *)businessLB {
    if (!_businessLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_666Color;
        la.font = [HDAppTheme.font gn_ForSize:14 weight:UIFontWeightMedium];
        _businessLB = la;
    }
    return _businessLB;
}

- (HDLabel *)areaLB {
    if (!_areaLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_333Color;
        la.font = [HDAppTheme.font gn_ForSize:12];
        _areaLB = la;
    }
    return _areaLB;
}

- (HDUIButton *)rightBTN {
    if (!_rightBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gn_storeinfo_gengd"] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        _rightBTN = btn;
    }
    return _rightBTN;
}

- (HDUIButton *)addressBTN {
    if (!_addressBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gn_storeinfo_daohang"] forState:UIControlStateNormal];
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[GNEvent eventResponder:self target:btn key:@"navigationAction"];
        }];
        _addressBTN = btn;
    }
    return _addressBTN;
}

- (HDUIButton *)callBTN {
    if (!_callBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gn_storeinfo_call"] forState:UIControlStateNormal];
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[GNEvent eventResponder:self target:btn key:@"callAction"];
        }];
        _callBTN = btn;
    }
    return _callBTN;
}

- (UIView *)line1 {
    if (!_line1) {
        UIView *line = UIView.new;
        line.backgroundColor = HDAppTheme.color.gn_lineColor;
        _line1 = line;
    }
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        UIView *line = UIView.new;
        line.backgroundColor = HDAppTheme.color.gn_lineColor;
        _line2 = line;
    }
    return _line2;
}

- (HDLabel *)addressLB {
    if (!_addressLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_333Color;
        la.numberOfLines = 2;
        la.font = [HDAppTheme.font gn_boldForSize:16];
        _addressLB = la;
    }
    return _addressLB;
}

- (HDLabel *)callLB {
    if (!_callLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_333Color;
        la.numberOfLines = 2;
        la.font = [HDAppTheme.font gn_boldForSize:16];
        _callLB = la;
    }
    return _callLB;
}

- (GNCollectionView *)tagCollectionView {
    if (!_tagCollectionView) {
        HDCollectionViewVerticalLayout *flowLayout = [[HDCollectionViewVerticalLayout alloc] init];
        flowLayout.delegate = self;
        _tagCollectionView = [[GNCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealHeight(28)) collectionViewLayout:flowLayout];
        _tagCollectionView.delegate = self;
        _tagCollectionView.dataSource = self;
        _tagCollectionView.clipsToBounds = YES;
        _tagCollectionView.needShowNoDataView = NO;
        _tagCollectionView.userInteractionEnabled = NO;
        _tagCollectionView.mj_header = nil;
        _tagCollectionView.mj_footer = nil;
        [_tagCollectionView registerClass:GNTagCollectionViewCell.class forCellWithReuseIdentifier:@"GNTagCollectionViewCell"];
    }
    return _tagCollectionView;
}

- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        const CGFloat w = self.hd_width;
        make.width.hd_equalTo(w);
        make.centerX.hd_equalTo(self.hd_width * 0.5);
        make.top.hd_equalTo(10);
        make.height.hd_equalTo(w * (260 / 375.0));
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(150);
        make.height.hd_equalTo(30);
        make.left.hd_equalTo(10);
        make.top.hd_equalTo(r0.hd_bottom + 10);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    r2.animationStyle = HDSkeletonLayerAnimationStyleGradientLeftToRight;
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(kScreenWidth * 0.15);
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(r1.hd_left);
        make.top.hd_equalTo(r1.hd_bottom + 10);
    }];

    HDSkeletonLayer *r2_1 = [[HDSkeletonLayer alloc] init];
    [r2_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(kScreenWidth * 0.2);
        make.height.hd_equalTo(r2.hd_height);
        make.left.hd_equalTo(r2.hd_right + 10);
        make.top.hd_equalTo(r2.hd_top);
    }];

    HDSkeletonLayer *r2_2 = [[HDSkeletonLayer alloc] init];
    [r2_2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(kScreenWidth * 0.25);
        make.height.hd_equalTo(r2.hd_height);
        make.left.hd_equalTo(r2_1.hd_right + 10);
        make.top.hd_equalTo(r2.hd_top);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(self.hd_width * 0.8);
        make.left.hd_equalTo(r1.hd_left);
        make.height.hd_equalTo(25);
        make.top.hd_equalTo(r2_1.hd_bottom + 10);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(100);
        make.left.hd_equalTo(r3.hd_left);
        make.height.hd_equalTo(40);
        make.top.hd_equalTo(r3.hd_bottom + 25);
    }];

    HDSkeletonLayer *r4_1 = [[HDSkeletonLayer alloc] init];
    [r4_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(CGSizeMake(10, 18));
        make.right.hd_equalTo(r0.hd_right);
        make.centerY.hd_equalTo(r4.hd_centerY);
    }];

    CGSize size = CGSizeMake(self.hd_width * 0.2, 30);
    HDSkeletonLayer *r5 = [[HDSkeletonLayer alloc] init];
    [r5 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(size);
        make.left.hd_equalTo(r4.hd_left);
        make.top.hd_equalTo(r4.hd_bottom + 25);
    }];

    HDSkeletonLayer *r5_1 = [[HDSkeletonLayer alloc] init];
    [r5_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(size);
        make.left.hd_equalTo(r5.hd_right + 10);
        make.top.hd_equalTo(r5.hd_top);
    }];

    HDSkeletonLayer *r5_2 = [[HDSkeletonLayer alloc] init];
    [r5_2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(size);
        make.left.hd_equalTo(r5_1.hd_right + 10);
        make.top.hd_equalTo(r5.hd_top);
    }];

    HDSkeletonLayer *r5_3 = [[HDSkeletonLayer alloc] init];
    [r5_3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(size);
        make.left.hd_equalTo(r5_2.hd_right + 10);
        make.top.hd_equalTo(r5.hd_top);
    }];

    return @[r0, r1, r2, r2_1, r2_2, r3, r4, r4_1, r5, r5_1, r5_2, r5_3];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return 235 + 20 + (kScreenWidth - 2 * 10) * (260 / 375.0);
}
@end
