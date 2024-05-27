//
//  TNProductDetailsStoreCell.m
//  SuperApp
//
//  Created by xixi on 2021/1/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductDetailsStoreCell.h"
#import "HDAppTheme+TinhNow.h"
#import "HDLocationUtils.h"
#import "SAOperationButton.h"
#import "TNCutomerServicePopCell.h"
#import "TNStoreRecommendProductView.h"
#import "TNStoreRecommendWapperView.h"
#import "YBPopupMenu.h"


@interface TNProductDetailsStoreCell ()
/// 背景视图
@property (strong, nonatomic) UIControl *storeInfoControl;
/// 渐变图片
@property (strong, nonatomic) UIImageView *gradeImageView;
/// 店铺logo
@property (nonatomic, strong) UIImageView *storeLogoImgView;
/// 店铺名称
@property (nonatomic, strong) UILabel *storeNameLabel;
/// 地址logo
@property (nonatomic, strong) UIImageView *addressLogoImgView;
/// 店铺地址
@property (nonatomic, strong) UILabel *addressLabel;
/// 距离多少米
@property (nonatomic, strong) UILabel *distanceMeterLabel;
/// 箭头图标
@property (nonatomic, strong) UIImageView *arrowImageView;
/// 商品总数 value
@property (nonatomic, strong) UILabel *productsCountValueLabel;
/// 店铺评价
@property (nonatomic, strong) UILabel *storeEvaluationLabel;
/// 评价背景
@property (strong, nonatomic) UIView *storeEvaluationBgView;
/// 评价展开按钮
@property (strong, nonatomic) HDUIButton *EvaluationDownBtn;
/// 九宫格标题
@property (strong, nonatomic) UILabel *gridTitleLabel;
/// 店铺商品推荐
@property (strong, nonatomic) TNStoreRecommendWapperView *productWapperView;
/// 聊天按钮
@property (nonatomic, strong) SAOperationButton *chatBtn;
/// 购物按钮
@property (nonatomic, strong) SAOperationButton *shoppingBtn;

@property (nonatomic, strong) TNProductDetailsStoreCellModel *oldModel;

@end


@implementation TNProductDetailsStoreCell
- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    newFrame.origin.x = kRealWidth(8);
    newFrame.size.width = kScreenWidth - kRealWidth(16);
    [super setFrame:newFrame];
}
- (void)hd_setupViews {
    [self.contentView addSubview:self.storeInfoControl];
    [self.storeInfoControl addSubview:self.gradeImageView];
    [self.storeInfoControl addSubview:self.storeLogoImgView];
    [self.storeInfoControl addSubview:self.storeNameLabel];
    [self.storeInfoControl addSubview:self.productsCountValueLabel];
    [self.storeInfoControl addSubview:self.arrowImageView];
    [self.contentView addSubview:self.addressLogoImgView];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.distanceMeterLabel];
    [self.contentView addSubview:self.storeEvaluationBgView];
    [self.storeEvaluationBgView addSubview:self.storeEvaluationLabel];
    [self.storeEvaluationBgView addSubview:self.EvaluationDownBtn];
    [self.contentView addSubview:self.gridTitleLabel];
    [self.contentView addSubview:self.productWapperView];
    [self.contentView addSubview:self.chatBtn];
    [self.contentView addSubview:self.shoppingBtn];
}

