//
//  CCContact.m
//  CCFC
//
//  Created by xichen on 11-12-16.
//  Copyright 2011年 ccteam. All rights reserved.
//

#import "CCContact.h"


@implementation CCContact

// 调用联系人界面
+ (ABPeoplePickerNavigationController *)
        showAddressBookPeopleView:(id)delegate 
                           withId:(ABPropertyID)propertyId 
                         animated:(BOOL)animated
{
    ABPeoplePickerNavigationController *peoplePicker = [ABPeoplePickerNavigationController new];
	if(!peoplePicker)
	{
		return nil;
	}
	[peoplePicker setPeoplePickerDelegate:delegate];
    
	//设置过滤属性
	[peoplePicker setDisplayedProperties:
     [NSArray arrayWithObject:[NSNumber numberWithInt:propertyId]]];
    
	//显示联系人界面
	[delegate presentModalViewController:peoplePicker animated:animated];
	[peoplePicker release];
	return peoplePicker;
}

// 调用新建联系人界面
+ (ABNewPersonViewController *)showNewPersonView:(id)delegate  
										animated:(BOOL)animated
{
	ABNewPersonViewController *newPersonVew = [ABNewPersonViewController new];
	if(!newPersonVew)
	{
		return nil;
	}
	
	newPersonVew.newPersonViewDelegate = delegate;
	[delegate presentModalViewController:newPersonVew animated:animated];
	
	[newPersonVew release];
	return newPersonVew;
}
 
@end
