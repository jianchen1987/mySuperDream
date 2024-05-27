//
//  WMNearbyFilterBarView.m
//  SuperApp
//
//  Created by Chaos on 2020/7/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMNearbyFilterBarView.h"
#import "SACacheManager.h"
#import "SAInternationalizationModel.h"
#import "SAWriteDateReadableModel.h"
#import "WMAppTheme.h"
#import "WMCategoryItem.h"
#import "WMCustomerSlideDownView.h"
#import "WMHorizontalTreeView.h"
#import "WMNearbyFilterModel.h"
#import "WMNearbyStoreTagsFilterView.h"
#import "WMNearbyStoreTagsModel.h"
#import <HDAppTheme.h>
#import "SAAddressCacheAdaptor.h"
#import "SAAddressModel.h"
#import "UICollectionViewLeftAlignLayout.h"
#import "SACollectionViewCell.h"
#import "SACouponFilterAlertViewCollectionReusableView.h"
#import "WMQueryMerchantFilterCategoryRspModel.h"

@interface WMNearbyFilterBarContentViewCollectionCell : SACollectionViewCell
/// 显示名字
@property (nonatomic, strong) NSString *text;
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) HDUIButton *button;

@end


@implementation WMNearbyFilterBarContentViewCollectionCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.button];
}

- (void)updateConstraints {
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [super updateConstraints];
}

#pragma mark setter
- (void)setText:(NSString *)text {
    _text = text;
    [self.button setTitle:text forState:UIControlStateNormal];
    [self setNeedsUpdateConstraints];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        [self.button setTitleColor:HDAppTheme.color.sa_C1 forState:UIControlStateNormal];
        self.button.layer.borderWidth = 1;
        self.button.layer.borderColor = UIColor.sa_C1.CGColor;
        self.button.backgroundColor = [HDAppTheme.color.sa_C1 colorWithAlphaComponent:0.06];
    } else {
        [self.button setTitleColor:HDAppTheme.color.sa_C666 forState:UIControlStateNormal];
        self.button.layer.borderWidth = 0;
        self.button.backgroundColor = [UIColor hd_colorWithHexString:@"#F7F7F7"];
    }
}

#pragma mark lazy
- (HDUIButton *)button {
    if (!_button) {
        HDUIButton *button = HDUIButton.new;
        if(kScreenWidth <= 375){
            button.titleLabel.font = HDAppTheme.font.sa_standard11;
            button.titleEdgeInsets = UIEdgeInsetsMake(3, 8, 3, 8);
        }else{
            button.titleLabel.font = HDAppTheme.font.sa_standard12;
            button.titleEdgeInsets = UIEdgeInsetsMake(5, 16, 5, 16);
        }
        button.backgroundColor = [UIColor hd_colorWithHexString:@"#F7F7F7"];
        [button setTitleColor:HDAppTheme.color.sa_C666 forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
        button.hd_frameDidChangeBlock = ^(__kindof UIView * _Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:2];
        };
        _button = button;
    }
    return _button;
}

@end





@implementation WMNearbyFilterBarViewFilterParamsModel

- (void)setName:(NSString *)name {
    _name = name;
    self.width = [name boundingAllRectWithSize:CGSizeMake(MAXFLOAT, kRealWidth(28)) font:[UIFont systemFontOfSize:12 weight:UIFontWeightSemibold] lineSpacing:0].width + 32;
}

@end



@implementation WMNearbyFilterBarViewFilterModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"params": WMNearbyFilterBarViewFilterParamsModel.class,
    };
}
@end



@implementation WMNearbyFilterBarContentView

- (void)hd_setupViews {
    
    [self addSubview:self.collectionView];
    [self addSubview:self.resetBTN];
    [self addSubview:self.submitBtn];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
    
    @HDWeakify(self);
    [self.KVOController hd_observe:self.collectionView keyPath:@"contentSize" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateConstraints];
            [self layoutyImmediately];
        });
    }];
}

- (void)updateConstraints {
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(self.collectionView.contentSize.height > 0 ? self.collectionView.contentSize.height : 200);
    }];
    
    [self.resetBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(kRealWidth(12));
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(kRealWidth(40));
        make.width.equalTo(self.submitBtn);
    }];
    
    [self.submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.resetBTN);
        make.right.mas_equalTo(-12);
        make.left.equalTo(self.resetBTN.mas_right).offset(12);
    }];
    
    [super updateConstraints];
}

