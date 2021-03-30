//
//  UserDefault.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/13/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigurationComp.h"
#import "Player.h"
#import "PlayerComp.h"

@interface UserDefault : NSObject

+(Player *)getActivePlayer;
+(void)setActivePlayer:(Player *)player;
+(PlayerComp *)getActivePlayerComp;
+(void)setActivePlayerComp:(PlayerComp *)player;
+(ConfigurationComp *)getConfiguration;
+(void)setConfiguration:(ConfigurationComp *)config;

@end
