//
//  PNMSStoreAddOrEditView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreAddOrEditView.h"
#import "PNCityPickerViewController.h"
#import "PNInfoView.h"
#import "PNInputItemView.h"
#import "PNMSStoreImageTakeView.h"
#import "PNMSStoreManagerViewModel.h"
#import "PNMSTimeView.h"
#import "PNOperationButton.h"
#import "PNUploadImageDTO.h"
#import "SAAddressModel.h"

static NSString *const kAddress = @"pn_ms_address_code";


@interface PNMSStoreAddOrEditView () <PNInputItemViewDelegate>
@property (nonatomic, strong) PNMSStoreManagerViewModel *viewModel;
@property (nonatomic, strong) PNInputItemView *storeNameInputView;
@property (nonatomic, strong) PNInfoView *addressInfoView;
@property (nonatomic, strong) PNInputItemView *storePhoneInputView;
@property (nonatomic, strong) PNMSTimeView *timeInfoView;
@property (nonatomic, strong) PNOperationButton *comfirmBtn;
@property (nonatomic, strong) PNMSStoreImageTakeView *takeImageView;
@end


@implementation PNMSStoreAddOrEditView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.KVOController hd_observe:self.takeImageView keyPath:@"selectedPhotos" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        HDLog(@"%@", self.takeImageView.selectedPhotos);
        [self ruleLimit];
    }];

    if (WJIsStringNotEmpty(self.viewModel.storeInfoModel.storeNo)) {
        PNMSStoreInfoModel *model = self.viewModel.storeInfoModel;
        self.storeNameInputView.model.value = model.storeName;
        [self.storeNameInputView update];

        self.addressInfoView.model.valueText = model.address;
        [self.addressInfoView setNeedsUpdateContent];

        NSString *storePhoneStr = [model.storePhone stringByReplacingOccurrencesOfString:@"8550" withString:@""];

        self.storePhoneInputView.model.value = storePhoneStr;
        [self.storePhoneInputView update];

        [self.timeInfoView setStart:model.businessHoursStart end:model.businessHoursEnd];

        self.takeImageView.imageURLs = model.storeImages;
    }
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.storeNameInputView];
    [self.scrollViewContainer addSubview:self.addressInfoView];
    [self.scrollViewContainer addSubview:self.storePhoneInputView];
    [self.scrollViewContainer addSubview:self.timeInfoView];
    [self.scrollViewContainer addSubview:self.takeImageView];

    [self addSubview:self.comfirmBtn];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.equalTo(self.comfirmBtn.mas_top);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.storeNameInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(12));
        make.left.right.equalTo(self.scrollViewContainer);
        make.height.equalTo(@(52));
    }];

    [self.addressInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.storeNameInputView.mas_bottom);
    }];

    [self.storePhoneInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.addressInfoView.mas_bottom);
        make.height.equalTo(@(80));
    }];

    [self.timeInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.storePhoneInputView.mas_bottom);
    }];

    [self.takeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeInfoView.mas_bottom).offset(kRealWidth(12));
        make.left.right.equalTo(self.scrollViewContainer);
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [self.comfirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kRealWidth(20));
        make.right.equalTo(self).offset(-kRealWidth(20));
        make.height.equalTo(@(48));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)ruleLimit {
    PNMSStoreInfoModel *model = self.viewModel.storeInfoModel;
    model.storeName = self.storeNameInputView.model.value;
    model.storePhone = self.storePhoneInputView.model.value;

    if (WJIsStringNotEmpty(model.storeName) && WJIsStringNotEmpty(model.storePhone) && WJIsStringNotEmpty(model.address) && WJIsStringNotEmpty(model.businessHoursStart)
        && WJIsStringNotEmpty(model.businessHoursEnd) && !WJIsArrayEmpty(self.takeImageView.selectedPhotos)) {
        self.comfirmBtn.enabled = YES;
    } else {
        self.comfirmBtn.enabled = NO;
    }
}

- (void)pushToMapVC {
    @HDWeakify(self);
    void (^callback)(SAAddressModel *) = ^(SAAddressModel *addressModel) {
        @HDStrongify(self);
        HDLog(@"%@", addressModel.yy_modelToJSONData);
        self.addressInfoView.model.valueText = addressModel.address;
        self.addressInfoView.model.valueColor = HDAppTheme.PayNowColor.c333333;
        [self.addressInfoView setNeedsUpdateContent];

        NSString *formatLon = [NSString stringWithFormat:@"%0.6f", addressModel.lon.doubleValue];
        NSString *formatLat = [NSString stringWithFormat:@"%0.6f", addressModel.lat.doubleValue];

        self.viewModel.storeInfoModel.address = addressModel.address;
        self.viewModel.storeInfoModel.province = addressModel.state;
        self.viewModel.storeInfoModel.area = addressModel.subLocality;
        self.viewModel.storeInfoModel.city = addressModel.city;
        self.viewModel.storeInfoModel.latitude = formatLat;
        self.viewModel.storeInfoModel.longitude = formatLon;

        NSDictionary *dict = [addressModel yy_modelToJSONObject];
        [self.viewModel.storeInfoModel hd_bindObject:dict forKey:kAddress];

        [self ruleLimit];
    };

    NSDictionary *addressDict = [self.viewModel.storeInfoModel hd_getBoundObjectForKey:kAddress];

    [HDMediator.sharedInstance navigaveToPayNowMerchantServicesMapAddressVC:@{@"callback": callback, @"address": addressDict}];
}