- (void)setModel:(TNProductDetailsStoreCellModel *)model {
    _model = model;
    if (!HDIsObjectNil(self.oldModel)) {
        return;
    }
    self.oldModel = model;
    if (model.detailViewStyle == TNProductDetailViewTypeMicroShop) {
        //微店商品  不用展示店铺
        self.storeInfoControl.hidden = YES;
        self.addressLabel.hidden = YES;
        self.distanceMeterLabel.hidden = YES;
        self.addressLogoImgView.hidden = YES;
        self.storeEvaluationBgView.hidden = YES;
        self.chatBtn.hidden = YES;
    } else {
        [HDWebImageManager setImageWithURL:model.storeModel.logo placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(50.f, 50.f)] imageView:self.storeLogoImgView];
        self.storeNameLabel.text = model.storeModel.name ?: @"";

        if (HDIsStringNotEmpty(model.storeModel.address)) {
            self.addressLabel.text = model.storeModel.address;
            self.addressLabel.hidden = NO;
            self.addressLogoImgView.hidden = NO;
            self.distanceMeterLabel.hidden = NO;
            model.storeModel.latitude = HDLocationManager.shared.coordinate2D.latitude - 2000;
            model.storeModel.longitude = HDLocationManager.shared.coordinate2D.longitude - 2000;
            // 计算距离
            NSString *distanceStr = @"";
            if ([HDLocationUtils getCLAuthorizationStatus] == HDCLAuthorizationStatusAuthed) {
                // 当店铺坐标 和 用户坐标 都有值得时候 才能够进行计算距离
                if (model.storeModel.latitude && model.storeModel.longitude && HDLocationManager.shared.coordinate2D.longitude && HDLocationManager.shared.coordinate2D.latitude) {
                    CLLocation *storeLocation = [[CLLocation alloc] initWithLatitude:model.storeModel.latitude longitude:model.storeModel.longitude];
                    CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:HDLocationManager.shared.coordinate2D.latitude longitude:HDLocationManager.shared.coordinate2D.longitude];
                    CLLocationDistance distance = [HDLocationUtils distanceFromLocation:storeLocation toLocation:myLocation];
                    distanceStr = [self converDistince:distance];
                }
            }
            self.distanceMeterLabel.text = distanceStr;
        } else {
            self.addressLabel.hidden = YES;
            self.addressLogoImgView.hidden = YES;
            self.distanceMeterLabel.hidden = YES;
        }

        self.productsCountValueLabel.text = [NSString stringWithFormat:TNLocalizedString(@"tn_items_number_k", @"%ld件商品"), model.storeModel.productCount];
        NSString *storeScoreStr = @"-";
        if (model.storeModel.storeScore > 0) {
            storeScoreStr = [NSString stringWithFormat:@"%0.1f", model.storeModel.storeScore];
        }

        if (HDIsStringEmpty(model.storeModel.storeEvaluate)) {
            self.storeEvaluationLabel.text = @"";
            self.storeEvaluationBgView.hidden = YES;
        } else {
            self.storeEvaluationBgView.hidden = NO;
            self.storeEvaluationLabel.text = model.storeModel.storeEvaluate;
            self.storeEvaluationLabel.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(56);
            [self.storeEvaluationLabel sizeToFit];
            self.EvaluationDownBtn.hidden = !model.isNeedShowEvaluateDownBtn;
        }
    }

    if (!HDIsArrayEmpty(model.goodsArray)) {
        self.productWapperView.hidden = NO;
        self.gridTitleLabel.hidden = NO;
        self.productWapperView.sp = model.sp;
        self.productWapperView.goodArr = model.goodsArray;
    } else {
        self.productWapperView.hidden = YES;
        self.gridTitleLabel.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}
#pragma mark - Tools
- (NSString *)converDistince:(CLLocationDistance)distance {
    //单位km，如果小于0.1km，显示<100m）
    distance = distance / 1000;
    NSString *returnStr = @"";
    if (distance < 0.1) {
        returnStr = [NSString stringWithFormat:@"<100%@", TNLocalizedString(@"meter", @"米")];
    } else {
        returnStr = [NSString stringWithFormat:@"%0.1fkm", distance];
    }

    return returnStr;
}

