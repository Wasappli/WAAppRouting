//
//  WAList1ViewController.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAList1ViewController.h"

@interface WAList1ViewController ()
@end

@implementation WAList1ViewController

static NSString *CellIdentifier = @"CellIdentifier";

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"List 1";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *goToList2Modal = [[UIBarButtonItem alloc] initWithTitle:@"Goto list 2 Modal"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(gotoList2Modal)];
    self.navigationItem.rightBarButtonItem = goToList2Modal;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void) gotoList2Modal {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] goTo:@"morecomplexexample://list2/%@/modal", self.appLinkRoutingParameters[@"itemID"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"Object id %ld", (long)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] goTo:@"morecomplexexample://list1/%ld?extraParam1=1&extraParam2=toto", (long)indexPath.row];
}

@end
