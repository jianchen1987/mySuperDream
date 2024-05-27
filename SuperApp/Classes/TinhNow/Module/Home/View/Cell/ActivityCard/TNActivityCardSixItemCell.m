//
//  TNActivityCardSixItemCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityCardSixItemCell.h"
#import "TNActivityCardItemView.h"
#define gridViewWidth (kScreenWidth - kRealWidth(20 * 3)) / 3


@interface TNActivityCardSixItemCell ()
//@property (nonatomic, strong) HDGridView *gridView;  ///< gridView
/// 容器
@property (strong, nonatomic) UIView *containView;
@end


@implementation TNActivityCardSixItemCell
- (void)hd_setupViews {
    [super hd_setupViews];
    [self.baseView addSubview:self.containView];
    //    [self.baseView addSubview:self.containView];
}
- (void)setCardModel:(TNActivityCardModel *)cardModel {
    [super setCardModel:cardModel];
    [self configSubView];
}
- (void)configSubView {
    [self.containView hd_removeAllSubviews];
    CGFloat HMargin = self.cardModel.isSpecialStyleVertical ? kRealWidth(5) : kRealWidth(10);
    CGFloat VMargin = self.cardModel.isSpecialStyleVertical ? kRealWidth(5) : kRealWidth(15);
    CGFloat width = self.cardModel.imageViewHeight;
    CGFloat firstLineViewHeight = width;
    CGFloat secondLineViewHeight = width;
    if (self.cardModel.bannerList.count > 3) {
        NSArray *firstLineArr = [self.cardModel.bannerList subarrayWithRange:NSMakeRange(0, 3)];
        BOOL hasText = [self.cardModel checkBannerListHasText:firstLineArr];
        if (hasText) {
            firstLineViewHeight += kRealWidth(30);
        }
        NSArray *lastArr = [self.cardModel.bannerList subarrayWithRange:NSMakeRange(3, self.cardModel.bannerList.count - 3)];
        BOOL secondHasText = [self.cardModel checkBannerListHasText:lastArr];
        if (secondHasText) {
            secondLineViewHeight += kRealWidth(30);
        }
    } else {
        BOOL hasText = [self.cardModel checkBannerListHasText:self.cardModel.bannerList];
        if (hasText) {
            firstLineViewHeight += kRealWidth(30);
        }
    }
    if (!HDIsArrayEmpty(self.cardModel.bannerList)) {
        for (int i = 0; i < self.cardModel.bannerList.count; i++) {
            TNActivityCardBannerItem *item = self.cardModel.bannerList[i];
            item.cardType = @"六宫格";
            item.index = i;
            if (self.cardModel.scene == TNActivityCardSceneTopic) { //专题不显示文本
                item.title = @"";
            }
            TNActivityCardItemView *itemView = [[TNActivityCardItemView alloc] init];
            itemView.imageViewHeight = self.cardModel.imageViewHeight;
            itemView.imageViewWidth = width;
            itemView.scene = self.cardModel.scene;
            itemView.item = item;
            CGFloat height = firstLineViewHeight;
            if (i >= 3) {
                height = secondLineViewHeight;
            }
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            CGFloat x = (width + HMargin) * col;
            CGFloat y = (firstLineViewHeight + VMargin) * row;
            itemView.frame = CGRectMake(x, y, width, height);
            [self.containView addSubview:itemView];
        }
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [super updateConstraints];
    [self.containView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView.mas_left).offset(self.cardModel.isSpecialStyleVertical ? 0 : kRealWidth(10));
        make.right.equalTo(self.baseView.mas_right).offset(self.cardModel.isSpecialStyleVertical ? 0 : -kRealWidth(10));
        make.top.equalTo(self.headerView.mas_bottom);
        make.bottom.equalTo(self.baseView);
    }];
}
#pragma mark - lazy load
//- (HDGridView *)gridView {
//    if (!_gridView) {
//        _gridView = HDGridView.new;
//        _gridView.columnCount = 3;
//        _gridView.subViewHMargin = kRealWidth(10);
//        _gridView.subViewVMargin = kRealWidth(15);
////        _gridView.rowHeight = gridViewWidth + kRealWidth(30);
//    }
//    return _gridView;
//}
- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] init];
    }
    return _containView;
}
@end
