//
//  TCDDetailViewController.h
//  TransactionsCoreData
//
//  Created by Jorge González on 11/04/15.
//  Copyright (c) 2015 Jorge González Recio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@interface TCDDetailViewController :  UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) Transaction * transactionSelected;

@end
