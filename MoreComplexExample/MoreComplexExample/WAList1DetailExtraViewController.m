//
//  WAList1DetailExtraViewController.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAList1DetailExtraViewController.h"
#import <PureLayout/PureLayout.h>

@implementation WAList1DetailExtraViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Extra List 1";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *subPath1Button = [UIButton newAutoLayoutView];
    [subPath1Button setTitle:@"Go to subpath 1" forState:UIControlStateNormal];
    [subPath1Button addTarget:self action:@selector(goToSubpath1) forControlEvents:UIControlEventTouchUpInside];
    [subPath1Button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:subPath1Button];
    
    UIButton *subPath2Button = [UIButton newAutoLayoutView];
    [subPath2Button setTitle:@"Go to subpath 2" forState:UIControlStateNormal];
    [subPath2Button addTarget:self action:@selector(goToSubpath2) forControlEvents:UIControlEventTouchUpInside];
    [subPath2Button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:subPath2Button];

    
    [subPath1Button autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [subPath1Button autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:subPath2Button];
    [subPath1Button autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:subPath2Button];
    [subPath1Button autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:subPath2Button withOffset:10.0f];
    [subPath1Button autoSetDimension:ALDimensionHeight toSize:40.0f];
    
    [subPath2Button autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [subPath2Button autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 10.0f, 60.0f, 10.0f) excludingEdge:ALEdgeTop];
    [subPath2Button autoSetDimension:ALDimensionHeight toSize:40.0f];
}

- (void)goToSubpath1 {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] goTo:@"morecomplexexample://list1/%@/extra/subpath1", self.appLinkRoutingParameters[@"itemID"]];
}

- (void)goToSubpath2 {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] goTo:@"morecomplexexample://list1/%@/extra/subpath2", self.appLinkRoutingParameters[@"itemID"]];
}

@end
