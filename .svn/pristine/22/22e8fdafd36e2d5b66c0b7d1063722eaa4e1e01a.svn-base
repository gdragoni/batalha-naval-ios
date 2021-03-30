//
//  Navio.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/25/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "ShipComp.h"
#import "ImageUtil.h"

@implementation ShipComp

-(ShipComp *)initShipType:(ShipType)type{
    if (type == PortaAvioes) {
        self.shipId = 0;
        self.name   = @"Porta-Aviões";
        self.size   = 5;
    }else if (type == Encouracado){
        self.shipId = 1;
        self.name   = @"Encouraçado";
        self.size   = 4;
    }else if (type == Cruiser){
        self.shipId = 2;
        self.name   = @"Cruiser";
        self.size   = 3;
    }else if (type == Destroyer){
        self.shipId = 3;
        self.name   = @"Destroyer";
        self.size   = 2;
    }else if (type == Submarino){
        self.shipId = 4;
        self.name   = @"Submarino";
        self.size   = 1;
    }
    self.positions = nil;
    self.type = type;
    self.sunkenShip = NO;
    return self;
}

-(BOOL)isHorizontal{
    if ([self isSubmarino]) return nil;
    BOOL test = (self.positions[0].integerValue == self.positions[1].integerValue - 1 || self.positions[1].integerValue == self.positions[0].integerValue - 1);
    return test;
}

-(BOOL)isInvertedShip{
    if ([self isSubmarino]) return YES;
    if (self.positions[0].integerValue < self.positions[1].integerValue) return NO;
    else return YES;
}

-(BOOL)isSubmarino{
    return self.size == 1;
}

-(UIImageView *)imageInThePositionTag:(NSInteger)tag size:(CGSize)size{
    if ([self isSubmarino]) return [ImageUtil imageViewWithImageNamed:@"submarino" size:size isHorizontal:YES];
    else if (tag == self.positions.firstObject.integerValue) return [self isInvertedShip] ? [ImageUtil imageViewWithImageNamed:@"atrasNavio" size:size isHorizontal:[self isHorizontal]] : [ImageUtil imageViewWithImageNamed:@"frenteNavio" size:size isHorizontal:[self isHorizontal]];
    else if (tag == self.positions.lastObject.integerValue) return ![self isInvertedShip] ? [ImageUtil imageViewWithImageNamed:@"atrasNavio" size:size isHorizontal:[self isHorizontal]] : [ImageUtil imageViewWithImageNamed:@"frenteNavio" size:size isHorizontal:[self isHorizontal]];
    else return [ImageUtil imageViewWithImageNamed:@"meioNavio" size:size isHorizontal:[self isHorizontal]];
}

@end
