//
//  TNRefundViewController.m
//  SuperApp
//
//  Created by xixi on 2021/1/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNRefundViewController.h"
#import "HDAppTheme+TinhNow.h"
#import "HXPhotoModel.h"
#import "SAInfoTableViewCell.h"
#import "SAInfoView.h"
#import "SATableView.h"
#import "SAUploadImageDTO.h"
#import "TNApplyRefundModel.h"
#import "TNCustomerServiceView.h"
#import "TNIMManger.h"
#import "TNPhoneActionAlertView.h"
#import "TNQueryOrderDetailsRspModel.h"
#import "TNRefundCommonDictModel.h"
#import "TNRefundCustomerServerCell.h"
#import "TNRefundDescriptionCell.h"
#import "TNRefundPhoneInputCell.h"
#import "TNRefundViewModel.h"


@interface TNRefundViewController () <UITableViewDelegate, UITableViewDataSource>
///
@property (nonatomic, strong) SATableView *tableView;
/// 提交按钮
@property (nonatomic, strong) HDUIButton *postBtn;
///
@property (nonatomic, strong) UIView *iphoneXSeriousSafeAreaFillView;
/// VM
@property (nonatomic, strong) TNRefundViewModel *viewModel;
/// 提交申请的model
@property (nonatomic, strong) TNApplyRefundModel *applyModel;
///
@property (nonatomic, strong) NSString *orderNo;

@property (nonatomic, strong) SAUploadImageDTO *uploadImageDTO;

@property (nonatomic, copy) NSArray<HXPhotoModel *> *selectedPhotos; ///< 选择的照片

@end


@implementation TNRefundViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.orderNo = [parameters objectForKey:@"orderNo"];
        if (HDIsStringEmpty(self.orderNo)) {
            return nil;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hd_needMoveView = self.tableView;
}

- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_orderDetail_apply_refund", @"申请退款");
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.postBtn];
    if (iPhoneXSeries) {
        [self.view addSubview:self.iphoneXSeriousSafeAreaFillView];
        self.iphoneXSeriousSafeAreaFillView.hidden = NO;
    }
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    [self.viewModel hd_getData:self.orderNo];
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.applyModel.orderNo = self.orderNo;
        self.applyModel.mobile = self.viewModel.simpleOrderInfoModel.userPhone;
        self.applyModel.applyType = self.viewModel.currentApplyRefundType.value;
        self.applyModel.refundType = self.viewModel.currentRefundType.value;
        self.applyModel.refundAmount = self.viewModel.simpleOrderInfoModel.price;
        self.applyModel.images = @[];
        self.applyModel.remarks = @"";
        [self.tableView successGetNewDataWithNoMoreData:NO];
    }];
}