- (void)layoutyImmediately {
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    
    self.frame = CGRectMake(0, 0, kScreenWidth, self.collectionView.contentSize.height + kRealWidth(40) + kRealWidth(12) * 2);
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.filterDataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    WMNearbyFilterBarViewFilterModel *model = self.filterDataSource[section];
    return model.params.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMNearbyFilterBarContentViewCollectionCell *cell = [WMNearbyFilterBarContentViewCollectionCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                                               identifier:NSStringFromClass(WMNearbyFilterBarContentViewCollectionCell.class)];
    WMNearbyFilterBarViewFilterModel *model = self.filterDataSource[indexPath.section];
    WMNearbyFilterBarViewFilterParamsModel *m = model.params[indexPath.row];
    cell.text = m.name;
    cell.isSelected = m.isSelected;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SACouponFilterAlertViewCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                       withReuseIdentifier:NSStringFromClass(SACouponFilterAlertViewCollectionReusableView.class)
                                                                                                              forIndexPath:indexPath];
        WMNearbyFilterBarViewFilterModel *model = self.filterDataSource[indexPath.section];
        headerView.text = model.title;
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.hd_width, kRealWidth(40));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(SAMultiLanguageManager.isCurrentLanguageCN){
        return CGSizeMake((kScreenWidth - 5 * kRealWidth(12)) / 4 , kRealWidth(32));
        
    }else{
        WMNearbyFilterBarViewFilterModel *model = self.filterDataSource[indexPath.section];
        WMNearbyFilterBarViewFilterParamsModel *m = model.params[indexPath.row];
        NSInteger width = m.width;
        if (width == 0) {
            width = [m.name boundingAllRectWithSize:CGSizeMake(MAXFLOAT, kRealWidth(32)) font:[UIFont systemFontOfSize:12 weight:UIFontWeightSemibold] lineSpacing:0].width + 32;
            m.width = width;
        }
        return CGSizeMake(width, kRealWidth(32));
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WMNearbyFilterBarViewFilterModel *model = self.filterDataSource[indexPath.section];
    WMNearbyFilterBarViewFilterParamsModel *m = model.params[indexPath.row];
    m.isSelected = !m.isSelected;
    [self.collectionView reloadData];
}

#pragma mark - lazy load
- (void)setFilterDataSource:(NSArray<WMNearbyFilterBarViewFilterParamsModel *> *)filterDataSource {
    _filterDataSource = filterDataSource.mutableCopy;
    [self.collectionView reloadData];
}


#pragma mark - lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewLeftAlignLayout *flowLayout = [[UICollectionViewLeftAlignLayout alloc] init];
        flowLayout.minimumLineSpacing = 8.0f;
        flowLayout.minimumInteritemSpacing = 12.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - HDAppTheme.value.padding.left - HDAppTheme.value.padding.right, 20) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:SACouponFilterAlertViewCollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(SACouponFilterAlertViewCollectionReusableView.class)];
        
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIButton *)resetBTN {
    if (!_resetBTN) {
        _resetBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetBTN setTitle:SALocalizedStringFromTable(@"reset", @"重置", @"Buttons") forState:UIControlStateNormal];
        [_resetBTN setTitleColor:HDAppTheme.color.sa_C666 forState:UIControlStateNormal];
        _resetBTN.backgroundColor = [HDAppTheme.color normalBackground];
        _resetBTN.titleLabel.font = [HDAppTheme.font boldForSize:14];
        _resetBTN.hd_frameDidChangeBlock = ^(__kindof UIView * _Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
        @HDWeakify(self);
        [_resetBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            for (WMNearbyFilterBarViewFilterModel *model in self.filterDataSource) {
                for (WMNearbyFilterBarViewFilterParamsModel *m in model.params) {
                    m.isSelected = NO;
                }
            }
            [self.collectionView reloadData];
        }];
        
    }
    return _resetBTN;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:SALocalizedStringFromTable(@"btn_complete", @"完成", @"Buttons") forState:UIControlStateNormal];
        [_submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [HDAppTheme.font boldForSize:14];
        _submitBtn.titleEdgeInsets = UIEdgeInsetsMake(kRealHeight(2), kRealWidth(5), kRealHeight(2), kRealWidth(5));
        _submitBtn.backgroundColor = HDAppTheme.color.sa_C1;
        _submitBtn.hd_frameDidChangeBlock = ^(__kindof UIView * _Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
        @HDWeakify(self);
        [_submitBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.submitBlock) {
                NSMutableArray *marketingTypes = @[].mutableCopy;
                NSMutableArray *storeFeature = @[].mutableCopy;
                for (WMNearbyFilterBarViewFilterModel *model in self.filterDataSource) {
                    if ([model.key isEqualToString:@"marketingTypes"]) {
                        for (WMNearbyFilterBarViewFilterParamsModel *m in model.params) {
                            if(m.isSelected) {
                                [marketingTypes addObject:m.value];
                            }
                        }
                    }else if([model.key isEqualToString:@"storeFeature"]){
                        for (WMNearbyFilterBarViewFilterParamsModel *m in model.params) {
                            if(m.isSelected) {
                                [storeFeature addObject:m.value];
                            }
                        }
                    }
                }
                self.submitBlock(marketingTypes,storeFeature);
            }
            
        }];
    }
    return _submitBtn;
}

@end




@interface WMNearbyFilterBarView ()
/// 背景
@property (nonatomic, strong) UIView *bgView;
/// model
@property (nonatomic, strong) WMNearbyFilterModel *model;
/// 全部分类
@property (nonatomic, strong) HDUIButton *categoryButton;
/// 综合排序
@property (nonatomic, strong) HDUIButton *sortButton;
/// 筛选按钮
@property (nonatomic, strong) HDUIButton *filterButton;
/// bubble
@property (nonatomic, strong) HDLabel *filterBubbleLabel;

