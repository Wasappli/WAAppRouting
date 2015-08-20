//
//  WAList2DetailViewController.m
//  MoreComplexExample
//
//  Created by Marian Paul on 19/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAList2DetailViewController.h"
#import <PureLayout/PureLayout.h>

@implementation WAList2DetailViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Detail List 1";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *previousButton = [UIButton newAutoLayoutView];
    [previousButton setTitle:@"Go back" forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [previousButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:previousButton];
    
    [previousButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [previousButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 10.0f, 60.0f, 10.0f) excludingEdge:ALEdgeTop];
    [previousButton autoSetDimension:ALDimensionHeight toSize:40.0f];
    
    UIButton *modalButton = [UIButton newAutoLayoutView];
    [modalButton setTitle:@"Modal" forState:UIControlStateNormal];
    [modalButton addTarget:self action:@selector(showModal) forControlEvents:UIControlEventTouchUpInside];
    [modalButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:modalButton];
    
    [modalButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [modalButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [modalButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [modalButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:previousButton];
    [modalButton autoSetDimension:ALDimensionHeight toSize:40.0f];
}

- (void)goBack {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] goTo:@"pprevealexample://list2?%@=YES", kWAAppRoutingForceAnimationKey];
}

- (void)showModal {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] goTo:@"pprevealexample://modal"];
}

@end
