//
//  Navios.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 1/4/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "ShipGenerator.h"
#import "ShipComp.h"
#import "TestField.h"

@implementation ShipGenerator{
    
    ConfigurationComp *config;
    NSMutableArray *arrayUsedFields;
}
-(NSMutableArray *)arrayWithConfiguration:(ConfigurationComp *)configuration{
    config = configuration;
    NSMutableArray *arrayShips = [[NSMutableArray alloc]init];
    arrayUsedFields = [NSMutableArray new];
    NSInteger amountPortaAvioes = config.amountPortaAvioes, amountEncouracado = config.amountEncouracado, amountCruiser = config.amountCruiser, amountDestroyer = config.amountDestroyer, amountSubmarino = config.amountSubmarino;
    NSInteger amountShips = amountPortaAvioes+amountEncouracado+amountCruiser+amountDestroyer+amountSubmarino;
    for (int i = 0; i < amountShips; i++) {
        ShipType shipType = Submarino;
        if (amountPortaAvioes != 0) {
            shipType = PortaAvioes;
            amountPortaAvioes--;
        }else if (amountEncouracado !=0){
            shipType = Encouracado;
            amountEncouracado--;
        }else if (amountCruiser !=0){
            shipType = Cruiser;
            amountCruiser--;
        }else if (amountDestroyer !=0){
            shipType = Destroyer;
            amountDestroyer--;
        }else if (amountSubmarino !=0){
            shipType = Submarino;
            amountSubmarino--;
        }
        ShipComp *ship = [[ShipComp alloc]initShipType:shipType];
        ship.positions = [self fieldsForShip:ship];
        [arrayShips addObject:ship];
    }
        return arrayShips;
}

-(NSArray *)fieldsForShip:(ShipComp *)ship{
    NSMutableArray *fields = [NSMutableArray new];
    NSInteger tableSize = config.tableSize, tableFieldAmount = tableSize*tableSize;
    do{
        NSInteger d = (arc4random() % 2);
        NSInteger r = (arc4random() % tableFieldAmount);
        if(d == 0) for (int i = 0; i < ship.size; i++) {
                
                fields[i] = @(r);
                r++;
        }
        else for (int i = 0; i < ship.size; i++) {
                fields[i] = @(r);
                r += tableSize;
            }
    }while (!(([TestField testHorizontalField:fields tableSize:config.tableSize] || [TestField testVerticalField:fields tableSize:config.tableSize]) && ![TestField testRepeatedField:fields usedFields:arrayUsedFields]));
    [arrayUsedFields addObjectsFromArray:fields];
    return fields;
}

@end
