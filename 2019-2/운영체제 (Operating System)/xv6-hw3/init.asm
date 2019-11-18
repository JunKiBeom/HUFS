
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 b3 09 00 00       	push   $0x9b3
  1b:	e8 ae 03 00 00       	call   3ce <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 b3 09 00 00       	push   $0x9b3
  33:	e8 9e 03 00 00       	call   3d6 <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 b3 09 00 00       	push   $0x9b3
  45:	e8 84 03 00 00       	call   3ce <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 af 03 00 00       	call   406 <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 a2 03 00 00       	call   406 <dup>
  64:	83 c4 10             	add    $0x10,%esp

  printf(1, "Welcome to HUFS xv6 Operating System Project!!! \n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 bc 09 00 00       	push   $0x9bc
  6f:	6a 01                	push   $0x1
  71:	e8 cf 04 00 00       	call   545 <printf>
  76:	83 c4 10             	add    $0x10,%esp
  printf(1, "Name: Jun, KiBeom \n");
  79:	83 ec 08             	sub    $0x8,%esp
  7c:	68 ee 09 00 00       	push   $0x9ee
  81:	6a 01                	push   $0x1
  83:	e8 bd 04 00 00       	call   545 <printf>
  88:	83 c4 10             	add    $0x10,%esp
  printf(1, "ID: 201703091 \n\n\n");
  8b:	83 ec 08             	sub    $0x8,%esp
  8e:	68 02 0a 00 00       	push   $0xa02
  93:	6a 01                	push   $0x1
  95:	e8 ab 04 00 00       	call   545 <printf>
  9a:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  9d:	83 ec 08             	sub    $0x8,%esp
  a0:	68 14 0a 00 00       	push   $0xa14
  a5:	6a 01                	push   $0x1
  a7:	e8 99 04 00 00       	call   545 <printf>
  ac:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  af:	e8 d2 02 00 00       	call   386 <fork>
  b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  bb:	79 17                	jns    d4 <main+0xd4>
      printf(1, "init: fork failed\n");
  bd:	83 ec 08             	sub    $0x8,%esp
  c0:	68 27 0a 00 00       	push   $0xa27
  c5:	6a 01                	push   $0x1
  c7:	e8 79 04 00 00       	call   545 <printf>
  cc:	83 c4 10             	add    $0x10,%esp
      exit();
  cf:	e8 ba 02 00 00       	call   38e <exit>
    }
    if(pid == 0){
  d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  d8:	75 3e                	jne    118 <main+0x118>
      exec("sh", argv);
  da:	83 ec 08             	sub    $0x8,%esp
  dd:	68 e8 0c 00 00       	push   $0xce8
  e2:	68 b0 09 00 00       	push   $0x9b0
  e7:	e8 da 02 00 00       	call   3c6 <exec>
  ec:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  ef:	83 ec 08             	sub    $0x8,%esp
  f2:	68 3a 0a 00 00       	push   $0xa3a
  f7:	6a 01                	push   $0x1
  f9:	e8 47 04 00 00       	call   545 <printf>
  fe:	83 c4 10             	add    $0x10,%esp
      exit();
 101:	e8 88 02 00 00       	call   38e <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
 106:	83 ec 08             	sub    $0x8,%esp
 109:	68 50 0a 00 00       	push   $0xa50
 10e:	6a 01                	push   $0x1
 110:	e8 30 04 00 00       	call   545 <printf>
 115:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
 118:	e8 79 02 00 00       	call   396 <wait>
 11d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 120:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 124:	0f 88 73 ff ff ff    	js     9d <main+0x9d>
 12a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 12d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 130:	75 d4                	jne    106 <main+0x106>
      printf(1, "zombie!\n");
  }
 132:	e9 66 ff ff ff       	jmp    9d <main+0x9d>

00000137 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 137:	55                   	push   %ebp
 138:	89 e5                	mov    %esp,%ebp
 13a:	57                   	push   %edi
 13b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 13c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 13f:	8b 55 10             	mov    0x10(%ebp),%edx
 142:	8b 45 0c             	mov    0xc(%ebp),%eax
 145:	89 cb                	mov    %ecx,%ebx
 147:	89 df                	mov    %ebx,%edi
 149:	89 d1                	mov    %edx,%ecx
 14b:	fc                   	cld    
 14c:	f3 aa                	rep stos %al,%es:(%edi)
 14e:	89 ca                	mov    %ecx,%edx
 150:	89 fb                	mov    %edi,%ebx
 152:	89 5d 08             	mov    %ebx,0x8(%ebp)
 155:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 158:	90                   	nop
 159:	5b                   	pop    %ebx
 15a:	5f                   	pop    %edi
 15b:	5d                   	pop    %ebp
 15c:	c3                   	ret    

