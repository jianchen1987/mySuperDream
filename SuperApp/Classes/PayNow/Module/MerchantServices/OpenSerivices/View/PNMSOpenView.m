//
//  PNMSOpenView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOpenView.h"
#import "HDTableViewSectionModel.h"
#import "NSMutableAttributedString+Highlight.h"
#import "NSObject+HDKitCore.h"
#import "PNCommonUtils.h"
#import "PNInputItemCell.h"
#import "PNInputItemView.h"
#import "PNMSOpenFooterView.h"
#import "PNMSOpenSectionHeaderView.h"
#import "PNMSOpenViewModel.h"
#import "PNMSStepView.h"
#import "PNMSStorePhotoCell.h"
#import "PNMSUploadPhotoCell.h"
#import "PNTableView.h"
#import "PNUploadImageCell.h"
#import "SAAddressModel.h"
#import "SAInfoTableViewCell.h"
#import "SAInfoView.h"

static NSString *const kCategoryCode = @"pn_ms_category_code";
static NSString *const kSubCategoryCode = @"pn_ms_sub_category_code";
static NSString *const kAddress = @"pn_ms_address_code";


@interface PNMSOpenView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNMSStepView *stepView;
@property (nonatomic, strong) PNMSOpenViewModel *viewModel;

@property (nonatomic, strong) PNMSOpenFooterView *footerView;
///< tableview
@property (nonatomic, strong) PNTableView *tableView;
///< datasource
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSource;

/// 商户类型
@property (nonatomic, strong) SAInfoViewModel *merchantTypeInfoModel;
/// 证件类型
@property (nonatomic, strong) SAInfoViewModel *legalDocTypeInfoModel;
/// 证件号
@property (nonatomic, strong) PNInputItemModel *legalDocNumberInfoModel;
/// 姓
@property (nonatomic, strong) PNInputItemModel *firstNameInputModel;
/// 名
@property (nonatomic, strong) PNInputItemModel *lastNameInputModel;
/// 证件照 正面
@property (nonatomic, strong) PNMSUploadPhotoModel *frontPhotoInfoModel;
/// 营业执照注册号
@property (nonatomic, strong) PNInputItemModel *businessLicenseNumberInputModel;
/// 商户店铺名称
@property (nonatomic, strong) PNInputItemModel *merchantNameInputModel;
/// 经营品类 大类
@property (nonatomic, strong) SAInfoViewModel *categoryTypeInfoModel;
/// 经营品类 小类
@property (nonatomic, strong) SAInfoViewModel *subCategoryTypeInfoModel;
/// 商户地址
@property (nonatomic, strong) SAInfoViewModel *addressInfoModel;
/// 经纬度
@property (nonatomic, strong) SAInfoViewModel *latLongInfoModel;
/// 营业执照
@property (nonatomic, strong) PNMSStorePhotoModel *businessLicenseInfoModel;
/// 店铺门头照
@property (nonatomic, strong) PNMSStorePhotoModel *shopHeadPhotoInfoModel;
/// 推荐人 姓
@property (nonatomic, strong) PNInputItemModel *recruitedByFirstNameInputModel;
/// 推荐人 名
@property (nonatomic, strong) PNInputItemModel *recruitedByLastNameInputModel;

@end


