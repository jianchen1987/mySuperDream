//
//  TNSpeciaActivityViewModel.m
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSpeciaActivityViewModel.h"
#import "SANoDataCellModel.h"
#import "SAShoppingAddressModel.h"
#import "TNHomeChoicenessSkeletonCell.h"
#import "TNHomeDTO.h"
#import "TNNotificationConst.h"
#import "TNSpecialActivityDTO.h"


@interface TNSpeciaActivityViewModel ()
@property (nonatomic, strong) TNSpecialActivityDTO *activityDTO;
@property (nonatomic, strong) TNHomeDTO *categoryDTO;
/// 队列组
@property (nonatomic, strong) dispatch_group_t taskGroup;
/// 记录专题id
@property (nonatomic, copy) NSString *oldActivityId;
@end


@implementation TNSpeciaActivityViewModel
- (void)setActivityId:(NSString *)activityId {
    _activityId = activityId;
    if (![self.oldActivityId isEqualToString:activityId]) {
        //切换专题id 清空缓存数据
        self.recommedProductsArr = @[];
        self.recommedHotSalesProductsArr = @[];
        self.recommendNormalTagsArr = @[];
        self.recommendHotTagsArr = @[];
    }
    self.oldActivityId = activityId;
}
- (CGFloat)getSpecialTagsHeightByTagsArr:(NSArray<TNGoodsTagModel *> *)tagsArr {
    CGFloat height = 0;
    if (!HDIsArrayEmpty(tagsArr)) {
        __block CGFloat width = 0;
        CGFloat showWidth = self.styleType == TNSpecialStyleTypeHorizontal ? kScreenWidth : kScreenWidth - kSpecialLeftCategoryWidth;
        CGFloat maxWidth = showWidth * 2;
        [tagsArr enumerateObjectsUsingBlock:^(TNGoodsTagModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            width += obj.itemSize.width;
            if (idx != tagsArr.count - 1) {
                width += kRealWidth(15);
            }
            if (width >= maxWidth) {
                *stop = YES;
            }
        }];
        if (width <= showWidth - kRealWidth(20)) {
            height = kRealWidth(45);
        } else {
            height = self.styleType == TNSpecialStyleTypeHorizontal ? kRealWidth(90) : kRealWidth(80);
        }
    }
    return height;
}
- (TNGoodsTagModel *)getDefaultTagModel {
    TNGoodsTagModel *model = [[TNGoodsTagModel alloc] init];
    model.tagName = TNLocalizedString(@"tn_title_all", @"全部");
    model.tagId = @"";
    model.isSelected = YES;
    return model;
}
- (NSArray<TNGoodsTagModel *> *)processSelectedTagByTagId:(NSString *)tagId inTagArr:(NSArray<TNGoodsTagModel *> *)tagsArr {
    if (HDIsStringNotEmpty(tagId)) {
        __block NSInteger bingoIndex = 0;
        [tagsArr enumerateObjectsUsingBlock:^(TNGoodsTagModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.isSelected = NO;
            if ([obj.tagId isEqualToString:tagId]) {
                obj.isSelected = YES;
                bingoIndex = idx;
                *stop = YES;
            }
        }];
        if (bingoIndex > 0) {
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[tagsArr subarrayWithRange:NSMakeRange(0, bingoIndex)]];
            NSArray *leftArr = [tagsArr subarrayWithRange:NSMakeRange(bingoIndex, tagsArr.count - bingoIndex)];

            [tempArr insertObjects:leftArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, leftArr.count)]];
            return tempArr;
        } else {
            return tagsArr;
        }
    } else {
        return tagsArr;
    }
}
- (void)getRedZoneSpecialActivityIdSuccessBlock:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.activityDTO queryRedZoneSpeciaActivityIdWithLongitude:self.addressModel.longitude latitude:self.addressModel.latitude success:^(TNRedZoneActivityModel *_Nonnull model) {
        @HDStrongify(self);
        if (self == nil) {
            return;
        }
        self.redZoneModel = model;
        successBlock();
    } failure:failureBlock];
}

