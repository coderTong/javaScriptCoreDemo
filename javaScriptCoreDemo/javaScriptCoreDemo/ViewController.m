//
//  ViewController.m
//  javaScriptCoreDemo
//
//  Created by Mac on 16/7/29.
//  Copyright © 2016年 wutong. All rights reserved.
//

#import "ViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

#import "Person.h"

/*
 #import "JSContext.h"
 #import "JSValue.h"
 #import "JSManagedValue.h"
 #import "JSVirtualMachine.h"
 #import "JSExport.h"
 */

@interface ViewController ()
@property (nonatomic, strong)JSContext * jsContext;
@end

@implementation ViewController


- (JSContext *)jsContext{
    if (!_jsContext) {
        _jsContext = [[JSContext alloc]init];
    }
    return _jsContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self jSCallNative];
}



/*
 ========================================================================
 use 1
 ========================================================================
 */

- (void)jSCallNative
{
    // 在下面这个block中绝对不能使用self.jsContext
    self.jsContext[@"sum"] = ^(){
        
        //        self.jsContext......  使用外部定义好的Context绝对不行,如果一定要使用Context,如下
        //
        //        [JSContext currentContext]; /如果要使用就这样获取然后再使用
        NSArray * args = [JSContext currentArguments];
        int32_t result = 0;
        for (JSValue *jsVal in args) {
            NSLog(@"%@",jsVal);
            
            result = result + [jsVal toInt32];
        }
        NSLog(@"result: %d", result);
        
    };
    
    
    [self.jsContext evaluateScript:@"sum(1,2,4,3)"];
}

- (void)nativeCallJs
{
    JSValue * jsFunction1 = [self.jsContext evaluateScript:
                             @"function test1(){"
                             "return 'xixi';"
                             "}"
                             "test1();"];
    
    
    
    //    NSString * jsStr = jsFunction1;//[jsFunction1 toString];
    //    NSLog(@"%@",jsFunction1);
    
    
    
    // 执行一个闭包
    //    JSValue * jsValue2 = [self.jsContext evaluateScript:
    //                          @"function block3(){"
    //                          "var xixi = '(*^__^*) 嘻嘻……';"
    //                          "var lala = '♪(^∇^*)';"
    //
    //                            "function block4(){"
    //                                "return xixi + lala;"
    //                            "}"
    //                          "return block4;"
    //                          "}"
    //
    //                          "block3()();"];
    //    NSLog(@"%@", jsValue2);
    
    // 执行一个文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"js"];
    NSString *jsFileStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    JSValue * jsValue3 = [self.jsContext evaluateScript:jsFileStr];
    //    NSLog(@"%@",jsValue3);
    
    
    // 注册一个js然后执行
    // 1.变量接收函数
    [self.jsContext evaluateScript:
     @"var hellow = function(){"
     "return 'hello';"
     "}"
     ];
    
    
    
    
    
    // 2.函数名
    [self.jsContext evaluateScript:
     @"function hi(){"
     "return 'hi';"
     "}"
     ];
    
    
    
    // 3.闭包函数体内
    [self.jsContext evaluateScript:
     @"function hiBlock(){"
     "var myHi = 'hi block';"
     "function sayHi(){"
     "return myHi;"
     "}"
     "return sayHi;"
     "}"
     ];
    
    
    
    //    // 4.闭包匿名?
    JSValue *jsFunction = [self.jsContext evaluateScript:
                           @"(function(){"
                           "return 'I am block too';"
                           "})"
                           ];
    
    JSValue * jsValueHello = [self.jsContext evaluateScript:@"hellow();"];
    NSLog(@"%@", jsValueHello);
    
    JSValue * jsValueHi = [self.jsContext evaluateScript:@"hi();"];
    NSLog(@"%@", jsValueHi);
    
    JSValue * jsValueSayHi = [self.jsContext evaluateScript:@"hiBlock()();"];
    NSLog(@"%@", jsValueSayHi);
    
    JSValue * jsFunctionValue = [jsFunction callWithArguments:nil];
    NSLog(@"%@", jsFunctionValue);
    
    [jsFunctionValue toString];
}

