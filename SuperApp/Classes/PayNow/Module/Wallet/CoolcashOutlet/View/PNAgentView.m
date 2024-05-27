//
//  PNAgentView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNAgentView.h"
#import "PNAgentInfoModel.h"
#import "PNAgentServicesCell.h"
#import "PNCollectionView.h"
#import "UICollectionViewLeftAlignLayout.h"


@interface PNAgentView () <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) PNCollectionView *collectionView;
@property (nonatomic, strong) PNView *contentView;
@property (nonatomic, strong) HDUIButton *bgButton;
@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) SALabel *agentNameLabel;
@property (nonatomic, strong) SALabel *agentAddressNameLabel;
@property (nonatomic, strong) SALabel *serviceSectionTitleLabel;
@property (nonatomic, strong) SALabel *addressSectionTitleLabel;
@property (nonatomic, strong) SALabel *addressLabel;
@property (nonatomic, strong) HDUIButton *navButton;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL flag;
@end


@implementation PNAgentView

#pragma mark
- (void)hd_setupViews {
    [self addSubview:self.bgButton];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.logoImgView];
    [self.contentView addSubview:self.agentNameLabel];
    [self.contentView addSubview:self.agentAddressNameLabel];
    [self.contentView addSubview:self.serviceSectionTitleLabel];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.addressSectionTitleLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.navButton];
}

- (void)updateConstraints {
    [self.bgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.bottom.mas_equalTo(self.mas_bottom).offset(kRealWidth(-50));
    }];

    [self.logoImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(70), kRealWidth(70)));
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(15));
    }];

    [self.agentNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoImgView.mas_right).offset(kRealWidth(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.logoImgView.mas_top).offset(kRealWidth(15));
    }];

    [self.agentAddressNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoImgView.mas_right).offset(kRealWidth(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.agentNameLabel.mas_bottom).offset(kRealWidth(5));
    }];

    [self.serviceSectionTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImgView.mas_bottom).offset(kRealWidth(8));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.cellHeight));
        make.top.mas_equalTo(self.serviceSectionTitleLabel.mas_bottom).offset(kRealWidth(8));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.bottom.mas_equalTo(self.addressSectionTitleLabel.mas_top).offset(kRealWidth(-8));
    }];

    [self.addressSectionTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(kRealWidth(8));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
    }];

    [self.navButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
        make.width.equalTo(@(self.navButton.width + 5));
        make.height.equalTo(@(25));
        if (!WJIsStringNotEmpty(self.addressLabel.text)) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(kRealWidth(-20));
        } else {
            make.bottom.mas_equalTo(self.addressLabel.mas_bottom);
        }
    }];

    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressSectionTitleLabel.mas_bottom).offset(kRealWidth(8));
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.navButton.mas_left).offset(kRealWidth(-15));
        if (WJIsStringNotEmpty(self.addressLabel.text)) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(kRealWidth(-20));
        }
    }];

    [super updateConstraints];
}

- (void)setModel:(PNAgentInfoModel *)model {
    _model = model;

    //    model.merchantNo = @"1223123";
    //    model.merchantName = @"葵花路的tit充值点";
    //    if (self.flag) {
    //        model.products = @[@"代理入金", @"代理出金", @"代理汇款", @"代理话费充值", @"代理提现"];
    //        model.address = @"柬埔寨的地址柬埔寨的地址柬埔寨的地址柬埔寨的地址柬埔寨的地址柬埔寨的地址";
    //    } else {
    //        model.products = @[@"2代理入金", @"2代理出金", @"22222代理汇款", @"2代理话费充值", @"2代理提现", @"3代理提现"];
    //        model.address = @"柬埔寨的地址柬埔寨的地址柬";
    //    }
    //    self.flag = !self.flag;

    [HDWebImageManager setImageWithURL:self.model.merchantLogo placeholderImage:[UIImage imageNamed:@"CoolCash"] imageView:self.logoImgView];
    self.agentAddressNameLabel.text = model.merchantName;
    self.addressLabel.text = model.address;

    [self.collectionView successGetNewDataWithNoMoreData:NO];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    self.cellHeight = self.collectionView.contentSize.height;
    [self setNeedsUpdateConstraints];
}

#pragma mark
/// 点击背景隐藏view
- (void)tap {
    !self.clickTapHiddenBlock ?: self.clickTapHiddenBlock();
    [self hiddenView];
}

/// 展示view
- (void)showInView:(UIView *)superview {
    if (!self.hidden) {
        [self hiddenView];
        return;
    }

    self.contentView.top = kScreenHeight;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.top = self.height - (self.contentView.height + 30);
        self.hidden = NO;
        self.contentView.alpha = 1;
    }];
}

