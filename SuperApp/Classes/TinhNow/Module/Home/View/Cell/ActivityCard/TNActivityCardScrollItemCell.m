//
//  TNActivityCardScrollItemCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityCardScrollItemCell.h"
#import "TNActivityCardItemView.h"


@interface TNActivityCardScrollItemCell ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollViewContainer;
@end


@implementation TNActivityCardScrollItemCell
- (void)hd_setupViews {
    [super hd_setupViews];
    [self.baseView addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
}
- (void)setCardModel:(TNActivityCardModel *)cardModel {
    [super setCardModel:cardModel];
    [self configSubView];
}
- (void)configSubView {
    [self.scrollViewContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (HDIsArrayEmpty(self.cardModel.bannerList)) {
        return;
    }
    UIView *lastView = nil;
    for (int i = 0; i < self.cardModel.bannerList.count; i++) {
        TNActivityCardBannerItem *item = self.cardModel.bannerList[i];
        item.cardType = @"滑动";
        item.index = i;
        if (self.cardModel.scene == TNActivityCardSceneTopic) { //专题不显示文本
            item.title = @"";
        }
        TNActivityCardItemView *itemView = [[TNActivityCardItemView alloc] init];
        itemView.imageViewHeight = self.cardModel.imageViewHeight;
        itemView.imageViewWidth = kRealWidth(150);
        itemView.scene = self.cardModel.scene;
        itemView.item = item;
        [self.scrollViewContainer addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView == nil) {
                make.left.equalTo(self.scrollViewContainer);
            } else {
                make.left.equalTo(lastView.mas_right).offset(self.cardModel.isSpecialStyleVertical ? kRealWidth(5) : kRealWidth(10));
            }
            make.top.bottom.equalTo(self.scrollViewContainer);
            if (i == self.cardModel.bannerList.count - 1) {
                make.right.equalTo(self.scrollViewContainer);
            }
            make.width.mas_equalTo(kRealWidth(150));
        }];
        lastView = itemView;
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [super updateConstraints];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.baseView.mas_left).offset(self.cardModel.isSpecialStyleVertical ? 0 : kRealWidth(10));
        make.right.equalTo(self.baseView.mas_right).offset(self.cardModel.isSpecialStyleVertical ? 0 : -kRealWidth(10));
        make.height.mas_equalTo(self.cardModel.cellHeight - self.cardModel.headerHeight);
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
        _scrollView.showsHorizontalScrollIndicator = false;
        //        _scrollView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 13.0, *)) {
            _scrollView.automaticallyAdjustsScrollIndicatorInsets = false;
        }
    }
    return _scrollView;
}

- (UIView *)scrollViewContainer {
    if (!_scrollViewContainer) {
        _scrollViewContainer = UIView.new;
    }
    return _scrollViewContainer;
}
@end
