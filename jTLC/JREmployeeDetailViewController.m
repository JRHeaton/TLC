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
#import "JRTextCell.h"

@interface JREmployeeDetailViewController () <UITextFieldDelegate>

@end

@implementation JREmployeeDetailViewController {
    JRMasterController *master;
    
    JRLightPlaceholderTextField *firstNameField;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadView {
    [super loadView];
    
    master = [JRMasterController sharedInstance];
    
    self.tableView.rowHeight = 64;
    self.tableView.separatorColor = master.colorTheme.tableSeparatorColor;
    self.tableView.backgroundColor = master.colorTheme.backgroundColor;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(confirmEmployee)];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.title = @"Employee";
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
    JRTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case 0: {
            cell.label.text = @"First Name";
            cell.textField.text = [self.employee.name componentsSeparatedByString:@" "][0];
//            cell.textField.clearButtonMode = UITextFieldViewModeUnlessEditing;
            cell.textField.delegate = self;
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
    
    cell.textField.textColor = master.colorTheme.disabledTextColor;
    
    return cell;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]].length > 0;
}

@end
