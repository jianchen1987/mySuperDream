//
//  GNImageTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNImageTableViewCell.h"


@interface GNImageTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>
/// 图片
@property (nonatomic, strong) GNCollectionView *tagCollectionView;
/// 图片查看
@property (nonatomic, strong) YBImageBrowser *browser;

@end


@implementation GNImageTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.tagCollectionView];
}

- (void)updateConstraints {
    [self.tagCollectionView layoutIfNeeded];

    [self.tagCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.model.contentInset.left);
        make.right.mas_equalTo(-self.model.contentInset.right);
        make.top.mas_equalTo(self.model.contentInset.top);
        make.height.mas_equalTo(self.tagCollectionView.collectionViewLayout.collectionViewContentSize);
        make.bottom.mas_equalTo(-self.model.contentInset.bottom);
    }];

    [super updateConstraints];
}

- (void)setGNModel:(GNTagViewCellModel *)data {
    self.model = data;
    self.tagCollectionView.backgroundColor = data.collectionViewBgColor;
    [self.tagCollectionView successGetNewDataWithNoMoreData:NO];
    [self setNeedsUpdateConstraints];
}

#pragma mark datasource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self showIndex:indexPath.row];
}

- (void)showIndex:(NSInteger)index {
    if (!self.browser) {
        NSMutableArray<YBIBImageData *> *marr = [NSMutableArray new];
        for (NSString *model in self.model.tagArr) {
            YBIBImageData *data = [YBIBImageData new];
            data.allowSaveToPhotoAlbum = NO;
            data.imageURL = [NSURL URLWithString:model];
            [marr addObject:data];
        }
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSourceArray = marr;
        browser.autoHideProjectiveView = false;
        GNImageHandle *handle = GNImageHandle.new;
        handle.sourceView = self;
        browser.toolViewHandlers = @[handle];
        self.browser = browser;
    }
    self.browser.currentPage = index;
    [self.browser show];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GNTagCollectionViewCell" forIndexPath:indexPath];
    cell.nameLb.clipsToBounds = YES;
    cell.nameLb.layer.cornerRadius = HDAppTheme.value.gn_radius8;
    cell.nameLb.userInteractionEnabled = NO;
    NSString *url = self.model.tagArr[indexPath.row];
    if ([url isKindOfClass:NSString.class]) {
        [cell.nameLb sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:HDHelper.placeholderImage];
    }
    cell.nameLb.imageView.frame = cell.nameLb.bounds;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.tagArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.model.itemSize;
}

- (GNCollectionView *)tagCollectionView {
    if (!_tagCollectionView) {
        HDCollectionViewVerticalLayout *flowLayout = [[HDCollectionViewVerticalLayout alloc] init];
        //        flowLayout.minimumLineSpacing = HDAppTheme.value.gn_marginL / 2;
        //        flowLayout.minimumInteritemSpacing = HDAppTheme.value.gn_marginL / 2;
        flowLayout.delegate = self;
        _tagCollectionView = [[GNCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 2 * HDAppTheme.value.gn_marginL, kRealHeight(28)) collectionViewLayout:flowLayout];
        _tagCollectionView.delegate = self;
        _tagCollectionView.dataSource = self;
        _tagCollectionView.scrollEnabled = NO;
        _tagCollectionView.needShowNoDataView = NO;
        _tagCollectionView.mj_header = nil;
        _tagCollectionView.mj_footer = nil;
        [_tagCollectionView registerClass:GNTagCollectionViewCell.class forCellWithReuseIdentifier:@"GNTagCollectionViewCell"];
    }
    return _tagCollectionView;
}

@end


@implementation GNImageHandle

- (void)yb_hide:(BOOL)hide {
    [super yb_hide:hide];
    if ([self valueForKey:@"downloadButton"]) {
        [[self valueForKey:@"downloadButton"] setHidden:YES];
    }
}

///防止崩溃
- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end
