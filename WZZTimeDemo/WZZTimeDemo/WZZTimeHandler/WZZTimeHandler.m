//
//  WZZTimeHandler.m
//  周小七
//
//  Created by 王泽众 on 2017/5/18.
//  Copyright © 2017年 LST. All rights reserved.
//

#import "WZZTimeHandler.h"

@implementation WZZTimeHandler

#pragma mark - 构造方法

//根据时间创建时间
+ (instancetype)handleWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    //年
    [formatter setDateFormat:@"yyyy"];
    NSString *yearStr = [formatter stringFromDate:date];
    
    //月
    [formatter setDateFormat:@"MM"];
    NSString * monthStr = [formatter stringFromDate:date];
    
    //日
    [formatter setDateFormat:@"dd"];
    NSString * dayStr = [formatter stringFromDate:date];
    
    //时
    [formatter setDateFormat:@"HH"];
    NSString *hourStr = [formatter stringFromDate:date];
    
    //分
    [formatter setDateFormat:@"mm"];
    NSString * minStr = [formatter stringFromDate:date];
    
    //秒
    [formatter setDateFormat:@"ss"];
    NSString * secStr = [formatter stringFromDate:date];
    
    WZZTimeHandler * handle = [[WZZTimeHandler alloc] init];
    handle->_date = date;
    handle->_year = yearStr.integerValue;
    handle->_month = monthStr.integerValue;
    handle->_day = dayStr.integerValue;
    handle->_hour = hourStr.integerValue;
    handle->_min = minStr.integerValue;
    handle->_sec = secStr.integerValue;
    handle->_timestamp = [date timeIntervalSince1970];
    handle->_week = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfYear forDate:date]-1;
    
    //链式方法
    __weak WZZTimeHandler * wh = handle;
    handle->_addTimestamp = ^WZZTimeHandler *(NSTimeInterval timestamp) {
        return [wh addTimestamp:timestamp];
    };
    handle->_addYear = ^WZZTimeHandler *(NSInteger year) {
        return [wh addYear:year];
    };
    handle->_addMonth = ^WZZTimeHandler *(NSInteger month) {
        return [wh addMonth:month];
    };
    handle->_addDay = ^WZZTimeHandler *(NSInteger day) {
        return [wh addDay:day];
    };
    handle->_addHour = ^WZZTimeHandler *(NSInteger hour) {
        return [wh addHour:hour];
    };
    handle->_addMin = ^WZZTimeHandler *(NSInteger min) {
        return [wh addMin:min];
    };
    handle->_addSec = ^WZZTimeHandler *(NSInteger sec) {
        return [wh addSec:sec];
    };
    
    return handle;
}

//创建当前时间
+ (instancetype)timeWithNow {
    return [self handleWithDate:[NSDate date]];
}

//date生成时间
+ (instancetype)timeWithDate:(NSDate *)date {
    return [self handleWithDate:date];
}

//根据时间戳创建时间
+ (instancetype)timeWithTimestamp:(NSTimeInterval)timestamp {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [self handleWithDate:date];
}

