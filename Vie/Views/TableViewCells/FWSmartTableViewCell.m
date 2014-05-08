//
// Created by Fabien Warniez on 2014-05-04.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSmartTableViewCell.h"

static NSTimeInterval const kFWSmartTableViewCellCheckmarkIndicatorDelay = 2.0f;
static NSTimeInterval const kFWSmartTableViewCellAnimationsDuration = 0.2f;

@interface FWSmartTableViewCell ()

@property (nonatomic, strong) UIButton *accessoryButton;
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

        self.useCustomAccessoryView = NO;
    }
    return self;
}

- (void)setAccessoryImage:(UIImage *)accessoryImage
{
    _accessoryImage = accessoryImage;

    if (accessoryImage != nil)
    {
        NSAssert(self.accessoryButton != nil, @"useCustomAccessoryView should be set to YES before setting images.");

        [self.accessoryButton setImage:accessoryImage forState:UIControlStateNormal];
        [self.accessoryButton sizeToFit];
    }
}

- (void)setAccessoryImageFlipped:(UIImage *)accessoryImageFlipped
{
    _accessoryImageFlipped = accessoryImageFlipped;

    if (accessoryImageFlipped != nil)
    {
        NSAssert(self.accessoryButton != nil, @"useCustomAccessoryView should be set to YES before setting images.");
    }
}

- (void)setUseCustomAccessoryView:(BOOL)useCustomAccessoryView
{
    _useCustomAccessoryView = useCustomAccessoryView;
    if (useCustomAccessoryView)
    {
        self.accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.accessoryButton addTarget:self action:@selector(accessoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        self.accessoryView = self.accessoryButton;
    }
    else
    {
        if (self.accessoryButton != nil)
        {
            [self.accessoryButton removeFromSuperview];
            self.accessoryView = nil;
        }
        self.accessoryButton = nil;
    }
}

- (void)accessoryButtonTapped:(id)sender
{
    [self.accessoryButton removeTarget:self action:@selector(accessoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self flashFlippedImageFor:kFWSmartTableViewCellCheckmarkIndicatorDelay];
    [self.delegate accessoryButtonTapped:self];
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.accessoryImage = nil;
    self.accessoryImageFlipped = nil;
    self.flashColor = nil;
    self.useCustomAccessoryView = NO;

    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.savedBackgroundColor = self.backgroundView.backgroundColor;
    self.delegate = nil;
}

- (void)flashFlippedImageFor:(NSTimeInterval)seconds
{
    NSAssert(self.useCustomAccessoryView, @"useCustomAccessoryView should be set to YES and images set before trying to flash.");

    UIButton *accessoryButton = (UIButton *) self.accessoryView;

    __weak FWSmartTableViewCell *weakSelf = self;

    [UIView animateWithDuration:kFWSmartTableViewCellAnimationsDuration
                    animations:^{
                        weakSelf.backgroundView.backgroundColor = self.flashColor;
                    }
                    completion:nil];

    accessoryButton.imageView.animationImages = [NSArray arrayWithObject:self.accessoryImageFlipped];
    [accessoryButton.imageView startAnimating];

    [UIView transitionWithView:accessoryButton
                      duration:kFWSmartTableViewCellAnimationsDuration
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{

                    }
            completion:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (kFWSmartTableViewCellAnimationsDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [UIView animateWithDuration:kFWSmartTableViewCellAnimationsDuration
                         animations:^{
                             weakSelf.backgroundView.backgroundColor = self.savedBackgroundColor;
                         }
                         completion:nil];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        accessoryButton.imageView.animationImages = [NSArray arrayWithObject:self.accessoryImage];
        [accessoryButton.imageView startAnimating];

        [UIView transitionWithView:accessoryButton
                          duration:kFWSmartTableViewCellAnimationsDuration
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                        }
                        completion:^(BOOL finished) {
                            [accessoryButton addTarget:self action:@selector(accessoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                        }];
    });
}

@end