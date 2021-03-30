//
//  DateUtil.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 5/18/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+(NSString *)transformDateWithString:(NSString *)dateString;
+(NSString *)getCurrentDate;

@end
