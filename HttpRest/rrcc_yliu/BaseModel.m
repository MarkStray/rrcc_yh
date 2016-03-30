//
//  BaseModel.m
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

- (id)initWithDictionary:(NSDictionary*)jsonDic {
    if ((self = [super init])) {
        [self setValuesForKeysWithDictionary:jsonDic];
    }
    return self;
}

+ (id)creatWithDictionary:(NSDictionary *)jsonDic {
    return [[self alloc] initWithDictionary:jsonDic];
}

// override
- (NSString *)description {
    unsigned int outCount, i;
    objc_property_t *properties =class_copyPropertyList([self class], &outCount);
    NSMutableString *mutableString = [NSMutableString stringWithFormat:@"[ %@ ] -->\n",[self class]];
    
    for (i = 0; i<outCount; i++) {
        
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:char_f];
        
        NSString *value = [self valueForKey:key];
        
        NSString *key_value = [NSString stringWithFormat:@"--> %@ : %@;\n",key,value];
        
        [mutableString appendString:key_value];

    }
    
    return mutableString;
}


#pragma mark key不存在
- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

#pragma mark 数据持久化

#if 1

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        unsigned int outCount, i;
        objc_property_t *properties =class_copyPropertyList([self class], &outCount);
        
        for (i = 0; i<outCount; i++)
        {
            objc_property_t property = properties[i];
            const char* char_f = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            
            NSString *capital = [[propertyName substringToIndex:1] uppercaseString];
            NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[propertyName substringFromIndex:1]];
            
            SEL sel = NSSelectorFromString(setterSelStr);
            
            [self performSelectorOnMainThread:sel
                                   withObject:[aDecoder decodeObjectForKey:propertyName]
                                waitUntilDone:[NSThread isMainThread]];
        }
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount, i;
    objc_property_t *properties =class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        
        if (propertyValue)
        {
            [aCoder encodeObject:propertyValue forKey:propertyName];
        }
    }
}


#else

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    if (self) {
        Class cls = [self class];
        while (cls != [NSObject class]) {
            unsigned int numberOfIvars =0;
            Ivar* ivars = class_copyIvarList(cls, &numberOfIvars);
            for(const Ivar* p = ivars; p < ivars+numberOfIvars; p++){
                Ivar const ivar = *p;
                const char *type =ivar_getTypeEncoding(ivar);
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
                id value = [decoder decodeObjectForKey:key];
                if (value) {
                    switch (type[0]) {
                        case _C_STRUCT_B: {
                            NSUInteger ivarSize =0;
                            NSUInteger ivarAlignment =0;
                            NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
                            NSData *data = [decoder decodeObjectForKey:key];
                            
                            char *sourceIvarLocation = (__bridge CFTypeRef)self+ivar_getOffset(ivar);
                            
                            [data getBytes:sourceIvarLocation length:ivarSize];
                        }
                            break;
                        default:
                            [self setValue:[decoder decodeObjectForKey:key] forKey:key];
                            break;
                    }
                }
            }
            free(ivars);
            cls = class_getSuperclass(cls);
        }
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    Class cls = [self class];
    while (cls != [NSObject class]) {
        unsigned int numberOfIvars =0;
        Ivar* ivars = class_copyIvarList(cls, &numberOfIvars);
        for(const Ivar* p = ivars; p < ivars+numberOfIvars; p++){
            Ivar const ivar = *p;
            const char *type =ivar_getTypeEncoding(ivar);
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [self valueForKey:key];
            if (value) {
                switch (type[0]) {
                    case _C_STRUCT_B: {
                        NSUInteger ivarSize =0;
                        NSUInteger ivarAlignment =0;
                        NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
                        //const char * myself = (__bridge CFTypeRef)self;
                        NSData *data = [NSData dataWithBytes:(__bridge CFTypeRef)self + ivar_getOffset(ivar) length:ivarSize];
                        [encoder encodeObject:data forKey:key];
                    }
                        break;
                    default:
                        [encoder encodeObject:value forKey:key];
                        break;
                }
            }
        }
        free(ivars);
        cls = class_getSuperclass(cls);
    }
}

#endif

@end