@implementation PNMSOpenView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (!WJIsObjectNil(self.viewModel.categoryRspModel)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.hidden = NO;
                if (WJIsStringEmpty(self.viewModel.merchantNo)) {
                    [self initDataSource:0];
                } else {
                    PNMSOpenModel *resultModel = self.viewModel.model;
                    /// 如果含有merchantNo 那说明会有回填的数据
                    [self initDataSource:resultModel.merchantType];

                    self.merchantTypeInfoModel.valueText = [PNCommonUtils getMerchantTypeName:resultModel.merchantType];
                    self.merchantTypeInfoModel.valueColor = HDAppTheme.PayNowColor.c333333;

                    self.legalDocTypeInfoModel.valueText = [PNCommonUtils getPapersNameByPapersCode:resultModel.identificationType];
                    self.legalDocTypeInfoModel.valueColor = HDAppTheme.PayNowColor.c333333;

                    self.legalDocNumberInfoModel.value = resultModel.identificationNumber;
                    self.firstNameInputModel.value = resultModel.personLastName;
                    self.lastNameInputModel.value = resultModel.personFirstName;
                    self.frontPhotoInfoModel.leftURL = resultModel.identificationFrontImg;
                    self.frontPhotoInfoModel.rightURL = resultModel.identificationBackImg;
                    self.businessLicenseNumberInputModel.value = resultModel.businessLicenseNumber;
                    self.merchantNameInputModel.value = resultModel.merchantName;
                    self.addressInfoModel.valueText = resultModel.address;
                    self.addressInfoModel.valueColor = HDAppTheme.PayNowColor.c333333;
                    NSString *formatLon = [NSString stringWithFormat:@"%0.6f", resultModel.longitude.doubleValue];
                    NSString *formatLat = [NSString stringWithFormat:@"%0.6f", resultModel.latitude.doubleValue];
                    self.latLongInfoModel.valueText = [NSString stringWithFormat:@"%@,%@", formatLon, formatLat];
                    self.latLongInfoModel.valueColor = HDAppTheme.PayNowColor.c333333;

                    [self getCategoryNameWithCode:resultModel.merchantCategory subCode:resultModel.categoryItem];

                    PNMSStorePhotoItemModel *storePhotoItemModel = [[PNMSStorePhotoItemModel alloc] init];
                    storePhotoItemModel.url = resultModel.storeFrontImg;
                    self.shopHeadPhotoInfoModel.imageArray = [NSMutableArray arrayWithObject:storePhotoItemModel];

                    PNMSStorePhotoItemModel *businessLicenseItemModel = [[PNMSStorePhotoItemModel alloc] init];
                    if (resultModel.businessLicenseImages.count > 0) {
                        businessLicenseItemModel.url = resultModel.businessLicenseImages.firstObject;
                    }
                    self.businessLicenseInfoModel.imageArray = [NSMutableArray arrayWithObject:businessLicenseItemModel];

                    self.recruitedByFirstNameInputModel.value = resultModel.recruitedFirstName;
                    self.recruitedByLastNameInputModel.value = resultModel.recruitedLastName;

                    [self setFooterView];
                    [self.tableView successGetNewDataWithNoMoreData:NO];
                }
            });
        }
    }];

    [self.viewModel getData];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    [self addSubview:self.tableView];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = [self.dataSource objectAtIndex:section];
    return sectionModel.list.count;
}

- (UITableViewCell *)tableView:(SATableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = [self.dataSource objectAtIndex:indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isMemberOfClass:SAInfoViewModel.class]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if ([model isMemberOfClass:PNInputItemModel.class]) {
        PNInputItemModel *itemModel = model;
        PNInputItemCell *cell = [PNInputItemCell cellWithTableView:tableView];
        //        @HDWeakify(self);
        cell.inputChangeBlock = ^(NSString *_Nonnull text) {
            //            @HDStrongify(self);
            itemModel.value = text;
        };
        cell.model = itemModel;
        return cell;
    } else if ([model isMemberOfClass:PNMSUploadPhotoModel.class]) {
        PNMSUploadPhotoCell *cell = [PNMSUploadPhotoCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if ([model isMemberOfClass:PNMSStorePhotoModel.class]) {
        PNMSStorePhotoCell *cell = [PNMSStorePhotoCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else {
        return UITableViewCell.new;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = [self.dataSource objectAtIndex:section];
    PNMSOpenSectionHeaderView *headerView = [PNMSOpenSectionHeaderView headerWithTableView:tableView];
    headerView.model = sectionModel.headerModel;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    id model = [sectionModel.list objectAtIndex:indexPath.row];
    if ([model isKindOfClass:SAInfoViewModel.class]) {
        SAInfoViewModel *trueModel = model;
        !trueModel.eventHandler ?: trueModel.eventHandler();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (WJIsStringEmpty(sectionModel.headerModel.title)) {
        return kRealWidth(8);
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.viewModel.model.merchantType != PNMerchantTypeNon) {
        if (section == (self.dataSource.count - 1)) {
            return kRealWidth(8);
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

#pragma mark
/// 商户类型
- (void)handleSelectMerchantType {
    @HDWeakify(self);
    void (^continueUpdateView)(PNMerchantType) = ^(PNMerchantType type) {
        @HDStrongify(self);
        [self initDataSource:type];
        self.viewModel.model.merchantType = type;
        self.merchantTypeInfoModel.valueText = [PNCommonUtils getMerchantTypeName:type];
        self.merchantTypeInfoModel.valueColor = HDAppTheme.PayNowColor.c333333;

        [self setFooterView];
        [self.tableView successGetNewDataWithNoMoreData:NO];
    };

    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];

    HDActionSheetViewButton *personBtn = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"ms_person_merchant", @"个人商户") type:HDActionSheetViewButtonTypeCustom
                                                                          handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                              [sheetView dismiss];
                                                                              continueUpdateView(PNMerchantTypeIndividual);
                                                                          }];
    HDActionSheetViewButton *businessBtn = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"ms_business_merchant", @"企业商户") type:HDActionSheetViewButtonTypeCustom
                                                                            handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                                [sheetView dismiss];
                                                                                continueUpdateView(PNMerchantTypeBusiness);
                                                                            }];

    [sheetView addButtons:@[personBtn, businessBtn]];
    [sheetView show];
}

/// 证件类型
- (void)handleSelectLegalType {
    @HDWeakify(self);
    void (^continueUpdateView)(PNPapersType) = ^(PNPapersType type) {
        @HDStrongify(self);
        self.legalDocTypeInfoModel.valueText = [PNCommonUtils getCardTypeNameByCode:type];
        self.legalDocTypeInfoModel.valueColor = HDAppTheme.PayNowColor.c333333;
        self.viewModel.model.identificationType = type;

        [self.tableView successGetNewDataWithNoMoreData:NO];
    };

    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];

    HDActionSheetViewButton *IDCARDBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"PAPER_TYPE_IDCARD", @"身份证") type:HDActionSheetViewButtonTypeCustom
                                                                          handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                              [sheetView dismiss];
                                                                              continueUpdateView(PNPapersTypeIDCard);
                                                                          }];
    HDActionSheetViewButton *PASSPORTBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"PAPER_TYPE_PASSPORT", @"护照") type:HDActionSheetViewButtonTypeCustom
                                                                            handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                                [sheetView dismiss];
                                                                                continueUpdateView(PNPapersTypePassport);
                                                                            }];

    [sheetView addButtons:@[IDCARDBTN, PASSPORTBTN]];
    [sheetView show];
}

