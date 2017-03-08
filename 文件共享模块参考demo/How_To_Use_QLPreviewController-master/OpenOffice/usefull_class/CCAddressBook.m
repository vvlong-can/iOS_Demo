//
//  CCAddressBook.m
//  CCFC
//
//  Created by xichen on 11-12-16.
//  Copyright 2011年 ccteam. All rights reserved.
//

#import "CCAddressBook.h"

@implementation CCAddressBook

- (id)init
{
    self = [super init];
    if(self)
    {
        _addressBook = ABAddressBookCreate();
        _abAllPeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(_addressBook);
        _abGroups = (NSArray *)ABAddressBookCopyArrayOfAllGroups(_addressBook);
    }
    return self;
}


- (void)dealloc
{
	CFRelease(_addressBook);
    CFRelease(_abAllPeople);
    CFRelease(_abGroups);
    [super dealloc];
}

- (int)getABRecordCount
{
    return [_abAllPeople count];
}

- (int)getABGroupCount
{
    return [_abGroups count];
}


- (ABRecordRef)getABRecordRefByIndex:(int)index
{
    return [_abAllPeople objectAtIndex:index];
} 

- (ABRecordID)getABRecordIDByIndex:(int)index
{
    return ABRecordGetRecordID([self getABRecordRefByIndex:index]);
}

// 获得通讯录联系人的全名
// 和getFullNameByRecord略有不同，例如，如果通讯录的姓保存的是"陈",名保存的是"曦",那么此得到的
// 是 "陈 曦", getFullNameByRecord得到的是"陈曦"
- (NSString *)getCompositeNameByIndex:(int)index
{
    return [(NSString *)ABRecordCopyCompositeName([self getABRecordRefByIndex:index]) autorelease];
}

- (NSMutableArray *)getPhoneNumberArrByIndex:(int)index
{
    ABRecordRef ref = [self getABRecordRefByIndex:index];
    // 获取号码数组
	ABMultiValueRef tempArr = (ABMultiValueRef)ABRecordCopyValue(ref, kABPersonPhoneProperty);
	if(!tempArr)
	{
		return nil;
	}
    
	NSMutableArray *phoneArr  = [NSMutableArray new];
	for(int i = 0; i < ABMultiValueGetCount(tempArr); ++i)
	{
		NSString *phoneNo = (NSString *)ABMultiValueCopyValueAtIndex(tempArr, i); 
		[phoneArr addObject:phoneNo];		// 依次将号码加入新数组中
		CFRelease(phoneNo);
	}
	
	CFRelease(tempArr);
	return [phoneArr autorelease];
}

// 根据ABRecordRef获取联系人姓名全称
- (NSString *)getFullNameByRecord:(ABRecordRef)record
{
	NSString *firstName = (NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
    NSString *midName = (NSString *)ABRecordCopyValue(record, kABPersonMiddleNameProperty);
	NSString *lastName = (NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
    
	
	if(firstName == nil)
		firstName = @"";
    if(midName == nil)
		midName = @"";
	if(lastName == nil)
		lastName = @"";
	
	CFRelease(firstName);
	CFRelease(lastName);
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *langName = [languages objectAtIndex:0];
	// 不需要使用 MiddleName
    if([langName isEqualToString:@"en"])
        return [NSString stringWithFormat:@"%@ %@", firstName, lastName]; 
    else if([langName isEqualToString:@"zh-Hans"])
        return [NSString stringWithFormat:@"%@%@", lastName, firstName]; 
    else
        return [NSString stringWithFormat:@"%@%@%@", firstName, midName, lastName];
}

// 根据index获取联系人姓名全称
- (NSString *)getFullNameByIndex:(int)index
{
    ABRecordRef ref = [self getABRecordRefByIndex:index];
    return  [self getFullNameByRecord:ref];
}

// get the person photo img data
- (NSData *)getPersonPhotoImgData:(ABRecordRef)record
{
	return (NSData *)ABPersonCopyImageData(record);
}

// get the first name phonetic str	// not ok
+ (NSString *)getFirstNamePhonetic:(ABRecordRef)record
{
	return (NSString *)ABRecordCopyValue(record, kABPersonFirstNamePhoneticProperty);
}

// get the last name phonetic str	// not ok
+ (NSString *)getLastNamePhonetic:(ABRecordRef)record
{
	return (NSString *)ABRecordCopyValue(record, kABPersonLastNamePhoneticProperty);
}

@end
