//
//  Position.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/7/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "Position.h"

@implementation Position

-(instancetype)positionWithDict:(NSDictionary *)data{
    self.positionX = [data[KEY_POSITION_X] integerValue];
    self.positionY = [data[KEY_POSITION_Y] integerValue];
    NSInteger posY = self.positionY;
    NSInteger posX = self.positionX;
    self.positionTag = ((posX)*10+posY)+1;
    return self;
}

-(instancetype)positionWithTag:(NSInteger)tag{
    self.positionY      = ((tag-1)%10);
    self.positionX      = ((tag -1)/10);
    self.positionTag    = tag;
    return self;
}

-(instancetype)positionWithX:(NSInteger)posX andY:(NSInteger)posY{
    self.positionX      = posX;
    self.positionY      = posY;
    self.positionTag    = ((posY)*10+posX)+1;
    return self;
}

@end