- (void)handleCategory:(NSString *)categoryCode {
    @HDWeakify(self);
    void (^continueUpdateView)(NSString *, NSString *) = ^(NSString *code, NSString *name) {
        @HDStrongify(self);
        if (WJIsStringEmpty(categoryCode)) {
            if (![self.categoryTypeInfoModel.valueText isEqualToString:name]) {
                self.subCategoryTypeInfoModel.valueText = PNLocalizedString(@"please_select", @"请选择");
                self.subCategoryTypeInfoModel.valueColor = HDAppTheme.PayNowColor.cCCCCCC;
            }
            /// 大类
            self.categoryTypeInfoModel.valueText = name;
            self.categoryTypeInfoModel.valueColor = HDAppTheme.PayNowColor.c333333;
            [self.categoryTypeInfoModel hd_bindObjectWeakly:code forKey:kCategoryCode];
            self.viewModel.model.merchantCategory = code;

            [self handleCategory:code];
        } else {
            /// 小类
            self.subCategoryTypeInfoModel.valueText = name;
            self.subCategoryTypeInfoModel.valueColor = HDAppTheme.PayNowColor.c333333;
            [self.subCategoryTypeInfoModel hd_bindObjectWeakly:code forKey:kSubCategoryCode];
            self.viewModel.model.categoryItem = code;
        }

        [self.tableView successGetNewDataWithNoMoreData:NO];
    };

    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];

    NSMutableArray *arr = [NSMutableArray array];
    NSArray *list;
    if (WJIsStringEmpty(categoryCode)) {
        list = self.viewModel.categoryRspModel.list;
    } else {
        for (PNMSCategoryModel *itemModel in self.viewModel.categoryRspModel.list) {
            if ([itemModel.code isEqualToString:categoryCode]) {
                list = itemModel.sub;
                break;
                ;
            }
        }
    }

    if (list.count <= 0)
        return;

    for (PNMSCategoryModel *itemModel in list) {
        HDActionSheetViewButton *button = [HDActionSheetViewButton buttonWithTitle:itemModel.name type:HDActionSheetViewButtonTypeCustom
                                                                           handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                               [sheetView dismiss];

                                                                               NSString *code = @"";
                                                                               if (WJIsStringEmpty(categoryCode)) {
                                                                                   code = [button hd_getBoundObjectForKey:kCategoryCode];
                                                                               } else {
                                                                                   code = [button hd_getBoundObjectForKey:kSubCategoryCode];
                                                                               }
                                                                               continueUpdateView(code, itemModel.name);
                                                                           }];

        if (WJIsStringEmpty(categoryCode)) {
            [button hd_bindObjectWeakly:itemModel.code forKey:kCategoryCode];
        } else {
            [button hd_bindObjectWeakly:itemModel.code forKey:kSubCategoryCode];
        }
        [arr addObject:button];
    }

    [sheetView addButtons:arr];
    [sheetView show];
}

#pragma mark Tools
- (void)getCategoryNameWithCode:(NSString *)code subCode:(NSString *)subCode {
    for (PNMSCategoryModel *categoryModel in self.viewModel.categoryRspModel.list) {
        if ([categoryModel.code isEqualToString:code]) {
            self.categoryTypeInfoModel.valueText = categoryModel.name;
            self.categoryTypeInfoModel.valueColor = HDAppTheme.PayNowColor.c333333;

            for (PNMSCategoryModel *itemCategoryModel in categoryModel.sub) {
                if ([itemCategoryModel.code isEqualToString:subCode]) {
                    self.subCategoryTypeInfoModel.valueText = itemCategoryModel.name;
                    self.subCategoryTypeInfoModel.valueColor = HDAppTheme.PayNowColor.c333333;
                    break;
                }
            }
        }
    }
}

