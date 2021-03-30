//
//  SortArray.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 5/20/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "SortArray.h"

@implementation SortArray

+(void)sortArray:(NSMutableArray *)array byKey:(NSString *)key ascending:(BOOL)ascending{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    [array sortUsingDescriptors:@[sort]];
}

@end
