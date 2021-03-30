//
//  ShipGenerator.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 1/4/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ConfigurationComp.h"

@interface ShipGenerator : NSObject

-(NSMutableArray *)arrayWithConfiguration:(ConfigurationComp *)configuration;

@end