#pragma mark
/// MARK: 切换数据源
- (void)initDataSource:(PNMerchantType)type {
    VipayUser *user = VipayUser.shareInstance;

    [self.dataSource removeAllObjects];

    void (^initSectionBlock)(NSArray *, NSString *) = ^(NSArray *list, NSString *sectionTitle) {
        HDTableViewSectionModel *sectionModel = [[HDTableViewSectionModel alloc] init];
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        if (WJIsStringNotEmpty(sectionTitle)) {
            headerModel.title = sectionTitle;
        }

        NSMutableArray *infosList = [NSMutableArray arrayWithArray:list];
        sectionModel.headerModel = headerModel;
        sectionModel.list = infosList;
        [self.dataSource addObject:sectionModel];
    };

    if (type == PNMerchantTypeNon) {
        initSectionBlock(@[self.merchantTypeInfoModel], @"");
    } else if (type == PNMerchantTypeIndividual) { ///个人
        NSMutableArray *infosList = [[NSMutableArray alloc] init];
        [infosList addObject:self.merchantTypeInfoModel];
        initSectionBlock(infosList, @"");

        infosList = [[NSMutableArray alloc] init];
        [infosList addObject:self.legalDocTypeInfoModel];
        [infosList addObject:self.legalDocNumberInfoModel];
        [infosList addObject:self.firstNameInputModel];
        [infosList addObject:self.lastNameInputModel];
        [infosList addObject:self.frontPhotoInfoModel];
        [infosList addObject:self.merchantNameInputModel];
        [infosList addObject:self.categoryTypeInfoModel];
        [infosList addObject:self.subCategoryTypeInfoModel];
        initSectionBlock(infosList, @"");

        if (user.cardType == PNPapersTypeIDCard || user.cardType == PNPapersTypePassport) {
            self.lastNameInputModel.value = user.firstName;
            self.firstNameInputModel.value = user.lastName;
            self.legalDocTypeInfoModel.valueText = [PNCommonUtils getPapersNameByPapersCode:user.cardType];
            self.legalDocTypeInfoModel.valueColor = HDAppTheme.PayNowColor.c333333;
            self.legalDocNumberInfoModel.value = user.cardNum;
            self.frontPhotoInfoModel.leftURL = user.idCardFrontUrl;
            self.frontPhotoInfoModel.rightURL = user.idCardBackUrl;
        }

        infosList = [[NSMutableArray alloc] init];
        [infosList addObject:self.addressInfoModel];
        [infosList addObject:self.latLongInfoModel];
        initSectionBlock(infosList, @"");

        infosList = [[NSMutableArray alloc] init];
        [infosList addObject:self.shopHeadPhotoInfoModel];
        [infosList addObject:self.recruitedByFirstNameInputModel];
        [infosList addObject:self.recruitedByLastNameInputModel];
        initSectionBlock(infosList, @"");

    } else if (type == PNMerchantTypeBusiness) { ///企业

        NSMutableArray *infosList = [[NSMutableArray alloc] init];
        [infosList addObject:self.merchantTypeInfoModel];
        initSectionBlock(infosList, @"");

        infosList = [[NSMutableArray alloc] init];
        [infosList addObject:self.legalDocTypeInfoModel];
        [infosList addObject:self.legalDocNumberInfoModel];
        [infosList addObject:self.firstNameInputModel];
        [infosList addObject:self.lastNameInputModel];
        [infosList addObject:self.frontPhotoInfoModel];
        initSectionBlock(infosList, PNLocalizedString(@"ms_merchant_person_info", @"商户法人信息"));

        if (user.cardType == PNPapersTypeIDCard || user.cardType == PNPapersTypePassport) {
            self.lastNameInputModel.value = user.firstName;
            self.firstNameInputModel.value = user.lastName;
            self.legalDocTypeInfoModel.valueText = [PNCommonUtils getPapersNameByPapersCode:user.cardType];
            self.legalDocTypeInfoModel.valueColor = HDAppTheme.PayNowColor.c333333;
            self.legalDocNumberInfoModel.value = user.cardNum;
            self.frontPhotoInfoModel.leftURL = user.idCardFrontUrl;
            self.frontPhotoInfoModel.rightURL = user.idCardBackUrl;
        }

        infosList = [[NSMutableArray alloc] init];
        [infosList addObject:self.businessLicenseNumberInputModel];
        [infosList addObject:self.merchantNameInputModel];
        initSectionBlock(infosList, PNLocalizedString(@"ms_merchant_info", @"商户信息"));

        infosList = [[NSMutableArray alloc] init];
        [infosList addObject:self.categoryTypeInfoModel];
        [infosList addObject:self.subCategoryTypeInfoModel];
        initSectionBlock(infosList, @"");

        infosList = [[NSMutableArray alloc] init];
        [infosList addObject:self.addressInfoModel];
        [infosList addObject:self.latLongInfoModel];
        initSectionBlock(infosList, @"");

        infosList = [[NSMutableArray alloc] init];
        [infosList addObject:self.businessLicenseInfoModel];
        initSectionBlock(infosList, @"");

        infosList = [[NSMutableArray alloc] init];
        [infosList addObject:self.shopHeadPhotoInfoModel];
        [infosList addObject:self.recruitedByFirstNameInputModel];
        [infosList addObject:self.recruitedByLastNameInputModel];
        initSectionBlock(infosList, @"");
    }

    [self.tableView successGetNewDataWithNoMoreData:NO];
}