+ (instancetype)timeWithTimeStr:(NSString *)timeStr {
    
    //正则检索
    NSRange(^rangeReg)(NSString *, NSString *) = ^(NSString * orgStr, NSString * regStr) {
        NSError * err;
        //正则
        NSRegularExpression * reg = [[NSRegularExpression alloc] initWithPattern:regStr options:NSRegularExpressionCaseInsensitive error:&err];
        if (err) {
            NSLog(@"%@", err);
            return NSMakeRange(0, 0);
        }
        //正则检索第一个
        NSTextCheckingResult * res = [reg firstMatchInString:orgStr options:0 range:NSMakeRange(0, orgStr.length)];
        
        return res.range;
    };
    
    //xxxx
    NSRange reg1 = rangeReg(timeStr, @"[0-9]{4,4}");
    //xxxx-xx
    NSRange reg2 = rangeReg(timeStr, @"[0-9]{4,4}-[0-9]{2,2}");
    //xxxx-xx-xx
    NSRange reg3 = rangeReg(timeStr, @"[0-9]{4,4}-[0-9]{2,2}-[0-9]{2,2}");
    //xxxx-xx-xx xx
    NSRange reg4 = rangeReg(timeStr, @"[0-9]{4,4}-[0-9]{2,2}-[0-9]{2,2} [0-9]{2,2}");
    //xxxx-xx-xx xx:xx
    NSRange reg5 = rangeReg(timeStr, @"[0-9]{4,4}-[0-9]{2,2}-[0-9]{2,2} [0-9]{2,2}:[0-9]{2,2}");
    //xxxx-xx-xx xx:xx:xx
    NSRange reg6 = rangeReg(timeStr, @"[0-9]{4,4}-[0-9]{2,2}-[0-9]{2,2} [0-9]{2,2}:[0-9]{2,2}:[0-9]{2,2}");
    
    if (reg6.length) {
        timeStr = [timeStr substringWithRange:reg6];
    } else if (reg5.length) {
        timeStr = [timeStr substringWithRange:reg5];
        timeStr = [timeStr stringByAppendingString:@":00"];
    } else if (reg4.length) {
        timeStr = [timeStr substringWithRange:reg4];
        timeStr = [timeStr stringByAppendingString:@":00:00"];
    } else if (reg3.length) {
        timeStr = [timeStr substringWithRange:reg3];
        timeStr = [timeStr stringByAppendingString:@" 00:00:00"];
    } else if (reg2.length) {
        timeStr = [timeStr substringWithRange:reg2];
        timeStr = [timeStr stringByAppendingString:@"-01 00:00:00"];
    } else if (reg1.length) {
        timeStr = [timeStr substringWithRange:reg1];
        timeStr = [timeStr stringByAppendingString:@"-01-01 00:00:00"];
    } else {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    return [self handleWithDate:date];
}

//NSCoding
- (instancetype)initWithCoder:(NSCoder *)coder
{
    NSTimeInterval timestamp = [coder decodeDoubleForKey:@"WZZTimeHandler_timestamp"];
    return [WZZTimeHandler timeWithTimestamp:timestamp];
}

//NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:self.timestamp forKey:@"WZZTimeHandler_timestamp"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%zd-%02zd-%02zd %02zd:%02zd:%02zd", self.year, self.month, self.day, self.hour, self.min, self.sec];
}


#pragma mark - 操作方法

//加时间戳
- (WZZTimeHandler *)addTimestamp:(NSTimeInterval)timestamp {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:self.timestamp];
    date = [date dateByAddingTimeInterval:timestamp];
    WZZTimeHandler * time = [WZZTimeHandler timeWithTimestamp:date.timeIntervalSince1970];
    _year = time.year;
    _month = time.month;
    _day = time.day;
    _hour = time.hour;
    _min = time.min;
    _sec = time.sec;
    _timestamp = time.timestamp;
    return self;
}

//加年
- (WZZTimeHandler *)addYear:(NSInteger)year {
    _year += year;
    return self;
}

//加月
- (WZZTimeHandler *)addMonth:(NSInteger)month {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *addcomps = [[NSDateComponents alloc] init];
    [addcomps setMonth:month];
    NSDate *newdate = [calendar dateByAddingComponents:addcomps toDate:self.date options:0];
    
    WZZTimeHandler * time = [WZZTimeHandler timeWithTimestamp:newdate.timeIntervalSince1970];
    _year = time.year;
    _month = time.month;
    _day = time.day;
    _hour = time.hour;
    _min = time.min;
    _sec = time.sec;
    _timestamp = time.timestamp;
    return self;
}

//加日
- (WZZTimeHandler *)addDay:(NSInteger)day {
    return [self addTimestamp:day*24*3600];
}

//加时
- (WZZTimeHandler *)addHour:(NSInteger)hour {
    return [self addTimestamp:hour*3600];
}

//加分
- (WZZTimeHandler *)addMin:(NSInteger)min {
    return [self addTimestamp:min*60];
}

//加秒
- (WZZTimeHandler *)addSec:(NSInteger)sec {
    return [self addTimestamp:sec];
}

@end
