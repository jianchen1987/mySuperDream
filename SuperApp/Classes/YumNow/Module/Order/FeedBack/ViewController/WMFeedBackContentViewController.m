//
//  WMFeedBackContentViewController.m
//  SuperApp
//
//  Created by wmz on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMFeedBackContentViewController.h"
#import "SAUploadImageDTO.h"
#import "WMOrderFeedBackDTO.h"
#import "WMOrderFeedBackFoodView.h"
#import "WMOrderFeedBackTitleView.h"
#import "WMOrderFeedBackUploadInfoView.h"


@interface WMFeedBackContentViewController ()
/// titleView
@property (nonatomic, strong) WMOrderFeedBackTitleView *titleView;
/// uploadView
@property (nonatomic, strong) WMOrderFeedBackUploadInfoView *uploadView;
/// foodView
@property (nonatomic, strong) WMOrderFeedBackFoodView *foodView;
/// bottomView
@property (nonatomic, strong) UIView *bottomView;
/// submitBTN
@property (nonatomic, strong) SAOperationButton *submitBTN;
/// showViewArr
@property (nonatomic, strong) NSMutableArray<SAView *> *showViewArr;
/// type
@property (nonatomic, strong) NSString *type;
/// DTO
@property (nonatomic, strong) WMOrderFeedBackDTO *DTO;
/// DTO
@property (nonatomic, strong) SAUploadImageDTO *uploadImageDTO;
/// 历史
@property (nonatomic, strong) HDUIButton *historyBTN;

@end


@implementation WMFeedBackContentViewController

- (void)hd_setupNavigation {
    self.boldTitle = WMLocalizedString(@"wm_order_feedback_title", @"Order Feedback");
    self.hd_backButtonImage = [UIImage imageNamed:@"yn_home_back"];
    self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.historyBTN];
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    self.type = self.parameters[@"type"];
    self.view.backgroundColor = HDAppTheme.WMColor.bgGray;
    self.scrollView.contentInset = UIEdgeInsetsMake(kRealWidth(12), 0, kRealWidth(12), 0);
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.submitBTN];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.titleView];
    [self.scrollViewContainer addSubview:self.uploadView];
    [self.scrollViewContainer addSubview:self.foodView];
    [self.scrollViewContainer setFollowKeyBoardConfigEnable:true margin:0 refView:nil];
    self.showViewArr = NSMutableArray.new;
    [self.showViewArr addObject:self.titleView];
    [self.showViewArr addObject:self.foodView];
    [self.showViewArr addObject:self.uploadView];
    if ([self.type isEqualToString:WMOrderFeedBackPostOther]) {
        self.foodView.hidden = YES;
        WMOrderFeedBackReasonRspModel *model = WMOrderFeedBackReasonRspModel.new;
        model.reason = [SAInternationalizationModel modelWithCN:@"其他" en:@"" kh:@""];
        model.no = @"OTHER";
        model.isRemark = YES;
        model.isPhoto = YES;
        self.uploadView.selectReasonModel = model;
    } else {
        [self getProductList];
    }
    [self checkBTNAction];
    self.historyBTN.hidden = ![self.parameters[@"hasPostSale"] boolValue];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.width.equalTo(self.scrollView);
    }];

    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kiPhoneXSeriesSafeBottomHeight + kRealWidth(60));
    }];

    [self.submitBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(8));
        make.height.mas_equalTo(kRealWidth(44));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    NSArray<SAView *> *visableInfoViews = [self.showViewArr hd_filterWithBlock:^BOOL(SAView *_Nonnull item) {
        return !item.isHidden;
    }];
    SAView *lastView;
    for (SAView *infoView in visableInfoViews) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(12));
            } else {
                make.top.mas_equalTo(0);
            }
            make.left.right.mas_equalTo(0);
            if (infoView == visableInfoViews.lastObject) {
                make.bottom.mas_equalTo(0);
            }
        }];
        lastView = infoView;
    }
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.uploadView keyPath:@"flag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self checkBTNAction];
    }];

    [self.KVOController hd_observe:self.foodView keyPath:@"flag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self checkBTNAction];
    }];
}

