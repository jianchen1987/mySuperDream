//
//  TNWholesaleSpecificationContentView.m
//  SuperApp
//
//  Created by 张杰 on 2022/7/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNWholesaleSpecificationContentView.h"
#import "SAOperationButton.h"
#import "SATableView.h"
#import "TNDecimalTool.h"
#import "TNEditSpecCell.h"
#import "TNHorizontalSpecsCell.h"
#import "TNHorizontalSpecsView.h"
#import "TNMultiLanguageManager.h"
#import "TNWholesaleHeaderView.h"
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDUIKit.h>


@interface TNWholesaleSpecificationContentView () <UITableViewDelegate, UITableViewDataSource>
///
@property (strong, nonatomic) TNWholesaleHeaderView *headerView;
/// 规格容器
@property (strong, nonatomic) UIStackView *specStackView;
/// 规格视图数组
@property (strong, nonatomic) NSMutableArray<TNHorizontalSpecsView *> *specsViewArray;
///
@property (strong, nonatomic) SATableView *tableView;
/// 合计视图
@property (strong, nonatomic) UIView *totalView;
/// 合计件数
@property (strong, nonatomic) UILabel *totalQuantityLabel;
/// 合计金额
@property (strong, nonatomic) UILabel *totalPriceLabel;
/// 添加购物车按钮
@property (nonatomic, strong) SAOperationButton *confirBtn;
/// 规格模型
@property (strong, nonatomic) TNSkuSpecModel *specModel;
/// 规格数组
@property (strong, nonatomic) NSMutableArray<HDTableViewSectionModel *> *specsDataSource;
/// 展示最后数组
@property (strong, nonatomic) NSMutableArray<TNEditSpecCellModel *> *skusDataSource;
/// 按钮显示类型
@property (nonatomic, assign) TNProductBuyType buyType;
/// tableView 高度
@property (nonatomic, assign) CGFloat tableViewHeight;
@end


