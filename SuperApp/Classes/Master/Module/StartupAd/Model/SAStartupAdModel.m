//
//  SAStartupAdModel.m
//  SuperApp
//
//  Created by Chaos on 2021/4/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAStartupAdModel.h"


@implementation SAStartupAdModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"url": @"imageUrl"};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.adPlayTime = 5;
    }
    return self;
}

- (BOOL)isEqual:(SAStartupAdModel *)object {
    if (![object isKindOfClass:SAStartupAdModel.class])
        return false;
    //不同类型
    if (self.timeType != object.timeType)
        return false;
    //定时投放，但开始时间不一致或者结束时间不一致
    if (object.timeType == 11 && (![self.startTimeSlot isEqualToString:object.startTimeSlot] || ![self.endTimeSlot isEqualToString:object.endTimeSlot]))
        return false;

    return [(self.adNo ?: @"") isEqualToString:(object.adNo ?: @"")] && [(self.url ?: @"") isEqualToString:(object.url ?: @"")] && [(self.jumpLink ?: @"") isEqualToString:(object.jumpLink ?: @"")]
           && self.adEffectiveTime == object.adEffectiveTime && self.adExpirationTime == object.adExpirationTime && self.adPlayTime == object.adPlayTime;
}

/// 判断是否在指定范围内
/// - Parameters:
///   - fromHour: 开始时间
///   - toHour: 结束时间
- (BOOL)isBetweenStartHour:(NSString *)startHour endHour:(NSString *)endHour {
    //获取当前时间
    NSDate *today = [NSDate date];

    NSDateFormatter *dateFormat = [NSDateFormatter new];
    // 时间格式,建议大写    HH 使用 24 小时制；hh 12小时制
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *todayStr = [dateFormat stringFromDate:today]; //将日期转换成字符串
    today = [dateFormat dateFromString:todayStr];           //转换成NSDate类型。日期置为方法默认日期
    // strar 格式 "5:30"  end: "19:08"
    NSDate *start = [dateFormat dateFromString:startHour];
    NSDate *end = [dateFormat dateFromString:endHour];
    //当前时间大于等于开始时间，小于结束时间
    if ([today compare:start] >= NSOrderedSame && [today compare:end] == NSOrderedAscending)
        return true;

    return false;
}

#pragma mark - getter
- (BOOL)isEligible {
    // 广告格式未设置
    if (HDIsStringEmpty(self.mediaType)) {
        return false;
    }
    // 图片视频都未下载好，不展示
    if (HDIsStringEmpty(self.imagePath) && HDIsStringEmpty(self.videoPath)) {
        return false;
    }
    if ([self.mediaType isEqualToString:SAStartupAdTypeImage]) {
        // 图片缓存文件不存在
        if (![HDFileUtil isFileExistedFilePath:[NSString stringWithFormat:@"%@%@", DocumentsPath, self.imagePath]]) {
            return false;
        }
    } else if ([self.mediaType isEqualToString:SAStartupAdTypeVideo]) {
        // 视频缓存文件不存在
        if (![HDFileUtil isFileExistedFilePath:[NSString stringWithFormat:@"%@%@", DocumentsPath, self.videoPath]]) {
            return false;
        }
    }
    // 广告展示时间为0s，不展示
    if (self.adPlayTime == 0) {
        return false;
    }

    //定时投放,但不在指定范围里面
    if (self.timeType == 11 && ![self isBetweenStartHour:self.startTimeSlot endHour:self.endTimeSlot])
        return false;
    // 在有效时间内
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970] * 1000;
    if (nowTime >= self.adEffectiveTime && nowTime <= self.adExpirationTime) {
        return true;
    }
    return false;
}

@end
