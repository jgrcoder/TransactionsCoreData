//
//  TCDDetailViewController.m
//  TransactionsCoreData
//
//  Created by Jorge González on 11/04/15.
//  Copyright (c) 2015 Jorge González Recio. All rights reserved.
//

#import "TCDDetailViewController.h"
#import "AppDelegate.h"
#import "Transaction.h"
#import "Transaction+ToCoreData.h"

@interface TCDDetailViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSManagedObjectContext * managedObjectContext;

@end

@implementation TCDDetailViewController

{
  NSMutableArray * transactions;
  NSMutableArray * distinctCurrencies;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  if (_transactionSelected){
    
    self.title = _transactionSelected.skuCode;
    
    transactions = [[NSMutableArray alloc] init];
    distinctCurrencies = [[NSMutableArray alloc] init];
    
    [self loadTransactionsWithSku];
    [self getDistinctCurrencies];
    [self.tableView reloadData];
  }
}

-(void) loadTransactionsWithSku {
  
  NSArray * skuArray = [_transactionSelected getAllTransactionsWithCode:_transactionSelected.skuCode
                                               withManagedObjectContext:_transactionSelected.managedObjectContext];
  
  transactions = [NSMutableArray arrayWithArray:skuArray];
}

-(void) getDistinctCurrencies {
  
  distinctCurrencies = [transactions valueForKeyPath:@"@distinctUnionOfObjects.currency"];
  distinctCurrencies = [NSMutableArray arrayWithArray:[distinctCurrencies sortedArrayUsingSelector:@selector(localizedStandardCompare:)]];
  //NSLog(@"Distinct: %@", distinctCurrencies);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return [distinctCurrencies count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 65;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail cell" forIndexPath:indexPath];
  
  NSString * currency = distinctCurrencies[indexPath.row];
  
  cell.textLabel.text = currency;
  cell.detailTextLabel.text = [self calculateSumOfCurrenciesWith: currency];
  
  return cell;
}

// Get all currencies with same kind and sum its amounts
-(NSString *) calculateSumOfCurrenciesWith: (NSString *) currency {
  
  NSPredicate *predicateGetActualCurrency = [NSPredicate predicateWithFormat:@"currency == %@", currency];
  NSArray * arrayOfTransactions = [transactions filteredArrayUsingPredicate:predicateGetActualCurrency];
  
  NSNumber * total = [arrayOfTransactions valueForKeyPath:@"@sum.amount"];
  NSString * totalFormatted = [NSNumberFormatter localizedStringFromNumber:total numberStyle:NSNumberFormatterDecimalStyle];
  
  return totalFormatted;
}



@end
