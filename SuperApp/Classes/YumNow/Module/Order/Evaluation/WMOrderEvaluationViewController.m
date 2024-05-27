//
//  WMOrderEvaluationViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderEvaluationViewController.h"
#import "SAInfoViewModel.h"
#import "SAPhotoManager.h"
#import "SAPhotoView.h"
#import "SAUploadImageDTO.h"
#import "WMOperationButton.h"
#import "WMOrderBriefRspModel.h"
#import "WMOrderEvaluationFoodItemView.h"
#import "WMOrderEvaluationGoodsModel.h"
#import "WMOrderRatingSingleView.h"
#import "WMReviewsDTO.h"
#import "WMStoreDetailDTO.h"
#import "WMTopView.h"
#import "WMOrderDetailDTO.h"
#import "WMOrderDetailRspModel.h"


@interface WMOrderEvaluationViewController () <HDTextViewDelegate, HXPhotoViewDelegate, HXPhotoViewCellCustomProtocol>
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// logo 地址
@property (nonatomic, copy) NSString *logoURL;
/// 门店名称
@property (nonatomic, copy) NSString *storeName;
/// 配送类型
@property (nonatomic, assign) WMDeliveryType deliveryType;
/// 骑手评分
@property (nonatomic, strong) WMOrderRatingSingleView *riderRatingView;
/// 门店评分
@property (nonatomic, strong) WMOrderRatingSingleView *storeRatingView;
/// 提交按钮
@property (nonatomic, strong) WMOperationButton *submitBTN;
/// DTO
@property (nonatomic, strong) WMReviewsDTO *evaluationDTO;
/// detailDTO
@property (nonatomic, strong) WMStoreDetailDTO *detailDTO;
/// orderDetailDTO
@property (nonatomic, strong) WMOrderDetailDTO *orderDetailDTO;
/// foodView
@property (nonatomic, strong) UIStackView *foodView;
/// food数据源
@property (nonatomic, copy) NSArray<WMOrderEvaluationGoodsModel *> *foodViewModelArray;
/// 反馈view
@property (nonatomic, strong) UIView *feedbackBgView;
/// 图片选择
@property (strong, nonatomic) SAPhotoManager *manager;
/// 图片选择
@property (strong, nonatomic) SAPhotoView *photoView;
/// 选择的照片
@property (nonatomic, copy) NSArray<HXPhotoModel *> *selectedPhotos;
/// 照片视图高度
@property (nonatomic, assign) CGFloat selectImageMinimumHeight;
/// 上传图片
@property (nonatomic, strong) SAUploadImageDTO *uploadViewModel;
/// 是否匿名
@property (nonatomic, assign) WMReviewAnonymousState anonymousState;
/// topView
@property (nonatomic, strong) WMTopView *topView;
/// 评价攻略按钮
@property (nonatomic, strong) UIButton *evaluationStrategyButton;

@property (nonatomic, assign) NSInteger serviceType;

@end


@implementation WMOrderEvaluationViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.orderNo = [parameters objectForKey:@"orderNo"];
    self.storeNo = [parameters objectForKey:@"storeNo"];
    self.logoURL = [parameters objectForKey:@"logoURL"];
    self.storeName = [parameters objectForKey:@"storeName"];
    self.deliveryType = [[parameters objectForKey:@"deliveryType"] integerValue];
    self.serviceType = [[parameters objectForKey:@"serviceType"] integerValue];
    return self;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupNavigation {
    self.boldTitle = WMLocalizedString(@"evaluation_title", @"订单评价");

    self.hd_navigationItem.rightBarButtonItem = nil;

    NSString *url = [SAApolloManager getApolloConfigForKey:kApolloEvaluationStrategyFromYumNow];
    if (HDIsStringNotEmpty(url)) {
        self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.evaluationStrategyButton];
    }
}

- (void)hd_setupViews {
    self.selectImageMinimumHeight = kRealWidth(80);
    self.anonymousState = WMReviewAnonymousStateFalse;
    self.view.backgroundColor = HDAppTheme.WMColor.white;
    [self.view addSubview:self.topView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.submitBTN];
    [self.scrollView addSubview:self.scrollViewContainer];
    self.scrollView.bounces = NO;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.scrollViewContainer addSubview:self.storeRatingView];
    if (self.serviceType != 20) {
        self.riderRatingView.hidden = NO;
        [self.scrollViewContainer addSubview:self.riderRatingView];
    } else {
        self.riderRatingView.hidden = YES;
    }
    [self.scrollViewContainer addSubview:self.photoView];
    [self.scrollViewContainer addSubview:self.foodView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyBoardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    UIEdgeInsets e = UIEdgeInsetsMake(0, 0, deltaY + 50, 0);
    [UIView animateWithDuration:duration animations:^{
        [self.scrollView setContentInset:e];
        [self.scrollView setScrollIndicatorInsets:e];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.scrollView setContentInset:UIEdgeInsetsZero];
        [self.scrollView setScrollIndicatorInsets:UIEdgeInsetsZero];
    }];
}

