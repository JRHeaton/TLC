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
#import "UIColor+TLC.h"
#import "GJB.h"

@interface JRLoginTableViewController () {
    id _target;
    SEL _action;
    
    // custom loading button item
    UIActivityIndicatorView *spinner;
    UIBarButtonItem *spinnerItem;
    
    // regular right bar item
    UIBarButtonItem *rightBarItem;
    
    // keep track of text fields/switches
    UITextField *idField, *passField;
    UISwitch *saveSwitch;
    
    TKSession *sessionCandidate;
}

@end

@implementation JRLoginTableViewController

- (id)init {
    if(self = [super initWithStyle:UITableViewStyleGrouped]) {
        _showingActivity = NO;
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        spinnerItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
        rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
        rightBarItem.enabled = NO;
    }
    
    return self;
}

- (void)submit {
    [self setShowingActivity:YES];

    Log(@"submitting");
    sessionCandidate = [TKSession sessionForEmployee:[TKEmployee employeeWithID:idField.text password:passField.text]];
    [sessionCandidate logIn:^(BOOL success, NSString *errorString) {
        if(!success) {
            [self performSelectorOnMainThread:@selector(reflectLogInErrorInUI) withObject:nil waitUntilDone:NO];
        }
        else {
            if(self.completionBlock)
                self.completionBlock(sessionCandidate);
            
            self.showingActivity = NO;
        }
    }];
}

- (void)reflectLogInErrorInUI {
    [self setShowingActivity:NO];
    [passField setText:nil];
    [passField becomeFirstResponder];
}

- (void)setShowingActivity:(BOOL)showingActivity {
    // animate
    
    if(showingActivity != self.showingActivity) {
        switch (showingActivity) {
            case NO: {
                NSLog(@"stuff");
                [spinner stopAnimating];
                self.navigationItem.rightBarButtonItem = rightBarItem;
                
                idField.enabled = passField.enabled = saveSwitch.enabled = YES;
                idField.textColor = passField.textColor = saveSwitch.onTintColor = [UIColor orangeColor];
                
            } break;
            default: {
                self.navigationItem.rightBarButtonItem = spinnerItem;
                [spinner startAnimating];
                
                [idField resignFirstResponder];
                [passField resignFirstResponder];
                idField.enabled = passField.enabled = saveSwitch.enabled = NO;
                idField.textColor = passField.textColor = saveSwitch.onTintColor = [UIColor colorWithWhite:0.5 alpha:1];
                
            } break;
        }
    }
    
    _showingActivity = showingActivity;
}

- (void)loadView {
    [super loadView];
    
    self.tableView.backgroundColor = [UIColor tlcBackgroundColor];
    self.title = @"Log In";
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    saveSwitch = [UISwitch new];
    saveSwitch.on = YES;
    saveSwitch.onTintColor = [UIColor orangeColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:@"Text"];
    self.tableView.rowHeight = 64;
    self.tableView.separatorColor = [UIColor colorWithWhite:0.8 alpha:0.2];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UITableViewHeaderFooterView *)view forSection:(NSInteger)section {
    view.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"ETK Credentials"; break;
        default: return nil; break;
    }
    
    return nil;
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
            cell.backgroundColor = [UIColor tlcNavBarTintColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            switch (indexPath.row) {
                case 0: {
                    cell.label.text = @"Employee ID";
                    cell.textField.placeholder = @"ex: a123456";
                    cell.textField.returnKeyType = UIReturnKeyNext;
                    cell.textField.delegate = self;
                    cell.textField.enablesReturnKeyAutomatically = YES;
                    
                    idField = cell.textField;
                } break;
                case 1: {
                    cell.label.text = @"Password";
                    cell.textField.placeholder = @"Required";
                    cell.textField.returnKeyType = UIReturnKeyGo;
                    cell.textField.secureTextEntry = YES;
                    cell.textField.enablesReturnKeyAutomatically = YES;
                    cell.textField.delegate = self;
                    
                    passField = cell.textField;
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
            cell.backgroundColor = [UIColor tlcNavBarTintColor];
            
            cell.label.text = @"Save Password";
            [cell.textField removeFromSuperview];
            cell.accessoryView = saveSwitch;
            
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == idField)
        [passField becomeFirstResponder];
    else
        [self submit];
    
    return YES;
}

@end