#pragma mark - btn action
- (void)goToStoreInfoVC {
    [SATalkingData trackEvent:[self.model.trackPrefixName stringByAppendingString:@"商品详情页_点击进店逛逛"]];

    //进店逛逛埋点
    [TNEventTrackingInstance trackEvent:@"detail_store" properties:@{@"productId": self.model.productId, @"storeId": self.model.storeModel.storeId}];

    if (self.model.storeModel.walkLink == 1 && HDIsStringNotEmpty(self.model.storeModel.walkLinkApp) && [SAWindowManager canOpenURL:self.model.storeModel.walkLinkApp]) {
        [SAWindowManager openUrl:self.model.storeModel.walkLinkApp withParameters:@{}];
    } else {
        if (self.model.detailViewStyle == TNProductDetailViewTypeNomal) {
            [HDMediator.sharedInstance navigaveToTinhNowStoreInfoViewController:@{@"storeNo": self.model.storeModel.storeId}];
        } else if (self.model.detailViewStyle == TNProductDetailViewTypeSupplyAndMarketing) {
            [[HDMediator sharedInstance] navigaveToTinhNowStoreInfoViewController:@{@"isFromProductCenter": @"1", @"storeNo": self.model.storeModel.storeId}];
        } else if (self.model.detailViewStyle == TNProductDetailViewTypeMicroShop) {
            [[HDMediator sharedInstance] navigaveToTinhNowStoreInfoViewController:@{@"sp": self.model.sp, @"storeNo": self.model.storeModel.storeId}];
        }
    }
}
/// MARK: pop弹窗
- (void)showPopMenu:(HDUIButton *)sender {
    [YBPopupMenu showRelyOnView:sender titles:@[@""] icons:@[@""] menuWidth:kRealWidth(240) otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.delegate = (id)self;
        popupMenu.itemHeight = kRealWidth(70);
        popupMenu.cornerRadius = 8.f;
        popupMenu.backColor = HDAppTheme.TinhNowColor.G1;
        popupMenu.offset = 6;
    }];

    //点击客服埋点
    [TNEventTrackingInstance trackEvent:@"detail_customer" properties:@{@"productId": self.model.productId}];
}
#pragma mark - YBPopupMenuDelegate
- (UITableViewCell *)ybPopupMenu:(YBPopupMenu *)ybPopupMenu cellForRowAtIndex:(NSInteger)index {
    TNCutomerServicePopCell *cell = [TNCutomerServicePopCell cellWithTableView:ybPopupMenu.tableView];
    @HDWeakify(self);
    cell.chatClickCallBack = ^{
        @HDStrongify(self);
        [YBPopupMenu dismissAllPopupMenu];
        !self.customerServiceButtonClickedHander ?: self.customerServiceButtonClickedHander(self.model.storeModel.storeId);
    };
    cell.phoneClickCallBack = ^{
        @HDStrongify(self);
        [YBPopupMenu dismissAllPopupMenu];
        !self.phoneButtonClickedHander ?: self.phoneButtonClickedHander();
    };
    cell.smsClickCallBack = ^{
        @HDStrongify(self);
        [YBPopupMenu dismissAllPopupMenu];
        !self.smsButtonClickedHander ?: self.smsButtonClickedHander();
    };
    return cell;
}
- (void)updateConstraints {
    [self.storeInfoControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
    }];
    [self.gradeImageView sizeToFit];
    [self.gradeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.storeInfoControl);
    }];

    [self.storeLogoImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeInfoControl.mas_left).offset(kRealWidth(10));
        make.top.equalTo(self.storeInfoControl.mas_top).offset(kRealWidth(17));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(50), kRealWidth(50)));
        make.bottom.equalTo(self.storeInfoControl.mas_bottom);
    }];

    [self.storeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeLogoImgView.mas_right).offset(kRealWidth(10));
        make.top.equalTo(self.storeLogoImgView.mas_top);
        make.right.lessThanOrEqualTo(self.arrowImageView.mas_left).offset(-kRealWidth(10));
    }];

    [self.productsCountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.storeNameLabel.mas_leading);
        make.bottom.equalTo(self.storeLogoImgView.mas_bottom);
        make.right.lessThanOrEqualTo(self.arrowImageView.mas_left).offset(-kRealWidth(10));
    }];

    [self.arrowImageView sizeToFit];
    [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.storeInfoControl.mas_right).offset(-kRealWidth(10));
        make.centerY.equalTo(self.storeLogoImgView.mas_centerY);
    }];

    UIView *topView = self.storeInfoControl.isHidden ? nil : self.storeInfoControl;

    if (!self.addressLabel.isHidden) {
        [self.addressLogoImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(10.f));
            make.height.equalTo(@(12.f));
            make.left.equalTo(self.storeLogoImgView.mas_left);
            make.top.equalTo(self.storeInfoControl.mas_bottom).offset(kRealWidth(10));
        }];
        [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addressLogoImgView.mas_right).offset(5.f);
            make.centerY.equalTo(self.addressLogoImgView.mas_centerY);
            make.right.lessThanOrEqualTo(self.distanceMeterLabel.mas_left).offset(-15.f);
        }];
        [self.distanceMeterLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15.f);
            make.centerY.equalTo(self.addressLogoImgView.mas_centerY);
        }];
        topView = self.addressLogoImgView;
    }
    if (!self.storeEvaluationBgView.isHidden) {
        [self.storeEvaluationBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
            make.top.equalTo(topView.mas_bottom).offset(kRealWidth(12));
        }];

        [self.storeEvaluationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.storeEvaluationBgView.mas_left).offset(kRealWidth(10));
            make.top.equalTo(self.storeEvaluationBgView.mas_top).offset(kRealWidth(5));
            make.right.equalTo(self.storeEvaluationBgView.mas_right).offset(-kRealWidth(10));
            if (self.EvaluationDownBtn.isHidden) {
                make.bottom.equalTo(self.storeEvaluationBgView.mas_bottom).offset(-kRealWidth(5));
            }
        }];

        if (!self.EvaluationDownBtn.isHidden) {
            [self.EvaluationDownBtn sizeToFit];
            [self.EvaluationDownBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.storeInfoControl.mas_centerX);
                make.top.equalTo(self.storeEvaluationLabel.mas_bottom).offset(kRealWidth(5));
                make.bottom.equalTo(self.storeEvaluationBgView.mas_bottom);
                make.width.mas_equalTo(80);
            }];
        }

        topView = self.storeEvaluationBgView;
    }
    if (!self.productWapperView.isHidden) {
        [self.gridTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            if (topView == nil) {
                make.top.equalTo(self.contentView.mas_top);
            } else {
                make.top.equalTo(topView.mas_bottom).offset(kRealWidth(8));
            }
            make.height.mas_equalTo(kRealWidth(50));
        }];

        CGFloat height = kRealWidth(182);
        if (self.model.goodsArray.count > 3) {
            height += 18;
        }
        [self.productWapperView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.gridTitleLabel.mas_bottom);
            make.height.mas_equalTo(height);
        }];
        topView = self.productWapperView;
    }

    [self.shoppingBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (topView == nil) {
            make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        } else {
            make.top.equalTo(topView.mas_bottom).offset(kRealWidth(10));
        }

        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        make.height.mas_equalTo(kRealWidth(35));
        if (!self.chatBtn.isHidden) {
            make.left.equalTo(self.chatBtn.mas_right).offset(kRealWidth(20));
            make.width.equalTo(self.chatBtn.mas_width);
        } else {
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
        }
    }];
    if (!self.chatBtn.isHidden) {
        [self.chatBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.shoppingBtn.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
            make.height.mas_equalTo(kRealWidth(35));
        }];
    }

    [super updateConstraints];
}