- (void)hd_getNewData {
    @HDWeakify(self);
    [self.detailDTO getOrderBriefInfoWithOrderId:self.orderNo success:^(WMOrderBriefRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.foodViewModelArray = rspModel.list;
        [self.foodViewModelArray enumerateObjectsUsingBlock:^(WMOrderEvaluationGoodsModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.orderNo = self.orderNo;
        }];
        [self hd_configFoodView];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];

    if (!self.parameters[@"time"]) {
        @HDWeakify(self)[self.orderDetailDTO getOrderDetailWithOrderNo:self.orderNo success:^(WMOrderDetailRspModel *_Nonnull rspModel) {
            @HDStrongify(self) NSDate *date = [NSDate dateWithTimeIntervalSince1970:rspModel.orderDetailForUser.deliveryInfo.ata / 1000.0];
            NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy HH:mm"];
            self.riderRatingView.time = dateStr;
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

        }];
    }
}

///加载food
- (void)hd_configFoodView {
    [[[self.foodView.arrangedSubviews reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [self.foodView removeArrangedSubview:obj];
        [obj removeFromSuperview];
    }];
    @HDWeakify(self);
    [self.foodViewModelArray enumerateObjectsUsingBlock:^(WMOrderEvaluationGoodsModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        @HDStrongify(self);
        if (!HDIsStringEmpty(obj.commodityName)) {
            WMOrderEvaluationFoodItemView *infoView = [[WMOrderEvaluationFoodItemView alloc] init];
            infoView.model = obj;
            [self.foodView addArrangedSubview:infoView];
        }
    }];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom).offset(kRealWidth(0));
        if (self.submitBTN.isHidden) {
            make.bottom.equalTo(self.view);
        } else {
            make.bottom.equalTo(self.submitBTN.mas_top);
        }
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.submitBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.submitBTN.isHidden) {
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_equalTo(-kRealWidth(12));
            make.height.mas_equalTo(kRealWidth(44));
            make.bottom.mas_equalTo(-kiPhoneXSeriesSafeBottomHeight - kRealWidth(8));
        }
    }];

    [self.riderRatingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.riderRatingView.hidden) {
            make.top.equalTo(self.scrollViewContainer.mas_top).offset(0);
            make.left.right.mas_equalTo(0);
        }
    }];

    [self.storeRatingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.riderRatingView.hidden) {
            make.top.equalTo(self.riderRatingView.mas_bottom).offset(0);
        } else {
            make.top.equalTo(self.scrollViewContainer.mas_top).offset(0);
        }
        make.left.right.mas_equalTo(0);
    }];


    [self.photoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storeRatingView.mas_bottom);
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(95));
        make.height.mas_equalTo(self.selectImageMinimumHeight);
    }];

    [self.photoView.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.photoView);
    }];

    [self.foodView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoView.mas_bottom).offset(kRealWidth(20));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kRealWidth(20));
    }];
}

#pragma mark - HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView
    changeComplete:(NSArray<HXPhotoModel *> *)allList
            photos:(NSArray<HXPhotoModel *> *)photos
            videos:(NSArray<HXPhotoModel *> *)videos
          original:(BOOL)isOriginal {
    self.selectedPhotos = photos;
    [photos enumerateObjectsUsingBlock:^(HXPhotoModel *_Nonnull model, NSUInteger idx, BOOL *_Nonnull stop) {
        CGSize size;
        if (isOriginal) {
            size = PHImageManagerMaximumSize;
        } else {
            size = CGSizeMake(model.imageSize.width * 0.5, model.imageSize.height * 0.5);
        }
        [model requestPreviewImageWithSize:size startRequestICloud:nil progressHandler:nil success:nil failed:nil];
    }];
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    self.selectImageMinimumHeight = frame.size.height;
    [self.view setNeedsUpdateConstraints];
}

- (UIView *)customView:(HXPhotoSubViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = kRealWidth(6);
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = HDAppTheme.WMColor.lineColorE9.CGColor;
    UIView *cornerView = [[UIView alloc] init];
    return cornerView;
}

- (CGRect)customDeleteButtonFrame:(HXPhotoSubViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    return CGRectMake(cell.frame.size.width - kRealWidth(16), 0, kRealWidth(16), kRealWidth(16));
}

