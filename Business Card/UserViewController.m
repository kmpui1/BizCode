//
//  UserViewController.m
//  Business Card
//
//
//
//  Created by Kar Mun Pui on 6/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController ()

@property (strong, nonatomic) NSMutableArray *users;

@end

@implementation UserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self useDocument];
    [self.tableView reloadData];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

}

//Update the content every time appear the view
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self useDocument];
    [self.tableView reloadData];
    
}

- (void)useDocument
{
    //base document url
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    //directory for our data storage
    url = [url URLByAppendingPathComponent:@"UserDocument"];
    //create document object
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        //create file path for document object
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  self.managedObjectContext = document.managedObjectContext;
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        //active document object
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    } else {
        self.managedObjectContext = document.managedObjectContext;
    }
}


-(void)performFetch{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Users"];
    self.users = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    [self performFetch];
}

-(void)setUsers:(NSMutableArray *)users{
    
    _users = users;
    [self.tableView reloadData];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSManagedObject *user = [self.users objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", [user valueForKey:@"title"], [user valueForKey:@"name"]]];
    [cell.detailTextLabel setText:[user valueForKey:@"position"]];
    
    return cell;
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ShowProfileSegue"]) {
        
        NSManagedObject *selectedUser = [self.users objectAtIndex:0];
        UserNamecardViewController *controller = segue.destinationViewController;
        controller.user = selectedUser;
    }
    else if ([[segue identifier] isEqualToString:@"AddSegue"]) {
        if (self.users.count > 0) {
            NSManagedObject *selectedUser = [self.users objectAtIndex:0];
            
            UserDetailsViewController *controller = segue.destinationViewController;
            controller.user = selectedUser;
            controller.number = self.users.count;
        }
        
    }
}


@end
