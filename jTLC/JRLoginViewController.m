//
//  JRLoginViewController.m
//  jTLC
//
//  Created by John Heaton on 9/18/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRLoginViewController.h"
#import "JRInterfaceTheme.h"
#import "JRTextFieldCell.h"
#import "JRColorCircleView.h"
#import "JRNavigationController.h"
#import "JREmployeeDetailViewController.h"
#import "TLCKit.h"

@interface JRLoginViewController ()

@property (nonatomic, readonly, strong) JRNavigationController *navigationController;

@end

@implementation JRLoginViewController {
    // Cell controls
    UISwitch        *saveSwitch;
    UITextField     *employeeIDField;
    UITextField     *passwordField;
    UITextField     *flaggedKeyboardField;
    
    // Progress views
    UIProgressView  *navProgressView;
    UIActivityIndicatorView *spinner;
    
    // Bar items
    UIBarButtonItem *leftItem;
    UIBarButtonItem *rightItem;
    UIBarButtonItem *spinnerItem;
    
    // Session
    TKSession       *sessionCandidate;
    
    // Detail view controller
    JREmployeeDetailViewController *employeeDetailController;
}

- (id)init {
    return self = [super initWithStyle:UITableViewStyleGrouped];
}

- (void)loadView {
    [super loadView];
    
    self.title = @"Log In";
    
    self.tableView.rowHeight = 65;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerNib:[UINib nibWithNibName:@"JRTextFieldCell" bundle:nil] forCellReuseIdentifier:@"TextCell"];
    
    navProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [navProgressView sizeToFit];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    saveSwitch = [UISwitch new];
    saveSwitch.on = YES;
}

- (void)reset {
    self.employeeID = nil;
    self.password = nil;
    sessionCandidate = nil;
    employeeIDField.text = nil;
    passwordField.text = nil;
    flaggedKeyboardField = nil;
    self.automaticallyShowKeyboard = NO;
    
    [self.navigationController setNavigationBarProgress:0];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[JRInterfaceTheme currentTheme] statusBarStyle];
}

- (JRNavigationController *)navigationController {
    return [super navigationController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyCurrentInterfaceTheme) name:JRInterfaceThemeChangedNotification object:nil];
    
    leftItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(aboutPressed)];
    rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    
    spinnerItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    employeeDetailController = [[JREmployeeDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];

    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self applyCurrentInterfaceTheme];
}

- (void)applyCurrentInterfaceTheme {
    JRInterfaceTheme *theme = [JRInterfaceTheme currentTheme];
    
    navProgressView.progressTintColor = [theme colorForType:JRInterfaceColorTypeAccentPrimary];
    
    self.tableView.separatorColor = [theme colorForType:JRInterfaceColorTypeTableSeparator];
    self.tableView.backgroundColor = [theme colorForType:JRInterfaceColorTypeBackground];
    
    saveSwitch.onTintColor = [theme colorForType:JRInterfaceColorTypeAccentPrimary];
    saveSwitch.tintColor = [theme colorForType:JRInterfaceColorTypeAccentPrimary];
    saveSwitch.thumbTintColor = [theme colorForType:JRInterfaceColorTypeSwitchThumbTint];
    
    spinner.color = [theme colorForType:JRInterfaceColorTypeAccentPrimary];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)aboutPressed {
    
}

- (NSString *)employeeID {
    return employeeIDField.text;
}

- (NSString *)password {
    return passwordField.text;
}

- (void)pushEmployeeDetail {
    employeeDetailController.employee = sessionCandidate.employee;
    __unsafe_unretained JRLoginViewController *_self = self;
    __unsafe_unretained TKSession *session = sessionCandidate;
    employeeDetailController.completionBlock = ^{
//        if(_self.completionBlock) {
//            _self.completionBlock(session);
//        }
        
        JRLog(@"Done");
    };
    
    NSLog(@"%@", employeeDetailController);

    [self.navigationController pushViewController:employeeDetailController animated:YES];
    
    self.showingActivity = NO;
}