@implementation TNWholesaleSpecificationContentView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (instancetype)initWithSpecModel:(TNSkuSpecModel *)model buyType:(TNProductBuyType)buyType {
    id json = [model yy_modelToJSONObject];
    self.specModel = [TNSkuSpecModel yy_modelWithJSON:json];
    self.buyType = buyType;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    return [super init];
}
- (void)hd_setupViews {
    [self addSubview:self.headerView];
    [self addSubview:self.specStackView];
    [self addSubview:self.tableView];
    [self addSubview:self.totalView];
    [self.totalView addSubview:self.totalQuantityLabel];
    [self.totalView addSubview:self.totalPriceLabel];
    [self addSubview:self.confirBtn];
    NSString *btnTitle = @"";
    if (self.buyType == TNProductBuyTypeBuyNow) {
        btnTitle = TNLocalizedString(@"tn_buynow", @"立即购买");
    } else if (self.buyType == TNProductBuyTypeAddCart) {
        btnTitle = TNLocalizedString(@"tn_add_cart", @"Add to Cart");
    }
    [self.confirBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self prepareHeaderWholsePriceData];
    [self prepareData];
    [self addHorizontalSpecsViews];
    [self calculateSelectedSkuCountAndPrice];
}
- (void)addHorizontalSpecsViews {
    if (!HDIsArrayEmpty(self.specsDataSource)) {
        [self.specStackView hd_removeAllSubviews];
        [self.specsViewArray removeAllObjects];
        for (HDTableViewSectionModel *sectionModel in self.specsDataSource) {
            TNHorizontalSpecsView *specsView = [[TNHorizontalSpecsView alloc] init];
            specsView.specValues = sectionModel.list;
            @HDWeakify(self);
            specsView.selectedItemCallBack = ^(TNProductSpecPropertieModel *_Nonnull model) {
                @HDStrongify(self);
                [self reloadSpecsData];
                [self calculateSelectedSkuCountAndPrice];
            };
            [self.specStackView addArrangedSubview:specsView];
            [self.specsViewArray addObject:specsView];
        }
    }
}
#pragma mark -准备头部 批发价数据
- (void)prepareHeaderWholsePriceData {
    if (self.specModel.batchPriceInfo.quoteType == TNProductQuoteTypeNoSpecByNumber || self.specModel.batchPriceInfo.quoteType == TNProductQuoteTypeHasSpecByNumber) {
        if (HDIsArrayEmpty(self.specModel.batchPriceInfo.priceRanges)) {
            return;
        }
        ///阶梯价
        NSMutableArray *itemArr = [NSMutableArray array];
        NSMutableArray *rangeArr = [NSMutableArray array];
        TNPriceRangesModel *lastModel = nil;
        for (TNPriceRangesModel *model in self.specModel.batchPriceInfo.priceRanges) {
            TNWholesalePriceAndBatchNumberModel *numberModel = [[TNWholesalePriceAndBatchNumberModel alloc] init];
            if (self.specModel.batchPriceInfo.detailViewType == TNProductDetailViewTypeSupplyAndMarketing) {
                numberModel.showPrice = model.tradePrice.thousandSeparatorAmount;
                numberModel.price = model.tradePrice;
            } else {
                numberModel.showPrice = model.price.thousandSeparatorAmount;
                numberModel.price = model.price;
            }

            if (lastModel) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"start"] = @(lastModel.startQuantity);
                dict[@"end"] = @(model.startQuantity - 1);
                [rangeArr addObject:dict];
            }
            [itemArr addObject:numberModel];
            lastModel = model;
        }
        //还要加上最后一个
        TNPriceRangesModel *model = self.specModel.batchPriceInfo.priceRanges.lastObject;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"start"] = @(model.startQuantity);
        dict[@"end"] = @(-1); //表示无限制
        [rangeArr addObject:dict];

        for (int i = 0; i < itemArr.count; i++) {
            TNWholesalePriceAndBatchNumberModel *numberModel = itemArr[i];
            NSDictionary *dic = rangeArr[i];
            NSInteger start = [dic[@"start"] integerValue];
            NSInteger end = [dic[@"end"] integerValue];
            numberModel.startNumber = start;
            numberModel.endNumber = end;
            if (i == itemArr.count - 1) {
                numberModel.batchNumber = [NSString stringWithFormat:@"≥%ld%@", start, self.specModel.batchPriceInfo.unit];
            } else {
                if (start < end) {
                    numberModel.batchNumber = [NSString stringWithFormat:@"%ld-%ld%@", start, end, self.specModel.batchPriceInfo.unit];
                } else {
                    numberModel.batchNumber = [NSString stringWithFormat:@"%ld%@", start, self.specModel.batchPriceInfo.unit];
                }
            }
        }
        self.headerView.list = itemArr;

    } else {
        ///按规格报价  遍历sku价格  找出最低价和  最高价
        SAMoneyModel *lowestMoney = nil;
        SAMoneyModel *highestMoney = nil;

        TNWholesalePriceAndBatchNumberModel *numberModel = [[TNWholesalePriceAndBatchNumberModel alloc] init];
        numberModel.isRangePrice = YES;
        for (TNProductSkuModel *sku in self.specModel.skus) {
            SAMoneyModel *price = self.specModel.batchPriceInfo.detailViewType == TNProductDetailViewTypeSupplyAndMarketing ? sku.priceRange.tradePrice : sku.priceRange.price;

            if (!lowestMoney || lowestMoney.cent.integerValue > price.cent.integerValue) {
                lowestMoney = price;
            }
            if (!highestMoney || highestMoney.cent.integerValue < price.cent.integerValue) {
                highestMoney = price;
            }
            if (HDIsStringEmpty(numberModel.batchNumber)) {
                numberModel.batchNumber = [NSString stringWithFormat:TNLocalizedString(@"JAl17oWr", @"%ld件起批"), sku.priceRange.startQuantity];
                numberModel.startNumber = sku.priceRange.startQuantity;
            }
        }
        if ([lowestMoney isEqual:highestMoney]) {
            numberModel.showPrice = lowestMoney.thousandSeparatorAmount;
        } else {
            numberModel.showPrice = [lowestMoney.thousandSeparatorAmount stringByAppendingFormat:@" - %@", highestMoney.thousandSeparatorAmount];
        }

        self.headerView.list = @[numberModel];
    }
}
#pragma mark -准备列表规格数据
- (void)prepareData {
    if (HDIsArrayEmpty(self.specModel.skus)) {
        return;
    }
    [self.specsDataSource removeAllObjects];
    [self.skusDataSource removeAllObjects];
    if (!HDIsArrayEmpty(self.specModel.specs)) {
        for (NSInteger i = 0; i < self.specModel.specs.count; i++) {
            TNProductSpecificationModel *model = self.specModel.specs[i];
            if (i == self.specModel.specs.count - 1) {
                if (!HDIsArrayEmpty(model.specValues)) {
                    for (TNProductSpecPropertieModel *proModel in model.specValues) {
                        TNEditSpecCellModel *cellModel = [[TNEditSpecCellModel alloc] init];
                        cellModel.name = proModel.propValue;
                        cellModel.skuModel = [self getTargetSkuWithLastPropertieModel:proModel];
                        cellModel.batchPriceInfoModel = self.specModel.batchPriceInfo;
                        [self.skusDataSource addObject:cellModel];
                    }
                }
            } else {
                if (!HDIsArrayEmpty(model.specValues)) {
                    TNProductSpecPropertieModel *firstModel = model.specValues.firstObject;
                    firstModel.isUserSelected = YES;
                    HDTableViewSectionModel *sectionModel = [[HDTableViewSectionModel alloc] init];
                    sectionModel.list = model.specValues;
                    sectionModel.commonHeaderModel = @"TNProductSpecPropertieModel"; //标记
                    [self.specsDataSource addObject:sectionModel];
                }
            }
        }
    } else {
        TNEditSpecCellModel *cellModel = [[TNEditSpecCellModel alloc] init];
        if (!HDIsArrayEmpty(self.specModel.skus)) {
            cellModel.skuModel = self.specModel.skus.firstObject;
        }
        cellModel.name = TNLocalizedString(@"tn_page_default_title", @"默认");
        cellModel.batchPriceInfoModel = self.specModel.batchPriceInfo;
        [self.skusDataSource addObject:cellModel];
    }
    //计算tableView 高度
    self.tableViewHeight = 0;
    self.tableViewHeight += self.skusDataSource.count * kRealWidth(100);

    CGFloat maxHeight = kScreenHeight * 0.55;
    if (!HDIsArrayEmpty(self.specsDataSource)) {
        if (self.specsDataSource.count > 4 && self.skusDataSource.count > 3) {
            maxHeight = kScreenHeight * 0.30;
        } else if (self.specsDataSource.count > 3 && self.skusDataSource.count > 3) {
            maxHeight = kScreenHeight * 0.35;
        } else {
            maxHeight = kScreenHeight * 0.4;
        }
    }

    if (self.tableViewHeight > maxHeight) {
        self.tableViewHeight = maxHeight;
    }
}
#pragma mark - 通过最后一个规格拿到对应的sku模型
- (TNProductSkuModel *)getTargetSkuWithLastPropertieModel:(TNProductSpecPropertieModel *)proModel {
    TNProductSkuModel *model = nil;
    NSMutableArray *specKeyArr = [NSMutableArray array];
    if (!HDIsArrayEmpty(self.specsDataSource)) {
        for (HDTableViewSectionModel *sectionModel in self.specsDataSource) {
            for (id temp in sectionModel.list) {
                if ([temp isKindOfClass:TNProductSpecPropertieModel.class]) {
                    TNProductSpecPropertieModel *model = temp;
                    if (model.isUserSelected == YES) {
                        [specKeyArr addObject:model.propId];
                        break;
                    }
                }
            }
        }
        // 拼接最后一个规格
        [specKeyArr addObject:proModel.propId];
    } else {
        [specKeyArr addObject:proModel.propId];
    }
    NSString *specKey = [specKeyArr componentsJoinedByString:@","];
    for (TNProductSkuModel *skuModel in self.specModel.skus) {
        if ([skuModel.specValueKey isEqualToString:specKey]) {
            model = skuModel;
            break;
        }
    }
    return model;
}
#pragma mark -重新刷新组合数据
- (void)reloadSpecsData {
    TNProductSpecificationModel *model = self.specModel.specs.lastObject;
    [self.skusDataSource removeAllObjects];
    for (TNProductSpecPropertieModel *proModel in model.specValues) {
        TNEditSpecCellModel *cellModel = [[TNEditSpecCellModel alloc] init];
        cellModel.name = proModel.propValue;
        cellModel.skuModel = [self getTargetSkuWithLastPropertieModel:proModel];
        cellModel.batchPriceInfoModel = self.specModel.batchPriceInfo;
        [self.skusDataSource addObject:cellModel];
    }

    [self.tableView successGetNewDataWithNoMoreData:YES];
}
#pragma mark -计算已选数量 价格统计
- (void)calculateSelectedSkuCountAndPrice {
    //展示 选中数量 只展示第一个规格的
    if (!HDIsArrayEmpty(self.specsDataSource)) {
        HDTableViewSectionModel *firstSectionModel = self.specsDataSource.firstObject;
        //每次只计算已选中的  因为未选中的不会变更数量
        __block NSInteger selectedCount = 0;
        [firstSectionModel.list enumerateObjectsUsingBlock:^(TNProductSpecPropertieModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (obj.isUserSelected) {
                [self.specModel.skus enumerateObjectsUsingBlock:^(TNProductSkuModel *_Nonnull skuObj, NSUInteger idx, BOOL *_Nonnull stop) {
                    if ([skuObj.specValueKeyArray containsObject:obj.propId]) {
                        selectedCount += skuObj.editCount;
                    }
                }];
                obj.selectedSkuCount = selectedCount;
                *stop = YES;
            }
        }];
        TNHorizontalSpecsView *firstView = self.specsViewArray.firstObject;
        firstView.specValues = firstSectionModel.list;
    }
    // 选中数量
    __block NSInteger totalCount = 0;
    // 计算总金额
    __block NSDecimalNumber *totolPrice = NSDecimalNumber.zero;
    NSString *unit = self.specModel.batchPriceInfo.unit;
    if (self.specModel.batchPriceInfo.quoteType == TNProductQuoteTypeNoSpecByNumber || self.specModel.batchPriceInfo.quoteType == TNProductQuoteTypeHasSpecByNumber) {
        if (self.specModel.batchPriceInfo.mixWholeSale) {
            //混批
            // 按阶梯价报价
            for (TNProductSkuModel *skuModel in self.specModel.skus) {
                totalCount += skuModel.editCount;
            }

            if (!HDIsArrayEmpty(self.headerView.list)) {
                //查询命中价格
                __block TNWholesalePriceAndBatchNumberModel *targetModel;
                [self.headerView.list enumerateObjectsUsingBlock:^(TNWholesalePriceAndBatchNumberModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    if ([obj checkInsideRangeNumber:totalCount]) {
                        targetModel = obj;
                        *stop = YES;
                    }
                }];

                if (HDIsObjectNil(targetModel)) {
                    targetModel = self.headerView.list.firstObject; //没命中就取第一个
                    // 情况选中
                    [self.headerView reset];
                } else {
                    //选中样式
                    [self.headerView bingoBatchNumberModel:targetModel];
                }

                for (TNProductSkuModel *skuModel in self.specModel.skus) {
                    NSDecimalNumber *price = NSDecimalNumber.zero;
                    NSString *centFace = targetModel.price.centFace;
                    if (skuModel.editCount > 0) {
                        price = [TNDecimalTool stringDecimalMultiplyingBy:centFace num2:[NSString stringWithFormat:@"%ld", skuModel.editCount]];
                        totolPrice = [TNDecimalTool decimalAddingBy:totolPrice num2:price];
                    }
                    //赋值金额
                    skuModel.tempSalesPrice = targetModel.price;
                }
            }
        } else {
            //非混批
            if (!HDIsArrayEmpty(self.headerView.list)) {
                [self.specModel.skus enumerateObjectsUsingBlock:^(TNProductSkuModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    totalCount += obj.editCount;
                    __block TNWholesalePriceAndBatchNumberModel *targetModel = self.headerView.list.firstObject;
                    [self.headerView.list enumerateObjectsUsingBlock:^(TNWholesalePriceAndBatchNumberModel *_Nonnull batchObj, NSUInteger idx, BOOL *_Nonnull stop) {
                        if ([batchObj checkInsideRangeNumber:obj.editCount]) {
                            targetModel = batchObj;
                            *stop = YES;
                        }
                    }];
                    //赋值金额
                    obj.tempSalesPrice = targetModel.price;
                    NSDecimalNumber *price = NSDecimalNumber.zero;
                    NSString *centFace = targetModel.price.centFace;
                    if (obj.editCount > 0) {
                        price = [TNDecimalTool stringDecimalMultiplyingBy:centFace num2:[NSString stringWithFormat:@"%ld", obj.editCount]];
                        totolPrice = [TNDecimalTool decimalAddingBy:totolPrice num2:price];
                    }
                }];
            }
        }

        self.totalQuantityLabel.text = [NSString stringWithFormat:@"%@%ld%@", TNLocalizedString(@"6v0MnD2N", @"已选"), totalCount, unit];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%@%0.2f", TNLocalizedString(@"tn_page_totalcount_text", @"合计:"), [totolPrice stringValue].floatValue];
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];

    } else {
        //按规格 报价
        for (TNProductSkuModel *skuModel in self.specModel.skus) {
            totalCount += skuModel.editCount;
            NSDecimalNumber *price = NSDecimalNumber.zero;
            NSString *centFace
                = self.specModel.batchPriceInfo.detailViewType == TNProductDetailViewTypeSupplyAndMarketing ? skuModel.priceRange.tradePrice.centFace : skuModel.priceRange.price.centFace;
            if (skuModel.editCount > 0) {
                price = [TNDecimalTool stringDecimalMultiplyingBy:centFace num2:[NSString stringWithFormat:@"%ld", skuModel.editCount]];
            }
            totolPrice = [TNDecimalTool decimalAddingBy:totolPrice num2:price];

            //赋值金额
            skuModel.tempSalesPrice = self.specModel.batchPriceInfo.detailViewType == TNProductDetailViewTypeSupplyAndMarketing ? skuModel.priceRange.tradePrice : skuModel.priceRange.price;
        }
        self.totalQuantityLabel.text = [NSString stringWithFormat:@"%@%ld%@", TNLocalizedString(@"6v0MnD2N", @"已选"), totalCount, unit];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%@%0.2f", TNLocalizedString(@"tn_page_totalcount_text", @"合计:"), [totolPrice stringValue].floatValue];
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    }
}
#pragma mark -获取选中规格组合描述
- (NSString *)getPropertiesWithSpecificationValues:(NSArray *)specificationValues {
    NSMutableArray *arr = [NSMutableArray array];
    for (TNProductSpecPropertieModel *model in specificationValues) {
        [arr addObject:model.propValue];
    }
    return [arr componentsJoinedByString:@","];
}
#pragma mark -监听键盘
- (void)keyboardWillShow:(NSNotification *)noti {
    CGRect keyboardRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat maxHeight = keyboardRect.size.height + self.headerView.height + kRealWidth(100);
    CGFloat maxY = kScreenHeight - maxHeight;
    if (self.frame.origin.y > maxY) {
        self.transform = CGAffineTransformTranslate(self.transform, 0, -(self.frame.origin.y - maxY));
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height - kRealWidth(80), 0);
    }
}
- (void)keyboardWillHide:(NSNotification *)noti {
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.transform = CGAffineTransformIdentity;
}
#pragma mark - 点击事件
- (void)onClickConfirm {
    if (self.buyType == TNProductBuyTypeBuyNow && ![self checkCanBuy]) {
        return;
    }
    TNItemModel *item = TNItemModel.new;
    item.storeNo = self.specModel.storeNo;
    item.goodsId = self.specModel.productId;
    item.goodName = self.specModel.productName;
    item.sp = self.specModel.sp;
    NSMutableArray *skuList = [NSMutableArray array];
    for (TNProductSkuModel *skuModel in self.specModel.skus) {
        if (skuModel.editCount > 0) {
            TNItemSkuModel *model = [[TNItemSkuModel alloc] init];
            model.goodsSkuId = skuModel.skuId;
            model.addDelta = @(skuModel.editCount);
            model.properties = [self getPropertiesWithSpecificationValues:skuModel.specificationValues];
            model.thumbnail = skuModel.thumbnail;
            model.weight = skuModel.weight;
            model.salePrice = skuModel.tempSalesPrice;
            [skuList addObject:model];
        }
    }
    item.skuList = skuList;
    item.salesType = TNSalesTypeBatch;
    if (!HDIsArrayEmpty(skuList)) {
        !self.buyNowOraddToCartCallBack ?: self.buyNowOraddToCartCallBack(item);
    } else {
        [HDTips showInfo:TNLocalizedString(@"NATLXIbk", @"请输入购买商品数量") inView:self];
    }
}
/// 检验是否可以购买
- (BOOL)checkCanBuy {
    __block BOOL canBuy = YES;
    if (HDIsArrayEmpty(self.headerView.list)) {
        return NO;
    }
    // 选中sku数据
    TNWholesalePriceAndBatchNumberModel *firstModel = self.headerView.list.firstObject;
    if (self.specModel.batchPriceInfo.mixWholeSale) {
        //支持混批 查看总数
        __block NSInteger totalCount = 0;
        [self.specModel.skus enumerateObjectsUsingBlock:^(TNProductSkuModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            totalCount += obj.editCount;
        }];
        if (totalCount < firstModel.startNumber) {
            canBuy = NO;
            [HDTips showInfo:[NSString stringWithFormat:TNLocalizedString(@"ju2TZTyz", @"商品总数起批量为%ld件"), firstModel.startNumber] inView:self];
        } else if (totalCount >= firstModel.startNumber && self.specModel.batchPriceInfo.batchNumber > 0) {
            [self.specModel.skus enumerateObjectsUsingBlock:^(TNProductSkuModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if (obj.editCount > 0 && self.specModel.batchPriceInfo.batchNumber > 0 && obj.editCount % self.specModel.batchPriceInfo.batchNumber != 0) {
                    canBuy = NO;
                    [HDTips showInfo:[NSString stringWithFormat:TNLocalizedString(@"mk3QbbX9", @"数量是%ld的倍数"), self.specModel.batchPriceInfo.batchNumber] inView:self];
                    *stop = YES;
                }
            }];
        }
    } else {
        //不支持混批的话  每一个sku选中的  都要大于最低起批
        [self.specModel.skus enumerateObjectsUsingBlock:^(TNProductSkuModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (obj.editCount > 0 && obj.editCount < firstModel.startNumber) {
                canBuy = NO;
                [HDTips showInfo:[NSString stringWithFormat:TNLocalizedString(@"zXpfvxcb", @"最小起批量为%ld件"), firstModel.startNumber] inView:self];
                *stop = YES;
            } else if (obj.editCount > 0 && self.specModel.batchPriceInfo.batchNumber > 0 && obj.editCount % self.specModel.batchPriceInfo.batchNumber != 0) {
                canBuy = NO;
                [HDTips showInfo:[NSString stringWithFormat:TNLocalizedString(@"mk3QbbX9", @"数量是%ld的倍数"), self.specModel.batchPriceInfo.batchNumber] inView:self];
                *stop = YES;
            }
        }];
    }
    return canBuy;
}

