//
//  SAChooseCityViewModel.m
//  SuperApp
//
//  Created by seeu on 2022/7/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAChooseCityViewModel.h"
#import "SAAddressZoneModel.h"
#import "SAChooseZoneDTO.h"


@interface SAChooseCityViewModel ()

/// 标志，只要变化就刷新
@property (nonatomic, assign) BOOL refreshFlag;
/// tableview数据源
@property (nonatomic, strong) NSArray<SAAddressZoneModel *> *dataSource;

/// DTO
@property (nonatomic, strong) SAChooseZoneDTO *chooseZoneDTO;

@end


@implementation SAChooseCityViewModel
#pragma mark - public methods
- (void)getNewData {
    [self.view showloading];
    @HDWeakify(self);
    [self.chooseZoneDTO getZoneListWithSuccess:^(NSArray<SAAddressZoneModel *> *_Nonnull list) {
        @HDStrongify(self);
        // 异步处理数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @autoreleasepool {
                [self parseDataWithList:list];
            }
        });
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        HDLog(@"获取地区列表失败");
        [self.view dismissLoading];
    }];
}

- (void)chooseZoneModel:(SAAddressZoneModel *)zoneModel {
    !self.callback ?: self.callback(zoneModel);
}

- (NSUInteger)findSectionWithChooseHotCity:(SAAddressZoneModel *)chooseHotCity {
    for (int i = 0; i < self.dataSource.count; i++) {
        SAAddressZoneModel *model = self.dataSource[i];
        if ([model.code isEqualToString:chooseHotCity.code]) {
            return i;
        }
    }
    return 0;
}

#pragma mark - private methods
- (void)parseDataWithList:(NSArray<SAAddressZoneModel *> *)list {
    NSArray<SAAddressZoneModel *> *provinces = [list hd_filterWithBlock:^BOOL(SAAddressZoneModel *_Nonnull item) {
        return item.zlevel == SAAddressZoneLevelProvince;
    }];

    self.dataSource = [provinces copy];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view dismissLoading];
        self.refreshFlag = !self.refreshFlag;
    });
}

#pragma mark - lazy load
- (NSArray<SAAddressZoneModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

- (SAChooseZoneDTO *)chooseZoneDTO {
    if (!_chooseZoneDTO) {
        _chooseZoneDTO = SAChooseZoneDTO.new;
    }
    return _chooseZoneDTO;
}
@end
