//
//  TNActivityTextItemCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityCardTextCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNHomeSectionHeaderView.h"


@interface TNActivityCardTextCell ()
@property (strong, nonatomic) TNHomeSectionHeaderView *headerView;
@end


@implementation TNActivityCardTextCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.headerView];
    self.backgroundColor = [UIColor clearColor];
}
- (void)setCardModel:(TNActivityCardModel *)cardModel {
    _cardModel = cardModel;
    if (!HDIsArrayEmpty(cardModel.bannerList)) {
        TNActivityCardBannerItem *item = cardModel.bannerList.firstObject;
        self.headerView.title = item.title;
        [self setNeedsUpdateConstraints];
    }
}
- (void)updateConstraints {
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(kRealWidth(60));
    }];
    [super updateConstraints];
}
- (TNHomeSectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[TNHomeSectionHeaderView alloc] init];
    }
    return _headerView;
}
@end
