//
//  CCContact.h
//  CCFC
//
//  Created by xichen on 11-12-16.
//  Copyright 2011年 ccteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface CCContact : NSObject 
{
    
}
 
// 调用联系人界面
+ (ABPeoplePickerNavigationController *)
               showAddressBookPeopleView:(id)delegate 
                                  withId:(ABPropertyID)propertyId 
                                animated:(BOOL)animated;

// 调用新建联系人界面
+ (ABNewPersonViewController *)showNewPersonView:(id)delegate  
										animated:(BOOL)animated;


@end