0000015d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 169:	90                   	nop
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	8d 50 01             	lea    0x1(%eax),%edx
 170:	89 55 08             	mov    %edx,0x8(%ebp)
 173:	8b 55 0c             	mov    0xc(%ebp),%edx
 176:	8d 4a 01             	lea    0x1(%edx),%ecx
 179:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 17c:	0f b6 12             	movzbl (%edx),%edx
 17f:	88 10                	mov    %dl,(%eax)
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	84 c0                	test   %al,%al
 186:	75 e2                	jne    16a <strcpy+0xd>
    ;
  return os;
 188:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 18b:	c9                   	leave  
 18c:	c3                   	ret    

0000018d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18d:	55                   	push   %ebp
 18e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 190:	eb 08                	jmp    19a <strcmp+0xd>
    p++, q++;
 192:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 196:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	0f b6 00             	movzbl (%eax),%eax
 1a0:	84 c0                	test   %al,%al
 1a2:	74 10                	je     1b4 <strcmp+0x27>
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	0f b6 10             	movzbl (%eax),%edx
 1aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ad:	0f b6 00             	movzbl (%eax),%eax
 1b0:	38 c2                	cmp    %al,%dl
 1b2:	74 de                	je     192 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	0f b6 00             	movzbl (%eax),%eax
 1ba:	0f b6 d0             	movzbl %al,%edx
 1bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c0:	0f b6 00             	movzbl (%eax),%eax
 1c3:	0f b6 c0             	movzbl %al,%eax
 1c6:	29 c2                	sub    %eax,%edx
 1c8:	89 d0                	mov    %edx,%eax
}
 1ca:	5d                   	pop    %ebp
 1cb:	c3                   	ret    

000001cc <strlen>:

uint
strlen(char *s)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1d9:	eb 04                	jmp    1df <strlen+0x13>
 1db:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1df:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	01 d0                	add    %edx,%eax
 1e7:	0f b6 00             	movzbl (%eax),%eax
 1ea:	84 c0                	test   %al,%al
 1ec:	75 ed                	jne    1db <strlen+0xf>
    ;
  return n;
 1ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1f1:	c9                   	leave  
 1f2:	c3                   	ret    

000001f3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f3:	55                   	push   %ebp
 1f4:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1f6:	8b 45 10             	mov    0x10(%ebp),%eax
 1f9:	50                   	push   %eax
 1fa:	ff 75 0c             	pushl  0xc(%ebp)
 1fd:	ff 75 08             	pushl  0x8(%ebp)
 200:	e8 32 ff ff ff       	call   137 <stosb>
 205:	83 c4 0c             	add    $0xc,%esp
  return dst;
 208:	8b 45 08             	mov    0x8(%ebp),%eax
}
 20b:	c9                   	leave  
 20c:	c3                   	ret    

0000020d <strchr>:

char*
strchr(const char *s, char c)
{
 20d:	55                   	push   %ebp
 20e:	89 e5                	mov    %esp,%ebp
 210:	83 ec 04             	sub    $0x4,%esp
 213:	8b 45 0c             	mov    0xc(%ebp),%eax
 216:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 219:	eb 14                	jmp    22f <strchr+0x22>
    if(*s == c)
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
 21e:	0f b6 00             	movzbl (%eax),%eax
 221:	3a 45 fc             	cmp    -0x4(%ebp),%al
 224:	75 05                	jne    22b <strchr+0x1e>
      return (char*)s;
 226:	8b 45 08             	mov    0x8(%ebp),%eax
 229:	eb 13                	jmp    23e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 22b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	84 c0                	test   %al,%al
 237:	75 e2                	jne    21b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 239:	b8 00 00 00 00       	mov    $0x0,%eax
}
 23e:	c9                   	leave  
 23f:	c3                   	ret    

00000240 <gets>:

char*
gets(char *buf, int max)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 246:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 24d:	eb 42                	jmp    291 <gets+0x51>
    cc = read(0, &c, 1);
 24f:	83 ec 04             	sub    $0x4,%esp
 252:	6a 01                	push   $0x1
 254:	8d 45 ef             	lea    -0x11(%ebp),%eax
 257:	50                   	push   %eax
 258:	6a 00                	push   $0x0
 25a:	e8 47 01 00 00       	call   3a6 <read>
 25f:	83 c4 10             	add    $0x10,%esp
 262:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 265:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 269:	7e 33                	jle    29e <gets+0x5e>
      break;
    buf[i++] = c;
 26b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26e:	8d 50 01             	lea    0x1(%eax),%edx
 271:	89 55 f4             	mov    %edx,-0xc(%ebp)
 274:	89 c2                	mov    %eax,%edx
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	01 c2                	add    %eax,%edx
 27b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 281:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 285:	3c 0a                	cmp    $0xa,%al
 287:	74 16                	je     29f <gets+0x5f>
 289:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 28d:	3c 0d                	cmp    $0xd,%al
 28f:	74 0e                	je     29f <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 291:	8b 45 f4             	mov    -0xc(%ebp),%eax
 294:	83 c0 01             	add    $0x1,%eax
 297:	3b 45 0c             	cmp    0xc(%ebp),%eax
 29a:	7c b3                	jl     24f <gets+0xf>
 29c:	eb 01                	jmp    29f <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 29e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 29f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	01 d0                	add    %edx,%eax
 2a7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ad:	c9                   	leave  
 2ae:	c3                   	ret    