/// 隐藏view
- (void)hiddenView {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.alpha = 0;
        self.contentView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

/// 跳转第三方导航
- (void)clickOnNavigave:(UIButton *)button {
    HDActionSheetView *alert = [HDActionSheetView alertViewWithCancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") config:nil];
    NSMutableArray<HDActionSheetViewButton *> *buttons = [[NSMutableArray alloc] initWithCapacity:3];

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        [buttons addObject:[HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"Google_Maps", @"Google Map") type:HDActionSheetViewButtonTypeCustom
                                                            handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                [alertView dismiss];
                                                                NSString *urlStr = [NSString stringWithFormat:@"comgooglemaps://?daddr=%f,%f(%@)&directionsmode=driving",
                                                                                                              self.model.latitude.doubleValue,
                                                                                                              self.model.longitude.doubleValue,
                                                                                                              self.model.address ?: @""];
                                                                /// 转换一下，防止转成NSURL 为nil
                                                                NSString *newURLStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

                                                                NSURL *url = [NSURL URLWithString:newURLStr];
                                                                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                                                            }]];
    }

    [buttons addObject:[HDActionSheetViewButton
                           buttonWithTitle:PNLocalizedString(@"Apple_Maps", @"Apple Map")
                                      type:HDActionSheetViewButtonTypeCustom
                                   handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                       [alertView dismiss];
                                       MKMapItem *currentStation = [MKMapItem mapItemForCurrentLocation];

                                       CLLocationCoordinate2D station = CLLocationCoordinate2DMake(self.model.latitude.doubleValue, self.model.longitude.doubleValue);
                                       MKMapItem *toStation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:station addressDictionary:nil]];
                                       toStation.name = self.model.address ?: @"";

                                       [MKMapItem
                                           openMapsWithItems:@[currentStation, toStation]
                                               launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
                                   }]];

    if (buttons.count == 0) {
        [HDTips showWithText:PNLocalizedString(@"not_find_nav", @"找不到可用的导航工具") hideAfterDelay:3];
        return;
    }
    [alert addButtons:buttons];
    [alert show];
}

#pragma mark - CollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PNAgentServicesCell *cell = [PNAgentServicesCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    NSString *itemStr = [self.model.products objectAtIndex:indexPath.item];
    cell.titleStr = itemStr;
    return cell;
}

#pragma mark
- (PNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewLeftAlignLayout *flowLayout = [[UICollectionViewLeftAlignLayout alloc] init];
        flowLayout.minimumLineSpacing = kRealWidth(5);
        flowLayout.minimumInteritemSpacing = kRealWidth(5);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
        flowLayout.estimatedItemSize = CGSizeMake(70, 23);
        _collectionView = [[PNCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 30, 100) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (PNView *)contentView {
    if (!_contentView) {
        PNView *view = [[PNView alloc] init];
        view.userInteractionEnabled = YES;
        view.layer.cornerRadius = kRealWidth(12);
        view.layer.shadowColor = [HDAppTheme.PayNowColor.c000000 colorWithAlphaComponent:0.3].CGColor;
        view.layer.shadowOffset = CGSizeMake(0, 3);
        view.layer.shadowOpacity = 0.5;
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;

        _contentView = view;
    }
    return _contentView;
}

- (UIImageView *)logoImgView {
    if (!_logoImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _logoImgView = imageView;
    }
    return _logoImgView;
}

- (SALabel *)agentNameLabel {
    if (!_agentNameLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.numberOfLines = 1;
        label.text = PNLocalizedString(@"agent_name", @"商户名称");
        _agentNameLabel = label;
    }
    return _agentNameLabel;
}

- (SALabel *)agentAddressNameLabel {
    if (!_agentAddressNameLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15B;
        label.numberOfLines = 2;
        _agentAddressNameLabel = label;
    }
    return _agentAddressNameLabel;
}

- (SALabel *)serviceSectionTitleLabel {
    if (!_serviceSectionTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.text = PNLocalizedString(@"agent_services", @"服务范围");
        _serviceSectionTitleLabel = label;
    }
    return _serviceSectionTitleLabel;
}

- (SALabel *)addressSectionTitleLabel {
    if (!_addressSectionTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.text = PNLocalizedString(@"agent_address", @"网点地址");
        _addressSectionTitleLabel = label;
    }
    return _addressSectionTitleLabel;
}

- (SALabel *)addressLabel {
    if (!_addressLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard13;
        label.numberOfLines = 0;
        _addressLabel = label;
    }
    return _addressLabel;
}

- (HDUIButton *)navButton {
    if (!_navButton) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"Navigate", @"导航") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard12;
        [button setImage:[UIImage imageNamed:@"pn_map_nav"] forState:0];
        button.adjustsButtonWhenHighlighted = NO;
        button.imagePosition = HDUIButtonImagePositionLeft;
        button.spacingBetweenImageAndTitle = kRealWidth(kRealWidth(5));
        button.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            @HDStrongify(self);
            [self clickOnNavigave:self.navButton];
        }];

        button.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(2)];
        };

        _navButton = button;
    }
    return _navButton;
}

- (HDUIButton *)bgButton {
    if (!_bgButton) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self tap];
        }];

        _bgButton = button;
    }
    return _bgButton;
}

@end
