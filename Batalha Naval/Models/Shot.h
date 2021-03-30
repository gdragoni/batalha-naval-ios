//
//  Shot.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/7/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelosOnline.h"

@interface Shot : NSObject

@property (nonatomic) Position *shotPosition;
@property (nonatomic) BOOL shotHit;

-(Shot *)shotWithDict:(NSDictionary *)data;
-(Shot *)lastShotFired:(PlayerField *)playerField;
-(Shot *)lastShotTaken:(PlayerField *)playerField;

@end
