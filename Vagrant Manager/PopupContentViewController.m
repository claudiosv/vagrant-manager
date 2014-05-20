//
//  PopupContentViewController.m
//  Vagrant Manager
//
//  Copyright (c) 2014 Lanayo. All rights reserved.
//

#import "PopupContentViewController.h"

@interface PopupContentViewController ()

@end

@implementation PopupContentViewController {
    BOOL _isRefreshing;
    NSMutableArray *_vagrantInstances;
}

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vagrantInstances = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.slideMenu.delegate = self;
    [self.moreUpIndicator setHidden:YES];
    [self.moreDownIndicator setHidden:YES];
    [self setIsRefreshing:_isRefreshing];
    
    for(VagrantInstance *instance in _vagrantInstances) {
        [self.slideMenu addInstance:instance];
    }
}

#pragma mark - Control

- (void)setIsRefreshing:(BOOL)isRefreshing {
    _isRefreshing = isRefreshing;
    
    [self.refreshButton setEnabled:!isRefreshing];
    [self.refreshButton setHidden:isRefreshing];
    if(isRefreshing) {
        [self.refreshingIndicator startAnimation:self];
    } else {
        [self.refreshingIndicator stopAnimation:self];
    }
}

#pragma mark - Menu management

- (void)addInstance:(VagrantInstance*)instance {
    [_vagrantInstances addObject:instance];
    if(self.slideMenu) {
        [self.slideMenu addInstance:instance];
    }
}

- (void)slideMenuHeightUpdated:(SlideMenuView *)slideMenuView {
    float gap = 29;
    
    CGRect frame = self.view.frame;
    frame.size.height = slideMenuView.frame.size.height + gap;
    frame.size.width = slideMenuView.frame.size.width;
    [[self.statusItemPopup getPopover] setContentSize:frame.size];
    self.view.frame = frame;
    
    frame = slideMenuView.frame;
    frame.origin.y = 0;
    slideMenuView.frame = frame;
    
    [self.moreUpIndicator setHidden:![slideMenuView hasMoreUp]];
    [self.moreDownIndicator setHidden:![slideMenuView hasMoreDown]];
}

#pragma mark - Button handlers

- (IBAction)quitButtonClicked:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}

- (IBAction)preferencesButtonClicked:(id)sender {
    preferencesWindow = [[PreferencesWindow alloc] initWithWindowNibName:@"PreferencesWindow"];
    [NSApp activateIgnoringOtherApps:YES];
    [preferencesWindow showWindow:self];
    [self.statusItemPopup hidePopover];
}

- (IBAction)aboutButtonClicked:(id)sender {
    aboutWindow = [[AboutWindow alloc] initWithWindowNibName:@"AboutWindow"];
    [NSApp activateIgnoringOtherApps:YES];
    [aboutWindow showWindow:self];
    [self.statusItemPopup hidePopover];    
}

- (IBAction)refreshButtonClicked:(id)sender {
    [[Util getApp] refreshVagrantMachines];
}

@end