000002af <stat>:

int
stat(char *n, struct stat *st)
{
 2af:	55                   	push   %ebp
 2b0:	89 e5                	mov    %esp,%ebp
 2b2:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b5:	83 ec 08             	sub    $0x8,%esp
 2b8:	6a 00                	push   $0x0
 2ba:	ff 75 08             	pushl  0x8(%ebp)
 2bd:	e8 0c 01 00 00       	call   3ce <open>
 2c2:	83 c4 10             	add    $0x10,%esp
 2c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2cc:	79 07                	jns    2d5 <stat+0x26>
    return -1;
 2ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2d3:	eb 25                	jmp    2fa <stat+0x4b>
  r = fstat(fd, st);
 2d5:	83 ec 08             	sub    $0x8,%esp
 2d8:	ff 75 0c             	pushl  0xc(%ebp)
 2db:	ff 75 f4             	pushl  -0xc(%ebp)
 2de:	e8 03 01 00 00       	call   3e6 <fstat>
 2e3:	83 c4 10             	add    $0x10,%esp
 2e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2e9:	83 ec 0c             	sub    $0xc,%esp
 2ec:	ff 75 f4             	pushl  -0xc(%ebp)
 2ef:	e8 c2 00 00 00       	call   3b6 <close>
 2f4:	83 c4 10             	add    $0x10,%esp
  return r;
 2f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2fa:	c9                   	leave  
 2fb:	c3                   	ret    

000002fc <atoi>:

int
atoi(const char *s)
{
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp
 2ff:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 302:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 309:	eb 25                	jmp    330 <atoi+0x34>
    n = n*10 + *s++ - '0';
 30b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 30e:	89 d0                	mov    %edx,%eax
 310:	c1 e0 02             	shl    $0x2,%eax
 313:	01 d0                	add    %edx,%eax
 315:	01 c0                	add    %eax,%eax
 317:	89 c1                	mov    %eax,%ecx
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	8d 50 01             	lea    0x1(%eax),%edx
 31f:	89 55 08             	mov    %edx,0x8(%ebp)
 322:	0f b6 00             	movzbl (%eax),%eax
 325:	0f be c0             	movsbl %al,%eax
 328:	01 c8                	add    %ecx,%eax
 32a:	83 e8 30             	sub    $0x30,%eax
 32d:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 330:	8b 45 08             	mov    0x8(%ebp),%eax
 333:	0f b6 00             	movzbl (%eax),%eax
 336:	3c 2f                	cmp    $0x2f,%al
 338:	7e 0a                	jle    344 <atoi+0x48>
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	3c 39                	cmp    $0x39,%al
 342:	7e c7                	jle    30b <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 344:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 347:	c9                   	leave  
 348:	c3                   	ret    

00000349 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 349:	55                   	push   %ebp
 34a:	89 e5                	mov    %esp,%ebp
 34c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
 352:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 355:	8b 45 0c             	mov    0xc(%ebp),%eax
 358:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 35b:	eb 17                	jmp    374 <memmove+0x2b>
    *dst++ = *src++;
 35d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 360:	8d 50 01             	lea    0x1(%eax),%edx
 363:	89 55 fc             	mov    %edx,-0x4(%ebp)
 366:	8b 55 f8             	mov    -0x8(%ebp),%edx
 369:	8d 4a 01             	lea    0x1(%edx),%ecx
 36c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 36f:	0f b6 12             	movzbl (%edx),%edx
 372:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 374:	8b 45 10             	mov    0x10(%ebp),%eax
 377:	8d 50 ff             	lea    -0x1(%eax),%edx
 37a:	89 55 10             	mov    %edx,0x10(%ebp)
 37d:	85 c0                	test   %eax,%eax
 37f:	7f dc                	jg     35d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 381:	8b 45 08             	mov    0x8(%ebp),%eax
}
 384:	c9                   	leave  
 385:	c3                   	ret    

00000386 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 386:	b8 01 00 00 00       	mov    $0x1,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <exit>:
SYSCALL(exit)
 38e:	b8 02 00 00 00       	mov    $0x2,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <wait>:
SYSCALL(wait)
 396:	b8 03 00 00 00       	mov    $0x3,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <pipe>:
SYSCALL(pipe)
 39e:	b8 04 00 00 00       	mov    $0x4,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <read>:
SYSCALL(read)
 3a6:	b8 05 00 00 00       	mov    $0x5,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <write>:
SYSCALL(write)
 3ae:	b8 10 00 00 00       	mov    $0x10,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <close>:
SYSCALL(close)
 3b6:	b8 15 00 00 00       	mov    $0x15,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <kill>:
SYSCALL(kill)
 3be:	b8 06 00 00 00       	mov    $0x6,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <exec>:
SYSCALL(exec)
 3c6:	b8 07 00 00 00       	mov    $0x7,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <open>:
SYSCALL(open)
 3ce:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <mknod>:
SYSCALL(mknod)
 3d6:	b8 11 00 00 00       	mov    $0x11,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <unlink>:
SYSCALL(unlink)
 3de:	b8 12 00 00 00       	mov    $0x12,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <fstat>:
SYSCALL(fstat)
 3e6:	b8 08 00 00 00       	mov    $0x8,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <link>:
SYSCALL(link)
 3ee:	b8 13 00 00 00       	mov    $0x13,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <mkdir>:
SYSCALL(mkdir)
 3f6:	b8 14 00 00 00       	mov    $0x14,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <chdir>:
SYSCALL(chdir)
 3fe:	b8 09 00 00 00       	mov    $0x9,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <dup>:
SYSCALL(dup)
 406:	b8 0a 00 00 00       	mov    $0xa,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <getpid>:
SYSCALL(getpid)
 40e:	b8 0b 00 00 00       	mov    $0xb,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <sbrk>:
SYSCALL(sbrk)
 416:	b8 0c 00 00 00       	mov    $0xc,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <sleep>:
SYSCALL(sleep)
 41e:	b8 0d 00 00 00       	mov    $0xd,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <uptime>:
SYSCALL(uptime)
 426:	b8 0e 00 00 00       	mov    $0xe,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <halt>:
SYSCALL(halt)
 42e:	b8 16 00 00 00       	mov    $0x16,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <getnp>:
SYSCALL(getnp)
 436:	b8 17 00 00 00       	mov    $0x17,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <sem_create>:
SYSCALL(sem_create)
 43e:	b8 18 00 00 00       	mov    $0x18,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <sem_destroy>:
SYSCALL(sem_destroy)
 446:	b8 19 00 00 00       	mov    $0x19,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <sem_wait>:
SYSCALL(sem_wait)
 44e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <sem_signal>:
SYSCALL(sem_signal)
 456:	b8 1b 00 00 00       	mov    $0x1b,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <clone>:
SYSCALL(clone)
 45e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <join>:
SYSCALL(join)
 466:	b8 1d 00 00 00       	mov    $0x1d,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 46e:	55                   	push   %ebp
 46f:	89 e5                	mov    %esp,%ebp
 471:	83 ec 18             	sub    $0x18,%esp
 474:	8b 45 0c             	mov    0xc(%ebp),%eax
 477:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 47a:	83 ec 04             	sub    $0x4,%esp
 47d:	6a 01                	push   $0x1
 47f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 482:	50                   	push   %eax
 483:	ff 75 08             	pushl  0x8(%ebp)
 486:	e8 23 ff ff ff       	call   3ae <write>
 48b:	83 c4 10             	add    $0x10,%esp
}
 48e:	90                   	nop
 48f:	c9                   	leave  
 490:	c3                   	ret    