#pragma mark
#pragma mark PNInputItemViewDelegate
- (BOOL)pn_textFieldShouldReturn:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)pn_textFieldShouldEndEditing:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [self ruleLimit];
    return YES;
}

- (void)pn_textFieldDidEndEditing:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [self ruleLimit];
}

- (void)pn_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason view:(nonnull PNInputItemView *)view {
    [self ruleLimit];
}

#pragma mark
- (void)comfirmAction {
    NSArray<UIImage *> *images = [self.takeImageView.selectedPhotos mapObjectsUsingBlock:^UIImage *_Nonnull(HXPhotoModel *_Nonnull model, NSUInteger idx) {
        return model.previewPhoto ?: model.thumbPhoto;
    }];

    if (images.count > 0) {
        @HDWeakify(self);
        [self.viewModel uploadImages:images completion:^(NSArray<NSString *> *_Nonnull imgUrlArray) {
            @HDStrongify(self);
            self.viewModel.storeInfoModel.storeImages = imgUrlArray;
            [self.viewModel saveOrUpdateStore];
        }];
    } else {
        [self.viewModel saveOrUpdateStore];
    }
}

#pragma mark
- (PNInputItemView *)storeNameInputView {
    if (!_storeNameInputView) {
        _storeNameInputView = [[PNInputItemView alloc] init];
        _storeNameInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));

        model.title = PNLocalizedString(@"pn_store_name", @"门店名称");
        model.titleFont = HDAppTheme.PayNowFont.standard14B;
        model.placeholder = PNLocalizedString(@"please_enter", @"请输入");
        model.fixWhenInputSpace = YES;
        model.canInputMoreSpace = NO;
        model.bottomLineHeight = PixelOne;

        _storeNameInputView.model = model;
    }
    return _storeNameInputView;
}

- (PNInfoView *)addressInfoView {
    if (!_addressInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_store_address", @"门店地址")];
        model.keyFont = HDAppTheme.PayNowFont.standard14B;
        model.rightButtonImage = [UIImage imageNamed:@"pn_arrow_gray_small"];
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));
        model.valueNumbersOfLines = 0;
        view.model = model;
        _addressInfoView = view;

        @HDWeakify(self);
        model.eventHandler = ^{
            HDLog(@"click");
            @HDStrongify(self);
            [self pushToMapVC];
        };
    }
    return _addressInfoView;
}

- (PNMSTimeView *)timeInfoView {
    if (!_timeInfoView) {
        _timeInfoView = [[PNMSTimeView alloc] init];

        @HDWeakify(self);
        _timeInfoView.selectBlock = ^(NSString *_Nonnull start, NSString *_Nonnull end) {
            @HDStrongify(self);
            self.viewModel.storeInfoModel.businessHoursStart = start;
            self.viewModel.storeInfoModel.businessHoursEnd = end;
            [self ruleLimit];
        };
    }
    return _timeInfoView;
}

- (PNInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    PNInfoViewModel *model = PNInfoViewModel.new;
    model.keyText = key;
    model.lineColor = HDAppTheme.PayNowColor.cECECEC;
    model.backgroundColor = [UIColor whiteColor];
    model.valueFont = HDAppTheme.PayNowFont.standard15M;
    model.enableTapRecognizer = YES;
    return model;
}

- (PNInputItemView *)storePhoneInputView {
    if (!_storePhoneInputView) {
        _storePhoneInputView = [[PNInputItemView alloc] init];
        _storePhoneInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));
        model.bottomLineHeight = 0;
        model.titleFont = HDAppTheme.PayNowFont.standard14B;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        model.title = PNLocalizedString(@"pn_store_phone", @"门店电话");
        model.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        model.bottomLineHeight = PixelOne;
        model.valueAlignment = NSTextAlignmentLeft;
        model.style = PNInputStypeRow_Two;
        model.leftLabelString = @"8550";

        _storePhoneInputView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeNumberPad theme:theme];

        kb.inputSource = _storePhoneInputView.textFiled;
        _storePhoneInputView.textFiled.inputView = kb;
    }
    return _storePhoneInputView;
}

- (PNMSStoreImageTakeView *)takeImageView {
    if (!_takeImageView) {
        _takeImageView = [[PNMSStoreImageTakeView alloc] init];
    }
    return _takeImageView;
}

- (PNOperationButton *)comfirmBtn {
    if (!_comfirmBtn) {
        _comfirmBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_comfirmBtn setTitle:PNLocalizedString(@"BUTTON_TITLE_SUBMIT", @"提交") forState:UIControlStateNormal];
        _comfirmBtn.enabled = NO;
        [_comfirmBtn addTarget:self action:@selector(comfirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirmBtn;
}

@end
