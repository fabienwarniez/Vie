//
// Created by Fabien Warniez on 2014-05-01.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSavedGameTableViewCell.h"

@interface FWSavedGameTableViewCell ()

@property (nonatomic, strong) UITextField *editingTextField;

@end

@implementation FWSavedGameTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _editingTextField = [[UITextField alloc] init];
        _editingTextField.placeholder = NSLocalizedString(@"name", @"Name");
        _editingTextField.hidden = YES;
        [_editingTextField addTarget:self
                              action:@selector(textFieldDidChange)
                    forControlEvents:UIControlEventEditingChanged];
        _editingTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self.contentView addSubview:_editingTextField];
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];

    self.textLabel.hidden = editing;
    self.editingTextField.hidden = !editing;

    if (editing)
    {
        self.editingTextField.frame = self.textLabel.frame;
        self.editingTextField.text = self.textLabel.text;
    }
}

- (void)textFieldDidChange
{
    NSLog(@"Text field updated: %@", self.editingTextField.text);
    [self.delegate savedGameCell:self didEditGameName:self.editingTextField.text];
}

@end