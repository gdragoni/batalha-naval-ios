//
//  Ship.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/7/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelosOnline.h"

@interface Ship : NSObject

@property (nonatomic) NSInteger shipId;
@property (nonatomic, strong) NSArray<Position *> *shipPositions;
@property (nonatomic) BOOL shipSunkenShip;

-(instancetype)shiptWithDict:(NSDictionary *)data;
-(instancetype)shipWithPositionsTag:(NSArray *)positionsTag andId:(NSInteger)id_;

-(BOOL)isSubmarine;
-(BOOL)isHorizontal;
-(BOOL)isInvertedShip;

@end
