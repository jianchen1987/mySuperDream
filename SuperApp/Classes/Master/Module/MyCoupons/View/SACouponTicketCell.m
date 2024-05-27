//
//  SACouponTicketCell.m
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACouponTicketCell.h"
#import "SACouponTicketContainView.h"


@interface SACouponTicketCell ()
/// 内容
@property (nonatomic, strong) SACouponTicketContainView *view;
@end


@implementation SACouponTicketCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;

    [self.contentView addSubview:self.view];

    @HDWeakify(self);
    self.view.clickedToUseBTNBlock = ^{
        @HDStrongify(self);
        !self.clickedToUseBTNBlock ?: self.clickedToUseBTNBlock();
    };
    self.view.clickedViewDetailBlock = ^{
        @HDStrongify(self);
        !self.clickedViewDetailBlock ?: self.clickedViewDetailBlock();
    };
}

- (void)updateConstraints {
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(SACouponTicketModel *)model {
    _model = model;
    self.view.model = model;
    [self setNeedsUpdateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - lazy load
- (SACouponTicketContainView *)view {
    return _view ?: ({ _view = SACouponTicketContainView.new; });
}

@end
