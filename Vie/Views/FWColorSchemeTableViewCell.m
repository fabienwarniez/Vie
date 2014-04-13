//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWColorSchemeTableViewCell.h"

@implementation FWColorSchemeTableViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.cellPreviewFillColor = nil;
    self.cellPreviewBorderColor = nil;
    self.layer.borderWidth = 0.0;
    self.layer.borderColor = nil;
}

- (void)setCellPreviewFillColor:(UIColor *)cellPreviewFillColor
{
    _cellPreviewFillColor = cellPreviewFillColor;
    self.cellPreviewView.backgroundColor = cellPreviewFillColor;
}

- (void)setCellPreviewBorderColor:(UIColor *)cellPreviewBorderColor
{
    _cellPreviewBorderColor = cellPreviewBorderColor;
    self.cellPreviewView.layer.borderColor = cellPreviewBorderColor.CGColor;
    self.cellPreviewView.layer.borderWidth = 2.0f;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}

@end