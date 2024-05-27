//
//  TNStoreInfoCollectionViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/7/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNStoreInfoCollectionViewCell.h"
#import "TNStoreInfoRspModel.h"
#import "TNStoreInfoView.h"


@interface TNStoreInfoCollectionViewCell ()
/// storeInfo
@property (nonatomic, strong) TNStoreInfoView *storeInfoView;
@end


@implementation TNStoreInfoCollectionViewCell

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.storeInfoView];
}

- (void)updateConstraints {
    [self.storeInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

// 重写优先约束属性
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

- (void)setModel:(TNStoreInfoRspModel *)model {
    _model = model;
    self.storeInfoView.model = model;
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
/** @lazy storeInfoView */
- (TNStoreInfoView *)storeInfoView {
    if (!_storeInfoView) {
        _storeInfoView = [[TNStoreInfoView alloc] init];
        @HDWeakify(self);
        _storeInfoView.changeMenuCallBack = ^(BOOL showAllProduct) {
            @HDStrongify(self);
            if (self.changeMenuCallBack) {
                self.changeMenuCallBack(showAllProduct);
            }
        };
    }
    return _storeInfoView;
}

@end