- (void)jsCallNative
{
    // 注册js方法给Native
    
    /**
     block使用仍然需要注意循环引用的问题，所以在block中可以使用JSContext的静态方法 ` + (JSContext *)currentContext ` 获取到context
     */
    
    // 注册一个方式一
    //    self.jsContext[@"log"] = ^(NSString * msg){
    //        NSLog(@"🐒----%@", msg);
    //    };
    
    // 注册方式二
    self.jsContext[@"log"] = ^(){
        NSArray * args = [JSContext currentArguments];
        
        //        JSValue * value = [JSContext currentCallee];
        JSValue * value = [JSContext currentThis];
        NSLog(@"value---%@", value);
        for (id obj in args) {
            NSLog(@"%@", obj);
        }
    };
    
    
    //    [self.jsContext evaluateScript:
    //     @"(function(){"
    //        "log('hi, i am js');"
    //     "})()"
    //     ];
    
    
    [self.jsContext evaluateScript:
     @"log('jkjkji, i am js');"
     
     ];
    
    
    //[self.jsContext evaluateScript:@"log('hi, i am js');"];
    //NSLog(@"%@", jsResult);
    
}

- (void)useJSExprot{
    Person * p = [[Person alloc]init];
    self.jsContext[@"person"] = p;
    JSValue * value = [self.jsContext evaluateScript:@"person.whatYouName();"];
    NSLog(@"%@", value);
}

/*
 注意，当我们 export 一个 OC 或 Swift object 到 JS 中时，不能在这个object 中存储对应的 JS values。这种行为会导致一个retain cycle，JSValue objects 持有他们对应的 JSContext 的强引用，JSContext 则持有export到JS的native object的强引用，即 native object(OC or Swift object) —> JSValue —> JSContext —> native object
 */

//- (void)

/*
 ========================================================================
 use 2
 ========================================================================
 */

- (void)nativeCellJs2
{
    JSValue * jsVal = [self.jsContext evaluateScript:@"21+9"];
    int iVal = [jsVal toInt32];
    
    NSLog(@"%zd", iVal);
}

- (void)nativeCellJs2_2
{
    [self.jsContext evaluateScript:@"var arr = [21, 7, 'baidu.com'];"];
    JSValue *jsArr = self.jsContext[@"arr"];
    
    NSLog(@"JS Array:%@----lenght:%@", jsArr, jsArr[@"length"]);
    jsArr[1] = @"xixi";
    jsArr[7] = @7;
    
    NSLog(@"JS Array:%@----lenght:%@", jsArr, jsArr[@"length"]);
    
    NSArray * nsArray = [jsArr toArray];
    NSLog(@"%@", nsArray);
    
}

- (void)nativeCellJs2_3
{
    self.jsContext[@"log"] = ^(){
        NSLog(@"+++++++Begin Log+++++++");
        
        NSArray * args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@",jsVal);
        }
    };
    
    JSValue * this = [JSContext currentThis];
    NSLog(@"this: %@", this);
    
    NSLog(@"+++++++End Log+++++++");
    
    [self.jsContext evaluateScript:@"log('xixi',[6,342], {hello:'word', js:100});"];
}

- (void)nativeCellJs2_4
{
    [self.jsContext evaluateScript:
     @"function add(a, b){"
     "return a + b;"
     "}"
     ];
    
    JSValue * addFunction = self.jsContext[@"add"];
    
    NSLog(@"Func: %@", addFunction);
    
    //    JSValue * sum = [addFunction callWithArguments:@[@"33", @"7"]];
    //    NSLog(@"----:%@", sum);
    //    NSLog(@"sum: %@", [sum toString]);
    
    JSValue * sum = [addFunction callWithArguments:@[@33, @7]];
    NSLog(@"----:%@", sum);
    NSLog(@"sum: %@", [sum toString]);
    
    
}

- (void)nativeCellJs2_5
{
    [self.jsContext evaluateScript:
     @"function myObject(){"
     "var name = 'wutong';"
     "this.mylog = function(){"
     "return name;"
     "}"
     "}"
     "var myOj1 = new myObject();"
     ];
    
    JSValue * this = [JSContext currentThis];
    NSLog(@"this: %@", this);
    
    JSValue * value1 = [self.jsContext evaluateScript:@"myOj1.mylog()"];
    NSLog(@"%@", value1);
    
    JSValue * value2 = [value1 callWithArguments:nil];
    NSLog(@"---%@", value2);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

