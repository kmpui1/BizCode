//
//  NamecardViewController.m
//  Business Card
//
//  Created by Kar Mun Pui on 8/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import "NamecardsViewController.h"

@interface NamecardsViewController ()

@property (strong, nonatomic) NSMutableArray *namecards;
@property (nonatomic) int pageToGo;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation NamecardsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self useDocument];
    self.pageToGo = 0;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


//Update the content every time appear the view
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performFetch];
    [self.tableView reloadData];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self useDocument];
    [self performFetch];
    self.pageToGo = 0;
    [super viewDidDisappear:animated];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self performFetch];
}

- (void)useDocument
{
    //base document url
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    //directory for our data storage
    url = [url URLByAppendingPathComponent:@"NamecardDocument"];
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
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"NamecardData1"];
    
    //sort the namecards according to the name
    NSSortDescriptor* nameSort = [NSSortDescriptor sortDescriptorWithKey:@"name"ascending:YES];
    [fetchRequest setSortDescriptors:@[nameSort]];
    
    self.namecards = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    [self performFetch];
}

-(void)setNamecards:(NSMutableArray *)namecards{

    _namecards = namecards;
    
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
    return self.namecards.count;
}

//NSSet *mySet = [NSSet setWithArray:self.namecards];
//NSArray *newArr = [mySet allObjects];
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NamecardCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSManagedObject *namecard = [self.namecards objectAtIndex:indexPath.row];
    [cell.textLabel setText:[namecard valueForKey:@"name"]];
    NSLog(@"%@ from %@", [namecard valueForKey:@"name"], [namecard valueForKey:@"company"]);
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ %@", [namecard valueForKey:@"position"], [namecard valueForKey:@"company"]]];
   
    
    
    
    return cell;
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     // Return NO if you do not want the specified item to be editable.
     return YES;
 }



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
         // Delete the row from the data source
     NSManagedObjectContext *context = [self managedObjectContext];
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete object from database
         [context deleteObject:[self.namecards objectAtIndex:indexPath.row]];
         
         NSError *error = nil;
         if (![context save:&error]) {
             NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
             return;
         }
         
         // Remove namecard from table view
         
         [self.namecards removeObjectAtIndex:indexPath.row];
         [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
 }


 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     if ([[segue identifier] isEqualToString:@"LoadSegue"]) {
         
         
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         self.indexPath = indexPath;
         NSManagedObject *selectedNamecard = [self.namecards objectAtIndex:indexPath.row];
         NamecardDetailsViewController *controller = segue.destinationViewController;
         controller.namecard = [self.namecards objectAtIndex:indexPath.row];
         controller.managedObjectContext = selectedNamecard.managedObjectContext;
         controller.namecardName = [selectedNamecard valueForKey:@"name"];
         controller.namecardId = [selectedNamecard valueForKey:@"identity"];
         controller.page = 1;
     }
 }
@end
