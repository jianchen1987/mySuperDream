//
//  TNProductBatchToggleCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductBatchToggleCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNProductBatchToggleView.h"


@interface TNProductBatchToggleCell ()
///
@property (strong, nonatomic) TNProductBatchToggleView *toggleView;
@end


@implementation TNProductBatchToggleCell
- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    newFrame.origin.x = kRealWidth(8);
    newFrame.size.width = kScreenWidth - kRealWidth(16);
    [super setFrame:newFrame];
}
- (void)hd_setupViews {
    [self.contentView addSubview:self.toggleView];
}
- (void)setModel:(TNProductBatchToggleCellModel *)model {
    _model = model;
    self.toggleView.model = model;
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.toggleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}
/** @lazy toggleView */
- (TNProductBatchToggleView *)toggleView {
    if (!_toggleView) {
        _toggleView = [[TNProductBatchToggleView alloc] init];
    }
    return _toggleView;
}
@end
