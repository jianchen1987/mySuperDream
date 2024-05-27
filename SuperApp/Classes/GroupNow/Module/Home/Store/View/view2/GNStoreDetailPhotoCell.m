//
//  GNStoreDetailPhotoCell.m
//  SuperApp
//
//  Created by wmz on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNStoreDetailPhotoCell.h"
#import "GNImageTableViewCell.h"
#import "WMHomeCollectionView.h"


@interface GNStoreDetailPhotoCell () <UICollectionViewDelegate, UICollectionViewDataSource>
/// 标签
@property (nonatomic, strong) WMHomeCollectionView *tagCollectionView;

@end


@implementation GNStoreDetailPhotoCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.tagCollectionView];
}

- (void)updateConstraints {
    [self.tagCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kRealWidth(8));
        make.bottom.mas_equalTo(-kRealWidth(16));
        make.height.mas_equalTo(kRealWidth(112));
    }];
    [super updateConstraints];
}

- (void)setGNModel:(NSArray *)data {
    if ([data isKindOfClass:NSArray.class]) {
        self.dataSource = data;
        [self.tagCollectionView reloadNewData:NO];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMAdvertiseItemCardCell" forIndexPath:indexPath];
    [cell setGNModel:self.dataSource[indexPath.row]];
    return cell;
}

- (WMHomeCollectionView *)tagCollectionView {
    if (!_tagCollectionView) {
        UICollectionViewFlowLayout *flowLayout = UICollectionViewFlowLayout.new;
        flowLayout.itemSize = CGSizeMake(kRealWidth(152), kRealWidth(112));
        flowLayout.minimumInteritemSpacing = kRealWidth(8);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _tagCollectionView = [[WMHomeCollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
        _tagCollectionView.delegate = self;
        _tagCollectionView.dataSource = self;
        _tagCollectionView.needShowNoDataView = YES;
        _tagCollectionView.backgroundColor = UIColor.whiteColor;
        [_tagCollectionView registerClass:NSClassFromString(@"WMAdvertiseItemCardCell") forCellWithReuseIdentifier:@"WMAdvertiseItemCardCell"];
        _tagCollectionView.contentInset = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
    }
    return _tagCollectionView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray<YBIBImageData *> *marr = [NSMutableArray new];
    for (NSString *model in self.dataSource) {
        YBIBImageData *data = [YBIBImageData new];
        if ([model isKindOfClass:NSString.class]) {
            NSString *modelStr = (NSString *)model;
            data.imageURL = [NSURL URLWithString:modelStr];
        }
        [marr addObject:data];
    }
    YBImageBrowser *browser = [YBImageBrowser new];

    GNImageHandle *handle = GNImageHandle.new;
    handle.sourceView = self;
    browser.toolViewHandlers = @[handle];

    browser.dataSourceArray = marr;
    browser.autoHideProjectiveView = false;
    [browser.defaultToolViewHandler yb_hide:YES];
    browser.currentPage = indexPath.row;
    [browser show];
}

@end