- (void)updateConstraints {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(kRealWidth(50));
    }];
    if (!self.specStackView.isHidden) {
        [self.specStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.headerView.mas_bottom);
        }];
    }
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (!self.specStackView.isHidden) {
            make.top.equalTo(self.specStackView.mas_bottom);
        } else {
            make.top.equalTo(self.headerView.mas_bottom);
        }
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.tableViewHeight);
    }];
    [self.totalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.mas_offset(kRealWidth(50));
    }];
    [self.totalQuantityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalView);
        make.centerY.equalTo(self.totalView);
    }];
    [self.totalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.totalView);
        make.centerY.equalTo(self.totalView);
    }];
    [self.confirBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalView.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_offset(kRealWidth(45));
    }];
    [super updateConstraints];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.skusDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNEditSpecCell *cell = [TNEditSpecCell cellWithTableView:tableView];
    cell.cellModel = self.skusDataSource[indexPath.row];
    @HDWeakify(self);
    cell.enterCountCallBack = ^(TNEditSpecCellModel *_Nonnull cellModel) {
        @HDStrongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self calculateSelectedSkuCountAndPrice];
        });
    };
    return cell;
}
/** @lazy tableview */
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGFLOAT_MIN) style:UITableViewStyleGrouped];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 90;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}
- (SAOperationButton *)confirBtn {
    if (!_confirBtn) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        button.cornerRadius = 0;
        button.titleEdgeInsets = UIEdgeInsetsMake(10, 30, 10, 30);
        button.titleLabel.font = HDAppTheme.TinhNowFont.standard17B;
        [button addTarget:self action:@selector(onClickConfirm) forControlEvents:UIControlEventTouchUpInside];
        [button applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        _confirBtn = button;
    }
    return _confirBtn;
}
/** @lazy headerView */
- (TNWholesaleHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[TNWholesaleHeaderView alloc] init];
    }
    return _headerView;
}
/** @lazy totalView */
- (UIView *)totalView {
    if (!_totalView) {
        _totalView = [[UIView alloc] init];
        _totalView.hd_borderPosition = HDViewBorderPositionTop;
        _totalView.hd_borderColor = HexColor(0xD6DBE8);
        _totalView.hd_borderWidth = 0.5;
        _totalView.hd_borderLocation = HDViewBorderLocationInside;
    }
    return _totalView;
}
/** @lazy totalQuantityLabel */
- (UILabel *)totalQuantityLabel {
    if (!_totalQuantityLabel) {
        _totalQuantityLabel = [[UILabel alloc] init];
        _totalQuantityLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _totalQuantityLabel.font = HDAppTheme.TinhNowFont.standard12;
        _totalQuantityLabel.text = [NSString stringWithFormat:@"%@%d%@", TNLocalizedString(@"6v0MnD2N", @"已选"), 0, self.specModel.batchPriceInfo.unit];
    }
    return _totalQuantityLabel;
}

