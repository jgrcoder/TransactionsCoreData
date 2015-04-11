//
//  Transaction+ToCoreData.m
//  TransactionsCoreData
//
//  Created by Jorge González on 11/04/15.
//  Copyright (c) 2015 Jorge González Recio. All rights reserved.
//

#import "Transaction+ToCoreData.h"

@implementation Transaction (ToCoreData)


// Method to add, remove and get


+(instancetype)adNewTransactionWith:(NSDictionary *) data inManagedObjectContext: (NSManagedObjectContext *) managedObjectContext{
  Transaction *newTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:managedObjectContext];
  
  newTransaction.skuCode = data[@"sku"];
  newTransaction.currency = data[@"currency"];
  newTransaction.amount = [NSNumber numberWithDouble:[data[@"amount"] doubleValue]];
  
  return newTransaction;
}

+(void)removeOldTransactionsInManagedObjectContext: (NSManagedObjectContext *) managedObjectContext{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Transaction"];
  [fetchRequest setPredicate: nil];
  
  NSError *error = nil;
  NSArray * oldTransactions = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  for (Transaction * transactionToDelete in oldTransactions){
    [managedObjectContext deleteObject:transactionToDelete];
  }
  
}

-(NSArray *)getAllTransactionsWithCode:(NSString *) skuCode withManagedObjectContext: (NSManagedObjectContext *) managedObjectContext{
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"skuCode == %@", skuCode];
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Transaction"];
  [fetchRequest setPredicate: predicate];
  fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"currency"
                                                                 ascending:YES
                                                                  selector:@selector(localizedStandardCompare:)]];
  
  NSError *error = nil;
  NSArray * transactionsArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  return transactionsArray;
  
  
}



@end
