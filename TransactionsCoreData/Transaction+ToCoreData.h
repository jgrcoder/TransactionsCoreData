//
//  Transaction+ToCoreData.h
//  TransactionsCoreData
//
//  Created by Jorge González on 11/04/15.
//  Copyright (c) 2015 Jorge González Recio. All rights reserved.
//

#import "Transaction.h"

@interface Transaction (ToCoreData)


+(instancetype)adNewTransactionWith:(NSDictionary *) data inManagedObjectContext: (NSManagedObjectContext *) managedObjectContext;

+(void)removeOldTransactionsInManagedObjectContext: (NSManagedObjectContext *) managedObjectContext;

-(NSArray *)getAllTransactionsWithCode:(NSString *) skuCode withManagedObjectContext: (NSManagedObjectContext *) managedObjectContext;



@end