@property (nonatomic, strong, nullable) NSArray<WMStoreFilterTableViewCellModel *> *merchantCategoryDataSource;
@property (nonatomic, strong, nullable) NSArray<WMStoreFilterTableViewCellModel *> *sortTypeDataSource;
/// 下滑窗口
@property (nonatomic, weak) WMCustomerSlideDownView *currentSlideView;
/// tmpSelectModel
@property (nonatomic, strong, nullable) WMStoreFilterTableViewCellModel *tmpSelectModel;

@property (nonatomic, strong) NSArray<WMNearbyFilterBarViewFilterModel *> *filterDataSource;

@property (nonatomic, strong) UILabel *numberLabel;

@end


@implementation WMNearbyFilterBarView

- (instancetype)initWithFrame:(CGRect)frame filterModel:(WMNearbyFilterModel *)filterModel startOffsetY:(CGFloat)offset {
    self.model = filterModel;
    self.startOffsetY = offset;
    self = [super initWithFrame:frame];
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.WMColor.bg3;
    [self addSubview:self.categoryButton];
    [self addSubview:self.sortButton];
    [self addSubview:self.filterButton];
    [self addSubview:self.numberLabel];
    
    //获取全部分类数据
    [self getCategoryData];
    
    //获取全部筛选数据
    [self getFilterData];
    
}

- (void)updateConstraints {
    [self.filterBubbleLabel sizeToFit];
    
    CGFloat margin = kRealWidth(15);
    CGFloat avaliableWith = kScreenWidth - 4 * margin;
    if (!self.numberLabel.hidden) {
        [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.centerY.equalTo(self.categoryButton.mas_centerY);
            make.right.mas_equalTo(-margin);
        }];
        avaliableWith -= 16;
    }
    
    CGFloat btnWidth = avaliableWith / 3;
    [self.categoryButton sizeToFit];
    [self.categoryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(btnWidth);
        make.top.mas_equalTo(0);
    }];
    
    [self.sortButton sizeToFit];
    [self.sortButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.categoryButton.mas_right).offset(margin);
        make.centerY.equalTo(self.categoryButton.mas_centerY);
        make.width.mas_equalTo(btnWidth);
        make.top.mas_equalTo(0);
    }];
    
    [self.filterButton sizeToFit];
    [self.filterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sortButton.mas_right).offset(margin);
        make.centerY.equalTo(self.categoryButton.mas_centerY);
        make.width.mas_equalTo(btnWidth);
        make.top.mas_equalTo(0);
    }];
    
    
    [super updateConstraints];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.model keyPath:@"category" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self updateUIWithModel:self.model];
    }];
    
    [self.KVOController hd_observe:self.model keyPath:@"sortType" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self updateUIWithModel:self.model];
    }];
    
    [self.KVOController hd_observe:self.model keyPath:@"tags" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self updateUIWithModel:self.model];
    }];
    
    [self.KVOController hd_observe:self.model keyPath:@"marketingTypes" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self updateUIWithModel:self.model];
    }];
    
    [self.KVOController hd_observe:self.model keyPath:@"storeFeature" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self updateUIWithModel:self.model];
    }];
}

- (void)getCategoryData {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/businessScope/list.do";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMQueryMerchantFilterCategoryRspModel *model = [WMQueryMerchantFilterCategoryRspModel yy_modelWithDictionary:@{@"list": rspModel.data}];
        if (model.list.count) {
            [SACacheManager.shared setObject:[SAWriteDateReadableModel modelWithStoreObj:model.list] forKey:kCacheKeyMerchantKind];
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        HDLog(@"全部分类接口报错啦");
    }];
}

- (void)getFilterData {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/takeaway-merchant/app/super-app/v2/getNearbyFilterParam";
    request.isNeedLogin = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    CLLocationCoordinate2D paramsCoordinate2D = CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue);
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:paramsCoordinate2D];
    if (HDIsObjectNil(addressModel) || !isParamsCoordinate2DValid) {
        // 没有选择地址或选择的地址无效，使用定位地址
        params[@"lon"] = [NSNumber numberWithDouble:HDLocationManager.shared.coordinate2D.longitude].stringValue;
        params[@"lat"] = [NSNumber numberWithDouble:HDLocationManager.shared.coordinate2D.latitude].stringValue;
    } else {
        params[@"lon"] = addressModel.lon.stringValue;
        params[@"lat"] = addressModel.lat.stringValue;
    }
    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    
    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        SARspModel *rspModel = response.extraData;
        self.filterDataSource = [NSArray yy_modelArrayWithClass:WMNearbyFilterBarViewFilterModel.class json:rspModel.data];
    } failure:^(HDNetworkResponse *_Nonnull response) {
        HDLog(@"接口报错啦");
    }];
}

