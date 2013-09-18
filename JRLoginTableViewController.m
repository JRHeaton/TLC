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
#import "JRAboutViewController.h"
#import "JREmployeeDetailViewController.h"
#import "JRNavigationBar.h"

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
    
    // about
    UINavigationController *aboutNavContainer;
    JRAboutViewController *aboutViewController;
    
    JREmployeeDetailViewController *employeeDetailController;
    
    JRNavigationBar *navBar;
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
    
    aboutViewController = [[JRAboutViewController alloc] init];
//    aboutViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    employeeDetailController = [[JREmployeeDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    aboutNavContainer = [master newThemedNavController];
    aboutNavContainer.navigationBar.translucent = NO;
    [aboutNavContainer pushViewController:aboutViewController animated:NO];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    spinner.color = master.colorTheme.accentColor;
    spinnerItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];

    rightBarItem.enabled = NO;
    
    //    self.tableView.backgroundColor = [UIColor tlcBackgroundColor];
    self.title = @"Log In";
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//    self.tableView.backgroundColor = theme.backgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:@"Text"];
    self.tableView.rowHeight = 64;
    self.tableView.separatorColor = theme.tableSeparatorColor;
    
    saveSwitch = [UISwitch new];
    saveSwitch.on = YES;
    //    saveSwitch.onTintColor = [UIColor orangeColor];
    
    
    // COLORS
    JRThemeManager *m = [JRThemeManager sharedInstance];
    [m registerView:self.tableView keyPath:JRThemeManagerKeyPathBackgroundColor colorType:JRThemeColorTypeBackground];
//    [m registerViewOrAppearance:[UISwitch appearanceWhenContainedIn:[JRTextCell class], nil] keyPath:JRThemeManagerKeyPathThumbTintColor colorType:JRThemeColorTypeBackground];
    
    NSLog(@"%@", ((JRNavigationController *) self.navigationController).navigationBar.progressView);
 
    // setup colors
    [[UISwitch appearanceWhenContainedIn:[JRTextCell class], nil] setOnTintColor:theme.accentColor];
//    [[UISwitch appearanceWhenContainedIn:[JRTextCell class], nil] setThumbTintColor:theme.backgroundColor];
    [[UISwitch appearanceWhenContainedIn:[JRTextCell class], nil] setTintColor:theme.accentColor];
    [[JRTextCell appearanceWhenContainedIn:self.tableView.class, nil] setBackgroundColor:theme.foregroundColor];
    [[UITextField appearanceWhenContainedIn:[JRTextCell class], nil] setTextColor:theme.accentColor];
    [[UITextField appearanceWhenContainedIn:[JRTextCell class], nil] setTintColor:theme.accentColor];
    //    [[UILabel appearanceWhenContainedIn:[JRTextCell class], nil] setTextColor:[UIColor tlcLogInCellLabelColor]];
}

- (void)themeChanged:(JRTheme *)theme {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navBar = (JRNavigationBar *)self.navigationController.navigationBar;
//    navBar.progressView.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(presentAboutUI)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(idField.text.length > 0 && passField.text.length > 0)
        self.navigationItem.rightBarButtonItem.enabled = YES;
    
//    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
//    self.navigationController.navigationBar.translucent = YES;
}

- (void)presentAboutUI {
    if(!self.showingActivity) {
        [self presentViewController:aboutNavContainer animated:YES completion:nil];
    }
}

- (void)pushEmployeeDetail {
    employeeDetailController.employee = sessionCandidate.employee;
    __unsafe_unretained JRLoginTableViewController *_self = self;
    __unsafe_unretained TKSession *session = sessionCandidate;
    employeeDetailController.completionBlock = ^{
        if(_self.completionBlock) {
            _self.completionBlock(session);
        }
    };
    [self.navigationController pushViewController:employeeDetailController animated:YES];
    
    self.showingActivity = NO;
}

- (void)setProgress:(CGFloat)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!progress) {
            if(navBar.progressView.progress == 1) {
                [UIView animateWithDuration:0.3 animations:^{
                    navBar.progressView.alpha = 0;
                } completion:^(BOOL finished) {
                    navBar.progressView.progress = 0;
                    navBar.progressView.hidden = YES;
                    navBar.progressView.alpha = 1;
                }];
            } else {
                navBar.progressView.hidden = YES;
                navBar.progressView.progress = 0;
            }
        } else {
            navBar.progressView.hidden = NO;
            [navBar.progressView setProgress:progress animated:YES];
            
            if(progress == 1) {
                double delayInSeconds = 0.3;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self setProgress:0];
                });
            }
        }
    });
}

- (void)submit {
    [self setShowingActivity:YES];

    JRLog(@"submitting");
    sessionCandidate = [TKSession sessionForEmployee:[TKEmployee employeeWithID:idField.text password:passField.text]];
//    [self setProgress:0.2];
    [self setNavigationBarProgress:0.2];
//    navBar.progressView.hidden
    [sessionCandidate logIn:^(BOOL success, NSString *errorString) {
        if(!success) {
            [self setNavigationBarProgress:0];
            [self performSelectorOnMainThread:@selector(reflectLogInErrorInUI) withObject:nil waitUntilDone:NO];
        }
        else {
//            if(self.completionBlock)
//                self.completionBlock(sessionCandidate);
            
            [self setNavigationBarProgress:0.5];

//            [self setProgress:0.5];
            [sessionCandidate fetchEmployeeInfo:^(BOOL success) {
                if(!success) {
                    [self setNavigationBarProgress:0];
                    [sessionCandidate logOut];
                    [self performSelectorOnMainThread:@selector(reflectLogInErrorInUI) withObject:nil waitUntilDone:NO];
                } else {
                    [self setNavigationBarProgress:1];
                    [self performSelectorOnMainThread:@selector(pushEmployeeDetail) withObject:nil waitUntilDone:NO];
                }
            }];

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
        rightBarItem.enabled = NO;
        switch (showingActivity) {
            case NO: {
                
                [spinner stopAnimating];
                self.navigationItem.rightBarButtonItem = rightBarItem;
                self.navigationItem.leftBarButtonItem.enabled = YES;
                
                idField.enabled = passField.enabled = saveSwitch.enabled = YES;
                idField.textColor = passField.textColor =  theme.accentColor;
                idLabel.textColor = passLabel.textColor = theme.labelColor;
                saveSwitch.onTintColor = theme.labelColor;

                saveSwitch.onTintColor = theme.accentColor;
                saveSwitch.tintColor = theme.accentColor;
                saveSwitch.thumbTintColor = theme.backgroundColor;
                
            } break;
            default: {
                self.navigationItem.rightBarButtonItem = spinnerItem;
                [spinner startAnimating];
                self.navigationItem.leftBarButtonItem.enabled = NO;
                
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
                    cell.textField.keyboardAppearance = UIKeyboardAppearanceDark;
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
                    cell.textField.clearsOnBeginEditing = YES;
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
