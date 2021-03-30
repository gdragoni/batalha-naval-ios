//
//  Configuracoes.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/13/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "ConfigurationComp.h"

#define KEY_TAMANHOGRID @"tamGrid"
#define KEY_TENTTURNO @"tentTurno"
#define KEY_TENTACERTO @"tentAcerto"
#define KEY_PORTAAVIOES @"portaAvioes"
#define KEY_ENCOURACADO @"encouracado"
#define KEY_CRUISER @"cruiser"
#define KEY_DESTROYER @"destroyer"
#define KEY_SUBMARINO @"submarino"
#define KEY_EFEITOSSONOROS @"efeitosSonoros"

@implementation ConfigurationComp

-(ConfigurationComp *)configWithDict:(NSDictionary *)dict{
    self.tableSize                  = [dict[KEY_TAMANHOGRID] integerValue];
    self.shotsPerTurn               = [dict[KEY_TENTTURNO] integerValue];
    self.extraShotPerHit            = [dict[KEY_TENTACERTO] integerValue];
    self.amountPortaAvioes          = [dict[KEY_PORTAAVIOES] integerValue];
    self.amountEncouracado          = [dict[KEY_ENCOURACADO] integerValue];
    self.amountCruiser              = [dict[KEY_CRUISER] integerValue];
    self.amountDestroyer            = [dict[KEY_DESTROYER] integerValue];
    self.amountSubmarino            = [dict[KEY_SUBMARINO] integerValue];
    self.enableSound                = [dict[KEY_EFEITOSSONOROS] boolValue];
    self.numberOfFields             = self.tableSize*self.tableSize;
    self.numberOfFieldsWithShip     = (
                                      self.amountPortaAvioes  *5+
                                      self.amountEncouracado  *4+
                                      self.amountCruiser      *3+
                                      self.amountDestroyer    *2+
                                      self.amountSubmarino
                                      );
    return self;
}

-(NSDictionary *)dict{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[KEY_TAMANHOGRID]       = @(self.tableSize);
    dict[KEY_TENTTURNO]         = @(self.shotsPerTurn);
    dict[KEY_TENTACERTO]        = @(self.extraShotPerHit);
    dict[KEY_PORTAAVIOES]       = @(self.amountPortaAvioes);
    dict[KEY_ENCOURACADO]       = @(self.amountEncouracado);
    dict[KEY_CRUISER]           = @(self.amountCruiser);
    dict[KEY_DESTROYER]         = @(self.amountDestroyer);
    dict[KEY_SUBMARINO]         = @(self.amountSubmarino);
    dict[KEY_EFEITOSSONOROS]    = @(self.enableSound);
    return dict;
}

-(ConfigurationComp *)standardConfiguration{
    self.tableSize                  = 10;
    self.shotsPerTurn               = 1;
    self.extraShotPerHit            = 0;
    self.amountPortaAvioes          = 1;
    self.amountEncouracado          = 1;
    self.amountCruiser              = 1;
    self.amountDestroyer            = 2;
    self.amountSubmarino            = 2;
    self.enableSound                = YES;
    self.numberOfFieldsWithShip     = 18;
    self.numberOfFields             = 100;
    return self;
}

@end
