//
//  Reponse.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reponse : NSObject

@property (nonatomic) int reponse_id;
@property (nonatomic) int question_id;
@property (nonatomic, strong) NSString* reponse;
@property (nonatomic) BOOL reponse_correcte;
@property (nonatomic) int question_suivante_id;
@property (nonatomic, strong) NSString* image;

@end