#pragma mark - event response
- (void)clickedSubmitButtonHandler {
    if (self.storeRatingView.score <= 0) {
        [NAT showToastWithTitle:nil content:WMLocalizedString(@"wm_review_experience", @"Please rate the dining experience.") type:HDTopToastTypeWarning];
        return;
    }
    if (self.serviceType != 20) {
        if (!self.riderRatingView.isHidden && self.riderRatingView.score <= 0) {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"wm_review_delivery", @"Please rate the delivery service.") type:HDTopToastTypeWarning];
            return;
        }
    }

    [self showloading];

    if (HDIsArrayEmpty(self.selectedPhotos)) {
        [self hd_submitEvaluation:@[]];
    } else {
        NSArray<UIImage *> *images = [self.selectedPhotos mapObjectsUsingBlock:^UIImage *_Nonnull(HXPhotoModel *_Nonnull model, NSUInteger idx) {
            return model.previewPhoto ?: model.thumbPhoto;
        }];

        @HDWeakify(self);
        [self.uploadViewModel batchUploadImages:images progress:^(NSProgress *_Nonnull progress) {

        } success:^(NSArray<NSString *> *_Nonnull imageURLArray) {
            @HDStrongify(self);
            [self hd_submitEvaluation:imageURLArray];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    }
}

- (void)hd_submitEvaluation:(NSArray *)images {
    NSArray<NSDictionary *> *foods = [self.foodViewModelArray mapObjectsUsingBlock:^id _Nonnull(WMOrderEvaluationGoodsModel *_Nonnull obj, NSUInteger idx) {
        if (obj.status != WMOrderEvaluationFoodItemViewStatusNone) {
            return obj.submitItem;
        }
        return nil;
    }];

    @HDWeakify(self);
    NSString *deliveryContent = self.riderRatingView.textView.text;
    __block NSMutableArray *arr = NSMutableArray.new;
    [self.riderRatingView.floatBtnArr enumerateObjectsUsingBlock:^(HDUIButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.selected) {
            [arr addObject:[obj titleForState:UIControlStateNormal]];
        }
    }];
    if (!HDIsArrayEmpty(arr)) {
        if (HDIsStringEmpty(deliveryContent)) {
            deliveryContent = [arr componentsJoinedByString:@","];
        } else {
            deliveryContent = [deliveryContent stringByAppendingFormat:@",%@", [arr componentsJoinedByString:@","]];
        }
    }
    [self.evaluationDTO orderEvaluationWithOrderNo:self.orderNo storeNo:self.storeNo riderScore:self.riderRatingView.score storeScore:self.storeRatingView.score deliveryContent:deliveryContent
        content:self.storeRatingView.textView.text
        anonymous:self.anonymousState
        images:images
        businessline:SAClientTypeYumNow
        itemReviewInfoReqDTOS:foods success:^{
            @HDStrongify(self);
            [self dismissLoading];
            self.submitBTN.hidden = true;
            self.photoView.hideDeleteButton = true;
            self.photoView.showAddCell = false;
            self.scrollViewContainer.userInteractionEnabled = false;
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"thank_you_for_your_rating", @"Thank you for your rating！") type:HDTopToastTypeSuccess];
            [self dismissAnimated:true completion:nil];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
}

#pragma mark - lazy load
- (WMOrderRatingSingleView *)riderRatingView {
    if (!_riderRatingView) {
        _riderRatingView = WMOrderRatingSingleView.new;
        _riderRatingView.title = WMLocalizedString(@"wm_evaluation_happy_rider", @"您对骑手满意吗？");
        _riderRatingView.time = self.parameters[@"time"];
        _riderRatingView.ratingTitle = WMLocalizedString(@"delivery_service", @"配送服务");
        _riderRatingView.backgroundColor = [UIColor whiteColor];
        @HDWeakify(self);
        _riderRatingView.scoreChangedBlock = ^{
            @HDStrongify(self);
            if (self.riderRatingView.score > 0 && self.storeRatingView.score > 0) {
                self.submitBTN.enabled = YES;
            }
        };
        _riderRatingView.hidden = YES;
    }
    return _riderRatingView;
}

- (WMOrderRatingSingleView *)storeRatingView {
    if (!_storeRatingView) {
        _storeRatingView = WMOrderRatingSingleView.new;
        _storeRatingView.isShowAnonymous = YES;
        _storeRatingView.storeName = self.storeName;
        _storeRatingView.logoURL = self.logoURL;
        _storeRatingView.showDetail = YES;
        _storeRatingView.title = WMLocalizedString(@"wm_evaluation_happy_merchant_food", @"您对商家/菜品满意吗？");
        _storeRatingView.ratingTitle = WMLocalizedString(@"wm_evaluation_meal_evaluation", @"用餐评价");
        _storeRatingView.backgroundColor = [UIColor whiteColor];
        @HDWeakify(self);
        _storeRatingView.scoreChangedBlock = ^{
            @HDStrongify(self);
            if (self.serviceType != 20) {
                if (self.riderRatingView.score > 0 && self.storeRatingView.score > 0) {
                    self.submitBTN.enabled = YES;
                }
            } else {
                if (self.storeRatingView.score > 0) {
                    self.submitBTN.enabled = YES;
                }
            }
        };
        _storeRatingView.clickedIsAnonymousButtonBlock = ^(WMReviewAnonymousState anonymousState) {
            @HDStrongify(self);
            self.anonymousState = anonymousState;
        };
    }
    return _storeRatingView;
}

