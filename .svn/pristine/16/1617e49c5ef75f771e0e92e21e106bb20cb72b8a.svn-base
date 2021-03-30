//
//  UserDefault.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/13/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "UserDefault.h"
#import "PlayerCompDAO.h"

#define KEY_PLAYERDICT      @"playerDict"
#define KEY_PLAYERNAME      @"playerName"
#define KEY_CONFIGURATION   @"config"

@implementation UserDefault

+(Player *)getActivePlayer{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [pref dictionaryForKey:KEY_PLAYERDICT];
    if (dict == nil) {
        return nil;
    }
    Player *player = [[Player alloc] playerWithDict:dict];
    return player;
}

+(void)setActivePlayer:(Player *)player{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setObject:[player dict] forKey:KEY_PLAYERDICT];
}

+(PlayerComp *)getActivePlayerComp{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSString *playerName  = [pref objectForKey:KEY_PLAYERNAME];
    PlayerCompDAO *pDAO = [PlayerCompDAO new];
    NSArray *arrayPlayer = [pDAO getPlayersOnDataBase];
    for (PlayerComp *player in arrayPlayer) {
        if ([player.name isEqualToString:playerName]) {
            return player;
        }
    }
    return nil;
}

+(void)setActivePlayerComp:(PlayerComp *)player{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setObject:player.name forKey:KEY_PLAYERNAME];
}

+(ConfigurationComp *)getConfiguration{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [pref dictionaryForKey:KEY_CONFIGURATION];
    if (dict == nil) {
        return [[ConfigurationComp alloc]standardConfiguration];
    }
    ConfigurationComp *config = [[ConfigurationComp alloc]configWithDict:dict];
    return config;
}

+(void)setConfiguration:(ConfigurationComp *)config{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setObject:[config dict] forKey:KEY_CONFIGURATION];
}

@end
