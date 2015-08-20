//
//  WAModalViewController.m
//  MoreComplexExample
//
//  Created by Marian Paul on 19/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAModalViewController.h"
#import <PureLayout/PureLayout.h>

@implementation WAModalViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Modal";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(dismissController)];
    
    UIBarButtonItem *goToButton = [[UIBarButtonItem alloc] initWithTitle:@"Go to list 1 detail"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(goToListOneDetail)];
    
    self.navigationItem.rightBarButtonItem = goToButton;
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goToListOneDetail {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] goTo:@"morecomplexexample://list1/6"];
    [self dismissController];
}

@end