- (UIStackView *)foodView {
    if (!_foodView) {
        _foodView = [[UIStackView alloc] init];
        _foodView.axis = UILayoutConstraintAxisVertical;
        _foodView.spacing = kRealWidth(12);
    }
    return _foodView;
}

- (NSArray<WMOrderEvaluationGoodsModel *> *)foodViewModelArray {
    if (!_foodViewModelArray) {
        _foodViewModelArray = [[NSArray alloc] init];
    }
    return _foodViewModelArray;
}

- (SAPhotoManager *)manager {
    if (!_manager) {
        _manager = [[SAPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.photoMaxNum = 9;
    }
    return _manager;
}

- (SAPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [SAPhotoView photoManager:self.manager];
        _photoView.delegate = self;
        _photoView.spacing = kRealWidth(8);
        _photoView.addImageName = @"";
        _photoView.deleteImageName = @"yn_order_feedback_uploadclose";
        _photoView.cellCustomProtocol = self;
        _photoView.backgroundColor = UIColor.whiteColor;
        if ([_photoView respondsToSelector:NSSelectorFromString(@"addModel")]) {
            HXPhotoModel *addModel = [_photoView valueForKey:@"addModel"];
            if ([addModel isKindOfClass:HXPhotoModel.class]) {
                UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kRealWidth(80), kRealWidth(80))];
                addImageView.contentMode = UIViewContentModeCenter;
                addImageView.image = [UIImage imageNamed:@"yn_order_feedback_uploadadd"];
                addImageView.layer.borderWidth = 1;
                addImageView.layer.cornerRadius = kRealWidth(4);
                addImageView.layer.borderColor = HDAppTheme.WMColor.lineColorE9.CGColor;
                [addImageView setNeedsLayout];
                [addImageView layoutIfNeeded];
                UIImage *addImage = [addImageView snapshotImage];
                addModel.thumbPhoto = addImage;
            }
        }
    }
    return _photoView;
}

- (WMOperationButton *)submitBTN {
    if (!_submitBTN) {
        _submitBTN = [WMOperationButton buttonWithType:UIButtonTypeCustom];
        _submitBTN.cornerRadius = kRealWidth(22);
        [_submitBTN addTarget:self action:@selector(clickedSubmitButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        [_submitBTN setTitle:WMLocalizedStringFromTable(@"submit", @"提交", @"Buttons") forState:UIControlStateNormal];
        _submitBTN.enabled = NO;
    }
    return _submitBTN;
}

- (UIButton *)evaluationStrategyButton {
    if (!_evaluationStrategyButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:SALocalizedString(@"Rating_instruction", @"评价攻略") forState:UIControlStateNormal];
        [btn setTitleColor:HDAppTheme.color.sa_C1 forState:UIControlStateNormal];
        btn.titleLabel.font = HDAppTheme.font.sa_standard12M;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = HDAppTheme.color.sa_C1.CGColor;
        btn.layer.cornerRadius = 5;
        btn.contentEdgeInsets = UIEdgeInsetsMake(5, 11, 5, 11);
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"点击评价攻略了");
            NSString *url = [SAApolloManager getApolloConfigForKey:kApolloEvaluationStrategyFromYumNow];
            if (HDIsStringNotEmpty(url)) {
                [SAWindowManager openUrl:url withParameters:nil];
            }
        }];
        _evaluationStrategyButton = btn;
    }
    return _evaluationStrategyButton;
}

- (WMReviewsDTO *)evaluationDTO {
    if (!_evaluationDTO) {
        _evaluationDTO = WMReviewsDTO.new;
    }
    return _evaluationDTO;
}

- (WMStoreDetailDTO *)detailDTO {
    if (!_detailDTO) {
        _detailDTO = WMStoreDetailDTO.new;
    }
    return _detailDTO;
}

- (SAUploadImageDTO *)uploadViewModel {
    if (!_uploadViewModel) {
        _uploadViewModel = [[SAUploadImageDTO alloc] init];
    }
    return _uploadViewModel;
}

- (WMTopView *)topView {
    if (!_topView) {
        _topView = WMTopView.new;
        if(self.serviceType == 20) {
            _topView.style = WMTopViewStyleEvaluationOnlyStore;
        }else{
            _topView.style = WMTopViewStyleEvaluation;
        }
    }
    return _topView;
}

- (WMOrderDetailDTO *)orderDetailDTO {
    if (!_orderDetailDTO) {
        _orderDetailDTO = WMOrderDetailDTO.new;
    }
    return _orderDetailDTO;
}
@end
