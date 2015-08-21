//
//  WABaseDetailViewController.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WABaseDetailViewController.h"
#import <PureLayout/PureLayout.h>

@implementation WABaseDetailViewController

- (void)loadView {
    [super loadView];
    
    self.label = [UILabel newAutoLayoutView];
    self.label.numberOfLines = 0;
    [self.view addSubview:self.label];
    [self.label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
}

- (void)reloadData {
    if (self.isViewLoaded) {
        self.label.text = [NSString stringWithFormat:@"%@\n\nRouteParameters: %@\n\nQueryParameters:%@\nAllParameters: %@", self.appLink.URL, self.appLink.routeParameters, self.appLink.queryParameters, self.appLinkRoutingParameters];
    }
}


- (void)reloadFromAppLinkRefresh {
    [super reloadFromAppLinkRefresh];
    
    [self reloadData];
}

@end