/** @lazy totalPriceLabel */
- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.textColor = HDAppTheme.TinhNowColor.cFF2323;
        _totalPriceLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        _totalPriceLabel.text = [NSString stringWithFormat:@"%@ %.2f", TNLocalizedString(@"tn_page_totalcount_text", @"合计:"), 0.00];
    }
    return _totalPriceLabel;
}
/** @lazy specStackView */
- (UIStackView *)specStackView {
    if (!_specStackView) {
        _specStackView = [[UIStackView alloc] init];
        _specStackView.axis = UILayoutConstraintAxisVertical;
        _specStackView.spacing = 0;
    }
    return _specStackView;
}
/** @lazy specsViewArray */
- (NSMutableArray<TNHorizontalSpecsView *> *)specsViewArray {
    if (!_specsViewArray) {
        _specsViewArray = [NSMutableArray array];
    }
    return _specsViewArray;
}
/** @lazy skusDataSource */
- (NSMutableArray<TNEditSpecCellModel *> *)skusDataSource {
    if (!_skusDataSource) {
        _skusDataSource = [NSMutableArray array];
    }
    return _skusDataSource;
}
/** @lazy specsDataSource */
- (NSMutableArray<HDTableViewSectionModel *> *)specsDataSource {
    if (!_specsDataSource) {
        _specsDataSource = [NSMutableArray array];
    }
    return _specsDataSource;
}
@end
