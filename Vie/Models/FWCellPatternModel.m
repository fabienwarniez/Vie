//
// Created by Fabien Warniez on 2014-05-08.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWCellPatternModel.h"
#import "FWPatternFormatReader.h"
#import "FWRleReader.h"

@implementation FWCellPatternModel

- (NSArray *)liveCells
{
    if (_liveCells == nil && self.encodedData != nil)
    {
        id<FWPatternFormatReader> patternFormatReader = [FWCellPatternModel patternFormatReaderForFormat:self.format];

       _liveCells = [patternFormatReader cellMatrixFromDataString:self.encodedData];
    }

    return _liveCells;
}

+ (id<FWPatternFormatReader>)patternFormatReaderForFormat:(NSString *)format
{
    if ([format isEqualToString:@"rle"])
    {
        return [[FWRleReader alloc] init];
    }
    else
    {
        NSAssert(@"Unrecognized pattern: %@.", format);
        return nil;
    }
}

@end