//
//  CStudyViewController.m
//  Maxmoo
//
//  Created by 程超 on 2024/1/16.
//

#import "CStudyViewController.h"

@interface CStudyViewController ()

@end

@implementation CStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self printLog];
    [self bit];
    [self calculate];
    [self type];
    [self point];
    
    // 程序运行成功
    // 等同于 exit(0);
//    exit(EXIT_SUCCESS);
    
    // 程序异常中止
    // 等同于 exit(1);
//    exit(EXIT_FAILURE);
}

- (void)printLog {
    // 限定小数位数
    printf("Number of %.2f\n", 0.5);
}

- (void)bit {
    int bit = 0b10010011;
    printf("原数据");
    print_binary(bit);
    printf("\n取反:");
    print_binary(~bit);
    printf("\n与0b00111101:");
    print_binary(bit & 0b00111101);
    printf("\n或0b00111101:");
    print_binary(bit | 0b00111101);
    printf("\n异或0b00111101:");
    print_binary(bit ^ 0b00111101);
    printf("\n左移2位<<");
    print_binary(bit << 2);
    printf("\n右移2位<<");
    print_binary(bit >> 2);
}

#define BITS_IN_INT 8
void print_binary(int num) {
    printf("\n------>[");
    for (int i = sizeof(int) * BITS_IN_INT - 1; i >= 0; --i) {
        int bit = (num >> i) & 1;
        printf("%d", bit);
    }
    printf("]<------");
}

- (void)calculate {
    int x;
    x = (1, 2, 3);
    printf("\nx is: %d", x);
    
    // goto
    goto end;
    
    printf("\n center");
end:
    printf("\n goto end!");
}

- (void)type {
    // char
    char c = 'B';
    char n_c = 66;
    printf("\n result %d",c + n_c);
    
    /*
     \a：警报，这会使得终端发出警报声或出现闪烁，或者两者同时发生。
     \b：退格键，光标回退一个字符，但不删除字符。
     \f：换页符，光标移到下一页。在现代系统上，这已经反映不出来了，行为改成类似于\v。
     \n：换行符。
     \r：回车符，光标移到同一行的开头。
     \t：制表符，光标移到下一个水平制表位，通常是下一个8的倍数。
     \v：垂直分隔符，光标移到下一个垂直制表位，通常是下一行的同一列。
     \0：null 字符，代表没有内容。注意，这个值不等于数字0。
     转义写法还能使用八进制和十六进制表示一个字符。

     \nn：字符的八进制写法，nn为八进制值。
     \xnn：字符的十六进制写法，nn为十六进制值。
     
     char x = 'B';
     char x = 66;
     char x = '\102'; // 八进制
     char x = '\x42'; // 十六进制
     上面示例的四种写法都是等价的。
     */
    
    
    /*
     %d：十进制整数。
     %o：八进制整数。
     %x：十六进制整数。
     %#o：显示前缀0的八进制整数。
     %#x：显示前缀0x的十六进制整数。
     %#X：显示前缀0X的十六进制整数。
     */
    int x = 100;
    printf("\ndec = %d\n", x); // 100
    printf("octal = %o\n", x); // 144
    printf("hex = %x\n", x); // 64
    printf("octal = %#o\n", x); // 0144
    printf("hex = %#x\n", x); // 0x64
    printf("hex = %#X\n", x); // 0X64
    
    printf("%zd\n", sizeof(int));
    
}

- (void)point {
    int *a = NULL;
    int b;
    a = &b;
    *a = 3;
    increment(a);
    printf("\n aaaa: %d",*a);
    
    int x = 1;
    // 取内存地址
    printf("x's address is %p\n", &x);
    increment(&x);
    printf("\n aaaa: %d",x);
    
    // 指针减法
    short* j1;
    short* j2;

    j1 = (short*)0x1234;
    j2 = (short*)0x1236;

    ptrdiff_t dist = j2 - j1;
    printf("%td\n", dist); // 1
}

void increment(int* p) {
  *p = *p + 1;
}

@end
