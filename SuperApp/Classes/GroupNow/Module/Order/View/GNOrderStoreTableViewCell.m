//
//  GNOrderStoreTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderStoreTableViewCell.h"
#import "GNProductModel.h"
#import "GNStoreCellModel.h"
#import "GNStringUntils.h"


@interface GNOrderStoreTableViewCell ()
/// 导航
@property (nonatomic, strong) HDUIButton *locationBtn;
/// 预约
@property (nonatomic, strong) HDUIButton *reserveBTN;
/// 联系
@property (nonatomic, strong) HDLabel *connectLB;
/// 门店
@property (nonatomic, strong) HDLabel *storeLB;
/// leftView
@property (nonatomic, strong) UIView *leftView;
/// topView
@property (nonatomic, strong) UIView *topView;

@end


@implementation GNOrderStoreTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.locationBtn];
    [self.contentView addSubview:self.reserveBTN];
    [self.contentView addSubview:self.connectLB];
    [self.contentView addSubview:self.storeLB];
    [self.contentView addSubview:self.leftView];
    [self.contentView addSubview:self.topView];
}

- (void)updateConstraints {
    [self.storeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(HDAppTheme.value.gn_marginL);
        make.right.mas_offset(-HDAppTheme.value.gn_marginL);
        make.top.mas_equalTo(kRealWidth(16));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
    }];

    [self.connectLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storeLB.mas_bottom).offset(kRealWidth(4));
        make.left.right.equalTo(self.storeLB);
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
    }];

    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.topView.isHidden) {
            make.top.equalTo(self.connectLB.mas_bottom).offset(kRealWidth(16));
            make.left.right.mas_offset(0);
            make.height.mas_offset(HDAppTheme.value.gn_line);
        }
    }];

    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.leftView.isHidden) {
            make.top.equalTo(self.topView.mas_bottom).offset(kRealWidth(16));
            make.centerX.mas_offset(0);
            make.width.mas_offset(HDAppTheme.value.gn_line);
            make.bottom.equalTo(self.locationBtn.mas_bottom).offset(-kRealWidth(16));
        }
    }];

    [self.reserveBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.reserveBTN.isHidden) {
            make.right.equalTo(self.leftView.mas_left);
            make.left.mas_offset(HDAppTheme.value.gn_marginL);
            make.top.height.mas_equalTo(self.locationBtn);
        }
    }];

    [self.locationBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.locationBtn.isHidden) {
            if (self.reserveBTN.isHidden) {
                make.centerX.mas_equalTo(0);
            } else {
                make.right.mas_offset(-HDAppTheme.value.gn_marginL);
                make.left.equalTo(self.leftView.mas_right);
            }
            make.top.equalTo(self.topView.mas_bottom);
            make.bottom.mas_lessThanOrEqualTo(0);
            make.height.mas_equalTo(kRealWidth(80));
        }
    }];

    [super updateConstraints];
}

- (void)setGNModel:(GNStoreCellModel *)data {
    self.model = data;
    self.topView.hidden = self.leftView.hidden = self.locationBtn.hidden = self.reserveBTN.hidden = YES;
    if ([data isKindOfClass:GNStoreCellModel.class]) {
        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:GNFillEmpty(data.address)];
        [GNStringUntils attributedString:mstr color:HDAppTheme.color.gn_333Color colorRange:mstr.string font:[HDAppTheme.font gn_ForSize:12] fontRange:mstr.string];
        [GNStringUntils attributedString:mstr lineSpacing:kRealWidth(4) colorRange:mstr.string];
        self.storeLB.text = GNFillEmpty(data.storeName.desc);
        self.connectLB.attributedText = mstr;
        self.topView.hidden = self.locationBtn.hidden = NO;
        self.leftView.hidden = self.reserveBTN.hidden = !data.showReserve;
    } else if ([data isKindOfClass:GNProductModel.class]) {
        GNProductModel *mo = (GNProductModel *)data;
        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:GNFillEmpty(mo.productContent.desc)];
        [GNStringUntils attributedString:mstr color:HDAppTheme.color.gn_333Color colorRange:mstr.string font:[HDAppTheme.font gn_ForSize:12] fontRange:mstr.string];
        [GNStringUntils attributedString:mstr lineSpacing:kRealWidth(4) colorRange:mstr.string];
        self.storeLB.text = GNLocalizedString(@"gn_product_details", @"产品详情");
        self.connectLB.attributedText = mstr;
    }
    [self setNeedsUpdateConstraints];
}

- (HDUIButton *)locationBtn {
    if (!_locationBtn) {
        _locationBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_locationBtn setImage:[UIImage imageNamed:@"gn_reserve_path"] forState:UIControlStateNormal];
        [_locationBtn setTitle:GNLocalizedString(@"gn_store_navigation", @"导航") forState:UIControlStateNormal];
        _locationBtn.titleLabel.font = [HDAppTheme.font gn_ForSize:11];
        [_locationBtn setTitleColor:HDAppTheme.color.gn_333Color forState:UIControlStateNormal];
        _locationBtn.imagePosition = HDUIButtonImagePositionTop;
        _locationBtn.spacingBetweenImageAndTitle = kRealWidth(2);
        @HDWeakify(self)[_locationBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[GNEvent eventResponder:self target:btn key:@"navigationAction"];
        }];
    }
    return _locationBtn;
}

- (HDUIButton *)reserveBTN {
    if (!_reserveBTN) {
        _reserveBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_reserveBTN setImage:[UIImage imageNamed:@"gn_reserve_icon"] forState:UIControlStateNormal];
        [_reserveBTN setTitle:GNLocalizedString(@"gn_book", @"预约") forState:UIControlStateNormal];
        _reserveBTN.titleLabel.font = [HDAppTheme.font gn_ForSize:11];
        [_reserveBTN setTitleColor:HDAppTheme.color.gn_333Color forState:UIControlStateNormal];
        _reserveBTN.imagePosition = HDUIButtonImagePositionTop;
        _reserveBTN.spacingBetweenImageAndTitle = kRealWidth(2);
        @HDWeakify(self)[_reserveBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[GNEvent eventResponder:self target:btn key:@"reserveAction"];
        }];
    }
    return _reserveBTN;
}

- (HDLabel *)connectLB {
    if (!_connectLB) {
        _connectLB = HDLabel.new;
        _connectLB.font = [HDAppTheme.font gn_boldForSize:12];
        _connectLB.textColor = HDAppTheme.color.gn_333Color;
        _connectLB.numberOfLines = 0;
    }
    return _connectLB;
}

- (HDLabel *)storeLB {
    if (!_storeLB) {
        _storeLB = HDLabel.new;
        _storeLB.numberOfLines = 0;
        _storeLB.textColor = HDAppTheme.color.gn_333Color;
        _storeLB.font = [HDAppTheme.font gn_ForSize:16 weight:UIFontWeightHeavy];
    }
    return _storeLB;
}

- (UIView *)leftView {
    if (!_leftView) {
        UIView *view = UIView.new;
        view.backgroundColor = HDAppTheme.color.gn_lineColor;
        _leftView = view;
    }
    return _leftView;
}

- (UIView *)topView {
    if (!_topView) {
        UIView *view = UIView.new;
        view.backgroundColor = HDAppTheme.color.gn_lineColor;
        _topView = view;
    }
    return _topView;
}

@end