#pragma mark -
/** @lazy storeInfoControl */
- (UIControl *)storeInfoControl {
    if (!_storeInfoControl) {
        _storeInfoControl = [[UIControl alloc] init];
        [_storeInfoControl addTarget:self action:@selector(goToStoreInfoVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _storeInfoControl;
}
/** @lazy gradeImageView */
- (UIImageView *)gradeImageView {
    if (!_gradeImageView) {
        _gradeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_product_detail_grade_color"]];
    }
    return _gradeImageView;
}
- (UIImageView *)storeLogoImgView {
    if (!_storeLogoImgView) {
        _storeLogoImgView = [[UIImageView alloc] init];
    }
    return _storeLogoImgView;
}

- (UILabel *)storeNameLabel {
    if (!_storeNameLabel) {
        _storeNameLabel = [[UILabel alloc] init];
        _storeNameLabel.textColor = HDAppTheme.TinhNowColor.c222222;
        _storeNameLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
    }
    return _storeNameLabel;
}

- (UIImageView *)addressLogoImgView {
    if (!_addressLogoImgView) {
        _addressLogoImgView = [[UIImageView alloc] init];
        _addressLogoImgView.image = [UIImage imageNamed:@"tn_product_detail_adress_logo"];
        _addressLogoImgView.hidden = YES;
    }
    return _addressLogoImgView;
}

/** @lazy arrowImageView */
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray_small"]];
    }
    return _arrowImageView;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _addressLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        _addressLabel.hidden = YES;
    }
    return _addressLabel;
}

- (UILabel *)distanceMeterLabel {
    if (!_distanceMeterLabel) {
        _distanceMeterLabel = [[UILabel alloc] init];
        _distanceMeterLabel.textColor = HDAppTheme.TinhNowColor.G3;
        _distanceMeterLabel.font = HDAppTheme.TinhNowFont.standard12B;
        _distanceMeterLabel.adjustsFontSizeToFitWidth = YES;
        _distanceMeterLabel.hidden = YES;
    }
    return _distanceMeterLabel;
}

