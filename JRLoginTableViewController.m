//
//  JRLoginViewController.m
//  jTLC
//
//  Created by John Heaton on 9/15/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRLoginTableViewController.h"
#import "JRLightPlaceholderTextField.h"
#import "JRTextCell.h"

@interface JRLoginTableViewController ()

@end

@implementation JRLoginTableViewController

- (void)loadView {
    [super loadView];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:@"Text"];
    self.tableView.rowHeight = 64;
    self.tableView.separatorColor = [UIColor colorWithWhite:0.8 alpha:0.2];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UITableViewHeaderFooterView *)view forSection:(NSInteger)section {
    view.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section) {
        case 0: return 2; break;
        case 1: return 1; break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    
    switch (indexPath.section) {
        case 0: {
            JRTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Text" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            switch (indexPath.row) {
                case 0: {
                    cell.label.text = @"Employee ID";
                    cell.textField.placeholder = @"ex: a123456";
                    cell.textField.returnKeyType = UIReturnKeyNext;
                    
                    NSLog(@"penis");
                } break;
                case 1: {
                    cell.label.text = @"Password";
                    cell.textField.placeholder = @"Required";
                    cell.textField.returnKeyType = UIReturnKeyGo;
                    cell.textField.secureTextEntry = YES;
                } break;
                case 2: {
                    cell.label.text = @"Preferred Name";
                    cell.textField.placeholder = @"Optional";
                } break;
                
            }
                    
                return cell;
        } break;
        case 1: {
            JRTextCell *cell = [[UINib nibWithNibName:@"TextCell" bundle:nil] instantiateWithOwner:self options:nil][0];
            
            cell.label.text = @"Save Password";
            [cell.textField removeFromSuperview];
            UISwitch *s = [UISwitch new];
            s.on = NO;
            s.onTintColor = [UIColor orangeColor];
            cell.accessoryView = s;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == 1) {
        return @"Your employee id and password are never shared or uploaded, and are encrypted when saved.";
    }
    
    return nil;
}

@end
