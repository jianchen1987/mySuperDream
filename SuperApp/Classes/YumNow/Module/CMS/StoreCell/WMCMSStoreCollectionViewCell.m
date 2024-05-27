//
//  WMCMSStoreCNCollectionViewCell.m
//  SuperApp
//
//  Created by Tia on 2023/12/1.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCMSStoreCollectionViewCell.h"
#import "WMStoreView.h"
#import "WMCNStoreView.h"

@interface WMCMSStoreCollectionViewCell ()
/// 小图内容
@property (nonatomic, strong) WMCNStoreView *smallContainView;
/// 大图内容
@property (nonatomic, strong) WMStoreView *bigContainView;

@end

@implementation WMCMSStoreCollectionViewCell

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.WMColor.bg3;
    [self.contentView addSubview:self.smallContainView];
    [self.contentView addSubview:self.bigContainView];
}

- (void)updateConstraints {
    if(!self.smallContainView.hidden) {
        [self.smallContainView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    if(!self.bigContainView.hidden) {
        [self.bigContainView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    [super updateConstraints];
}

#pragma mark - setter
- (void)setStoreModel:(WMNewStoreModel *)storeModel {
    _storeModel = storeModel;
    _smallContainView.hidden = YES;
    _bigContainView.hidden = YES;
    if([storeModel.storeLogoShowType isEqualToString:YumNowLandingPageStoreCardStyleSmall]){
        _smallContainView.hidden = NO;
        _smallContainView.model = storeModel;
    }else{
        _bigContainView.hidden = NO;
        _bigContainView.model = storeModel;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (WMCNStoreView *)smallContainView {
    if(!_smallContainView) {
        _smallContainView = WMCNStoreView.new;
        _smallContainView.hidden = YES;
    }
    return _smallContainView;
}

- (WMStoreView *)bigContainView {
    if(!_bigContainView) {
        _bigContainView = WMStoreView.new;
        _bigContainView.hidden = YES;
    }
    return _bigContainView;
}

@end
