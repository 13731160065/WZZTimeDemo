//
//  WZZTimeHandler.h
//  time
//
//  Created by 王泽众 on 2017/5/18.
//  Copyright © 2017年 LST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZZTimeHandler : NSObject<NSCoding>

/**
 年
 */
@property (nonatomic, assign, readonly) NSInteger year;

/**
 月
 */
@property (nonatomic, assign, readonly) NSInteger month;

/**
 日
 */
@property (nonatomic, assign, readonly) NSInteger day;

/**
 时
 */
@property (nonatomic, assign, readonly) NSInteger hour;

/**
 分
 */
@property (nonatomic, assign, readonly) NSInteger min;

/**
 秒
 */
@property (nonatomic, assign, readonly) NSInteger sec;

/**
 周0-6，日一二三四五六
 */
@property (nonatomic, assign, readonly) NSInteger week;

/**
 时间戳
 */
@property (nonatomic, assign, readonly) NSTimeInterval timestamp;

/**
 日期
 */
@property (nonatomic, strong, readonly) NSDate * date;

#pragma mark - 构造方法
/**
 当前时间
 */
+ (instancetype)timeWithNow;

/**
 根据NSDate生成时间
 */
+ (instancetype)timeWithDate:(NSDate *)date;

/**
 根据时间戳生成时间
 */
+ (instancetype)timeWithTimestamp:(NSTimeInterval)timestamp;

/**
 格式化字符串转时间
 xxxx-xx-xx
 xxxx-xx-xx xx
 xxxx-xx-xx xx:xx
 xxxx-xx-xx xx:xx:xx
 */
+ (instancetype)timeWithTimeStr:(NSString *)timeStr;

#pragma mark - 操作方法

/**
 增加时间戳

 @param timestamp 时间戳
 */
- (WZZTimeHandler *)addTimestamp:(NSTimeInterval)timestamp;

/**
 增加年
 
 @param year 天，正加负减
 */
- (WZZTimeHandler *)addYear:(NSInteger)year;

/**
 增加月
 
 @param month 天，正加负减
 */
- (WZZTimeHandler *)addMonth:(NSInteger)month;

/**
 增加日
 
 @param day 日，正加负减
 */
- (WZZTimeHandler *)addDay:(NSInteger)day;

/**
 增加时

 @param hour 时，正加负减
 */
- (WZZTimeHandler *)addHour:(NSInteger)hour;

/**
 增加分

 @param min 分，正加负减
 */
- (WZZTimeHandler *)addMin:(NSInteger)min;

/**
 增加秒
 
 @param sec 秒，正加负减
 */
- (WZZTimeHandler *)addSec:(NSInteger)sec;

#pragma mark - 链式操作方法
@property (nonatomic, strong, readonly) WZZTimeHandler *(^addTimestamp)(NSTimeInterval timestamp);
@property (nonatomic, strong, readonly) WZZTimeHandler *(^addYear)(NSInteger year);
@property (nonatomic, strong, readonly) WZZTimeHandler *(^addMonth)(NSInteger month);
@property (nonatomic, strong, readonly) WZZTimeHandler *(^addDay)(NSInteger day);
@property (nonatomic, strong, readonly) WZZTimeHandler *(^addHour)(NSInteger hour);
@property (nonatomic, strong, readonly) WZZTimeHandler *(^addMin)(NSInteger min);
@property (nonatomic, strong, readonly) WZZTimeHandler *(^addSec)(NSInteger sec);

@end
