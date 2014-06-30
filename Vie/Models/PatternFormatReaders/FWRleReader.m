//
// Created by Fabien Warniez on 2014-06-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWRleReader.h"
#import "FWCellModel.h"

@implementation FWRleReader

- (NSArray *)cellMatrixFromDataString:(NSString *)data
{
    NSScanner *scanner = [NSScanner scannerWithString:data];

    NSMutableArray *liveCells = [NSMutableArray array];
    NSUInteger columnIndex = 0;
    NSUInteger rowIndex = 0;

    while (![scanner isAtEnd])
    {
        NSInteger numberOfOccurences;
        if (![scanner scanInteger:&numberOfOccurences])
        {
            numberOfOccurences = 1;
        }

        NSString *nextCharacter = [data substringWithRange:NSMakeRange([scanner scanLocation], 1)];
        if ([nextCharacter isEqualToString:@"!"]) // end of file
        {
            break;
        }
        else if ([nextCharacter isEqualToString:@"$"]) // line end
        {
            columnIndex = 0;
            rowIndex++;
        }
        else if ([nextCharacter isEqualToString:@"b"]) // dead cell
        {
            columnIndex += numberOfOccurences;
        }
        else if ([nextCharacter isEqualToString:@"o"]) // live cell
        {
            for (NSUInteger i = 0; i < numberOfOccurences; i++)
            {
                FWCellModel *cellModel = [FWCellModel cellWithAlive:YES column:columnIndex row:rowIndex];
                columnIndex++;
                [liveCells addObject:cellModel];
            }
        }
        [scanner setScanLocation:[scanner scanLocation] + 1];
    }

    return liveCells;
}

@end