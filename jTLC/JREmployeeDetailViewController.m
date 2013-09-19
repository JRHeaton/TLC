//
//  JREmployeeDetailViewController.m
//  jTLC
//
//  Created by John Heaton on 9/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JREmployeeDetailViewController.h"
#import "GJB.h"
#import "JRMasterController.h"
#import "JRTextFieldCell.h"

@interface JREmployeeDetailViewController () <UITextFieldDelegate>

@end

@implementation JREmployeeDetailViewController {
    JRMasterController *master;
    
    UITextField *firstNameField;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.tableView.rowHeight = 64;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.title = @"Employee";
    [self.tableView registerNib:[UINib nibWithNibName:@"JRTextFieldCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    master = [JRMasterController sharedInstance];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(confirmEmployee)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyCurrentInterfaceTheme) name:JRInterfaceThemeChangedNotification object:nil];
    [self applyCurrentInterfaceTheme];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[JRInterfaceTheme currentTheme] statusBarStyle];
}

- (void)applyCurrentInterfaceTheme {
    JRInterfaceTheme *theme = [JRInterfaceTheme currentTheme];
    
    self.tableView.separatorColor = [theme colorForType:JRInterfaceColorTypeTableSeparator];
    self.tableView.backgroundColor = [theme colorForType:JRInterfaceColorTypeBackground];
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:Nil waitUntilDone:NO];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)confirmEmployee {
    if(self.completionBlock)
        self.completionBlock();
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [firstNameField resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.employee == nil ? 0 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.employee == nil ? 0 : (!section ? 1 : 4);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return !section ? @"Editable Information" : nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return section == 0 ? @"If your first name used by TLC is not the name you go by, you can change it here, and the app will remember." : nil;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UITableViewHeaderFooterView *)view forSection:(NSInteger)section {
    view.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    JRTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JRInterfaceTheme *theme = [JRInterfaceTheme currentTheme];
    
    cell.backgroundColor = [theme colorForType:JRInterfaceColorTypeForeground];
    cell.label.textColor = [theme colorForType:JRInterfaceColorTypeTitleText];
    cell.textField.textColor = cell.textField.tintColor = [theme colorForType:JRInterfaceColorTypeAccentPrimary];
    
    switch (indexPath.section) {
        case 0: {
            cell.label.text = @"First Name";
            cell.textField.text = [self.employee.name componentsSeparatedByString:@" "][0];
            cell.textField.delegate = self;
            cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Required" attributes:@{ NSForegroundColorAttributeName : [theme colorForType:JRInterfaceColorTypeDisabledText] }];
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            
            firstNameField = cell.textField;
            
            return cell;
        } break;
        case 1: {
            switch (indexPath.row) {
                case 0: cell.label.text = @"Last Name"; cell.textField.text = [self.employee.name componentsSeparatedByString:@" "][1]; break;
                case 1: cell.label.text = @"Employment Type"; cell.textField.text = self.employee.employmentStatus; break;
                case 2: cell.label.text = @"Store Number"; cell.textField.text = [NSString stringWithFormat:@"%d", self.employee.store.storeNumber]; break;
                case 3: cell.label.text = @"Department"; cell.textField.text = self.employee.department.name; break;
            }
            cell.textField.enabled = NO;
        } break;
    }
    
    cell.textField.textColor = [theme colorForType:JRInterfaceColorTypeDisabledText];
    
    return cell;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *resolved = [firstNameField.text stringByReplacingCharactersInRange:range withString:string];
    self.navigationItem.rightBarButtonItem.enabled = resolved.length > 0;
    
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]].length > 0;
}

@end
