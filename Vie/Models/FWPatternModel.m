//
// Created by Fabien Warniez on 2014-05-08.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWPatternModel.h"
#import "FWPatternFormatReader.h"
#import "FWRleReader.h"
#import "FWBoardSizeModel.h"

@interface FWPatternModel ()

@property (nonatomic, strong) NSNumber *boardWidth;
@property (nonatomic, strong) NSNumber *boardHeight;

@end

@implementation FWPatternModel
{
    FWBoardSizeModel *_boardSize;
}

@dynamic name;
@dynamic fileName;
@dynamic format;
@dynamic boardWidth;
@dynamic boardHeight;
@dynamic encodedData;
@dynamic favourited;

@synthesize liveCells=_liveCells;

- (NSArray *)liveCells
{
    if (_liveCells == nil && self.encodedData != nil)
    {
        id<FWPatternFormatReader> patternFormatReader = [FWPatternModel patternFormatReaderForFormat:self.format];

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
        NSAssert(@"Unrecognized pattern format: %@.", format);
        return nil;
    }
}

- (FWBoardSizeModel *)boardSize
{
    if (_boardSize == nil) {
        _boardSize = [FWBoardSizeModel boardSizeWithNumberOfColumns:[self.boardWidth unsignedIntegerValue] numberOfRows:[self.boardHeight unsignedIntegerValue]];
    }
    return _boardSize;
}

- (void)setBoardSize:(FWBoardSizeModel *)boardSize
{
    _boardSize = boardSize;
    self.boardWidth = @(boardSize.numberOfColumns);
    self.boardHeight = @(boardSize.numberOfRows);
}

@end