00000491 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 491:	55                   	push   %ebp
 492:	89 e5                	mov    %esp,%ebp
 494:	53                   	push   %ebx
 495:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 498:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 49f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4a3:	74 17                	je     4bc <printint+0x2b>
 4a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4a9:	79 11                	jns    4bc <printint+0x2b>
    neg = 1;
 4ab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b5:	f7 d8                	neg    %eax
 4b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ba:	eb 06                	jmp    4c2 <printint+0x31>
  } else {
    x = xx;
 4bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4c9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4cc:	8d 41 01             	lea    0x1(%ecx),%eax
 4cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d8:	ba 00 00 00 00       	mov    $0x0,%edx
 4dd:	f7 f3                	div    %ebx
 4df:	89 d0                	mov    %edx,%eax
 4e1:	0f b6 80 f0 0c 00 00 	movzbl 0xcf0(%eax),%eax
 4e8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f2:	ba 00 00 00 00       	mov    $0x0,%edx
 4f7:	f7 f3                	div    %ebx
 4f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 500:	75 c7                	jne    4c9 <printint+0x38>
  if(neg)
 502:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 506:	74 2d                	je     535 <printint+0xa4>
    buf[i++] = '-';
 508:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50b:	8d 50 01             	lea    0x1(%eax),%edx
 50e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 511:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 516:	eb 1d                	jmp    535 <printint+0xa4>
    putc(fd, buf[i]);
 518:	8d 55 dc             	lea    -0x24(%ebp),%edx
 51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51e:	01 d0                	add    %edx,%eax
 520:	0f b6 00             	movzbl (%eax),%eax
 523:	0f be c0             	movsbl %al,%eax
 526:	83 ec 08             	sub    $0x8,%esp
 529:	50                   	push   %eax
 52a:	ff 75 08             	pushl  0x8(%ebp)
 52d:	e8 3c ff ff ff       	call   46e <putc>
 532:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 535:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 539:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53d:	79 d9                	jns    518 <printint+0x87>
    putc(fd, buf[i]);
}
 53f:	90                   	nop
 540:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 543:	c9                   	leave  
 544:	c3                   	ret    

