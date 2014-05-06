//
// Created by Fabien Warniez on 2014-05-04.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSmartTableViewCell.h"
#import "UIColor+FWAppColors.h"

static NSTimeInterval const kFWSmartTableViewCellCheckmarkIndicatorDelay = 2.0;

@interface FWSmartTableViewCell ()

@property (nonatomic, strong) UIColor *savedBackgroundColor;

@end

@implementation FWSmartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.textColor = [UIColor blackColor];

        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView = backgroundView;
        self.savedBackgroundColor = backgroundView.backgroundColor;
    }
    return self;
}

- (void)showSaveButton
{
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(accessoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton sizeToFit];
    self.accessoryView = saveButton;
}

- (void)accessoryButtonTapped:(id)sender
{
    [self markAsCompleteFor:kFWSmartTableViewCellCheckmarkIndicatorDelay];
    [self.delegate accessoryButtonTapped:self];
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView.backgroundColor = [UIColor selectedTableViewCellColor];
    self.savedBackgroundColor = self.selectedBackgroundView.backgroundColor;
    self.delegate = nil;
}

- (void)markAsCompleteFor:(NSTimeInterval)seconds
{
    UIButton *accessoryButton = (UIButton *) self.accessoryView;

    __weak FWSmartTableViewCell *weakSelf = self;

    [UIView animateWithDuration:0.3
                    animations:^{
                        weakSelf.backgroundView.backgroundColor = [UIColor successfulBackgroundColor];
                    }
                    completion:nil];

    accessoryButton.imageView.animationImages = [NSArray arrayWithObject:[UIImage imageNamed:@"checkmark"]];
    [accessoryButton.imageView startAnimating];

    [UIView transitionWithView:accessoryButton
                      duration:0.3
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{

                    }
            completion:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3
                         animations:^{
                             weakSelf.backgroundView.backgroundColor = self.savedBackgroundColor;
                         }
                         completion:nil];

        accessoryButton.imageView.animationImages = [NSArray arrayWithObject:[UIImage imageNamed:@"save"]];
        [accessoryButton.imageView startAnimating];

        [UIView transitionWithView:accessoryButton
                          duration:0.3
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                        }
                        completion:nil];
    });
}

@end