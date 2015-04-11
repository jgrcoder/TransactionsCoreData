//
//  TCDTransactionsTableViewController.m
//  TransactionsCoreData
//
//  Created by Jorge González on 11/04/15.
//  Copyright (c) 2015 Jorge González Recio. All rights reserved.
//

#import "TCDTransactionsTableViewController.h"
#import "AppDelegate.h"
#import "Transaction.h"
#import "TCDDetailViewController.h"
#import "TCDConnectionManager.h"

@interface TCDTransactionsTableViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectCOntext;

@end

@implementation TCDTransactionsTableViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  [self setManagedObjectContext:[(AppDelegate *)([UIApplication sharedApplication].delegate) managedObjectContext]];
  
}



- (IBAction)refreshData:(UIBarButtonItem *)sender {
  [[[TCDConnectionManager alloc] init] getTransactionsFromService];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transaction cell" forIndexPath:indexPath];
  
  
  Transaction *transaction = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  cell.textLabel.text = [NSString stringWithFormat:@"Item %li", (long)indexPath.row + 1];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %.2f : %@", transaction.skuCode, [transaction.amount doubleValue], transaction.currency];
  
  return cell;
}



#pragma mark - NSfetchedresultcontroller methods

-(NSFetchedResultsController *)fetchedResultsController {
  if (_fetchedResController != nil) {
    return _fetchedResController;
  }
  
  // Load data with keypath to view sections headers...
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:_managedObjectCOntext];
  [request setEntity:entity];
  
  NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"skuCode" ascending:YES];
  [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
  
  NSFetchedResultsController *fetchedResController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_managedObjectCOntext sectionNameKeyPath:@"skuCode" cacheName:nil];
  
  
  self.fetchedResController = fetchedResController;
  _fetchedResController.delegate = self;
  
  return _fetchedResController;
}


-(void)setManagedObjectContext:(NSManagedObjectContext *) managedObjectContext {
  _managedObjectCOntext = managedObjectContext;
  
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Transaction"];
  request.predicate = nil;
  request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"skuCode" ascending:YES selector:@selector(localizedStandardCompare:)],
                              [NSSortDescriptor sortDescriptorWithKey:@"currency" ascending:YES selector:@selector(localizedStandardCompare:)]
                              ];
  
  self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_managedObjectCOntext sectionNameKeyPath:nil cacheName:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  
  Transaction * transaction = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
  
  if ([segue.identifier isEqualToString:@"detailSegue"]) {
    TCDDetailViewController * detailViewController = segue.destinationViewController;
    
    if (detailViewController){
      detailViewController.transactionSelected = transaction;
    }
  }
}



@end
