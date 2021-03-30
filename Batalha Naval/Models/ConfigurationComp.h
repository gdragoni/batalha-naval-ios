//
//  Configuracoes.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/13/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigurationComp : NSObject

@property (nonatomic) NSInteger tableSize, shotsPerTurn, extraShotPerHit, amountPortaAvioes, amountEncouracado, amountCruiser, amountDestroyer, amountSubmarino, numberOfFields, numberOfFieldsWithShip;
@property (nonatomic) BOOL enableSound;

-(ConfigurationComp *)configWithDict:(NSDictionary *)dict;
-(ConfigurationComp *)standardConfiguration;
-(NSDictionary *)dict;

@end
