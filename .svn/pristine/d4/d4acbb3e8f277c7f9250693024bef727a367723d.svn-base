//
//  RestKitCallBack.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/6/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GET_PLAYERFIELD_PLAYERONEID_GAMEID,
    GET_PLAYERFIELD_PLAYERTWOID_GAMEID,
    GET_PLAYER,
    GET_PLAYER_ID,
    POST_PLAYER,
    POST_GAMESHIP,
    GET_GAME_ID,
    POST_GAME,
    PUT_GAME,
    GET_LISTPLAYERGAMES_ID,
    POST_FIRE
} CallType;

@protocol RestKitCallBack <NSObject>

@required
-(void)callBackType:(CallType)type withdata:(id)data;

@end
