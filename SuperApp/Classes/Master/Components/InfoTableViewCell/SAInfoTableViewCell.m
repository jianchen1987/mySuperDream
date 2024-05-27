//
//  SAInfoTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInfoTableViewCell.h"
#import "SAInfoView.h"


@interface SAInfoTableViewCell ()
@property (nonatomic, strong) SAInfoView *infoView; ///< 信息
@end


@implementation SAInfoTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.infoView];
}

- (void)updateConstraints {
    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - getters and setters
- (void)setModel:(SAInfoViewModel *)model {
    _model = model;

    self.infoView.model = model;
    [self setNeedsUpdateConstraints];
}

#pragma mark - public methods
- (void)showRightButton:(BOOL)isShow {
    [self.infoView showRightButton:isShow];
}

#pragma mark - lazy load
- (SAInfoView *)infoView {
    return _infoView ?: ({ _infoView = SAInfoView.new; });
}
@end
