//
//  FireResponse.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/7/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "Fire.h"

@implementation Fire

-(instancetype) fireWithDict:(NSDictionary *)data{
    self.fireHit        = [data[KEY_HIT] boolValue];
    self.fireRemaining  = [data[KEY_REMAINING] integerValue];
    self.fireSunkenShip = data[KEY_SUNKENSHIP] == (id)[NSNull null] ? nil : data[KEY_SUNKENSHIP];
    return self;
}

@end