- (void)updateViewConstraints {
    if (!self.iphoneXSeriousSafeAreaFillView.hidden) {
        [self.iphoneXSeriousSafeAreaFillView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.height.equalTo(@(kiPhoneXSeriesSafeBottomHeight));
            make.right.mas_equalTo(self.view.mas_right);
        }];
    }

    [self.postBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        if (self.iphoneXSeriousSafeAreaFillView.hidden) {
            make.bottom.mas_equalTo(self.view.mas_bottom);
        } else {
            make.bottom.mas_equalTo(self.iphoneXSeriousSafeAreaFillView.mas_top);
        }
        make.height.equalTo(@(50.f));
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.bottom.mas_equalTo(self.postBtn.mas_top);
    }];

    [super updateViewConstraints];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource[section].list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.viewModel.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:SAInfoViewModel.class]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
        cell.model = (SAInfoViewModel *)model;
        NSString *keyStr = cell.model.associatedObject;
        if ([keyStr isEqualToString:@"apply_reason"]) {
            @HDWeakify(self);
            cell.model.clickedValueButtonHandler = ^{
                @HDStrongify(self);
                [self showApplyReasonAlertView:indexPath];
            };
        } else {
            cell.model.clickedValueButtonHandler = nil;
        }

        return cell;
    } else if ([model isKindOfClass:TNRefundDescriptionCellModel.class]) {
        TNRefundDescriptionCell *cell = [TNRefundDescriptionCell cellWithTableView:tableView];
        cell.model = self.applyModel;

        cell.frame = tableView.bounds;
        [cell layoutIfNeeded];

        @HDWeakify(self);
        cell.reloadHander = ^{
            @HDStrongify(self);
            [self.tableView successGetNewDataWithNoMoreData:NO];
        };
        cell.endInputHander = ^(NSString *_Nonnull reasonStr) {
            @HDStrongify(self);
            self.applyModel.remarks = reasonStr;
        };
        cell.selectImageHander = ^(NSArray *_Nonnull imageArray) {
            @HDStrongify(self);
            self.selectedPhotos = imageArray;
        };
        return cell;
    } else if ([model isKindOfClass:TNRefundCustomerServerCellModel.class]) {
        TNRefundCustomerServerCell *cell = [TNRefundCustomerServerCell cellWithTableView:tableView];
        cell.customerPhone = self.viewModel.simpleOrderInfoModel.phone;
        @HDWeakify(self);
        cell.customerServiceButtonClickedHander = ^{
            @HDStrongify(self);
            [self getCustomerList:self.viewModel.simpleOrderInfoModel.storeNo];
        };
        cell.platformButtonClickedHander = ^{
            @HDStrongify(self);
            [self showPlatform];
        };
        return cell;
    } else if ([model isKindOfClass:TNRefundPhoneInputCellModel.class]) {
        TNRefundPhoneInputCell *cell = [TNRefundPhoneInputCell cellWithTableView:tableView];
        cell.userPhone = self.viewModel.simpleOrderInfoModel.userPhone;
        @HDWeakify(self);
        cell.endEidtHandler = ^(NSString *_Nonnull inputPhone) {
            @HDStrongify(self);
            self.applyModel.mobile = inputPhone;
        };
        return cell;
    }
    return nil;
}

#pragma mark - action
- (void)postAction {
    HDLog(@"%@", self.applyModel);

    @HDWeakify(self);
    void (^postSubmit)(NSArray<NSString *> *) = ^void(NSArray<NSString *> *imageURLArray) {
        @HDStrongify(self);
        if (imageURLArray.count > 0) {
            self.applyModel.images = imageURLArray;
        }
        if (self.applyModel.remarks.length > 500) {
            self.applyModel.remarks = [self.applyModel.remarks substringToIndex:500];
        }
        NSDictionary *dic = [self.applyModel yy_modelToJSONObject];
        @HDWeakify(self);
        [self.viewModel postApplyInfoData:dic success:^{
            @HDStrongify(self);
            [NAT showToastWithTitle:nil content:@"申请成功" type:HDTopToastTypeSuccess];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

        }];
    };

    if ([self checkIsOperationValid]) {
        if (self.selectedPhotos.count > 0) {
            [self uploadImagesCompletion:^(NSArray<NSString *> *imgUrlArray) {
                postSubmit(imgUrlArray);
            }];
        } else {
            postSubmit(@[]);
        }
    }
}

- (BOOL)checkIsOperationValid {
    if (self.applyModel.refundReason.length <= 0) {
        [NAT showToastWithTitle:nil content:TNLocalizedString(@"no_select_apply_reason", @"您还没有选择申请原因") type:HDTopToastTypeError];
        return NO;
    }
    return YES;
}

