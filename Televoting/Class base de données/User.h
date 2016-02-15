//
//  User.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) int user_id;
@property (nonatomic, strong) NSString* login;
@property (nonatomic, strong) NSString* password;
@property (nonatomic) int annee;
@property (nonatomic) int promotion;
@property (nonatomic) bool professeur;

@end
