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
#import "GJB.h"
#import "JRColorTheme.h"
#import "JRMasterController.h"

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
    UILabel *idLabel, *passLabel;
    UISwitch *saveSwitch;
    
    TKSession *sessionCandidate;
    JRColorTheme *theme;
    
    JRMasterController *master;
}

@end

@implementation JRLoginTableViewController

- (id)init {
    if(self = [super initWithStyle:UITableViewStyleGrouped]) {
        _showingActivity = NO;
    }
    
    return self;
}


- (void)loadView {
    [super loadView];
    
    master = [JRMasterController sharedInstance];
    theme = master.colorTheme;
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinnerItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];

    rightBarItem.enabled = NO;
    
    //    self.tableView.backgroundColor = [UIColor tlcBackgroundColor];
    self.title = @"Log In";
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = theme.backgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:@"Text"];
    self.tableView.rowHeight = 64;
    self.tableView.separatorColor = theme.tableSeparatorColor;
    
    saveSwitch = [UISwitch new];
    saveSwitch.on = YES;
    //    saveSwitch.onTintColor = [UIColor orangeColor];
    
    // setup colors
    [[UISwitch appearanceWhenContainedIn:[JRTextCell class], nil] setOnTintColor:theme.accentColor];
    [[UISwitch appearanceWhenContainedIn:[JRTextCell class], nil] setThumbTintColor:theme.labelColor];
    [[UISwitch appearanceWhenContainedIn:[JRTextCell class], nil] setTintColor:theme.backgroundColor];
    [[JRTextCell appearanceWhenContainedIn:self.tableView.class, nil] setBackgroundColor:theme.foregroundColor];
    [[UITextField appearanceWhenContainedIn:[JRTextCell class], nil] setTextColor:theme.accentColor];
    [[UITextField appearanceWhenContainedIn:[JRTextCell class], nil] setTintColor:theme.accentColor];
    //    [[UILabel appearanceWhenContainedIn:[JRTextCell class], nil] setTextColor:[UIColor tlcLogInCellLabelColor]];
    
    self.navigationController.navigationBar.tintColor = theme.accentColor;
    self.navigationController.navigationBar.barTintColor = theme.navigationBarColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
}

- (void)submit {
    [self setShowingActivity:YES];

    JRLog(@"submitting");
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
                [spinner stopAnimating];
                self.navigationItem.rightBarButtonItem = rightBarItem;
                rightBarItem.enabled = NO;
                
                idField.enabled = passField.enabled = saveSwitch.enabled = YES;
                idField.textColor = passField.textColor =  theme.accentColor;
                idLabel.textColor = passLabel.textColor = theme.labelColor;
                saveSwitch.onTintColor = theme.labelColor;
                /*
                 [[UISwitch appearanceWhenContainedIn:[JRTextCell class], nil] setOnTintColor:theme.accentColor];
                 [[UISwitch appearanceWhenContainedIn:[JRTextCell class], nil] setThumbTintColor:theme.labelColor];
                 [[UISwitch appearanceWhenContainedIn:[JRTextCell class], nil] setTintColor:theme.backgroundColor];
                 [[JRTextCell appearanceWhenContainedIn:self.tableView.class, nil] setBackgroundColor:theme.foregroundColor];
                 */
                saveSwitch.onTintColor = theme.accentColor;
                saveSwitch.tintColor = theme.backgroundColor;
                saveSwitch.thumbTintColor = theme.labelColor;
                
            } break;
            default: {
                self.navigationItem.rightBarButtonItem = spinnerItem;
                [spinner startAnimating];
                
                [idField resignFirstResponder];
                [passField resignFirstResponder];
                idField.enabled = passField.enabled = saveSwitch.enabled = NO;
                idLabel.textColor = passLabel.textColor = theme.disabledColor;
                idField.textColor = passField.textColor = saveSwitch.onTintColor = theme.disabledColor;
                
            } break;
        }
    }
    
    _showingActivity = showingActivity;
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
            cell.backgroundColor = theme.foregroundColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            switch (indexPath.row) {
                case 0: {
                    cell.label.text = @"Employee ID";
                    cell.textField.placeholder = @"ex: a123456";
                    cell.textField.returnKeyType = UIReturnKeyNext;
                    cell.textField.delegate = self;
                    cell.textField.enablesReturnKeyAutomatically = YES;
            
//                    cell.textField.textColor = [UIColor tlcLogInCellTextColor];
                    
                    idField = cell.textField;
                    idLabel = cell.label;
                    
                } break;
                case 1: {
                    cell.label.text = @"Password";
                    cell.textField.placeholder = @"Required";
                    cell.textField.returnKeyType = UIReturnKeyGo;
                    cell.textField.secureTextEntry = YES;
                    cell.textField.enablesReturnKeyAutomatically = YES;
                    cell.textField.delegate = self;
                    
                    passField = cell.textField;
                    passLabel = cell.label;
                } break;
                case 2: {
                    cell.label.text = @"Preferred Name";
                    cell.textField.placeholder = @"Optional";
                } break;
                
            }
            idLabel.textColor = theme.labelColor;

            return cell;
        } break;
        case 1: {
            JRTextCell *cell = [[UINib nibWithNibName:@"TextCell" bundle:nil] instantiateWithOwner:self options:nil][0];
//            cell.backgroundColor = [UIColor tlcNavBarTintColor];
            cell.backgroundColor = theme.foregroundColor;
            
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *resolvedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    UITextField *other = textField == idField ? passField : idField;
    
    BOOL enableButton = other.text.length > 0 && resolvedString.length > 0;
    self.navigationItem.rightBarButtonItem.enabled = enableButton;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == idField)
        [passField becomeFirstResponder];
    else
        [self submit];
    
    return YES;
}

@end
