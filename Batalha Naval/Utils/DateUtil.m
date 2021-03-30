//
//  DateUtil.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 5/18/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+(NSString *)transformDateWithString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTF"]];
    //  2016-05-18T09:54:19.9830284-03:00
    NSDate *date = [dateFormatter dateFromString: dateString];
    if (!date) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        date = [dateFormatter dateFromString:dateString];
    }
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd/MM/yyyy 'ás' HH:mm 'Hrs'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTF"]];
    NSString *convertedString = [dateFormatter stringFromDate:date];
    return convertedString;
}

+(NSString *)getCurrentDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString *Sdate = [formatter stringFromDate:date];
    return Sdate;
}

@end