#pragma mark - 获取砍价专题配置数据
- (void)getSpecialActivityConfigDataSuccessBlock:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    [self.activityDTO querySpecialActivityDetailWithActivityId:self.activityId success:^(TNSpeciaActivityDetailModel *_Nonnull detailModel) {
        @HDStrongify(self);
        if (self == nil) {
            return;
        }
        self.configModel = detailModel;
        if (detailModel.businessLine == TNSpeciaActivityBusinessLineOverseas) {
            self.speciaTrackPrefixName = TNTrackEventPrefixNameOverseas;
        } else if (detailModel.businessLine == TNSpeciaActivityBusinessLineFastConsume) {
            self.speciaTrackPrefixName = TNTrackEventPrefixNameFastConsume;
        } else {
            self.speciaTrackPrefixName = TNTrackEventPrefixNameOther;
        }
        // 2.9.5  新增漏斗  可能会覆盖之前的漏斗
        self.funnel = [self.speciaTrackPrefixName stringByAppendingString:@"商品专题_"];
        //如果没有本地记录的样式 使用接口定义的显示样式
        if (self.styleType <= 0) {
            self.styleType = detailModel.styleType;
        }

        if (successBlock) {
            successBlock();
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        if (failureBlock) {
            failureBlock(rspModel, errorType, error);
        }
    }];
}
#pragma mark - 获取广告以及分类数据
- (void)requestAdsAndCategoryDataCompletion:(void (^)(void))completion {
    dispatch_group_enter(self.taskGroup);
    @HDWeakify(self);
    [self requestActivityCardDataCompletion:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];
    dispatch_group_enter(self.taskGroup);
    [self getSpecialCategoryDataCompletion:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];
    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^() {
        self.adsAndCategoryRefrehFlag = !self.adsAndCategoryRefrehFlag;
        !completion ?: completion();
    });
}
#pragma mark - 获取分类数据
- (void)getSpecialCategoryDataCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.activityDTO queryGoodCategoryDataWithActivityId:self.activityId success:^(NSArray<TNCategoryModel *> *_Nonnull categoryArr) {
        @HDStrongify(self);
        if (self == nil) {
            return;
        }
        [self.categoryArr removeAllObjects];
        [self addRecommondCategoryModel];
        if (!HDIsArrayEmpty(categoryArr)) {
            [self.categoryArr addObjectsFromArray:categoryArr];
        }
        !completion ?: completion();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion();
    }];
}
//加入本地推荐分类
- (void)addRecommondCategoryModel {
    TNCategoryModel *model = [[TNCategoryModel alloc] init];
    model.name = TNLocalizedString(@"tn_recommend", @"推荐");
    model.menuId = kCategotyRecommondItemName;
    model.selectLogoImage = [UIImage imageNamed:@"tn_special_recommend_k"];
    [self.categoryArr addObject:model];
}
#pragma mark - 获取广告数据
- (void)requestActivityCardDataCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.activityDTO querySpeciaActivityCardWithActivityId:self.activityId success:^(TNActivityCardRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (self == nil) {
            return;
        }
        self.activityCardRspModel = rspModel;
        self.activityCardRspModel.backGroundColor = [UIColor whiteColor];
        !completion ?: completion();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion();
    }];
}
- (void)resetCategoryDataSelectedState {
    if (!HDIsArrayEmpty(self.categoryArr)) {
        [self.categoryArr enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.isSelected = NO;
            if (!HDIsArrayEmpty(obj.children)) {
                [obj.children enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull subObj, NSUInteger idx, BOOL *_Nonnull stop) {
                    subObj.isSelected = NO;
                }];
            }
        }];
    }

    //热卖 推荐商品标签重置
    if (!HDIsArrayEmpty(self.recommendHotTagsArr)) {
        [self.recommendHotTagsArr enumerateObjectsUsingBlock:^(TNGoodsTagModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (idx == 0) {
                obj.isSelected = YES;
            } else {
                obj.isSelected = NO;
            }
        }];
    }
    if (!HDIsArrayEmpty(self.recommendNormalTagsArr)) {
        [self.recommendNormalTagsArr enumerateObjectsUsingBlock:^(TNGoodsTagModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (idx == 0) {
                obj.isSelected = YES;
            } else {
                obj.isSelected = NO;
            }
        }];
    }
}
- (void)clearCacheData {
    self.recommedHotSalesProductsArr = @[];
    self.recommedProductsArr = @[];
    if (!HDIsObjectNil(self.activityCardRspModel)) {
        self.activityCardRspModel.list = @[];
    }
}
#pragma mark - private methods
- (TNSpecialActivityDTO *)activityDTO {
    if (!_activityDTO) {
        _activityDTO = [[TNSpecialActivityDTO alloc] init];
    }
    return _activityDTO;
}
- (NSMutableArray *)categoryArr {
    if (!_categoryArr) {
        _categoryArr = [NSMutableArray array];
        TNCategoryModel *model = [[TNCategoryModel alloc] init];
        model.name = TNLocalizedString(@"tn_recommend", @"推荐");
        [_categoryArr addObject:model];
    }
    return _categoryArr;
}

- (TNHomeDTO *)categoryDTO {
    if (!_categoryDTO) {
        _categoryDTO = [[TNHomeDTO alloc] init];
    }
    return _categoryDTO;
}
- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}
/** @lazy addressModel */
- (SAShoppingAddressModel *)addressModel {
    if (!_addressModel) {
        _addressModel = [[SAShoppingAddressModel alloc] init];
    }
    return _addressModel;
}

- (BOOL)showHorizontalStyle {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kNSUserDefaultsKeyShowHorizontalProductsStyle];
}
- (NSString *)specialTrackStyleParamete {
    // 埋点
    NSString *style;
    if (self.styleType == TNSpecialStyleTypeHorizontal) {
        if (self.showHorizontalStyle) {
            style = @"4";
        } else {
            style = @"1";
        }
    } else if (self.styleType == TNSpecialStyleTypeVertical) {
        if (self.showHorizontalStyle) {
            style = @"2";
        } else {
            style = @"3";
        }
    }
    return style;
}
@end
