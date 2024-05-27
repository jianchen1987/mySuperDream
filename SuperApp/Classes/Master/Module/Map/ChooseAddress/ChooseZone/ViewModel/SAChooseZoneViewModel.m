//
//  SAChooseZoneViewModel.m
//  SuperApp
//
//  Created by Chaos on 2021/3/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAChooseZoneViewModel.h"
#import "SAChooseZoneDTO.h"
#import "SAAddressZoneModel.h"


@interface SAChooseZoneViewModel ()

/// 标志，只要变化就刷新
@property (nonatomic, assign) BOOL refreshFlag;
/// tableview数据源
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;

/// DTO
@property (nonatomic, strong) SAChooseZoneDTO *chooseZoneDTO;

@end


@implementation SAChooseZoneViewModel

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
        HDTableViewSectionModel *sectionModel = self.dataSource[i];
        if ([sectionModel.commonHeaderModel isKindOfClass:NSString.class] && [sectionModel.commonHeaderModel isEqualToString:chooseHotCity.code]) {
            return i;
        }
    }
    return 0;
}

#pragma mark - private methods
- (void)parseDataWithList:(NSArray<SAAddressZoneModel *> *)list {
    NSMutableArray *provinces = [NSMutableArray array];
    NSMutableDictionary *districtDict = [NSMutableDictionary dictionary];
    for (SAAddressZoneModel *zoneModel in list) {
        if (zoneModel.zlevel == SAAddressZoneLevelProvince) {
            [provinces addObject:zoneModel];
        } else if (zoneModel.zlevel == SAAddressZoneLevelDistrict) {
            NSMutableArray *districts = districtDict[zoneModel.parent];
            if (!districts) {
                districts = [NSMutableArray array];
            }
            [districts addObject:zoneModel];
            districtDict[zoneModel.parent] = districts;
        }
    }
    NSMutableArray *dataSource = [NSMutableArray array];
    for (SAAddressZoneModel *province in provinces) {
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        headerModel.title = province.message.desc;
        headerModel.titleFont = HDAppTheme.font.standard3Bold;
        headerModel.titleColor = HDAppTheme.color.G1;
        HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
        sectionModel.headerModel = headerModel;
        sectionModel.list = districtDict[province.code];
        sectionModel.commonHeaderModel = province.code;
        [dataSource addObject:sectionModel];
    }
    self.dataSource = dataSource;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view dismissLoading];
        self.refreshFlag = !self.refreshFlag;
    });
}

#pragma mark - lazy load
- (NSArray<HDTableViewSectionModel *> *)dataSource {
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
