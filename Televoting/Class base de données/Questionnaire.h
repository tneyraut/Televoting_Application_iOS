//
//  Questionnaire.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Questionnaire : NSObject

@property (nonatomic) int questionnaire_id;
@property (nonatomic) int cours_id;
@property (nonatomic, strong) NSString* questionnaire_name;
@property (nonatomic) BOOL mode_examen;
@property (nonatomic) float malus;
@property (nonatomic) BOOL pause;

@end
