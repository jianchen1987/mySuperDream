//
//  TNSpecialProductTagReusableView.m
//  SuperApp
//
//  Created by 张杰 on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSpecialProductTagReusableView.h"
#import "TNSpecialProductTagView.h"


@interface TNSpecialProductTagReusableView ()
///
@property (strong, nonatomic) TNSpecialProductTagView *tagView;
@end


@implementation TNSpecialProductTagReusableView

- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.tagView];
}
- (void)setContentWidth:(CGFloat)contentWidth {
    _contentWidth = contentWidth;
    self.tagView.contentWidth = contentWidth;
}
- (void)setTagArr:(NSArray<TNGoodsTagModel *> *)tagArr {
    _tagArr = tagArr;
    self.tagView.itemArray = tagArr;
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
/** @lazy tagView */
- (TNSpecialProductTagView *)tagView {
    if (!_tagView) {
        _tagView = [[TNSpecialProductTagView alloc] init];
        @HDWeakify(self);
        _tagView.tagClickCallBack = ^(TNGoodsTagModel *_Nonnull model) {
            @HDStrongify(self);
            !self.tagClickCallBack ?: self.tagClickCallBack(model);
        };
        _tagView.dropSpecialProductTagClickCallBack = ^{
            @HDStrongify(self);
            !self.dropSpecialProductTagClickCallBack ?: self.dropSpecialProductTagClickCallBack();
        };
    }
    return _tagView;
}
@end