/** @lazy EvaluationDownBtn */
- (HDUIButton *)EvaluationDownBtn {
    if (!_EvaluationDownBtn) {
        _EvaluationDownBtn = [[HDUIButton alloc] init];
        [_EvaluationDownBtn setImage:[UIImage imageNamed:@"tn_product_detail_down"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_EvaluationDownBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            self.model.extandStoreEvaluation = !self.model.extandStoreEvaluation;
            if (self.model.extandStoreEvaluation) {
                btn.transform = CGAffineTransformMakeRotation(M_PI);
                self.storeEvaluationLabel.numberOfLines = 0;
            } else {
                btn.transform = CGAffineTransformIdentity;
                self.storeEvaluationLabel.numberOfLines = 2;
            }
            [self setNeedsUpdateConstraints];
            !self.reloadStoreCellCallBack ?: self.reloadStoreCellCallBack();
        }];
    }
    return _EvaluationDownBtn;
}

- (UILabel *)productsCountValueLabel {
    if (!_productsCountValueLabel) {
        _productsCountValueLabel = [[UILabel alloc] init];
        _productsCountValueLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
        _productsCountValueLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _productsCountValueLabel;
}

- (UILabel *)storeEvaluationLabel {
    if (!_storeEvaluationLabel) {
        _storeEvaluationLabel = [[UILabel alloc] init];
        _storeEvaluationLabel.textColor = HexColor(0x9F8153);
        _storeEvaluationLabel.font = HDAppTheme.TinhNowFont.standard12;
        _storeEvaluationLabel.numberOfLines = 2;
    }
    return _storeEvaluationLabel;
}

- (UIView *)storeEvaluationBgView {
    if (!_storeEvaluationBgView) {
        _storeEvaluationBgView = [[UIView alloc] init];
        _storeEvaluationBgView.backgroundColor = [HDAppTheme.TinhNowColor.cFF8824 colorWithAlphaComponent:0.1];
        _storeEvaluationBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _storeEvaluationBgView;
}
/** @lazy gridTitleLabel */
- (UILabel *)gridTitleLabel {
    if (!_gridTitleLabel) {
        _gridTitleLabel = [[UILabel alloc] init];
        _gridTitleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _gridTitleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _gridTitleLabel.numberOfLines = 2;
        _gridTitleLabel.textAlignment = NSTextAlignmentCenter;
        _gridTitleLabel.text = TNLocalizedString(@"K36W3YCd", @"店长推荐");
    }
    return _gridTitleLabel;
}
- (TNStoreRecommendWapperView *)productWapperView {
    if (!_productWapperView) {
        _productWapperView = [[TNStoreRecommendWapperView alloc] init];
    }
    return _productWapperView;
}
/** @lazy chatBtn */
- (SAOperationButton *)chatBtn {
    if (!_chatBtn) {
        _chatBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [_chatBtn setTitle:TNLocalizedString(@"tn_product_customer", @"Customer") forState:UIControlStateNormal];
        [_chatBtn setImage:[UIImage imageNamed:@"tn_product_detail_chat"] forState:UIControlStateNormal];
        _chatBtn.spacingBetweenImageAndTitle = 5;
        [_chatBtn applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.cD6DBE8];
        _chatBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard14;
        [_chatBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        _chatBtn.borderWidth = 0.5;
        _chatBtn.titleEdgeInsets = UIEdgeInsetsZero;
        [_chatBtn addTarget:self action:@selector(showPopMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatBtn;
}
/** @lazy shoppingBtn */
- (SAOperationButton *)shoppingBtn {
    if (!_shoppingBtn) {
        _shoppingBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [_shoppingBtn setTitle:TNLocalizedString(@"goShopping", @"进店逛逛") forState:UIControlStateNormal];
        [_shoppingBtn setImage:[UIImage imageNamed:@"tn_product_detail_store"] forState:UIControlStateNormal];
        _shoppingBtn.titleEdgeInsets = UIEdgeInsetsZero;
        _shoppingBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard14;
        _shoppingBtn.spacingBetweenImageAndTitle = 5;
        [_shoppingBtn applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.cD6DBE8];
        [_shoppingBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        _shoppingBtn.borderWidth = 0.5;
        [_shoppingBtn addTarget:self action:@selector(goToStoreInfoVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shoppingBtn;
}

@end

#pragma mark -


@implementation TNProductDetailsStoreCellModel
- (CGFloat)isNeedShowEvaluateDownBtn {
    BOOL show = NO;
    if (HDIsStringNotEmpty(self.storeModel.storeEvaluate)) {
        NSString *text = self.storeModel.storeEvaluate;
        CGFloat height = [text boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(60), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard12].height;
        CGFloat maxHeight = [@"一/n二" boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(60), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard12].height;
        if (height > maxHeight) {
            show = YES;
        }
    }
    return show;
}
@end
