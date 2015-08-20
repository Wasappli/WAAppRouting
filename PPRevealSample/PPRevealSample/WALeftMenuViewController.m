//
//  WALeftMenuViewController.m
//  PPRevealSample
//
//  Created by Marian Paul on 20/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WALeftMenuViewController.h"

@interface WALeftMenuViewController ()
@property (nonatomic, strong) NSArray *array;
@end

@implementation WALeftMenuViewController

static NSString *CellIdentifier = @"CellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = @[
                   @"Go to list 1",
                   @"Go to list 2",
                   @"Go to list 1 detail"
                   ];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = self.array[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch(indexPath.row) {
        case 0:
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] goTo:@"pprevealexample://list1"];
            break;
        case 1:
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] goTo:@"pprevealexample://list2"];
            break;
        case 2:
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] goTo:@"pprevealexample://list1/3?%@=NO", kWAAppRoutingForceAnimationKey];
            break;
        default:
            break;
    }
}

@end