///获取商品列表
- (void)getProductList {
    @HDWeakify(self);
    [self.view showloading];
    [self.DTO requestGetRefundableProductWithNO:self.parameters[@"orderNo"] success:^(NSArray<WMOrderDetailProductModel *> *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        NSMutableArray<WMShoppingCartStoreProduct *> *pruductArr = NSMutableArray.new;
        for (WMOrderDetailProductModel *product in rspModel) {
            WMShoppingCartStoreProduct *model = [WMShoppingCartStoreProduct modelWithOrderDetailProductModel:product];
            model.purchaseQuantity = 1;
            model.maxQuantity = product.maxQuantity;
            model.orderCommodityId = product.orderCommodityId;
            [pruductArr addObject:model];
        }
        self.foodView.productArr = pruductArr;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)checkBTNAction {
    BOOL enable = NO;
    if ([self.type isEqualToString:WMOrderFeedBackPostOther]) {
        if (!HDIsObjectNil(self.uploadView.selectReasonModel) && !HDIsStringEmpty(self.uploadView.contentTV.text) && !HDIsArrayEmpty(self.uploadView.selectedPhotos)) {
            enable = YES;
        }
    } else {
        if (!HDIsObjectNil(self.uploadView.selectReasonModel)) {
            for (WMShoppingCartStoreProduct *product in self.foodView.productArr) {
                if (product.isSelected) {
                    enable = YES;
                }
            }
            if (self.uploadView.selectReasonModel.isRemark) {
                if (HDIsStringEmpty(self.uploadView.contentTV.text)) {
                    enable = NO;
                }
            }
            if (self.uploadView.selectReasonModel.isPhoto) {
                if (HDIsArrayEmpty(self.uploadView.selectedPhotos)) {
                    enable = NO;
                }
            }
        }
    }
    [self.submitBTN applyPropertiesWithBackgroundColor:enable ? HDAppTheme.color.mainColor : [HDAppTheme.color.mainColor colorWithAlphaComponent:0.3]];
    self.submitBTN.userInteractionEnabled = enable;
}

///上传图片
- (void)uploadImagesCompletion:(void (^)(NSArray<NSString *> *imgUrlArray))completion {
    if (!HDIsArrayEmpty(self.uploadView.selectedPhotos)) {
        NSArray<UIImage *> *images = [self.uploadView.selectedPhotos mapObjectsUsingBlock:^UIImage *_Nonnull(HXPhotoModel *_Nonnull model, NSUInteger idx) {
            return model.previewPhoto ?: model.thumbPhoto;
        }];

        HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self.view];
        [self.uploadImageDTO batchUploadImages:images progress:^(NSProgress *_Nonnull progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
            });
        } success:^(NSArray *_Nonnull imageURLArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud showSuccessNotCreateNew:SALocalizedString(@"upload_completed", @"上传完毕")];
            });
            !completion ?: completion(imageURLArray);
        } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
            [hud hideAnimated:true];
        }];
    } else {
        !completion ?: completion(@[]);
    }
}

///提交
- (void)submitAction {
    if (!HDIsArrayEmpty(self.uploadView.selectedPhotos)) {
        @HDWeakify(self)[self uploadImagesCompletion:^(NSArray<NSString *> *imgUrlArray) {
            @HDStrongify(self)[self requestSubmitAction:imgUrlArray];
        }];
    } else {
        [self requestSubmitAction:nil];
    }
}

- (void)requestSubmitAction:(nullable NSArray<NSString *> *)imagePaths {
    [self.view showloading];
    @HDWeakify(self) NSMutableArray *commodityInfo = NSMutableArray.new;
    for (WMShoppingCartStoreProduct *product in self.foodView.productArr) {
        if (product.isSelected) {
            [commodityInfo addObject:@{@"orderCommodityId": product.orderCommodityId, @"quantity": @(product.purchaseQuantity).stringValue}];
        }
    }
    [self.DTO requestSubmitOrderPostSaleFeedBackWithNo:self.parameters[@"orderNo"] postSaleType:self.type reasonCode:self.uploadView.selectReasonModel.no commodityInfo:commodityInfo
        description:self.uploadView.contentTV.text
        imagePaths:imagePaths success:^(SARspModel *_Nonnull rspModel) {
            @HDStrongify(self)[self.view dismissLoading];
            [self.navigationController removeSpecificViewControllerClass:NSClassFromString(@"WMFeedBackMainViewController") onlyOnce:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self)[self.view dismissLoading];
        }];
}

- (WMOrderFeedBackDTO *)DTO {
    if (!_DTO) {
        _DTO = WMOrderFeedBackDTO.new;
    }
    return _DTO;
}

- (SAUploadImageDTO *)uploadImageDTO {
    return _uploadImageDTO ?: ({ _uploadImageDTO = SAUploadImageDTO.new; });
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = UIView.new;
        _bottomView.backgroundColor = UIColor.whiteColor;
    }
    return _bottomView;
}

- (SAOperationButton *)submitBTN {
    if (!_submitBTN) {
        _submitBTN = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        _submitBTN.layer.cornerRadius = kRealWidth(22);
        _submitBTN.layer.masksToBounds = YES;
        @HDWeakify(self)[_submitBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self submitAction];
        }];
        [_submitBTN setTitle:WMLocalizedString(@"wm_cancel_submit", @"确认修改") forState:UIControlStateNormal];
    }
    return _submitBTN;
}

- (WMOrderFeedBackTitleView *)titleView {
    if (!_titleView) {
        _titleView = WMOrderFeedBackTitleView.new;
        _titleView.model = self.parameters[@"model"];
    }
    return _titleView;
}

- (WMOrderFeedBackUploadInfoView *)uploadView {
    if (!_uploadView) {
        _uploadView = WMOrderFeedBackUploadInfoView.new;
        _uploadView.type = self.type;
    }
    return _uploadView;
}

- (WMOrderFeedBackFoodView *)foodView {
    if (!_foodView) {
        _foodView = WMOrderFeedBackFoodView.new;
        _foodView.orderNo = self.parameters[@"orderNo"];
        _foodView.type = self.type;
    }
    return _foodView;
}

- (HDUIButton *)historyBTN {
    if (!_historyBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        [button setTitle:WMLocalizedString(@"wm_order_feedback_history", @"历史记录") forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToFeedBackHistoryController:@{@"orderNo": self.parameters[@"orderNo"]}];
        }];
        _historyBTN = button;
    }
    return _historyBTN;
}

@end
