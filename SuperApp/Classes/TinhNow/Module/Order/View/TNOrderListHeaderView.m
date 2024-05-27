//
//  TNOrderListHeaderView.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNOrderListHeaderView.h"
#import "HDAppTheme+TinhNow.h"
#import "HDMediator+TinhNow.h"
#import <HDVendorKit/HDWebImageManager.h>
#import <Masonry/Masonry.h>


@interface TNOrderListHeaderView ()
///
@property (strong, nonatomic) UIView *sectionView;
/// 门店 logo
@property (nonatomic, strong) UIImageView *storeIV;
/// 门店名称
@property (nonatomic, strong) UILabel *storeNameLabel;
/// 箭头
@property (nonatomic, strong) UIImageView *arrowIV;
/// 店铺点击背景
@property (strong, nonatomic) UIControl *storeControl;
/// 电商店铺类型标签
@property (strong, nonatomic) UIImageView *storeTypeTag;
/// 状态文本
@property (strong, nonatomic) UILabel *statusLabel;
/// 分隔线
@property (nonatomic, strong) UIView *sepLine;
@end


@implementation TNOrderListHeaderView
- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.sectionView];
    [self.contentView addSubview:self.storeControl];
    [self.storeControl addSubview:self.storeIV];
    [self.storeControl addSubview:self.arrowIV];
    [self.storeControl addSubview:self.storeNameLabel];
    [self.contentView addSubview:self.storeTypeTag];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.sepLine];
}
- (void)setOrderModel:(TNOrderModel *)orderModel {
    _orderModel = orderModel;
    self.storeNameLabel.text = orderModel.storeInfo.storeName;
    //电商店铺标签显示
    if ([orderModel.storeInfo.storeType isEqualToString:TNStoreTypeOverseasShopping]) {
        self.storeTypeTag.hidden = NO;
        self.storeTypeTag.image = [UIImage imageNamed:@"tn_global_k"];
    } else if ([orderModel.storeInfo.storeType isEqualToString:TNStoreTypeSelf]) {
        self.storeTypeTag.hidden = NO;
        self.storeTypeTag.image = [UIImage imageNamed:@"tn_offcial_k"];
    } else {
        self.storeTypeTag.hidden = YES;
    }
    [HDWebImageManager setImageWithURL:orderModel.storeInfo.storeLogo placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(25), kRealWidth(25))] imageView:self.storeIV];
    self.statusLabel.textColor = orderModel.statusColor;
    self.statusLabel.text = orderModel.statusDes;
    [self setNeedsUpdateConstraints];
}
#pragma mark -点击店铺
- (void)storeClick {
    [HDMediator.sharedInstance navigaveToTinhNowStoreInfoViewController:@{@"storeNo": self.orderModel.storeInfo.storeNo}];
}
- (void)updateConstraints {
    [self.sectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(kRealWidth(10));
    }];
    [self.storeControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.top.equalTo(self.sectionView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
    }];
    [self.storeIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.equalTo(self.storeControl);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(25), kRealWidth(25)));
    }];
    [self.storeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.storeControl);
        make.left.equalTo(self.storeIV.mas_right).offset(kRealWidth(5));
    }];
    [self.arrowIV sizeToFit];
    [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(self.storeControl);
        make.left.equalTo(self.storeNameLabel.mas_right).offset(kRealWidth(10));
        if (self.storeTypeTag.isHidden) {
            make.right.lessThanOrEqualTo(self.statusLabel.mas_left).offset(-kRealWidth(30));
        }
    }];
    if (!self.storeTypeTag.isHidden) {
        [self.storeTypeTag sizeToFit];
        [self.storeTypeTag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.storeControl);
            make.left.equalTo(self.storeControl.mas_right).offset(kRealWidth(10));
            make.right.lessThanOrEqualTo(self.statusLabel.mas_left).offset(-kRealWidth(20));
        }];
    }
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.storeControl);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.sepLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(0.5);
    }];

    [self.storeNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.storeTypeTag setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.statusLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}
/** @lazy storeControl */
- (UIControl *)storeControl {
    if (!_storeControl) {
        _storeControl = [[UIControl alloc] init];
        [_storeControl addTarget:self action:@selector(storeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _storeControl;
}
- (UIImageView *)storeIV {
    if (!_storeIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(25), kRealWidth(25))];
        imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.width / 2];
        };
        _storeIV = imageView;
    }
    return _storeIV;
}
/** @lazy storeNameLabel */
- (UILabel *)storeNameLabel {
    if (!_storeNameLabel) {
        _storeNameLabel = [[UILabel alloc] init];
        _storeNameLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _storeNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
    }
    return _storeNameLabel;
}
- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"order_list_right"];
        imageView.userInteractionEnabled = true;
        imageView.contentMode = UIViewContentModeCenter;
        _arrowIV = imageView;
    }
    return _arrowIV;
}
/** @lazy storeTypeTag */
- (UIImageView *)storeTypeTag {
    if (!_storeTypeTag) {
        _storeTypeTag = [[UIImageView alloc] init];
    }
    return _storeTypeTag;
}

- (UIView *)sepLine {
    if (!_sepLine) {
        _sepLine = UIView.new;
        _sepLine.backgroundColor = HDAppTheme.TinhNowColor.cD6DBE8;
    }
    return _sepLine;
}
/** @lazy statusLabel */
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [HDAppTheme.TinhNowFont fontRegular:12];
        _statusLabel.textColor = HDAppTheme.TinhNowColor.G1;
    }
    return _statusLabel;
}
/** @lazy sectionView */
- (UIView *)sectionView {
    if (!_sectionView) {
        _sectionView = [[UIView alloc] init];
        _sectionView.backgroundColor = HDAppTheme.TinhNowColor.G5;
    }
    return _sectionView;
}
@end
