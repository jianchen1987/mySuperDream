//
//  WMNewSpecialActivesProductView.m
//  SuperApp
//
//  Created by Tia on 2023/7/31.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewSpecialActivesProductView.h"
#import "WMZPageView.h"
#import "WMSpecialActivesViewModel.h"
#import "WMSpecialPromotionRspModel.h"
#import "WMNewSpecialActivesProductSubView.h"
#import "WMNewSpecialActivesProductCategoryView.h"


@interface WMNewSpecialActivesProductView ()
/// viewModel
@property (nonatomic, strong) WMSpecialActivesViewModel *viewModel;
///指示视图
@property (strong, nonatomic) WMZPageView *pageView;
/// 分类列表
@property (nonatomic, strong) NSArray<WMSpecialPromotionCategoryModel *> *categoryList;
/// pageNo
@property (nonatomic, assign) NSUInteger pageNo;

@property (nonatomic, weak) WMNewSpecialActivesProductCategoryView *categoryView;

@property (nonatomic, strong) WMSpecialPromotionCategoryModel *selectedCategoryModel;

@end


@implementation WMNewSpecialActivesProductView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"productList" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.pageNo = 1;
        WMSpecialPromotionCategoryModel *m = WMSpecialPromotionCategoryModel.new;
        m.categoryNo = nil;
        m.name = @"All";
        m.nameZh = @"全部";
        m.nameKm = @"ទាំងអស់";

        NSMutableArray *categoryList = @[m].mutableCopy;
        //不展示分类的情况，不用网络数据了
        if (self.viewModel.showCategoryBar) {
            [categoryList addObjectsFromArray:self.viewModel.categoryList];
        }
        self.categoryList = categoryList;
        NSMutableArray *titleArr = @[].mutableCopy;
        for (WMSpecialPromotionCategoryModel *m in self.categoryList) {
            if (SAMultiLanguageManager.isCurrentLanguageCN) {
                [titleArr addObject:m.nameZh];
            } else if (SAMultiLanguageManager.isCurrentLanguageKH) {
                [titleArr addObject:m.nameKm];
            } else {
                [titleArr addObject:m.name];
            }
        }
        if (self.viewModel.showCategoryBar) {
            self.pageView.param.wMenuHeight = 40;
        } else {
            self.pageView.param.wMenuHeight = 0.01;
        }
        self.pageView.param.wMenuDefaultIndex = 0;
        self.pageView.param.wTitleArr = titleArr;


        if (HDIsStringNotEmpty(self.viewModel.backgroundImageUrl)) {
            self.pageView.param.wMenuHeadViewSet(^UIView * {
                UIImageView *back = [UIImageView new];
                back.frame = CGRectMake(0, 0, PageVCWidth, PageVCWidth / 375.0 * 170);
                [back sd_setImageWithURL:[NSURL URLWithString:self.viewModel.backgroundImageUrl] placeholderImage:HDHelper.placeholderImage];
                return back;
            });
        }

        [self.pageView updateMenuData];
        [self addSubview:self.pageView];
        self.pageView.frame = self.bounds;
        //        [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.proModel.products.hasNextPage];
        //        [self updateMJFoot:!self.viewModel.proModel.products.hasNextPage];
    }];
}

//- (void)hd_setupViews {
//    self.backgroundColor = UIColor.orangeColor;
//}

- (WMZPageView *)pageView {
    if (!_pageView) {
        @HDWeakify(self);
        WMZPageParam *param = WMZPageParam.new;
        param.wLazyLoading = YES;
        param.wMenuIndicatorWidth = 20;
        param.wMenuIndicatorHeight = 3;
        param.wMenuIndicatorRadio = 2;
        param.wMenuIndicatorY = 0;
        //右边固定标题宽度
        param.wMenuFixWidth = 36;
        //右边固定标题开启阴影
        param.wMenuFixShadow = YES;
        //最右边固定内容
        param.wMenuFixRightData = @{WMZPageKeyImage: @"icon_special_actives_category"};
        //右边固定标题点击
        param.wEventFixedClick = ^void(id anyID, NSInteger index) {
            //            HDLog(@"固定标题点击%ld",index);
            @HDStrongify(self);
            WMNewSpecialActivesProductCategoryView *view = [[WMNewSpecialActivesProductCategoryView alloc] initWithStartOffsetY:kNavigationBarH];
            view.categoryList = self.categoryList;


            [view showInView:self.viewController.view];
            @HDWeakify(self);
            view.dismissBlock = ^{
                @HDStrongify(self);
                self.categoryView = nil;
            };

            view.selectedBlock = ^(WMSpecialPromotionCategoryModel *_Nonnull m) {
                //                HDLog(@"%@--%@",m.categoryNo,m.name);
                @HDStrongify(self);
                self.selectedCategoryModel = m;
                if (!m.categoryNo) {
                    [self.pageView selectMenuWithIndex:0];
                    return;
                }
                for (NSInteger i = 0; i < self.categoryList.count; i++) {
                    WMSpecialPromotionCategoryModel *m1 = self.categoryList[i];

                    if ([m1.categoryNo isEqualToString:m.categoryNo]) {
                        [self.pageView selectMenuWithIndex:i];
                        break;
                    }
                }
            };
            self.categoryView = view;
            [self.pageView downScrollViewSetOffset:CGPointZero animated:NO];
        };

        param.wMenuTitleUIFontSet([HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightRegular]);
        param.wMenuTitleSelectUIFontSet([HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightBold]);
        param.wMenuTitleColorSet(HDAppTheme.WMColor.B6);
        param.wMenuTitleSelectColorSet(HDAppTheme.color.sa_C1);
        param.wTopSuspensionSet(YES);
        param.wEventClick = ^(id _Nullable anyID, NSInteger index) {
            @HDStrongify(self);
            self.selectedCategoryModel.isSelected = NO;
            self.selectedCategoryModel = self.categoryList[index];
            self.selectedCategoryModel.isSelected = YES;
        };
        param.wEventEndTransferControllerSet(^(UIViewController *oldVC, UIViewController *newVC, NSInteger oldIndex, NSInteger newIndex) {
            self.selectedCategoryModel.isSelected = NO;
            self.selectedCategoryModel = self.categoryList[newIndex];
            self.selectedCategoryModel.isSelected = YES;
        });
        param.wViewController = ^UIViewController *_Nullable(NSInteger index) {
            @HDStrongify(self);
            WMNewSpecialActivesProductSubView *listView = nil;
            if (self.categoryList.count > index) {
                listView = [[WMNewSpecialActivesProductSubView alloc] initWithViewModel:self.viewModel categoryNo:[self.categoryList[index] categoryNo]];
            } else {
                listView = [[WMNewSpecialActivesProductSubView alloc] initWithViewModel:self.viewModel categoryNo:nil];
            }
            return (id)listView;
        };
        _pageView = [[WMZPageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kiPhoneXSeriesSafeBottomHeight - kNavigationBarH) autoFix:NO param:param
                                        parentReponder:self.viewController];
    }
    return _pageView;
}

@end