- (void)uploadImagesCompletion:(void (^)(NSArray<NSString *> *imgUrlArray))completion {
    NSArray<UIImage *> *images = [self.selectedPhotos mapObjectsUsingBlock:^UIImage *_Nonnull(HXPhotoModel *_Nonnull model, NSUInteger idx) {
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
}

/// 获取商户客服列表
- (void)getCustomerList:(NSString *)storeNo {
    [self showloading];
    [[TNIMManger shared] getCustomerServerList:storeNo success:^(NSArray<TNIMRspModel *> *_Nonnull rspModelArray) {
        [self dismissLoading];
        if (rspModelArray.count > 0) {
            TNIMRspModel *imModel = rspModelArray.firstObject;
            HDLog(@"%@", imModel);
            [self openIMViewControllerWithOperatorNo:imModel.operatorNo storeNo:storeNo];
        } else {
            HDLog(@"没获取到数据");
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [self dismissLoading];
        HDLog(@"%@", error.domain);
    }];
}

- (void)openIMViewControllerWithOperatorNo:(NSString *)operatorNo storeNo:(NSString *)storeNo {
    NSDictionary *dict = @{
        @"operatorType": @(8),
        @"operatorNo": operatorNo ?: @"",
        @"storeNo": storeNo ?: @"",
        @"prepareSendTxt": [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"tn_im_orderNo", @"咨询订单，编号"), self.orderNo ?: @""],
        @"scene": SAChatSceneTypeTinhNowConsult
    };
    [[HDMediator sharedInstance] navigaveToIMViewController:dict];
}

/// 联系平台
- (void)showPlatform {
    TNCustomerServiceView *view = [[TNCustomerServiceView alloc] init];
    view.dataSource = [view getTinhnowDefaultPlatform];
    [view layoutyImmediately];

    TNPhoneActionAlertView *actionView = [[TNPhoneActionAlertView alloc] initWithContentView:view];
    [actionView show];
}

// show 申请原因
- (void)showApplyReasonAlertView:(NSIndexPath *)indexPath {
    if (self.viewModel.applyReasonTypeArray.count > 0) {
        HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];

        // clang-format off
        for (int i = 0; i < self.viewModel.applyReasonTypeArray.count; i++) {
            @HDWeakify(self);
            TNRefundCommonDictItemModel *itemModel = self.viewModel.applyReasonTypeArray[i];
            HDActionSheetViewButton *reasonBtn = [HDActionSheetViewButton buttonWithTitle:itemModel.name type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
                [sheetView dismiss];
                @HDStrongify(self);
                TNRefundCommonDictItemModel *selectModel = [button hd_getBoundObjectForKey:@"currentReasonType"];
                if (selectModel) {
                    self.viewModel.currentApplyReasonType = selectModel;
                    self.applyModel.refundReason = self.viewModel.currentApplyReasonType.value;
                    {
                        SAInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                        cell.model.valueText = self.viewModel.currentApplyReasonType.name;
                        cell.model.valueColor = HDAppTheme.TinhNowColor.c343B4D;
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }
            }];
            [reasonBtn hd_bindObjectWeakly:itemModel forKey:@"currentReasonType"];
            [sheetView addButton:reasonBtn];
        }

        // clang-format on
        [sheetView show];
    }
}

#pragma mark -
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
        _tableView.needShowNoDataView = YES;
        _tableView.needShowErrorView = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 5.0f;
    }
    return _tableView;
}

- (HDUIButton *)postBtn {
    if (!_postBtn) {
        _postBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_postBtn setTitle:TNLocalizedString(@"tn_button_submit", @"提交") forState:UIControlStateNormal];
        [_postBtn setTitleColor:[UIColor whiteColor] forState:0];
        _postBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15.f];
        _postBtn.backgroundColor = HDAppTheme.TinhNowColor.cFF8824;
        _postBtn.adjustsButtonWhenHighlighted = false;
        @HDWeakify(self);
        [_postBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self postAction];
        }];
    }
    return _postBtn;
}

- (UIView *)iphoneXSeriousSafeAreaFillView {
    if (!_iphoneXSeriousSafeAreaFillView) {
        _iphoneXSeriousSafeAreaFillView = [[UIView alloc] init];
        _iphoneXSeriousSafeAreaFillView.backgroundColor = self.postBtn.backgroundColor;
        _iphoneXSeriousSafeAreaFillView.hidden = YES;
    }
    return _iphoneXSeriousSafeAreaFillView;
}

- (TNRefundViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNRefundViewModel alloc] init];
    }
    return _viewModel;
}

- (TNApplyRefundModel *)applyModel {
    if (!_applyModel) {
        _applyModel = [[TNApplyRefundModel alloc] init];
    }
    return _applyModel;
}

- (SAUploadImageDTO *)uploadImageDTO {
    if (!_uploadImageDTO) {
        _uploadImageDTO = [[SAUploadImageDTO alloc] init];
    }
    return _uploadImageDTO;
}

#pragma mark - override
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return false;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
