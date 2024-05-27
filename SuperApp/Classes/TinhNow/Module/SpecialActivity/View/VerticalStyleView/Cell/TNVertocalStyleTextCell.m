//
//  TNVertocalStyleTextCellCollectionViewCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/4/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNVertocalStyleTextCell.h"
#import "TNHomeSectionHeaderView.h"


@interface TNVertocalStyleTextCell ()
///
@property (strong, nonatomic) TNHomeSectionHeaderView *sectionView;
@end


@implementation TNVertocalStyleTextCell
- (void)setModel:(TNVertocalStyleTextCellModel *)model {
    _model = model;
    self.sectionView.title = model.title;
}
- (void)hd_setupViews {
    [self.contentView addSubview:self.sectionView];
}
- (void)updateConstraints {
    [self.sectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}
/** @lazy sectionView */
- (TNHomeSectionHeaderView *)sectionView {
    if (!_sectionView) {
        _sectionView = [[TNHomeSectionHeaderView alloc] init];
    }
    return _sectionView;
}
@end


@implementation TNVertocalStyleTextCellModel

@end
