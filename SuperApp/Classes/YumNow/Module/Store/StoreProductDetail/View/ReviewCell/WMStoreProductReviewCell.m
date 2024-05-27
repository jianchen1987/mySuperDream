//
//  WMStoreProductReviewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductReviewCell.h"
#import "WMStoreProductReviewModel.h"
#import "WMStoreProductReviewView.h"


@interface WMStoreProductReviewCell ()
/// 评论 View
@property (nonatomic, strong) WMStoreProductReviewView *reviewView;
@end


@implementation WMStoreProductReviewCell
#pragma mark - SATableViewCellProtocol
- (void)hd_setupViews {
    [self.contentView addSubview:self.reviewView];

    @HDWeakify(self);
    self.reviewView.clickedUserReviewContentReadMoreOrReadLessBlock = ^{
        @HDStrongify(self);
        !self.clickedUserReviewContentReadMoreOrReadLessBlock ?: self.clickedUserReviewContentReadMoreOrReadLessBlock();
    };
    self.reviewView.clickedMerchantReplyReadMoreOrReadLessBlock = ^{
        @HDStrongify(self);
        !self.clickedMerchantReplyReadMoreOrReadLessBlock ?: self.clickedMerchantReplyReadMoreOrReadLessBlock();
    };

    self.reviewView.clickedProductItemBlock = ^(NSString *_Nonnull goodsId, NSString *_Nonnull storeNo) {
        @HDStrongify(self);
        !self.clickedProductItemBlock ?: self.clickedProductItemBlock(goodsId, storeNo);
    };
    
    self.reviewView.clickedStoreInfoBlock = ^(NSString * _Nonnull storeNo) {
        @HDStrongify(self);
        !self.clickedStoreInfoBlock ?: self.clickedStoreInfoBlock(storeNo);
    };
}

- (void)hd_bindViewModel {
}

#pragma mark - setter
- (void)setModel:(WMStoreProductReviewModel *)model {
    _model = model;

    self.reviewView.model = model;
}

#pragma mark - event response

#pragma mark - public methods

#pragma mark - private methods

#pragma mark - layout
- (void)updateConstraints {
    [self.reviewView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (WMStoreProductReviewView *)reviewView {
    return _reviewView ?: ({ _reviewView = WMStoreProductReviewView.new; });
}
@end
