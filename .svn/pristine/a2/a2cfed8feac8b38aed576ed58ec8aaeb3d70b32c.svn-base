//
//  Ship.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/7/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "Ship.h"

@implementation Ship

-(instancetype)shiptWithDict:(NSDictionary *)data{
    self.shipId = [data[KEY_SHIPID] integerValue];
    NSMutableArray *arrayDePositions = [NSMutableArray new];
    for (NSDictionary *pos in data[KEY_POSITIONS]) {
        Position *position = [Position new];
        [position positionWithDict:pos];
        [arrayDePositions addObject:position];
    }
    self.shipPositions = arrayDePositions;
    return self;
}

-(instancetype)shipWithPositionsTag:(NSArray *)positionsTag andId:(NSInteger)id_{
    NSInteger shipId = 0;
    switch (positionsTag.count) {
        case 5:
            shipId = 1;
            break;
        case 4:
            shipId = 2;
            break;
        case 3:
            shipId = 3;
            break;
        case 2:
            shipId = 4;
            break;
        case 1:
            shipId = 5;
            break;
    }
    self.shipId = shipId;
    NSMutableArray *arrayDePositions = [NSMutableArray new];
    for (NSNumber *pos in positionsTag) {
        Position *position = [Position new];
        [position positionWithTag:pos.integerValue];
        [arrayDePositions addObject:position];
    }
    self.shipPositions = arrayDePositions;
    return self;
}

-(BOOL)isSubmarine{
    return self.shipPositions.count == 1;
}

-(BOOL)isHorizontal{
    if (self.shipPositions != nil && self.shipPositions.count > 1) {
        if (self.shipPositions[0].positionTag+1 == self.shipPositions[1].positionTag || self.shipPositions[0].positionTag-1 == self.shipPositions[1].positionTag) {
            return YES;
        }else return NO;
    }
    return nil;
}

-(BOOL)isInvertedShip{
    if (self.shipPositions != nil && self.shipPositions.count > 1) {
        if ([self.shipPositions[0] positionTag] < [self.shipPositions[1] positionTag]) {
            return NO;
        }else return YES;
    }
    return nil;
}

@end