#pragma mark - lazy load
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGFLOAT_MAX) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.estimatedSectionHeaderHeight = 0.01;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionFooterHeight = 0.01;
        _tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _tableView.hidden = YES;
        [self setHeaderView];
    }
    return _tableView;
}

- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark
- (NSMutableAttributedString *)preTitle:(NSString *)title {
    NSString *hightStr = @"*";
    NSString *allStr = [NSString stringWithFormat:@"%@%@", hightStr, title];
    NSMutableAttributedString *attStr = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard14B
                                                                    highLightColor:HDAppTheme.PayNowColor.mainThemeColor
                                                                           norFont:HDAppTheme.PayNowFont.standard14B
                                                                          norColor:HDAppTheme.PayNowColor.c333333];
    return attStr;
}

- (PNInputItemModel *)baseInputModel {
    PNInputItemModel *model = [[PNInputItemModel alloc] init];
    model.titleFont = HDAppTheme.PayNowFont.standard14B;
    model.titleColor = HDAppTheme.PayNowColor.c333333;
    model.valueFont = HDAppTheme.PayNowFont.standard14;
    model.valueColor = HDAppTheme.PayNowColor.c333333;
    model.placeholderColor = HDAppTheme.PayNowColor.cCCCCCC;
    model.keyboardType = UIKeyboardTypeASCIICapable;
    model.bottomLineHeight = PixelOne;
    model.bottomLineColor = HDAppTheme.PayNowColor.lineColor;
    model.bottomLineSpaceToLeft = kRealWidth(12);
    model.bottomLineSpaceToRight = kRealWidth(12);
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));

    return model;
}

/// 基础类
/// @param key title
/// @param option 是否必填 - * 的显示
/// @param isShowArrow 是否有箭头
- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key option:(BOOL)option showArrow:(BOOL)isShowArrow {
    SAInfoViewModel *model = SAInfoViewModel.new;
    if (option) {
        model.keyText = key;
    } else {
        model.attrKey = [self preTitle:key];
    }
    model.keyFont = HDAppTheme.PayNowFont.standard14B;
    model.keyColor = HDAppTheme.PayNowColor.c333333;
    model.lineColor = HDAppTheme.PayNowColor.cECECEC;
    model.backgroundColor = [UIColor whiteColor];
    model.valueFont = HDAppTheme.PayNowFont.standard14;

    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));

    if (isShowArrow) {
        model.valueText = PNLocalizedString(@"please_select", @"请选择");
        model.valueColor = HDAppTheme.PayNowColor.cCCCCCC;
        model.rightButtonImage = [UIImage imageNamed:@"pn_arrow_gray_small"];
    }
    return model;
}

- (PNUploadImageViewModel *)uploadImageInfoViewModelWithKey:(NSString *)key {
    PNUploadImageViewModel *model = PNUploadImageViewModel.new;
    model.keyText = key;
    model.keyFont = HDAppTheme.PayNowFont.standard14B;
    model.keyColor = HDAppTheme.PayNowColor.c333333;
    model.lineColor = HDAppTheme.PayNowColor.cECECEC;
    model.backgroundColor = [UIColor whiteColor];
    model.valueFont = HDAppTheme.PayNowFont.standard14;
    model.valueColor = HDAppTheme.PayNowColor.c333333;
    model.lineColor = HDAppTheme.PayNowColor.lineColor;
    model.lineEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), 0, kRealWidth(15));
    model.uploadImageViewLineWidth = 1;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));
    return model;
}

- (SAInfoViewModel *)merchantTypeInfoModel {
    if (!_merchantTypeInfoModel) {
        _merchantTypeInfoModel = [self infoViewModelWithKey:PNLocalizedString(@"ms_merchant_type", @"商户类型") option:NO showArrow:YES];
        @HDWeakify(self);
        _merchantTypeInfoModel.eventHandler = ^{
            @HDStrongify(self);
            [self handleSelectMerchantType];
        };
    }
    return _merchantTypeInfoModel;
}

