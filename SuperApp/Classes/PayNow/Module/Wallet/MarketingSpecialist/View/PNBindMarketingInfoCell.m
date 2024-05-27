//
//  PNBindMarketingInfoCell.m
//  SuperApp
//
//  Created by xixi_wen on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNBindMarketingInfoCell.h"
#import "PNBindMarketingItemView.h"
#import "PNMarketingListItemModel.h"


@interface PNBindMarketingInfoCell ()
@property (nonatomic, strong) PNBindMarketingItemView *itemView;
@end


@implementation PNBindMarketingInfoCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.itemView];
}

- (void)updateConstraints {
    [self.itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNMarketingListItemModel *)model {
    _model = model;
    self.itemView.model = self.model;
}


#pragma mark
- (PNBindMarketingItemView *)itemView {
    if (!_itemView) {
        _itemView = [[PNBindMarketingItemView alloc] initWithType:PNBindMarketingItemView_Content];
    }
    return _itemView;
}


@end
