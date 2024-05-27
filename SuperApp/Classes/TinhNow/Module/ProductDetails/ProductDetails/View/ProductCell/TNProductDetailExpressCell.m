//
//  TNProductDetailExpressCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//
#import "TNProductDetailExpressCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNProductOverseaExpressView.h"


@interface TNProductDetailExpressCell ()
/// 背景视图
@property (strong, nonatomic) TNProductOverseaExpressView *overseaExpressView;
/// 底部分割线
//@property (strong, nonatomic) UIView *bottomLineView;
@end


@implementation TNProductDetailExpressCell

- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    newFrame.origin.x = kRealWidth(8);
    newFrame.size.width = kScreenWidth - kRealWidth(16);
    [super setFrame:newFrame];
}

- (void)hd_setupViews {
    [self.contentView addSubview:self.overseaExpressView];
    //    [self.contentView addSubview:self.bottomLineView];
}
- (void)updateConstraints {
    [self.overseaExpressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(7));
        make.height.mas_equalTo(kRealWidth(60));
    }];

    //    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(self.contentView);
    //        make.top.equalTo(self.overseaExpressView.mas_bottom).offset(kRealWidth(7));
    //        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
    //        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    //        make.height.mas_equalTo(PixelOne);
    //    }];
    [super updateConstraints];
}
- (void)setModel:(TNDeliverFlowModel *)model {
    _model = model;
    self.overseaExpressView.model = model;
}
/** @lazy overseaExpressView */
- (TNProductOverseaExpressView *)overseaExpressView {
    if (!_overseaExpressView) {
        _overseaExpressView = [[TNProductOverseaExpressView alloc] init];
    }
    return _overseaExpressView;
}

///** @lazy bottomLineView */
//- (UIView *)bottomLineView {
//    if (!_bottomLineView) {
//        _bottomLineView = [[UIView alloc] init];
//        _bottomLineView.backgroundColor = HDAppTheme.color.G4;
//    }
//    return _bottomLineView;
//}
@end