- (SAInfoViewModel *)legalDocTypeInfoModel {
    if (!_legalDocTypeInfoModel) {
        _legalDocTypeInfoModel = [self infoViewModelWithKey:PNLocalizedString(@"Legal_type", @"证件类型") option:NO showArrow:YES];
        @HDWeakify(self);
        _legalDocTypeInfoModel.eventHandler = ^{
            @HDStrongify(self);
            [self handleSelectLegalType];
        };
    }
    return _legalDocTypeInfoModel;
}

- (PNInputItemModel *)legalDocNumberInfoModel {
    if (!_legalDocNumberInfoModel) {
        PNInputItemModel *model = [self baseInputModel];
        model.attributedTitle = [self preTitle:PNLocalizedString(@"Legal_number", @"证件号")];
        model.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        model.keyboardType = UIKeyboardTypeASCIICapable;

        _legalDocNumberInfoModel = model;
    }
    return _legalDocNumberInfoModel;
}

- (PNInputItemModel *)firstNameInputModel {
    if (!_firstNameInputModel) {
        PNInputItemModel *model = [self baseInputModel];
        model.attributedTitle = [self preTitle:PNLocalizedString(@"familyName", @"姓")];
        model.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        model.useWOWNOWKeyboard = YES;
        model.wownowKeyBoardType = HDKeyBoardTypeLetterCapable;
        model.canInputMoreSpace = NO;

        _firstNameInputModel = model;
    }
    return _firstNameInputModel;
}

- (PNInputItemModel *)lastNameInputModel {
    if (!_lastNameInputModel) {
        PNInputItemModel *model = [self baseInputModel];
        model.attributedTitle = [self preTitle:PNLocalizedString(@"givenName", @"名")];
        model.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        model.useWOWNOWKeyboard = YES;
        model.wownowKeyBoardType = HDKeyBoardTypeLetterCapable;
        model.canInputMoreSpace = NO;

        _lastNameInputModel = model;
    }
    return _lastNameInputModel;
}

- (PNInputItemModel *)merchantNameInputModel {
    if (!_merchantNameInputModel) {
        PNInputItemModel *model = [self baseInputModel];
        model.attributedTitle = [self preTitle:PNLocalizedString(@"ms_merchant_shop_name", @"商户店铺名称")];
        model.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        model.keyboardType = UIKeyboardTypeDefault;
        model.isUppercaseString = YES;
        //        model.useWOWNOWKeyboard = YES;
        //        model.wownowKeyBoardType = HDKeyBoardTypeLetterCapable;
        model.maxInputLength = 25;
        model.canInputMoreSpace = NO;

        _merchantNameInputModel = model;
    }
    return _merchantNameInputModel;
}

- (PNInputItemModel *)businessLicenseNumberInputModel {
    if (!_businessLicenseNumberInputModel) {
        PNInputItemModel *model = [self baseInputModel];
        model.attributedTitle = [self preTitle:PNLocalizedString(@"ms_merchant_number", @"营业执照注册号")];
        model.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        model.useWOWNOWKeyboard = YES;
        model.wownowKeyBoardType = HDKeyBoardTypeLetterCapable;

        _businessLicenseNumberInputModel = model;
    }
    return _businessLicenseNumberInputModel;
}

- (SAInfoViewModel *)addressInfoModel {
    if (!_addressInfoModel) {
        _addressInfoModel = [self infoViewModelWithKey:PNLocalizedString(@"ms_merchant_address", @"商户地址") option:NO showArrow:YES];

        @HDWeakify(self);
        _addressInfoModel.eventHandler = ^{
            @HDStrongify(self);
            [self pushToMapVC];
        };
    }
    return _addressInfoModel;
}

- (void)pushToMapVC {
    @HDWeakify(self);
    void (^callback)(SAAddressModel *) = ^(SAAddressModel *addressModel) {
        @HDStrongify(self);
        self.addressInfoModel.valueText = addressModel.address;
        self.addressInfoModel.valueColor = HDAppTheme.PayNowColor.c333333;

        NSString *formatLon = [NSString stringWithFormat:@"%0.6f", addressModel.lon.doubleValue];
        NSString *formatLat = [NSString stringWithFormat:@"%0.6f", addressModel.lat.doubleValue];
        self.latLongInfoModel.valueText = [NSString stringWithFormat:@"%@,%@", formatLon, formatLat];
        self.latLongInfoModel.valueColor = HDAppTheme.PayNowColor.c333333;

        self.viewModel.model.address = addressModel.address;
        self.viewModel.model.province = addressModel.state;
        self.viewModel.model.area = addressModel.subLocality;
        self.viewModel.model.city = addressModel.city;
        self.viewModel.model.latitude = formatLat;
        self.viewModel.model.longitude = formatLon;

        [self.tableView successGetNewDataWithNoMoreData:NO];

        NSDictionary *dict = [addressModel yy_modelToJSONObject];
        [self.addressInfoModel hd_bindObject:dict forKey:kAddress];
    };

    NSDictionary *addressDict = [self.addressInfoModel hd_getBoundObjectForKey:kAddress];

    [HDMediator.sharedInstance navigaveToPayNowMerchantServicesMapAddressVC:@{@"callback": callback, @"address": addressDict}];
}

