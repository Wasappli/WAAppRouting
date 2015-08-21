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
    // You can do something with self.appLink
    // But more important: with self.appLinkRoutingParameters which has merged route|query|default parameters
}

@end
