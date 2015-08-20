//
//  WAList1ViewController.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAListViewController.h"
#import <PureLayout/PureLayout.h>
#import "ArticleAppLinkParameters+Additions.h"

@interface WAListViewController ()
@end

@implementation WAListViewController

static NSString *CellIdentifier = @"CellIdentifier";

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"List";
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    // Allocate table view
    UITableView *tableView    = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate        = self;
    tableView.dataSource      = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // We are not using UITableViewController because we don't want the view to be the tableview
    [self.view addSubview:tableView];
    
    // Setup constraints as seen https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/ViewLoadingandUnloading/ViewLoadingandUnloading.html#//apple_ref/doc/uid/TP40007457-CH10-SW36
    [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    self.tableView = tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"My super article %ld", (long)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ArticleAppLinkParameters *params = [self.routingParameters copy];
    params.articleTitle = [NSString stringWithFormat:@"My super article %ld", (long)indexPath.row];
        
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] goTo:@"simpleexampleparameters://list/%ld?%@", (long)indexPath.row, [params articleDetailQuery]];
}

@end
