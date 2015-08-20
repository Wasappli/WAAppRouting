//
//  WAList1DetailViewController.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAListDetailViewController.h"
#import <PureLayout/PureLayout.h>
#import "ArticleAppLinkParameters+Additions.h"

@implementation WAListDetailViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Detail List";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *nextButton = [UIButton newAutoLayoutView];
    [nextButton setTitle:@"Go to extra" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:nextButton];
    
    [nextButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [nextButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 10.0f, 10.0f, 10.0f) excludingEdge:ALEdgeTop];
    [nextButton autoSetDimension:ALDimensionHeight toSize:40.0f];
}

- (void)goNext {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] goTo:@"simpleexampleparameters://list/%@/extra?%@", self.routingParameters.articleID, [self.routingParameters articleDetailQuery]];
}

@end
