//
//  TableViewController.m
//  TableViewEditingHW
//
//  Created by Ivan Kozaderov on 26.06.2018.
//  Copyright © 2018 n1ke71. All rights reserved.
//

#import "TableViewController.h"
#import "Student.h"
#import "Group.h"

@interface TableViewController () 

@property (strong, nonatomic) NSMutableArray *studentsArray;
@property (strong, nonatomic) NSMutableArray *groupsArray;

@end

@implementation TableViewController


-(void) loadView{
    
    [super loadView];
    
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.dataSource = self;
    tableView.delegate   = self;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.studentsArray = [NSMutableArray array];
    self.groupsArray   = [NSMutableArray array];
    
    for (int j = 0; j < 5; j++) {
        
        Group *group = [[Group alloc]init];
        
        group.name = [NSString stringWithFormat:@"Group#%d",j];
        
        for (int i = 0; i < 15; i++) {
            
            Student *student = [Student randomStudent];
            
            [self.studentsArray addObject:student];
            
            
        }
        
        group.students = [NSArray arrayWithArray:self.studentsArray];
        
        [self.studentsArray removeAllObjects];
        
        [self.groupsArray addObject:group];
    }
    
    self.navigationController.title = @"Students";
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                             target:self
                                                                             action:@selector(actionEdit:)];
    
    self.navigationItem.rightBarButtonItem = editItem;
    
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(actionAddSection:)];
    
    self.navigationItem.leftBarButtonItem = addItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)actionEdit:(UIBarButtonItem *) sender{
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;

    if (self.tableView.editing) {
        
        item = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem* editItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:item
                                                                             target:self
                                                                             action:@selector(actionEdit:)];
    
    [self.navigationItem setRightBarButtonItem:editItem animated:YES];
    
}

- (void)actionAddSection:(UIBarButtonItem *) sender{
    
    Group *group = [[Group alloc]init];
    
    group.name = [NSString stringWithFormat:@"Group#%lu",[self.groupsArray count]];
    
    group.students = @[[Student randomStudent],[Student randomStudent]];
    
    NSInteger newSectionIndex = 0;
    
    [self.groupsArray insertObject:group atIndex:newSectionIndex];
    
    [self.tableView beginUpdates];
    
    NSIndexSet* insertSections = [NSIndexSet indexSetWithIndex:newSectionIndex];
    
    [self.tableView insertSections:insertSections withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.tableView endUpdates];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
        }
        
    });
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.groupsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    Group* group = [self.groupsArray objectAtIndex:section];
    
    return [group.students count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [[self.groupsArray objectAtIndex:section] name];;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.row == 0){
        
        static NSString *addStudentIdentifier = @"AddStudentCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addStudentIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addStudentIdentifier];
            cell.textLabel.textColor = [UIColor blueColor];
            cell.textLabel.text = @"Tap to add new student";
        }
        return cell;
    }
    
    else {
        
        static NSString *studentIdentifier = @"StudentCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studentIdentifier];
        
        if (! cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:studentIdentifier];
        }
        
        Group *group       = [self.groupsArray objectAtIndex:indexPath.section];
        Student *student   = [group.students objectAtIndex:indexPath.row - 1];
        
        cell.textLabel.text             = [NSString stringWithFormat:@"%@ %@",student.firstName,student.lastName];
        cell.detailTextLabel.textColor  = student.averageGrageColor;
        cell.detailTextLabel.text       = [NSString stringWithFormat:@"%1.1f",student.averageGrage];
        
        return cell;
        
    }
  
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.row > 0;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    Group *sourceGroup = [self.groupsArray objectAtIndex:sourceIndexPath.section];
    Student *student = [sourceGroup.students objectAtIndex:sourceIndexPath.row - 1];
    
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:sourceGroup.students];
    
    if (sourceIndexPath.section == destinationIndexPath.section) {
        
        [tempArray exchangeObjectAtIndex:sourceIndexPath.row - 1 withObjectAtIndex:destinationIndexPath.row - 1];
        
        sourceGroup.students = tempArray;
    }
    else{
        
        [tempArray removeObject:student];
        
        sourceGroup.students = tempArray;
        
        Group *destinationGroup = [self.groupsArray objectAtIndex:destinationIndexPath.section];
        
        tempArray = [NSMutableArray arrayWithArray:destinationGroup.students];
        
        [tempArray insertObject:student atIndex:destinationIndexPath.row - 1];
        
        destinationGroup.students = tempArray;
        
    }
    
}
#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.row == 0 ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    
    if (proposedDestinationIndexPath.row == 0) {
        
        return sourceIndexPath;
    }
    else return proposedDestinationIndexPath;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 0) {
        
        Group *group = [self.groupsArray objectAtIndex:indexPath.section];
        
        NSMutableArray *tempArray = nil;
        
        if (group.students) {
            
            tempArray = [NSMutableArray arrayWithArray:group.students];
            
        }
        else {
            
            tempArray = [NSMutableArray array];
            
        }
        
        
        NSInteger newStudentIndex = 0;
        
        [tempArray insertObject:[Student randomStudent] atIndex:newStudentIndex];
        
        group.students = tempArray;
        
        
        [self.tableView beginUpdates];
        
        NSIndexPath* newIndexPath = [NSIndexPath indexPathForItem:newStudentIndex + 1 inSection:indexPath.section];
        
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self.tableView endUpdates];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
            }
            
        });
        
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"Remove";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Group *group     = [self.groupsArray objectAtIndex:indexPath.section];
        Student *student = [group.students objectAtIndex:indexPath.row - 1];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:group.students];
        
        [tempArray removeObject:student];
        
        group.students = tempArray;
        
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationRight];
        
        [tableView endUpdates];
        
    }
 
}
@end
