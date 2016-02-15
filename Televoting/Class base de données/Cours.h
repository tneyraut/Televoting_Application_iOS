//
//  Cours.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cours : NSObject

@property (nonatomic) int cours_id;
@property (nonatomic) int user_id;
@property (nonatomic, strong) NSString* cours_name;
@property (nonatomic) int annee;

@end
