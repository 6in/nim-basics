// file: objcsrc.m
#include <Foundation/NSObject.h>
#include <stdlib.h>
#include <stdio.h>

@interface Greeter:NSObject
{
}
- (void)greet;
@end

@implementation Greeter
- (void)greet:
{
  printf("Hello, World!\n");
}
@end

int main() {
  id obj = [Greeter alloc];
  [ obj greet ];
  return 0;
}



