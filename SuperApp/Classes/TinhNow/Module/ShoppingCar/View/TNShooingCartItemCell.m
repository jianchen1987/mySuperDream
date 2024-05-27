//
//  TNShooingCartItemCell.m
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNShooingCartItemCell.h"


@interface TNShooingCartItemCell ()
@end


@implementation TNShooingCartItemCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.productView];
    [self.productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];
}
- (void)updateConstraints {
    [super updateConstraints];
}
- (void)setModel:(TNShoppingCarItemModel *)model {
    _model = model;
    self.productView.model = model;
    //    [self setNeedsUpdateConstraints];
}
- (TNShoppingCartProductView *)productView {
    if (!_productView) {
        _productView = [[TNShoppingCartProductView alloc] init];
    }
    return _productView;
}
@end
