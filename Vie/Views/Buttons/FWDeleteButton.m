//
// Created by Fabien Warniez on 15-03-20.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWDeleteButton.h"
#import "UIColor+FWAppColors.h"
#import "UIFont+FWAppFonts.h"

@interface FWDeleteButton ()

@property (nonatomic, strong) UIImageView *deleteImageView;
@property (nonatomic, strong) UILabel *deleteLabel;

@end

@implementation FWDeleteButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        _deleteImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete"]];
        [self addSubview:_deleteImageView];

        _deleteLabel = [[UILabel alloc] init];
        _deleteLabel.font = [UIFont smallUppercase];
        _deleteLabel.textColor = [UIColor whiteColor];
        _deleteLabel.text = [NSLocalizedString(@"delete", @"delete") uppercaseString];
        _deleteLabel.hidden = YES;
        [self addSubview:_deleteLabel];

        [self addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}

- (void)tapped
{
    if (self.selected) {
        [self.delegate deleteButtonDidDelete:self];
    } else {
        self.selected = YES;

        CGFloat padding = self.deleteImageView.frame.origin.x;

        [self.deleteLabel sizeToFit];
        CGRect labelFrame = self.deleteLabel.frame;
        labelFrame.origin.x = self.bounds.size.width;
        labelFrame.origin.y = FWRoundFloat((self.bounds.size.height - labelFrame.size.height) / 2.0f);
        self.deleteLabel.frame = labelFrame;
        self.deleteLabel.hidden = NO;

        [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect newLabelFrame = self.deleteLabel.frame;
            newLabelFrame.origin.x = self.deleteImageView.frame.origin.x + self.deleteImageView.frame.size.width + padding;
            self.deleteLabel.frame = newLabelFrame;

            self.deleteImageView.transform = CGAffineTransformMakeRotation((CGFloat) (FWDegreesToRadians(90)));
            CGRect newFrame = self.frame;
            newFrame.size.width += self.deleteLabel.frame.size.width + padding;
            newFrame.origin.x -= self.deleteLabel.frame.size.width + padding;
            self.frame = newFrame;

            self.backgroundColor = [UIColor brightPink];
        } completion:^(BOOL finished) {
            // TODO setup timer to cancel
        }];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (!self.selected) {
        self.deleteImageView.frame = CGRectMake(
                FWRoundFloat((self.bounds.size.width - self.deleteImageView.frame.size.width) / 2.0f),
                FWRoundFloat((self.bounds.size.height - self.deleteImageView.frame.size.height) / 2.0f),
                self.deleteImageView.frame.size.width,
                self.deleteImageView.frame.size.height
        );
    }
}

@end
