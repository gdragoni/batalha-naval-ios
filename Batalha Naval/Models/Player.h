//
//  Player.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 2/11/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelosOnline.h"

@interface Player : NSObject

@property (nonatomic) NSInteger playerID;
@property (nonatomic) NSString* playerName;

-(Player *)playerWithName:(NSString *)nome andId:(NSInteger)playerId;
-(Player *)playerWithDict:(NSDictionary *)dict;
+(NSArray *)arrayPlayersWithDict:(NSDictionary *)dict;
-(NSDictionary *)dict;

@end
