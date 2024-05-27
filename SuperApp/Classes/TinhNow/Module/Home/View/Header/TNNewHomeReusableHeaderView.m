//
//  TNNewHomeReusableHeaderView.m
//  SuperApp
//
//  Created by 张杰 on 2021/2/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNNewHomeReusableHeaderView.h"
#import "TNHomeSectionHeaderView.h"


@interface TNNewHomeReusableHeaderView ()
@property (strong, nonatomic) TNHomeSectionHeaderView *headerView;
@end


@implementation TNNewHomeReusableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self hd_setupViews];
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.headerView];
    self.backgroundColor = HDAppTheme.TinhNowColor.G5;
}

- (void)updateConstraints {
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(kRealWidth(60));
    }];
    [super updateConstraints];
}

- (void)setSectionTitle:(NSString *)sectionTitle {
    _sectionTitle = sectionTitle;
    _headerView.title = self.sectionTitle;
    [self setNeedsUpdateConstraints];
}

- (TNHomeSectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[TNHomeSectionHeaderView alloc] init];
    }
    return _headerView;
}

@end
