//
//  Navio.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/25/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef enum {
    PortaAvioes,
    Encouracado,
    Cruiser,
    Destroyer,
    Submarino
} ShipType;

@interface ShipComp : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) ShipType type;
@property (nonatomic, strong) NSArray<NSNumber *> *positions;
@property (nonatomic) NSInteger shipId, size;
@property (nonatomic) BOOL sunkenShip;

-(ShipComp *)initShipType:(ShipType)type;
-(UIImageView *)imageInThePositionTag:(NSInteger)tag size:(CGSize)size;
-(BOOL)isSubmarino;
-(BOOL)isHorizontal;
-(BOOL)isInvertedShip;

@end