- (void)submit {
    [self setShowingActivity:YES];
    
    sessionCandidate = [TKSession sessionForEmployee:[TKEmployee employeeWithID:employeeIDField.text password:passwordField.text]];
    [self.navigationController setNavigationBarProgress:0.2];
    [sessionCandidate logIn:^(BOOL success, NSString *errorString) {
        NSLog(@"%d succ log", success);
        if(!success) {
            [self.navigationController setNavigationBarProgress:0];
            [self performSelectorOnMainThread:@selector(reflectLogInErrorInUI) withObject:nil waitUntilDone:NO];
        }
        else {
            [self.navigationController setNavigationBarProgress:0.5];
            
            [sessionCandidate fetchEmployeeInfo:^(BOOL success) {
                if(!success) {
                    [self.navigationController setNavigationBarProgress:0];
                    [sessionCandidate logOut];
                    [self performSelectorOnMainThread:@selector(reflectLogInErrorInUI) withObject:nil waitUntilDone:NO];
                } else {
                    [self.navigationController setNavigationBarProgress:1];
                    [self performSelectorOnMainThread:@selector(pushEmployeeDetail) withObject:nil waitUntilDone:NO];
                }
            }];
            
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem.enabled = (employeeIDField.text.length > 0 && passwordField.text.length > 0);
}

- (void)setShowingActivity:(BOOL)showingActivity {
    if(showingActivity != self.showingActivity) {
        JRInterfaceTheme *theme = [JRInterfaceTheme currentTheme];
        
        rightItem.enabled = NO;
        switch (showingActivity) {
            case NO: {
                [spinner stopAnimating];
                self.navigationItem.rightBarButtonItem = rightItem;
                self.navigationItem.leftBarButtonItem.enabled = YES;
                
                employeeIDField.enabled = passwordField.enabled = saveSwitch.enabled = YES;
                employeeIDField.textColor = passwordField.textColor = [theme colorForType:JRInterfaceColorTypeAccentPrimary];
//                idLabel.textColor = passLabel.textColor = theme.labelColor;
                
                saveSwitch.onTintColor = [theme colorForType:JRInterfaceColorTypeAccentPrimary];
                saveSwitch.tintColor = [theme colorForType:JRInterfaceColorTypeAccentPrimary];
                saveSwitch.thumbTintColor = [theme colorForType:JRInterfaceColorTypeSwitchThumbTint];
                
            } break;
            default: {
                self.navigationItem.rightBarButtonItem = spinnerItem;
                [spinner startAnimating];
                self.navigationItem.leftBarButtonItem.enabled = NO;
                
                [employeeIDField resignFirstResponder];
                [passwordField resignFirstResponder];
                employeeIDField.enabled = passwordField.enabled = saveSwitch.enabled = NO;
//                idLabel.textColor = passLabel.textColor = theme.disabledColor;
                employeeIDField.textColor = passwordField.textColor = saveSwitch.onTintColor = [theme colorForType:JRInterfaceColorTypeDisabledText];
                
            } break;
        }
    }
    
    _showingActivity = showingActivity;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(flaggedKeyboardField == employeeIDField && indexPath.row == 0)
//        [flaggedKeyboardField becomeFirstResponder];
//    if(flaggedKeyboardField == passwordField && indexPath.row == 1)
//        [flaggedKeyboardField becomeFirstResponder];
    
}

- (void)reflectLogInErrorInUI {
    [self setShowingActivity:NO];
    passwordField.text = nil;
    [passwordField becomeFirstResponder];
}


#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"ETK CREDENTIALS"; break;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return 2; break;
        case 1: return 1; break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TextCell";
    JRTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    JRInterfaceTheme *theme = [JRInterfaceTheme currentTheme];
    
    cell.backgroundColor = [theme colorForType:JRInterfaceColorTypeForeground];
    cell.textField.textColor = cell.textField.tintColor = [theme colorForType:JRInterfaceColorTypeAccentPrimary];
    cell.label.textColor = [theme colorForType:JRInterfaceColorTypeTitleText];
    cell.textField.keyboardAppearance = theme.keyboardAppearance;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    cell.label.text = @"Employee ID";
                    cell.textField.text = _employeeID;
                    cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ex: a123456" attributes:@{ NSForegroundColorAttributeName : [theme colorForType:JRInterfaceColorTypeDisabledText] }];
                    employeeIDField = cell.textField;
                    employeeIDField.delegate = self;
                } break;
                case 1: {
                    cell.label.text = @"Password";
                    cell.textField.text = _password;
                    cell.textField.secureTextEntry = YES;
                    cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Required" attributes:@{ NSForegroundColorAttributeName : [theme colorForType:JRInterfaceColorTypeDisabledText] }];
                    passwordField = cell.textField;
                    passwordField.delegate = self;
                } break;
            }
        } break;
        case 1: {
            [cell.textField removeFromSuperview];
            cell.label.text = @"Stay Logged In";
            cell.accessoryView = saveSwitch;
        } break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UITableViewHeaderFooterView *)view forSection:(NSInteger)section {
    view.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == 1) {
        return @"Your employee id and password are never shared or uploaded, and are encrypted when saved.";
    }
    
    return nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *resolvedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    UITextField *other = textField == employeeIDField ? passwordField : employeeIDField;
    
    BOOL enableButton = other.text.length > 0 && resolvedString.length > 0;
    self.navigationItem.rightBarButtonItem.enabled = enableButton;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == employeeIDField)
        [passwordField becomeFirstResponder];
    else
        [self submit];
    
    return YES;
}

@end
