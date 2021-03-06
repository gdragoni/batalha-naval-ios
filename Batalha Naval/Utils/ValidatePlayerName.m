//
//  ValidacaoNomeJogador.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 3/24/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "ValidatePlayerName.h"
#import "PlayerComp.h"
#import "Player.h"

@implementation ValidatePlayerName

+(BOOL)nameWithInvalidCharacters:(NSString *)name{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 "] invertedSet];
    if ([name rangeOfCharacterFromSet:set].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+(BOOL)nameWithInvalidSize:(NSString *)name{
    if (name.length < 4 || name.length > 25) {
        return YES;
    }
    return NO;
}

+(BOOL)repeatedName:(NSString *)name playerClass:(Class)playerClass withArrayPlayers:(NSArray *)arrayPlayers{
    if (playerClass == [Player class]) for (Player *pl in arrayPlayers) {
        if ([name isEqualToString:pl.playerName]) return YES;
    }
    else if (playerClass == [PlayerComp class]) for (PlayerComp *pl in arrayPlayers) if ([name isEqualToString:pl.name]) return YES;
    return NO;
}

@end
