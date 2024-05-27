//
//  TNBargainGoodSpecView.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainGoodSpecView.h"
#import "TNBargainSpecTagsCell.h"
#import "TNProductSpecPropertieModel.h"
#import "TNProductSpecificationModel.h"


@interface TNBargainGoodSpecView () <UITableViewDelegate, UITableViewDataSource>
/// 规格列表
@property (strong, nonatomic) UITableView *tableView;
/// 选中的规格
@property (nonatomic, strong) NSMutableDictionary<NSString *, TNProductSpecPropertieModel *> *selectedSpecifications;
/// 当前选中的SKU
//@property (nonatomic, strong) TNProductSkuModel *curSelectedSkuModel;
/// 所有有库存的sku 集合
@property (nonatomic, strong) NSArray<NSString *> *powerSet;
/// 规格高度
@property (nonatomic, assign) CGFloat tableHeight;
@end


@implementation TNBargainGoodSpecView
- (void)hd_setupViews {
    [self addSubview:self.tableView];
}
- (void)setSkuModel:(TNProductDetailsRspModel *)skuModel {
    _skuModel = skuModel;
    //设置默认选择数据
    for (TNProductSpecificationModel *specModel in self.skuModel.specs) {
        for (TNProductSpecPropertieModel *propertyModel in specModel.specValues) {
            if (propertyModel.isDefault == YES) {
                specModel.isSelected = YES;
                propertyModel.status = TNSpecPropertyStatusSelected;
                NSUInteger index = [self.skuModel.specs indexOfObject:specModel];
                NSString *specKey = [NSString stringWithFormat:@"%zd", index];
                if (propertyModel) {
                    [self.selectedSpecifications setObject:propertyModel forKey:specKey];
                }
            }
        }
    }
    //获取所有集合
    self.powerSet = [self powerSetWithSkus:skuModel.skus.mutableCopy];
    HDLog(@"所有可卖的skupowerSet===%@", self.powerSet);
    //刷新设置sku的点击
    [self haveStoreWithValues:skuModel.specs powerSet:self.powerSet];
    [self ProcessChoosedSpecSku];
    [self.tableView reloadData];
}
- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
- (CGFloat)getGoodSpecTableViewHeight {
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    if (self.tableView.contentSize.height > self.tableHeight) {
        self.tableHeight = self.tableView.contentSize.height;
    }
    return self.tableHeight;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.skuModel.specs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNProductSpecificationModel *model = self.skuModel.specs[indexPath.row];
    TNBargainSpecTagsCell *cell = [TNBargainSpecTagsCell cellWithTableView:tableView];
    cell.model = model;
    @HDWeakify(self);
    cell.specValueSelected = ^(TNProductSpecPropertieModel *specValueModel, TNProductSpecificationModel *specModel) {
        @HDStrongify(self);
        specModel.isSelected = true;
        [self haveStoreWithValues:self.skuModel.specs powerSet:self.powerSet];
        [self.tableView reloadData];
        NSUInteger index = [self.skuModel.specs indexOfObject:specModel];
        NSString *specKey = [NSString stringWithFormat:@"%zd", index];
        if (specValueModel) {
            [self.selectedSpecifications setObject:specValueModel forKey:specKey];
        }
        [self ProcessChoosedSpecSku];
        //        HDLog(@"select spec:%@,%@", specValueModel.propId, specValueModel.propValue);
    };
    return cell;
}
#pragma mark - 选择规格后的数据处理
- (void)ProcessChoosedSpecSku {
    //所有规格必须全部选中
    BOOL isAllSpecChoosed = self.selectedSpecifications.allKeys.count == self.skuModel.specs.count;
    if (!isAllSpecChoosed) {
        return;
    }
    TNProductSkuModel *sku = nil;
    if (self.skuModel.skus.count == 1 && self.skuModel.specs.count == 0) {
        sku = self.skuModel.skus.firstObject;
    } else {
        NSString *skuKey = [self getSkuKey];
        sku = [self.skuModel getSkuModelWithKey:skuKey];
        if (!sku) {
            [NAT showToastWithTitle:TNLocalizedString(@"6RzEul4A", @"找不到对应的sku") content:nil type:HDTopToastTypeError];
            return;
        }
    }
    if (self.selectedSpecCallBack) {
        self.selectedSpecCallBack(sku);
    }
}
#pragma mark - 规格处理相关
- (NSString *)getSkuKey {
    NSString *skuKey = @"";
    NSMutableArray *allKey = [NSMutableArray arrayWithArray:[self.selectedSpecifications allKeys]];
    [allKey sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        if (str1.integerValue > str2.integerValue) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    for (NSString *key in allKey) {
        TNProductSpecPropertieModel *properties = [self.selectedSpecifications objectForKey:key];
        skuKey = [skuKey stringByAppendingFormat:@",%@", properties.propId];
    }

    return [skuKey substringFromIndex:1];
}
///找出所有有库存的sku
- (NSMutableArray *)enoughStoreSkusWithSkus:(NSArray<TNProductSkuModel *> *)skus {
    NSMutableArray *enoughSkus = [NSMutableArray array];
    for (int i = 0; i < skus.count; i++) {
        TNProductSkuModel *model = skus[i];
        if (model.stock.integerValue > 0) {
            //            model.isOutOfStock == false
            [enoughSkus addObject:model];
        }
    }
    return enoughSkus;
}
///找出所有可能组合的幂集
- (NSMutableArray *)powerSetWithSkus:(NSMutableArray *)skus {
    NSMutableArray *enoughStoreSkus = [self enoughStoreSkusWithSkus:skus];
    NSMutableArray *allPowerSet = [NSMutableArray array];
    for (int i = 0; i < enoughStoreSkus.count; i++) {
        TNProductSkuModel *model = enoughStoreSkus[i];
        NSArray *selectSpecIds = [model.specValueKey componentsSeparatedByString:@","];
        [self powersetArray:selectSpecIds index:0 set:@"" powerSet:allPowerSet];
    }
    return allPowerSet;
}
///递归单个sku 集
- (void)powersetArray:(NSArray *)specArr index:(NSInteger)index set:(NSString *)setString powerSet:(NSMutableArray *)powerSet {
    NSString *tempString = setString;
    if (index >= specArr.count) {
        if (setString.length > 0 && ![powerSet containsObject:setString]) {
            [powerSet addObject:setString];
        }
    } else {
        [self powersetArray:specArr index:index + 1 set:tempString powerSet:powerSet];
        if (tempString.length > 0) {
            tempString = [tempString stringByAppendingFormat:@",%@", specArr[index]];
        } else {
            tempString = [tempString stringByAppendingFormat:@"%@", specArr[index]];
        }
        [self powersetArray:specArr index:index + 1 set:tempString powerSet:powerSet];
    }
}

- (void)haveStoreWithValues:(NSArray *)specValues powerSet:(NSArray *)powerset {
    if (HDIsArrayEmpty(specValues)) { //没有规格的就直接过滤
        return;
    }
    //已经选中的规格
    NSMutableArray *selectedSpecValues = [NSMutableArray array];
    //还未选中的规格
    NSMutableArray *withOutSelectedValues = [NSMutableArray array];
    for (TNProductSpecificationModel *model in specValues) {
        if (model.isSelected == YES) {
            [selectedSpecValues addObject:model];
        } else {
            [withOutSelectedValues addObject:model];
        }
    }
    for (int i = 0; i < specValues.count; i++) {
        TNProductSpecificationModel *specModel = specValues[i];
        NSMutableArray *selections = [NSMutableArray arrayWithArray:selectedSpecValues];
        if (![selections containsObject:specModel]) {
            [selections addObject:specModel];
        }
        for (int j = 0; j < specModel.specValues.count; j++) {
            TNProductSpecPropertieModel *propertyModel = specModel.specValues[j];
            if (propertyModel.status != TNSpecPropertyStatusSelected) {
                NSString *specIds = [self getSpecIdPathWithSpecValues:selections propertyModel:propertyModel];
                HDLog(@"可组合的specIds==%@", specIds);
                if ([powerset containsObject:specIds]) { //有库存  就设置为可选
                    propertyModel.status = TNSpecPropertyStatusNormal;
                } else {
                    propertyModel.status = TNSpecPropertyStatusdisEnble;
                }
            } else {
                propertyModel.status = TNSpecPropertyStatusSelected;
            }
        }
    }
}
///根据当前的属性h元素 和已经选择的其他属性元素 拼接成最短路径
- (NSString *)getSpecIdPathWithSpecValues:(NSArray *)specValues propertyModel:(TNProductSpecPropertieModel *)propertyModel {
    NSString *specIds = @"";
    for (int i = 0; i < specValues.count; i++) {
        TNProductSpecificationModel *specModel = specValues[i];
        for (int j = 0; j < specModel.specValues.count; j++) {
            TNProductSpecPropertieModel *model = specModel.specValues[j];
            //没有选择的就继续下个循环
            if ((model.status != TNSpecPropertyStatusSelected) && ![propertyModel.propId isEqualToString:model.propId]) {
                continue;
            }
            if ([propertyModel.propId isEqualToString:model.propId]) {
                if (specIds.length > 0) {
                    specIds = [specIds stringByAppendingFormat:@",%@", model.propId];
                } else {
                    specIds = [specIds stringByAppendingString:model.propId];
                }
            } else {
                if (model.status == TNSpecPropertyStatusNormal && ![model.propId isEqualToString:propertyModel.propId]) {
                    if (specIds.length > 0) {
                        specIds = [specIds stringByAppendingFormat:@",%@", model.propId];
                    } else {
                        specIds = [specIds stringByAppendingString:model.propId];
                    }
                }
            }
        }
    }
    return specIds;
}
/** @lazy tableView */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 91.5;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}
/** @lazy selectedSpecifications */
- (NSMutableDictionary<NSString *, TNProductSpecPropertieModel *> *)selectedSpecifications {
    if (!_selectedSpecifications) {
        _selectedSpecifications = [[NSMutableDictionary alloc] init];
    }
    return _selectedSpecifications;
}

@end