00000545 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 545:	55                   	push   %ebp
 546:	89 e5                	mov    %esp,%ebp
 548:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 54b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 552:	8d 45 0c             	lea    0xc(%ebp),%eax
 555:	83 c0 04             	add    $0x4,%eax
 558:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 55b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 562:	e9 59 01 00 00       	jmp    6c0 <printf+0x17b>
    c = fmt[i] & 0xff;
 567:	8b 55 0c             	mov    0xc(%ebp),%edx
 56a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 56d:	01 d0                	add    %edx,%eax
 56f:	0f b6 00             	movzbl (%eax),%eax
 572:	0f be c0             	movsbl %al,%eax
 575:	25 ff 00 00 00       	and    $0xff,%eax
 57a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 57d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 581:	75 2c                	jne    5af <printf+0x6a>
      if(c == '%'){
 583:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 587:	75 0c                	jne    595 <printf+0x50>
        state = '%';
 589:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 590:	e9 27 01 00 00       	jmp    6bc <printf+0x177>
      } else {
        putc(fd, c);
 595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 598:	0f be c0             	movsbl %al,%eax
 59b:	83 ec 08             	sub    $0x8,%esp
 59e:	50                   	push   %eax
 59f:	ff 75 08             	pushl  0x8(%ebp)
 5a2:	e8 c7 fe ff ff       	call   46e <putc>
 5a7:	83 c4 10             	add    $0x10,%esp
 5aa:	e9 0d 01 00 00       	jmp    6bc <printf+0x177>
      }
    } else if(state == '%'){
 5af:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5b3:	0f 85 03 01 00 00    	jne    6bc <printf+0x177>
      if(c == 'd'){
 5b9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5bd:	75 1e                	jne    5dd <printf+0x98>
        printint(fd, *ap, 10, 1);
 5bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c2:	8b 00                	mov    (%eax),%eax
 5c4:	6a 01                	push   $0x1
 5c6:	6a 0a                	push   $0xa
 5c8:	50                   	push   %eax
 5c9:	ff 75 08             	pushl  0x8(%ebp)
 5cc:	e8 c0 fe ff ff       	call   491 <printint>
 5d1:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d8:	e9 d8 00 00 00       	jmp    6b5 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5dd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5e1:	74 06                	je     5e9 <printf+0xa4>
 5e3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e7:	75 1e                	jne    607 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ec:	8b 00                	mov    (%eax),%eax
 5ee:	6a 00                	push   $0x0
 5f0:	6a 10                	push   $0x10
 5f2:	50                   	push   %eax
 5f3:	ff 75 08             	pushl  0x8(%ebp)
 5f6:	e8 96 fe ff ff       	call   491 <printint>
 5fb:	83 c4 10             	add    $0x10,%esp
        ap++;
 5fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 602:	e9 ae 00 00 00       	jmp    6b5 <printf+0x170>
      } else if(c == 's'){
 607:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 60b:	75 43                	jne    650 <printf+0x10b>
        s = (char*)*ap;
 60d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 610:	8b 00                	mov    (%eax),%eax
 612:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 615:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 61d:	75 25                	jne    644 <printf+0xff>
          s = "(null)";
 61f:	c7 45 f4 59 0a 00 00 	movl   $0xa59,-0xc(%ebp)
        while(*s != 0){
 626:	eb 1c                	jmp    644 <printf+0xff>
          putc(fd, *s);
 628:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62b:	0f b6 00             	movzbl (%eax),%eax
 62e:	0f be c0             	movsbl %al,%eax
 631:	83 ec 08             	sub    $0x8,%esp
 634:	50                   	push   %eax
 635:	ff 75 08             	pushl  0x8(%ebp)
 638:	e8 31 fe ff ff       	call   46e <putc>
 63d:	83 c4 10             	add    $0x10,%esp
          s++;
 640:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 644:	8b 45 f4             	mov    -0xc(%ebp),%eax
 647:	0f b6 00             	movzbl (%eax),%eax
 64a:	84 c0                	test   %al,%al
 64c:	75 da                	jne    628 <printf+0xe3>
 64e:	eb 65                	jmp    6b5 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 650:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 654:	75 1d                	jne    673 <printf+0x12e>
        putc(fd, *ap);
 656:	8b 45 e8             	mov    -0x18(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	0f be c0             	movsbl %al,%eax
 65e:	83 ec 08             	sub    $0x8,%esp
 661:	50                   	push   %eax
 662:	ff 75 08             	pushl  0x8(%ebp)
 665:	e8 04 fe ff ff       	call   46e <putc>
 66a:	83 c4 10             	add    $0x10,%esp
        ap++;
 66d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 671:	eb 42                	jmp    6b5 <printf+0x170>
      } else if(c == '%'){
 673:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 677:	75 17                	jne    690 <printf+0x14b>
        putc(fd, c);
 679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67c:	0f be c0             	movsbl %al,%eax
 67f:	83 ec 08             	sub    $0x8,%esp
 682:	50                   	push   %eax
 683:	ff 75 08             	pushl  0x8(%ebp)
 686:	e8 e3 fd ff ff       	call   46e <putc>
 68b:	83 c4 10             	add    $0x10,%esp
 68e:	eb 25                	jmp    6b5 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 690:	83 ec 08             	sub    $0x8,%esp
 693:	6a 25                	push   $0x25
 695:	ff 75 08             	pushl  0x8(%ebp)
 698:	e8 d1 fd ff ff       	call   46e <putc>
 69d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a3:	0f be c0             	movsbl %al,%eax
 6a6:	83 ec 08             	sub    $0x8,%esp
 6a9:	50                   	push   %eax
 6aa:	ff 75 08             	pushl  0x8(%ebp)
 6ad:	e8 bc fd ff ff       	call   46e <putc>
 6b2:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6bc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6c0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c6:	01 d0                	add    %edx,%eax
 6c8:	0f b6 00             	movzbl (%eax),%eax
 6cb:	84 c0                	test   %al,%al
 6cd:	0f 85 94 fe ff ff    	jne    567 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6d3:	90                   	nop
 6d4:	c9                   	leave  
 6d5:	c3                   	ret    

000006d6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d6:	55                   	push   %ebp
 6d7:	89 e5                	mov    %esp,%ebp
 6d9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6dc:	8b 45 08             	mov    0x8(%ebp),%eax
 6df:	83 e8 08             	sub    $0x8,%eax
 6e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e5:	a1 28 0d 00 00       	mov    0xd28,%eax
 6ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ed:	eb 24                	jmp    713 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	8b 00                	mov    (%eax),%eax
 6f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f7:	77 12                	ja     70b <free+0x35>
 6f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ff:	77 24                	ja     725 <free+0x4f>
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 709:	77 1a                	ja     725 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	8b 00                	mov    (%eax),%eax
 710:	89 45 fc             	mov    %eax,-0x4(%ebp)
 713:	8b 45 f8             	mov    -0x8(%ebp),%eax
 716:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 719:	76 d4                	jbe    6ef <free+0x19>
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 00                	mov    (%eax),%eax
 720:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 723:	76 ca                	jbe    6ef <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 725:	8b 45 f8             	mov    -0x8(%ebp),%eax
 728:	8b 40 04             	mov    0x4(%eax),%eax
 72b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	01 c2                	add    %eax,%edx
 737:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73a:	8b 00                	mov    (%eax),%eax
 73c:	39 c2                	cmp    %eax,%edx
 73e:	75 24                	jne    764 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 740:	8b 45 f8             	mov    -0x8(%ebp),%eax
 743:	8b 50 04             	mov    0x4(%eax),%edx
 746:	8b 45 fc             	mov    -0x4(%ebp),%eax
 749:	8b 00                	mov    (%eax),%eax
 74b:	8b 40 04             	mov    0x4(%eax),%eax
 74e:	01 c2                	add    %eax,%edx
 750:	8b 45 f8             	mov    -0x8(%ebp),%eax
 753:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 756:	8b 45 fc             	mov    -0x4(%ebp),%eax
 759:	8b 00                	mov    (%eax),%eax
 75b:	8b 10                	mov    (%eax),%edx
 75d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 760:	89 10                	mov    %edx,(%eax)
 762:	eb 0a                	jmp    76e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 10                	mov    (%eax),%edx
 769:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 76e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 771:	8b 40 04             	mov    0x4(%eax),%eax
 774:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	01 d0                	add    %edx,%eax
 780:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 783:	75 20                	jne    7a5 <free+0xcf>
    p->s.size += bp->s.size;
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	8b 50 04             	mov    0x4(%eax),%edx
 78b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78e:	8b 40 04             	mov    0x4(%eax),%eax
 791:	01 c2                	add    %eax,%edx
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 799:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79c:	8b 10                	mov    (%eax),%edx
 79e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a1:	89 10                	mov    %edx,(%eax)
 7a3:	eb 08                	jmp    7ad <free+0xd7>
  } else
    p->s.ptr = bp;
 7a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7ab:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b0:	a3 28 0d 00 00       	mov    %eax,0xd28
}
 7b5:	90                   	nop
 7b6:	c9                   	leave  
 7b7:	c3                   	ret    

000007b8 <morecore>:

static Header*
morecore(uint nu)
{
 7b8:	55                   	push   %ebp
 7b9:	89 e5                	mov    %esp,%ebp
 7bb:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7be:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7c5:	77 07                	ja     7ce <morecore+0x16>
    nu = 4096;
 7c7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ce:	8b 45 08             	mov    0x8(%ebp),%eax
 7d1:	c1 e0 03             	shl    $0x3,%eax
 7d4:	83 ec 0c             	sub    $0xc,%esp
 7d7:	50                   	push   %eax
 7d8:	e8 39 fc ff ff       	call   416 <sbrk>
 7dd:	83 c4 10             	add    $0x10,%esp
 7e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7e3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7e7:	75 07                	jne    7f0 <morecore+0x38>
    return 0;
 7e9:	b8 00 00 00 00       	mov    $0x0,%eax
 7ee:	eb 26                	jmp    816 <morecore+0x5e>
  hp = (Header*)p;
 7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f9:	8b 55 08             	mov    0x8(%ebp),%edx
 7fc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 802:	83 c0 08             	add    $0x8,%eax
 805:	83 ec 0c             	sub    $0xc,%esp
 808:	50                   	push   %eax
 809:	e8 c8 fe ff ff       	call   6d6 <free>
 80e:	83 c4 10             	add    $0x10,%esp
  return freep;
 811:	a1 28 0d 00 00       	mov    0xd28,%eax
}
 816:	c9                   	leave  
 817:	c3                   	ret    

00000818 <malloc>:

void*
malloc(uint nbytes)
{
 818:	55                   	push   %ebp
 819:	89 e5                	mov    %esp,%ebp
 81b:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81e:	8b 45 08             	mov    0x8(%ebp),%eax
 821:	83 c0 07             	add    $0x7,%eax
 824:	c1 e8 03             	shr    $0x3,%eax
 827:	83 c0 01             	add    $0x1,%eax
 82a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 82d:	a1 28 0d 00 00       	mov    0xd28,%eax
 832:	89 45 f0             	mov    %eax,-0x10(%ebp)
 835:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 839:	75 23                	jne    85e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 83b:	c7 45 f0 20 0d 00 00 	movl   $0xd20,-0x10(%ebp)
 842:	8b 45 f0             	mov    -0x10(%ebp),%eax
 845:	a3 28 0d 00 00       	mov    %eax,0xd28
 84a:	a1 28 0d 00 00       	mov    0xd28,%eax
 84f:	a3 20 0d 00 00       	mov    %eax,0xd20
    base.s.size = 0;
 854:	c7 05 24 0d 00 00 00 	movl   $0x0,0xd24
 85b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 861:	8b 00                	mov    (%eax),%eax
 863:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 866:	8b 45 f4             	mov    -0xc(%ebp),%eax
 869:	8b 40 04             	mov    0x4(%eax),%eax
 86c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 86f:	72 4d                	jb     8be <malloc+0xa6>
      if(p->s.size == nunits)
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	8b 40 04             	mov    0x4(%eax),%eax
 877:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 87a:	75 0c                	jne    888 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	8b 10                	mov    (%eax),%edx
 881:	8b 45 f0             	mov    -0x10(%ebp),%eax
 884:	89 10                	mov    %edx,(%eax)
 886:	eb 26                	jmp    8ae <malloc+0x96>
      else {
        p->s.size -= nunits;
 888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88b:	8b 40 04             	mov    0x4(%eax),%eax
 88e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 891:	89 c2                	mov    %eax,%edx
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 899:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89c:	8b 40 04             	mov    0x4(%eax),%eax
 89f:	c1 e0 03             	shl    $0x3,%eax
 8a2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ab:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b1:	a3 28 0d 00 00       	mov    %eax,0xd28
      return (void*)(p + 1);
 8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b9:	83 c0 08             	add    $0x8,%eax
 8bc:	eb 3b                	jmp    8f9 <malloc+0xe1>
    }
    if(p == freep)
 8be:	a1 28 0d 00 00       	mov    0xd28,%eax
 8c3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8c6:	75 1e                	jne    8e6 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8c8:	83 ec 0c             	sub    $0xc,%esp
 8cb:	ff 75 ec             	pushl  -0x14(%ebp)
 8ce:	e8 e5 fe ff ff       	call   7b8 <morecore>
 8d3:	83 c4 10             	add    $0x10,%esp
 8d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8dd:	75 07                	jne    8e6 <malloc+0xce>
        return 0;
 8df:	b8 00 00 00 00       	mov    $0x0,%eax
 8e4:	eb 13                	jmp    8f9 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	8b 00                	mov    (%eax),%eax
 8f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8f4:	e9 6d ff ff ff       	jmp    866 <malloc+0x4e>
}
 8f9:	c9                   	leave  
 8fa:	c3                   	ret    

000008fb <hufs_thread_create>:

int thread_num = 0;


int hufs_thread_create(void *func(), void *args)
{
 8fb:	55                   	push   %ebp
 8fc:	89 e5                	mov    %esp,%ebp
 8fe:	83 ec 18             	sub    $0x18,%esp
	void *stack; 
	int pid;

	stack = malloc(4096);
 901:	83 ec 0c             	sub    $0xc,%esp
 904:	68 00 10 00 00       	push   $0x1000
 909:	e8 0a ff ff ff       	call   818 <malloc>
 90e:	83 c4 10             	add    $0x10,%esp
 911:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (stack==0) return -1;
 914:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 918:	75 07                	jne    921 <hufs_thread_create+0x26>
 91a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 91f:	eb 42                	jmp    963 <hufs_thread_create+0x68>

	pid = clone(func, args, stack); 
 921:	83 ec 04             	sub    $0x4,%esp
 924:	ff 75 f4             	pushl  -0xc(%ebp)
 927:	ff 75 0c             	pushl  0xc(%ebp)
 92a:	ff 75 08             	pushl  0x8(%ebp)
 92d:	e8 2c fb ff ff       	call   45e <clone>
 932:	83 c4 10             	add    $0x10,%esp
 935:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (pid==-1) {
 938:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 93c:	75 15                	jne    953 <hufs_thread_create+0x58>
		free(stack);
 93e:	83 ec 0c             	sub    $0xc,%esp
 941:	ff 75 f4             	pushl  -0xc(%ebp)
 944:	e8 8d fd ff ff       	call   6d6 <free>
 949:	83 c4 10             	add    $0x10,%esp
		return -1;
 94c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 951:	eb 10                	jmp    963 <hufs_thread_create+0x68>
	}

	thread_info[pid].stack = stack; 
 953:	8b 45 f0             	mov    -0x10(%ebp),%eax
 956:	8b 55 f4             	mov    -0xc(%ebp),%edx
 959:	89 14 85 40 0d 00 00 	mov    %edx,0xd40(,%eax,4)

	return pid; 
 960:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 963:	c9                   	leave  
 964:	c3                   	ret    

00000965 <hufs_thread_join>:

int hufs_thread_join(int pid)
{
 965:	55                   	push   %ebp
 966:	89 e5                	mov    %esp,%ebp
 968:	83 ec 18             	sub    $0x18,%esp
	void *stack = thread_info[pid].stack;
 96b:	8b 45 08             	mov    0x8(%ebp),%eax
 96e:	8b 04 85 40 0d 00 00 	mov    0xd40(,%eax,4),%eax
 975:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (stack==0) return -1;
 978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 97c:	75 07                	jne    985 <hufs_thread_join+0x20>
 97e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 983:	eb 28                	jmp    9ad <hufs_thread_join+0x48>

	join(&thread_info[pid].stack);	
 985:	8b 45 08             	mov    0x8(%ebp),%eax
 988:	c1 e0 02             	shl    $0x2,%eax
 98b:	05 40 0d 00 00       	add    $0xd40,%eax
 990:	83 ec 0c             	sub    $0xc,%esp
 993:	50                   	push   %eax
 994:	e8 cd fa ff ff       	call   466 <join>
 999:	83 c4 10             	add    $0x10,%esp
	free(stack);
 99c:	83 ec 0c             	sub    $0xc,%esp
 99f:	ff 75 f4             	pushl  -0xc(%ebp)
 9a2:	e8 2f fd ff ff       	call   6d6 <free>
 9a7:	83 c4 10             	add    $0x10,%esp

	return pid;
 9aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 9ad:	c9                   	leave  
 9ae:	c3                   	ret    