- (SAInfoViewModel *)latLongInfoModel {
    if (!_latLongInfoModel) {
        _latLongInfoModel = [self infoViewModelWithKey:PNLocalizedString(@"ms_longitude_latitude", @"经纬度") option:YES showArrow:NO];
    }
    return _latLongInfoModel;
}

- (SAInfoViewModel *)categoryTypeInfoModel {
    if (!_categoryTypeInfoModel) {
        _categoryTypeInfoModel = [self infoViewModelWithKey:PNLocalizedString(@"ms_business_type", @"经营品类") option:NO showArrow:YES];
        @HDWeakify(self);
        _categoryTypeInfoModel.eventHandler = ^{
            @HDStrongify(self);
            [self handleCategory:@""];
        };
    }
    return _categoryTypeInfoModel;
}

- (SAInfoViewModel *)subCategoryTypeInfoModel {
    if (!_subCategoryTypeInfoModel) {
        _subCategoryTypeInfoModel = [self infoViewModelWithKey:PNLocalizedString(@"ms_business_type", @"经营品类") option:NO showArrow:YES];
        @HDWeakify(self);
        _subCategoryTypeInfoModel.eventHandler = ^{
            @HDStrongify(self);
            NSString *code = [self.categoryTypeInfoModel hd_getBoundObjectForKey:kCategoryCode];
            if (WJIsStringNotEmpty(code)) {
                [self handleCategory:code];
            }
        };
    }
    return _subCategoryTypeInfoModel;
}

- (PNMSStorePhotoModel *)businessLicenseInfoModel {
    if (!_businessLicenseInfoModel) {
        _businessLicenseInfoModel = [[PNMSStorePhotoModel alloc] init];
        _businessLicenseInfoModel.attrTitle = [self preTitle:PNLocalizedString(@"ms_business_license", @"营业执照")];
        _businessLicenseInfoModel.subTitle = PNLocalizedString(@"ms_image_support_formats", @"支持jpg、jpeg、png、bmp格式，不超过5MB");
        PNMSStorePhotoItemModel *itemModel = [[PNMSStorePhotoItemModel alloc] init];
        _businessLicenseInfoModel.imageArray = [NSMutableArray arrayWithObjects:itemModel, nil];
    }
    return _businessLicenseInfoModel;
}

- (PNInputItemModel *)recruitedByFirstNameInputModel {
    if (!_recruitedByFirstNameInputModel) {
        PNInputItemModel *model = [self baseInputModel];
        model.title = [NSString stringWithFormat:@"%@(%@)", PNLocalizedString(@"ms_recruited_by", @"推荐人"), PNLocalizedString(@"ms_not_required", @"非必填")];
        model.placeholder = PNLocalizedString(@"familyName", @"姓");
        model.useWOWNOWKeyboard = YES;
        model.wownowKeyBoardType = HDKeyBoardTypeLetterCapable;

        _recruitedByFirstNameInputModel = model;
    }
    return _recruitedByFirstNameInputModel;
}

- (PNInputItemModel *)recruitedByLastNameInputModel {
    if (!_recruitedByLastNameInputModel) {
        PNInputItemModel *model = [self baseInputModel];
        model.title = [NSString stringWithFormat:@"%@(%@)", PNLocalizedString(@"ms_recruited_by", @"推荐人"), PNLocalizedString(@"ms_not_required", @"非必填")];
        model.placeholder = PNLocalizedString(@"givenName", @"姓");
        model.useWOWNOWKeyboard = YES;
        model.wownowKeyBoardType = HDKeyBoardTypeLetterCapable;

        _recruitedByLastNameInputModel = model;
    }
    return _recruitedByLastNameInputModel;
}

- (PNMSUploadPhotoModel *)frontPhotoInfoModel {
    if (!_frontPhotoInfoModel) {
        _frontPhotoInfoModel = [[PNMSUploadPhotoModel alloc] init];
    }
    return _frontPhotoInfoModel;
}

- (PNMSStorePhotoModel *)shopHeadPhotoInfoModel {
    if (!_shopHeadPhotoInfoModel) {
        _shopHeadPhotoInfoModel = [[PNMSStorePhotoModel alloc] init];
        _shopHeadPhotoInfoModel.attrTitle = [self preTitle:PNLocalizedString(@"ms_shop_photo", @"店铺门头照")];
        _shopHeadPhotoInfoModel.subTitle = PNLocalizedString(@"ms_image_support_formats", @"支持jpg、jpeg、png、bmp格式，不超过5MB");
        PNMSStorePhotoItemModel *itemModel = [[PNMSStorePhotoItemModel alloc] init];
        _shopHeadPhotoInfoModel.imageArray = [NSMutableArray arrayWithObjects:itemModel, nil];
    }
    return _shopHeadPhotoInfoModel;
}

