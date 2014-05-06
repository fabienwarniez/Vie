//
// Created by Fabien Warniez on 2014-05-04.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSmartTableViewCell.h"
#import "UIColor+FWAppColors.h"

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

        UIView *selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = [UIColor selectedTableViewCellColor];
        self.selectedBackgroundView = selectedBackgroundView;
        self.savedBackgroundColor = selectedBackgroundView.backgroundColor;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView.backgroundColor = [UIColor selectedTableViewCellColor];
}

- (void)markAsCompleteFor:(NSTimeInterval)seconds
{
    UIImageView *accessoryImageView = (UIImageView *) self.accessoryView;
    self.savedBackgroundColor = self.backgroundView.backgroundColor;

    __weak FWSmartTableViewCell *weakSelf = self;

    [UIView animateWithDuration:0.3
                    animations:^{
                        weakSelf.backgroundView.backgroundColor = [UIColor successfulBackgroundColor];
                    }
                    completion:nil];

    [UIView transitionWithView:accessoryImageView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        accessoryImageView.image = [UIImage imageNamed:@"checkmark"];
                    }
            completion:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3
                         animations:^{
                             weakSelf.backgroundView.backgroundColor = self.savedBackgroundColor;
                         }
                         completion:nil];

        [UIView transitionWithView:accessoryImageView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            accessoryImageView.image = [UIImage imageNamed:@"right_arrow"];
                        }
                        completion:nil];
    });
}

@end