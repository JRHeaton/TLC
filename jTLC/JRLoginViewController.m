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

@interface JRLoginViewController ()

@end

@implementation JRLoginViewController {
    // Cell controls
    UISwitch        *saveSwitch;
    UITextField     *employeeIDField;
    UITextField     *passwordField;
    
    UIProgressView  *navProgressView;
    
    UIBarButtonItem *leftItem;
    UIBarButtonItem *rightItem;
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
    
    saveSwitch = [UISwitch new];
    saveSwitch.on = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[JRInterfaceTheme currentTheme] statusBarStyle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyCurrentInterfaceTheme) name:JRInterfaceThemeChangedNotification object:nil];
    
    leftItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(aboutPressed)];
    rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStylePlain target:self action:@selector(goPressed)];

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
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)aboutPressed {
    
}

- (void)goPressed {
    [((JRNavigationController *)self.navigationController) setNavigationBarProgress:0.5];
}

- (NSString *)employeeID {
    return employeeIDField.text;
}

- (NSString *)password {
    return passwordField.text;
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
                } break;
                case 1: {
                    cell.label.text = @"Password";
                    cell.textField.text = _password;
                    cell.textField.secureTextEntry = YES;
                    cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Required" attributes:@{ NSForegroundColorAttributeName : [theme colorForType:JRInterfaceColorTypeDisabledText] }];
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

@end