- (void)setHeaderView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectZero];
    headView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [headView addSubview:self.stepView];

    [self.stepView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(headView);
        make.bottom.mas_equalTo(headView.mas_bottom);
    }];

    CGFloat height = [headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headView.frame;
    frame.size.height = height;

    headView.frame = frame;

    self.tableView.tableHeaderView = headView;
}

- (void)setFooterView {
    PNMSOpenFooterView *fv = [[PNMSOpenFooterView alloc] init];

    @HDWeakify(self);
    /// MARK: 点击确认按钮
    fv.submitBtnClickBlock = ^{
        @HDStrongify(self);
        PNMSOpenModel *model = self.viewModel.model;

        model.personLastName = self.firstNameInputModel.value;
        model.personFirstName = self.lastNameInputModel.value;

        model.identificationNumber = self.legalDocNumberInfoModel.value;

        PNMSStorePhotoItemModel *storePhotoModel = [self.shopHeadPhotoInfoModel.imageArray firstObject];
        model.storeFrontImg = storePhotoModel.url;

        model.identificationFrontImg = self.frontPhotoInfoModel.leftURL;
        model.identificationBackImg = self.frontPhotoInfoModel.rightURL;

        model.businessLicenseNumber = self.businessLicenseNumberInputModel.value;
        model.merchantName = self.merchantNameInputModel.value;

        PNMSStorePhotoItemModel *businessLicense = [self.businessLicenseInfoModel.imageArray firstObject];
        model.businessLicenseImages = @[businessLicense.url ?: @""];

        model.recruitedFirstName = self.recruitedByFirstNameInputModel.value;
        model.recruitedLastName = self.recruitedByLastNameInputModel.value;

        HDLog(@"%@", model.description);
        [self.viewModel sumitApplyOpenMerchantServices];
    };

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    footerView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [footerView addSubview:fv];

    [fv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(footerView);
        make.bottom.mas_equalTo(footerView.mas_bottom);
    }];

    CGFloat height = [footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = footerView.frame;
    frame.size.height = height;

    footerView.frame = frame;

    self.tableView.tableFooterView = footerView;
}

- (PNMSStepView *)stepView {
    if (!_stepView) {
        _stepView = [[PNMSStepView alloc] init];
        _stepView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        [_stepView layoutIfNeeded];

        NSMutableArray<PNMSStepItemModel *> *list = [NSMutableArray arrayWithCapacity:3];
        PNMSStepItemModel *model = PNMSStepItemModel.new;
        model.iconImage = [UIImage imageNamed:@"pn_ms_open_apply_hight"];
        model.titleStr = @"01";
        model.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), 0, 0, 0);
        model.titleFont = [HDAppTheme.PayNowFont fontDINBlack:20];
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        model.subTitleStr = PNLocalizedString(@"ms_submit_apply", @"提交申请");
        model.subTitleFont = HDAppTheme.PayNowFont.standard12;
        model.subTitleColor = HDAppTheme.PayNowColor.c666666;
        [list addObject:model];

        model = PNMSStepItemModel.new;
        model.iconImage = [UIImage imageNamed:@"pn_ms_open_apply_ing_nor"];
        model.titleStr = @"02";
        model.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), 0, 0, 0);
        model.titleFont = [HDAppTheme.PayNowFont fontDINBlack:20];
        model.titleColor = HDAppTheme.PayNowColor.cCCCCCC;
        model.subTitleStr = PNLocalizedString(@"ms_approval_merchant_info", @"审核商户信息");
        model.subTitleFont = HDAppTheme.PayNowFont.standard12;
        model.subTitleColor = HDAppTheme.PayNowColor.cCCCCCC;
        [list addObject:model];

        model = PNMSStepItemModel.new;
        model.iconImage = [UIImage imageNamed:@"pn_ms_open_apply_success_nor"];
        model.titleStr = @"03";
        model.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), 0, 0, 0);
        model.titleFont = [HDAppTheme.PayNowFont fontDINBlack:20];
        model.titleColor = HDAppTheme.PayNowColor.cCCCCCC;
        model.subTitleStr = PNLocalizedString(@"ms_open_success", @"开通成功");
        model.subTitleFont = HDAppTheme.PayNowFont.standard12;
        model.subTitleColor = HDAppTheme.PayNowColor.cCCCCCC;
        [list addObject:model];

        [_stepView setModelList:list step:0];
    }
    return _stepView;
}
@end
