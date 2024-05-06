//
//  CStudyViewController.m
//  Maxmoo
//
//  Created by 程超 on 2024/1/16.
//

#import "CStudyViewController.h"
#include <string.h>

@interface CStudyViewController ()

@end

@implementation CStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
//    [self printLog];
//    [self bit];
//    [self calculate];
//    [self type];
//    [self point];
//    [self sString];
//    [self malloc];
    [self structDemo];
    
    // 程序运行成功
    // 等同于 exit(0);
//    exit(EXIT_SUCCESS);
    
    // 程序异常中止
    // 等同于 exit(1);
//    exit(EXIT_FAILURE);
}

struct fra {
    int num;
    int den;
};

struct turtle {
  char* name;
  char* species;
  int age;
};

struct containTur {
    int index;
    struct turtle tur;
};

- (void)structDemo {
    // 结构体的三种初始化方式
    struct fra f1;
    f1.num = 1;
    f1.den = 2;
    
    struct fra f2 = {3, 4};
    printf("\n f2 num: %i, den: %i", f2.num, f2.den);
    
    struct fra f3 = {.den = 4, .num = 3};
    printf("\n f3 num: %i, den: %i", f3.num, f3.den);
    struct fra f4 = {};
    
    // 结构体的复制
    struct turtle t1 = {"jack", "sea t", 3};
    happy(t1);
    printf("\n t1.age: %i", t1.age);
    p_happy(&t1);
    printf("\n t1.age: %i", t1.age);
    
    // 嵌套的struct初始化的四种方式
    struct containTur ct1 = {2, {"j", "a", 30}};
    struct turtle tu1 = {"j", "a", 30};
    struct containTur ct2 = {3, tu1};
    struct containTur ct3 = {.index = 0, .tur = {"j", "a", 30}};
    struct containTur ct4 = {.index = 2, .tur.name = "", .tur.species = "", .tur.age = 5};
}

void happy(struct turtle t) {
    t.age = t.age + 1;
}

void p_happy(struct turtle *t) {
    (*t).age = (*t).age + 1;
    // 另一种写法,结果同上
//    t->age = t->age + 1;
}

- (void)malloc {
    int *p = malloc(sizeof(int));
    *p = 12;
    printf("p: %i", *p);
    free(p);
    
    
    int* p1 = calloc(10, sizeof(int));
    // 等同于
    int* p2 = malloc(sizeof(int) * 10);
    memset(p2, 0, sizeof(int) * 10);
    free(p1);
    free(p2);
    
    int* b;
    b = malloc(sizeof(int) * 10);
    b = realloc(b, sizeof(int) * 2000);
    free(b);
    
    char *cp1 = "copy1";
    char cp2[100];
    memcpy(cp2, cp1, strlen(cp1));
    printf("cp2: %s", cp2);
    
    char *cmp1 = "cmp1";
    char *cmp2 = "cmp2 2222";
    int rescmp1 = memcmp(cmp1, cmp2, strlen(cmp1) - 1);
    int rescmp2 = memcmp(cmp1, cmp2, strlen(cmp2));
    printf("\n res1: %i res2: %i", rescmp1, rescmp2);
}

- (void)sString {
    char *ss = "hello world!";
    printf("the s len: %zd", strlen(ss));
    
    char s[] = "hello world!";
    char t[100];
    
    strcpy(t, s);
    t[0] = 'z';
    
    printf("\n t: %s", t);
    printf("\n s: %s", s);
    
    char aa[20];
    char bb[20];
    strcpy(aa, strcpy(bb, "abcd!"));
    printf("\n aa: %s", aa);
    printf("\n bb: %s", bb);
    
    char *str1 = "test123456789";
    char str2[6];
    // 此处需要-1，不-1 str2就不是以/0结尾，结尾的实际位置不可预测
    strncpy(str2, str1, sizeof(str2) - 1);
    printf("\n str1: %s", str1);
    printf("\n str2: %s", str2);
    
    char str3[100] = "add ";
    strcat(str3, str2);
    printf("\n str3: %s", str3);
    
    char str4[7] = "add ";
    strncat(str4, str2, sizeof(str4) - strlen(str4) - 1);
    printf("\n str4: %s", str4);
    
    char cs1[20] = "copy equal";
    char cs2[20] = "copy xxx";
    int rs1 = strcmp(cs1, cs2);
    int rs2 = strncmp(cs1, cs2, 4);
    printf("\n rs1: %i  rs2: %i", rs1, rs2);
    
    char str5[100];
    sprintf(str5, "rs1: %i  rs2: %i", rs1, rs2);
    printf("\n str5: %s \n", str5);
    
    char weekdays[7][10] = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
    for (int i = 0; i < 7; i++) {
      printf("%s\n", weekdays[i]);
    }
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
