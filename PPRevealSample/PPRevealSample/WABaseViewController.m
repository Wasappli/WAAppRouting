//
//  WABaseViewController.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WABaseViewController.h"

@implementation WABaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)reloadFromAppLinkRefresh {
    
}

- (void)addSideMenuButton {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStyleDone target:self action:@selector(pushLeft)];
}

- (void)pushLeft {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] goTo:@"pprevealexample://left"];
}

@end
