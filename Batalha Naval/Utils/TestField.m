//
//  TestesDeCampos.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/26/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "TestField.h"

@implementation TestField

+(BOOL)testHorizontalField:(NSArray *)arrayFields tableSize:(NSInteger)tableSize{
    NSInteger firstThreadIndex = 0;
    NSInteger lastThreadIndex = 0;
    NSInteger firstIndex = [arrayFields[0] integerValue];
    NSInteger amountFields = arrayFields.count;
    firstThreadIndex = (firstIndex -1)/tableSize;
    firstThreadIndex = firstThreadIndex * tableSize + 1;
    lastThreadIndex  = firstThreadIndex+tableSize-1;
    if (amountFields == 1) {
        return YES;
    }
    if (!([arrayFields[0] integerValue] == [arrayFields[1] integerValue]+1 || [arrayFields[1] integerValue] == [arrayFields[0] integerValue]+1)) {
        return NO;
    }
    for (int i = 0; i<=amountFields-1; i++) {
        if ([arrayFields[i]integerValue]<firstThreadIndex || [arrayFields[i]integerValue]>lastThreadIndex) {
            return NO;
        }
    }
    return YES;
}

+(BOOL)testVerticalField:(NSArray *)arrayFields tableSize:(NSInteger)tableSize{
    NSInteger amountOfFields = arrayFields.count;
    if (amountOfFields == 1) {
        if ([arrayFields[0] integerValue] > 0 && [arrayFields[0] integerValue] < tableSize*tableSize) {
            return YES;
        }
        return NO;
    }
    if ([arrayFields[0] integerValue] == [arrayFields[1] integerValue]+1 || [arrayFields[1] integerValue] == [arrayFields[0] integerValue]+1) {
        return NO;
    }
    for (int i = 0; i <= amountOfFields-1; i++) {
        if ([arrayFields[i]integerValue]<1 || [arrayFields[i]integerValue]>tableSize*tableSize) {
            return NO;
        }
        if (amountOfFields > 1) {
            if (!([arrayFields[0]integerValue] + tableSize != [arrayFields[1]integerValue] || [arrayFields[1]integerValue] + tableSize != [arrayFields[0]integerValue])) {
                return NO;
            }
        }
    }
    return YES;
}

+(BOOL)testRepeatedField:(NSArray *)arrayFields usedFields:(NSArray *)arrayUsedFields{
    for (NSNumber *field in arrayFields) {
        for (NSNumber *usedField in arrayUsedFields) {
            if ([usedField integerValue] == [field integerValue]) {
                return YES;
            }
        }
    }
    return NO;
}

@end