- (void)reSetAll {
    
}

#pragma mark - public methods
- (void)hideAllSlideDownView {
    if (self.currentSlideView) {
        [self.currentSlideView dismissCompleted:nil];
    }
}

#pragma mark - setter
- (void)setModel:(WMNearbyFilterModel *)model {
    _model = model;
    [self updateUIWithModel:model];
}

#pragma mark - private methods
- (void)updateUIWithModel:(WMNearbyFilterModel *)model {
    if (model.category) {
        [self.categoryButton setTitle:model.category.message.desc forState:UIControlStateNormal];
        [self.categoryButton setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
    } else {
        [self.categoryButton setTitle:WMLocalizedString(@"home_cuisine", @"全部分类") forState:UIControlStateNormal];
        [self.categoryButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
    }
    
    if (model.sortType != WMNearbyStoreSortTypeNone) {
        [self.sortButton setTitle:[self getLocalizedStringWithSrotType:model.sortType] forState:UIControlStateNormal];
        [self.sortButton setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
    } else {
        [self.sortButton setTitle:WMLocalizedString(@"98qt1uye", @"综合排序") forState:UIControlStateNormal];
        [self.sortButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
    }
    
    [self.filterButton setTitle:WMLocalizedString(@"wm_sort_Find_more", @"全部筛选") forState:UIControlStateNormal];
    [self.filterButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
    [self.filterButton setImage:[UIImage imageNamed:@"yn_home_u_new"] forState:UIControlStateNormal];
    [self.filterButton setImage:[UIImage imageNamed:@"yn_home_d_new"] forState:UIControlStateSelected];
    NSInteger count1 = model.marketingTypes.count;
    NSInteger count2 = model.storeFeature.count;
    NSInteger count = count1 + count2;
    self.numberLabel.hidden = count <= 0;
    if (!self.numberLabel.hidden) {
        [self.filterButton setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
        [self.filterButton setImage:nil forState:UIControlStateNormal];
        [self.filterButton setImage:nil forState:UIControlStateSelected];
        self.numberLabel.text = [NSString stringWithFormat:@"%ld",count];
    }
    [self setNeedsUpdateConstraints];
}

- (NSString *)getLocalizedStringWithSrotType:(WMNearbyStoreSortType)type {
    if ([type isEqualToString:WMNearbyStoreSortTypePopularity]) {
        return WMLocalizedString(@"wm_sort_Best_sell", @"Popularity");
    } else if ([type isEqualToString:WMNearbyStoreSortTypeDeliveryFeeLowToHigh]) {
        return WMLocalizedString(@"delivery_fee_low_to_high", @"Delivery fee:Low To  High");
    } else if ([type isEqualToString:WMNearbyStoreSortTypeRatingHighToLow]) {
        return WMLocalizedString(@"wm_sort_Good_rates", @"Rating:High To Low");
    } else if ([type isEqualToString:WMNearbyStoreSortTypeDistance]) {
        return WMLocalizedString(@"wm_sort_Nearest", @"Distance");
    } else if ([type isEqualToString:WMNearbyStoreSortTypeDeliveryTime]) {
        return WMLocalizedString(@"sort_delivery_time", @"Delivery Time");
    } else if ([type isEqualToString:WMNearbyStoreSortTypeNone]) {
        return WMLocalizedString(@"98qt1uye", @"综合排序");
    } else {
        return @"";
    }
}

- (void)clickOnCategory:(HDUIButton *)categoryButton {
    HDLog(@"%@", self.model.category);
    if (self.categoryButton.isSelected) {
        [self.currentSlideView dismissCompleted:nil];
        return;
    }
    
    void (^showCategoryView)(NSArray<WMStoreFilterTableViewCellModel *> *) = ^(NSArray<WMStoreFilterTableViewCellModel *> *categorys) {
        if ([self.tmpSelectModel isKindOfClass:WMStoreFilterTableViewCellModel.class] && SAMultiLanguageManager.isCurrentLanguageCN) {
            [categorys enumerateObjectsUsingBlock:^(WMStoreFilterTableViewCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.selected = NO;
                for (WMStoreFilterTableViewCellModel *son in obj.subArrList) {
                    if (son.isSelected) {
                        obj.selected = YES;
                        break;
                    }
                }
                if (!obj.selected) {
                    for (WMStoreFilterTableViewCellModel *son in obj.subArrList) {
                        if (son.isSelected) {
                            son.selected = NO;
                        }
                    }
                }
            }];
        }
        
        WMHorizontalTreeView *view = [[WMHorizontalTreeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        view.dataSource = categorys;
        view.oneNest = SAMultiLanguageManager.isCurrentLanguageCN ? NO : YES;
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            view.cellHeight = kRealWidth(44);
            view.minHeight = view.maxHeight = MIN(kScreenHeight * 0.54, view.dataSource.count * view.cellHeight);
            view.maxWidth = kRealWidth(100);
        } else {
            view.maxHeight = view.minHeight = kScreenHeight - kNavigationBarH - kRealWidth(36) - kRealWidth(70);
            view.cellHeight = kRealWidth(50);
        }
        
        [view layoutyImmediately];
        WMCustomerSlideDownView *slideDownView = [[WMCustomerSlideDownView alloc] initWithStartOffsetY:self.startOffsetY customerView:view];
        slideDownView.slideDownViewWillAppear = ^(WMCustomerSlideDownView *_Nonnull slideDownView) {
            [self.categoryButton setSelected:YES];
        };
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            slideDownView.cornerRadios = kRealWidth(8);
        }
        slideDownView.slideDownViewWillDisappear = ^(WMCustomerSlideDownView *_Nonnull slideDownView) {
            [self.categoryButton setSelected:NO];
        };
        self.currentSlideView = slideDownView;
        
        @HDWeakify(self);
        @HDWeakify(slideDownView);
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            view.didSelectSubTableViewRowAtIndexPath = ^(WMStoreFilterTableViewCellBaseModel *_Nonnull model, NSIndexPath *_Nonnull indexPath) {
                @HDStrongify(self);
                @HDStrongify(slideDownView);
                id associatedParamsModel = model.associatedParamsModel;
                NSString *title = nil;
                if ([associatedParamsModel isKindOfClass:WMCategoryItem.class]) {
                    WMCategoryItem *item = (WMCategoryItem *)associatedParamsModel;
                    self.model.category = item;
                    if ([model.title isEqualToString:WMLocalizedString(@"title_all1", @"全部")] && HDIsStringNotEmpty(model.superTitle)) {
                        title = model.superTitle;
                    } else {
                        title = model.title;
                    }
                    [self.categoryButton setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
                }
                if (self.viewWillDisappear) {
                    self.viewWillDisappear(self);
                }
                [slideDownView dismissCompleted:nil];
            };
        }
        view.didSelectMainTableViewRowAtIndexPath = ^(WMStoreFilterTableViewCellBaseModel *_Nonnull model, NSIndexPath *_Nonnull indexPath) {
            @HDStrongify(self);
            @HDStrongify(slideDownView);
            id associatedParamsModel = model.associatedParamsModel;
            NSString *title = nil;
            if ([associatedParamsModel isKindOfClass:WMCategoryItem.class]) {
                WMCategoryItem *item = (WMCategoryItem *)associatedParamsModel;
                if (!SAMultiLanguageManager.isCurrentLanguageCN) {
                    self.model.category = item;
                    if ([model.title isEqualToString:WMLocalizedString(@"title_all1", @"全部")] && HDIsStringNotEmpty(model.superTitle)) {
                        title = model.superTitle;
                    } else {
                        title = model.title;
                    }
                    [self.categoryButton setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
                } else {
                    if ([model.title isEqualToString:WMLocalizedString(@"title_all1", @"全部")] && HDIsStringNotEmpty(model.superTitle)) {
                        title = model.superTitle;
                        [self.categoryButton setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
                        self.model.category = item;
                    } else {
                        self.tmpSelectModel = (WMStoreFilterTableViewCellModel *)model;
                    }
                }
            } else {
                if (!SAMultiLanguageManager.isCurrentLanguageCN) {
                    self.model.category = nil;
                    title = WMLocalizedString(@"home_cuisine", @"全部分类");
                    [self.categoryButton setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
                } else {
                    self.model.category = nil;
                    title = WMLocalizedString(@"home_cuisine", @"全部分类");
                    [self.categoryButton setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
                    if (self.tmpSelectModel) {
                        self.tmpSelectModel.selected = NO;
                        [self.tmpSelectModel.subArrList enumerateObjectsUsingBlock:^(WMStoreFilterTableViewCellBaseModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                            obj.selected = NO;
                        }];
                    }
                }
            }
            if (title) {
                // 更新标题
                [self.categoryButton setTitle:title forState:UIControlStateNormal];
            }
            if (!SAMultiLanguageManager.isCurrentLanguageCN || (SAMultiLanguageManager.isCurrentLanguageCN && ![associatedParamsModel isKindOfClass:WMCategoryItem.class])) {
                if (self.viewWillDisappear) {
                    self.viewWillDisappear(self);
                }
                [slideDownView dismissCompleted:nil];
            }
        };
        
        if (self.viewWillAppear) {
            self.viewWillAppear(self);
        }
        
        [slideDownView show];
    };
    
    if (self.currentSlideView) {
        [self.currentSlideView dismissCompleted:^{
            showCategoryView(self.merchantCategoryDataSource);
        }];
    } else {
        showCategoryView(self.merchantCategoryDataSource);
    }
}

- (void)clickOnSort:(HDUIButton *)sortButton {
    if (self.sortButton.isSelected) {
        [self.currentSlideView dismissCompleted:nil];
        return;
    }
    
    void (^showActionView)(NSArray<WMStoreFilterTableViewCellModel *> *) = ^(NSArray<WMStoreFilterTableViewCellModel *> *categorys) {
        WMHorizontalTreeView *view = [[WMHorizontalTreeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            view.cellHeight = kRealWidth(44);
        } else {
            view.cellHeight = kRealWidth(50);
        }
        view.dataSource = categorys;
        view.minHeight = kScreenHeight * 0.2;
        view.maxHeight = kScreenHeight * 0.6;
        [view layoutyImmediately];
        
        WMCustomerSlideDownView *slideDownView = [[WMCustomerSlideDownView alloc] initWithStartOffsetY:self.startOffsetY customerView:view];
        slideDownView.slideDownViewWillAppear = ^(WMCustomerSlideDownView *_Nonnull slideDownView) {
            [self.sortButton setSelected:YES];
        };
        slideDownView.slideDownViewWillDisappear = ^(WMCustomerSlideDownView *_Nonnull slideDownView) {
            [self.sortButton setSelected:NO];
        };
        slideDownView.cornerRadios = kRealWidth(8);
        self.currentSlideView = slideDownView;
        @HDWeakify(slideDownView);
        @HDWeakify(self);
        view.didSelectSubTableViewRowAtIndexPath = ^(WMStoreFilterTableViewCellBaseModel *_Nonnull model, NSIndexPath *_Nonnull indexPath) {
            @HDStrongify(self);
            @HDStrongify(slideDownView);
            id associatedParamsModel = model.associatedParamsModel;
            NSString *title = nil;
            if ([associatedParamsModel isKindOfClass:NSString.class]) {
                if ([associatedParamsModel length]) {
                    self.model.sortType = associatedParamsModel;
                    title = model.title;
                    [self.sortButton setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
                } else {
                    self.model.sortType = WMNearbyStoreSortTypeNone;
                    title = WMLocalizedString(@"98qt1uye", @"综合排序");
                    [self.sortButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
                }
                [self.sortButton setTitle:title forState:UIControlStateNormal];
            }
            if (self.viewWillDisappear) {
                self.viewWillDisappear(self);
            }
            
            [slideDownView dismissCompleted:nil];
        };
        
        if (self.viewWillAppear) {
            self.viewWillAppear(self);
        }
        
        [slideDownView show];
    };
    
    if (self.currentSlideView) {
        [self.currentSlideView dismissCompleted:^{
            showActionView(self.sortTypeDataSource);
        }];
    } else {
        showActionView(self.sortTypeDataSource);
    }
}

- (void)clickOnFilter:(HDUIButton *)btn {
    HDLog(@"%s",__func__);
    if (btn.isSelected) {
        [self.currentSlideView dismissCompleted:nil];
        return;
    }
    @HDWeakify(self);
    void (^showActionView)(void) = ^{
        WMNearbyFilterBarContentView *view = [[WMNearbyFilterBarContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        
        for (WMNearbyFilterBarViewFilterModel *model in self.filterDataSource) {
            for (WMNearbyFilterBarViewFilterParamsModel *m in model.params) {
                m.isSelected = [self.model.marketingTypes containsObject:m.value] || [self.model.storeFeature containsObject:m.value];
            }
        }
        
        view.filterDataSource = self.filterDataSource;
        [view layoutyImmediately];
        
        WMCustomerSlideDownView *slideDownView = [[WMCustomerSlideDownView alloc] initWithStartOffsetY:self.startOffsetY customerView:view];
        slideDownView.slideDownViewWillAppear = ^(WMCustomerSlideDownView *_Nonnull slideDownView) {
            [self.filterButton setSelected:YES];
        };
        slideDownView.slideDownViewWillDisappear = ^(WMCustomerSlideDownView *_Nonnull slideDownView) {
            [self.filterButton setSelected:NO];
        };
        slideDownView.cornerRadios = kRealWidth(8);
        self.currentSlideView = slideDownView;
        @HDWeakify(slideDownView);
        @HDWeakify(self);
        view.submitBlock = ^(NSArray<NSString *> *marketingTypes, NSArray<NSString *> *storeFeature) {
            @HDStrongify(self);
            @HDStrongify(slideDownView);
            self.model.marketingTypes = marketingTypes;
            self.model.storeFeature = storeFeature;
            
            if(marketingTypes.count + storeFeature.count <= 0) {
                
                [self.filterButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
            } else {
                [self.filterButton setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
            }
            
            
            if (self.viewWillDisappear) {
                self.viewWillDisappear(self);
            }
            [slideDownView dismissCompleted:nil];
        };
        
        if (self.viewWillAppear) {
            self.viewWillAppear(self);
        }
        
        [slideDownView show];
    };
    
    if (self.currentSlideView) {
        [self.currentSlideView dismissCompleted:^{
            if(self.filterDataSource.count) {
                showActionView();
            }
        }];
    } else {
        if(self.filterDataSource.count) {
            showActionView();
        }
    }
}

///重置筛选条件
- (void)resetAll {
    self.model.category = nil;
    [self.categoryButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
    [self.sortButton setTitle:WMLocalizedString(@"home_cuisine", @"全部分类") forState:UIControlStateNormal];
    
    self.model.sortType = WMNearbyStoreSortTypeNone;
    [self.sortButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
    [self.sortButton setTitle:WMLocalizedString(@"98qt1uye", @"综合排序") forState:UIControlStateNormal];
    
    [self.filterButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
    [self.filterButton setTitle:WMLocalizedString(@"home_filters", @"全部筛选") forState:UIControlStateNormal];
    self.sortTypeDataSource = nil;
    self.merchantCategoryDataSource = nil;
}

#pragma mark - lazy load
/** @lazy categoryButton */
- (HDUIButton *)categoryButton {
    if (!_categoryButton) {
        _categoryButton = [[HDUIButton alloc] init];
        _categoryButton.imagePosition = HDUIButtonImagePositionRight;
        _categoryButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        _categoryButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        _categoryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_categoryButton setImage:[UIImage imageNamed:@"yn_home_u_new"] forState:UIControlStateNormal];
        [_categoryButton setImage:[UIImage imageNamed:@"yn_home_d_new"] forState:UIControlStateSelected];
        [_categoryButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        [_categoryButton addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _categoryButton;
}

/** @lazy sortButton */
- (HDUIButton *)sortButton {
    if (!_sortButton) {
        _sortButton = [[HDUIButton alloc] init];
        _sortButton.imagePosition = HDUIButtonImagePositionRight;
        _sortButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        _sortButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        _sortButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_sortButton setImage:[UIImage imageNamed:@"yn_home_u_new"] forState:UIControlStateNormal];
        [_sortButton setImage:[UIImage imageNamed:@"yn_home_d_new"] forState:UIControlStateSelected];
        [_sortButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        [_sortButton addTarget:self action:@selector(clickOnSort:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortButton;
}

- (HDUIButton *)filterButton {
    if (!_filterButton) {
        _filterButton = [[HDUIButton alloc] init];
        _filterButton.imagePosition = HDUIButtonImagePositionRight;
        _filterButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        _filterButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        _filterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_filterButton setImage:[UIImage imageNamed:@"yn_home_u_new"] forState:UIControlStateNormal];
        [_filterButton setImage:[UIImage imageNamed:@"yn_home_d_new"] forState:UIControlStateSelected];
        [_filterButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        [_filterButton addTarget:self action:@selector(clickOnFilter:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterButton;
}

/** @lazy filterBubbleLabel */
- (HDLabel *)filterBubbleLabel {
    if (!_filterBubbleLabel) {
        _filterBubbleLabel = [[HDLabel alloc] init];
        _filterBubbleLabel.textColor = UIColor.whiteColor;
        _filterBubbleLabel.font = [UIFont systemFontOfSize:9];
        _filterBubbleLabel.backgroundColor = HDAppTheme.color.G4;
        _filterBubbleLabel.hd_edgeInsets = UIEdgeInsetsMake(2, 5, 2, 5);
        _filterBubbleLabel.hidden = YES;
        _filterBubbleLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height / 2.0f;
            view.layer.masksToBounds = YES;
        };
    }
    return _filterBubbleLabel;
}

- (NSArray<WMStoreFilterTableViewCellModel *> *)merchantCategoryDataSource {
    if (!_merchantCategoryDataSource) {
        NSMutableArray<WMStoreFilterTableViewCellModel *> *list = [NSMutableArray array];
        WMStoreFilterTableViewCellModel *model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"title_all1", @"全部") associatedParamsModel:nil];
        if (!SAMultiLanguageManager.isCurrentLanguageCN) {
            model.canSelect = YES;
            model.titleFont = [HDAppTheme.WMFont wm_boldForSize:17];
            model.titleSelectFont = [HDAppTheme.WMFont wm_boldForSize:17];
        } else {
            model.titleFont = [HDAppTheme.WMFont wm_ForSize:14];
            model.titleSelectFont = [HDAppTheme.WMFont wm_ForSize:14];
        }
        model.titleColor = HDAppTheme.WMColor.B3;
        model.titleSelectColor = HDAppTheme.WMColor.mainRed;
        
        SAWriteDateReadableModel *cacheModel = [SACacheManager.shared objectForKey:kCacheKeyMerchantKind];
        NSArray<WMCategoryItem *> *cachedList = [NSArray yy_modelArrayWithClass:WMCategoryItem.class json:cacheModel.storeObj];
        [list addObject:model];
        
        @autoreleasepool {
            for (WMCategoryItem *item in cachedList) {
                model = [WMStoreFilterTableViewCellModel modelWithTitle:item.message.desc associatedParamsModel:item];
                if (SAMultiLanguageManager.isCurrentLanguageCN) {
                    model.titleColor = HDAppTheme.WMColor.B3;
                    model.titleSelectColor = HDAppTheme.WMColor.mainRed;
                    model.titleFont = [HDAppTheme.WMFont wm_ForSize:14];
                    model.titleSelectFont = [HDAppTheme.WMFont wm_ForSize:14];
                } else {
                    model.titleColor = HDAppTheme.WMColor.B3;
                    model.titleSelectColor = HDAppTheme.WMColor.mainRed;
                    model.titleFont = [HDAppTheme.WMFont wm_boldForSize:17];
                    model.titleSelectFont = [HDAppTheme.WMFont wm_boldForSize:17];
                }
                [list addObject:model];
                
                NSMutableArray<WMStoreFilterTableViewCellModel *> *subArrList = NSMutableArray.new;
                WMStoreFilterTableViewCellModel *subCellModel = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"title_all1", @"全部") associatedParamsModel:item];
                
                if (HDIsStringNotEmpty(self.model.category.scopeCode) && [self.model.category.scopeCode isEqualToString:item.scopeCode]) {
                    model.selected = true;
                    subCellModel.selected = true;
                    [self.categoryButton setTitle:item.message.desc forState:UIControlStateNormal];
                    self.model.category.scopeCode = item.scopeCode;
                }
                subCellModel.superTitle = item.message.desc;
                [subArrList addObject:subCellModel];
                
                [subArrList addObjectsFromArray:[item.subClassifications mapObjectsUsingBlock:^id _Nonnull(WMCategoryItem *_Nonnull obj, NSUInteger idx) {
                    return [WMStoreFilterTableViewCellModel modelWithTitle:obj.message.desc associatedParamsModel:obj];
                }]];
                if (SAMultiLanguageManager.isCurrentLanguageCN) {
                    [subArrList enumerateObjectsUsingBlock:^(WMStoreFilterTableViewCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                        obj.titleFont = [HDAppTheme.WMFont wm_ForSize:14];
                        obj.titleSelectFont = [HDAppTheme.WMFont wm_ForSize:14];
                        obj.titleColor = HDAppTheme.WMColor.B3;
                        obj.titleSelectColor = HDAppTheme.WMColor.mainRed;
                    }];
                    model.subArrList = [NSArray arrayWithArray:subArrList];
                } else {
                    [subArrList enumerateObjectsUsingBlock:^(WMStoreFilterTableViewCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                        obj.canSelect = YES;
                        obj.titleFont = [HDAppTheme.WMFont wm_ForSize:17];
                        obj.titleSelectFont = [HDAppTheme.WMFont wm_boldForSize:17];
                        obj.titleColor = HDAppTheme.WMColor.B3;
                        obj.titleSelectColor = HDAppTheme.WMColor.mainRed;
                    }];
                    [list addObjectsFromArray:subArrList];
                }
            }
        }
        
        _merchantCategoryDataSource = list.copy;
    }
    return _merchantCategoryDataSource;
}

- (NSArray<WMStoreFilterTableViewCellModel *> *)sortTypeDataSource {
    if (!_sortTypeDataSource) {
        NSMutableArray<WMStoreFilterTableViewCellModel *> *dataSource = [NSMutableArray array];
        WMStoreFilterTableViewCellModel *model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"98qt1uye", @"综合排序") associatedParamsModel:@""];
        [dataSource addObject:model];
        
        //        model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"sort_distance", @"距离") associatedParamsModel:@"MS_004"];
        model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"wm_sort_Nearest", @"距离最近") associatedParamsModel:@"MS_004"];
        [dataSource addObject:model];
        
        model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"wm_sort_Best_sell", @"销量最高") associatedParamsModel:@"MS_001"];
        [dataSource addObject:model];
        
        //        model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"rating_high_to_low", @"评分：从高到低") associatedParamsModel:@"MS_003"];
        model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"wm_sort_Good_rates", @"好评优先") associatedParamsModel:@"MS_003"];
        [dataSource addObject:model];
        
        [dataSource enumerateObjectsUsingBlock:^(WMStoreFilterTableViewCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.titleColor = HDAppTheme.WMColor.B3;
            obj.titleSelectColor = HDAppTheme.WMColor.mainRed;
            if (SAMultiLanguageManager.isCurrentLanguageCN) {
                obj.canSelect = YES;
                obj.titleFont = [HDAppTheme.WMFont wm_ForSize:14];
                obj.titleSelectFont = [HDAppTheme.WMFont wm_ForSize:14];
            } else {
                obj.canSelect = YES;
                obj.titleFont = [HDAppTheme.WMFont wm_boldForSize:17];
                obj.titleSelectFont = [HDAppTheme.WMFont wm_boldForSize:17];
            }
        }];
        _sortTypeDataSource = dataSource.copy;
    }
    
    return _sortTypeDataSource;
}

- (UILabel *)numberLabel {
    if(!_numberLabel) {
        _numberLabel = UILabel.new;
        _numberLabel.textColor = UIColor.sa_C1;
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        //        _numberLabel.backgroundColor = UIColor.sa_C1;
        _numberLabel.layer.borderColor = UIColor.sa_C1.CGColor;
        _numberLabel.layer.borderWidth = 1;
        _numberLabel.layer.cornerRadius = 8;
        _numberLabel.font = HDAppTheme.font.sa_standard11M;
        _numberLabel.hidden = YES;
    }
    return _numberLabel;
}
@end
