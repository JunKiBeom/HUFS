
_down:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(void){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  return halt();
  11:	e8 00 03 00 00       	call   316 <halt>
}
  16:	83 c4 04             	add    $0x4,%esp
  19:	59                   	pop    %ecx
  1a:	5d                   	pop    %ebp
  1b:	8d 61 fc             	lea    -0x4(%ecx),%esp
  1e:	c3                   	ret    

0000001f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  1f:	55                   	push   %ebp
  20:	89 e5                	mov    %esp,%ebp
  22:	57                   	push   %edi
  23:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  24:	8b 4d 08             	mov    0x8(%ebp),%ecx
  27:	8b 55 10             	mov    0x10(%ebp),%edx
  2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  2d:	89 cb                	mov    %ecx,%ebx
  2f:	89 df                	mov    %ebx,%edi
  31:	89 d1                	mov    %edx,%ecx
  33:	fc                   	cld    
  34:	f3 aa                	rep stos %al,%es:(%edi)
  36:	89 ca                	mov    %ecx,%edx
  38:	89 fb                	mov    %edi,%ebx
  3a:	89 5d 08             	mov    %ebx,0x8(%ebp)
  3d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  40:	90                   	nop
  41:	5b                   	pop    %ebx
  42:	5f                   	pop    %edi
  43:	5d                   	pop    %ebp
  44:	c3                   	ret    

00000045 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  45:	55                   	push   %ebp
  46:	89 e5                	mov    %esp,%ebp
  48:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4b:	8b 45 08             	mov    0x8(%ebp),%eax
  4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  51:	90                   	nop
  52:	8b 45 08             	mov    0x8(%ebp),%eax
  55:	8d 50 01             	lea    0x1(%eax),%edx
  58:	89 55 08             	mov    %edx,0x8(%ebp)
  5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  61:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  64:	0f b6 12             	movzbl (%edx),%edx
  67:	88 10                	mov    %dl,(%eax)
  69:	0f b6 00             	movzbl (%eax),%eax
  6c:	84 c0                	test   %al,%al
  6e:	75 e2                	jne    52 <strcpy+0xd>
    ;
  return os;
  70:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  73:	c9                   	leave  
  74:	c3                   	ret    

00000075 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  75:	55                   	push   %ebp
  76:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  78:	eb 08                	jmp    82 <strcmp+0xd>
    p++, q++;
  7a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  7e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  82:	8b 45 08             	mov    0x8(%ebp),%eax
  85:	0f b6 00             	movzbl (%eax),%eax
  88:	84 c0                	test   %al,%al
  8a:	74 10                	je     9c <strcmp+0x27>
  8c:	8b 45 08             	mov    0x8(%ebp),%eax
  8f:	0f b6 10             	movzbl (%eax),%edx
  92:	8b 45 0c             	mov    0xc(%ebp),%eax
  95:	0f b6 00             	movzbl (%eax),%eax
  98:	38 c2                	cmp    %al,%dl
  9a:	74 de                	je     7a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  9c:	8b 45 08             	mov    0x8(%ebp),%eax
  9f:	0f b6 00             	movzbl (%eax),%eax
  a2:	0f b6 d0             	movzbl %al,%edx
  a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  a8:	0f b6 00             	movzbl (%eax),%eax
  ab:	0f b6 c0             	movzbl %al,%eax
  ae:	29 c2                	sub    %eax,%edx
  b0:	89 d0                	mov    %edx,%eax
}
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    

000000b4 <strlen>:

uint
strlen(char *s)
{
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c1:	eb 04                	jmp    c7 <strlen+0x13>
  c3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  ca:	8b 45 08             	mov    0x8(%ebp),%eax
  cd:	01 d0                	add    %edx,%eax
  cf:	0f b6 00             	movzbl (%eax),%eax
  d2:	84 c0                	test   %al,%al
  d4:	75 ed                	jne    c3 <strlen+0xf>
    ;
  return n;
  d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d9:	c9                   	leave  
  da:	c3                   	ret    

000000db <memset>:

void*
memset(void *dst, int c, uint n)
{
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  de:	8b 45 10             	mov    0x10(%ebp),%eax
  e1:	50                   	push   %eax
  e2:	ff 75 0c             	pushl  0xc(%ebp)
  e5:	ff 75 08             	pushl  0x8(%ebp)
  e8:	e8 32 ff ff ff       	call   1f <stosb>
  ed:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  f3:	c9                   	leave  
  f4:	c3                   	ret    

000000f5 <strchr>:

char*
strchr(const char *s, char c)
{
  f5:	55                   	push   %ebp
  f6:	89 e5                	mov    %esp,%ebp
  f8:	83 ec 04             	sub    $0x4,%esp
  fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  fe:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 101:	eb 14                	jmp    117 <strchr+0x22>
    if(*s == c)
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	0f b6 00             	movzbl (%eax),%eax
 109:	3a 45 fc             	cmp    -0x4(%ebp),%al
 10c:	75 05                	jne    113 <strchr+0x1e>
      return (char*)s;
 10e:	8b 45 08             	mov    0x8(%ebp),%eax
 111:	eb 13                	jmp    126 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 113:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	0f b6 00             	movzbl (%eax),%eax
 11d:	84 c0                	test   %al,%al
 11f:	75 e2                	jne    103 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 121:	b8 00 00 00 00       	mov    $0x0,%eax
}
 126:	c9                   	leave  
 127:	c3                   	ret    

00000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 135:	eb 42                	jmp    179 <gets+0x51>
    cc = read(0, &c, 1);
 137:	83 ec 04             	sub    $0x4,%esp
 13a:	6a 01                	push   $0x1
 13c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 13f:	50                   	push   %eax
 140:	6a 00                	push   $0x0
 142:	e8 47 01 00 00       	call   28e <read>
 147:	83 c4 10             	add    $0x10,%esp
 14a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 14d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 151:	7e 33                	jle    186 <gets+0x5e>
      break;
    buf[i++] = c;
 153:	8b 45 f4             	mov    -0xc(%ebp),%eax
 156:	8d 50 01             	lea    0x1(%eax),%edx
 159:	89 55 f4             	mov    %edx,-0xc(%ebp)
 15c:	89 c2                	mov    %eax,%edx
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	01 c2                	add    %eax,%edx
 163:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 167:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 169:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16d:	3c 0a                	cmp    $0xa,%al
 16f:	74 16                	je     187 <gets+0x5f>
 171:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 175:	3c 0d                	cmp    $0xd,%al
 177:	74 0e                	je     187 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 179:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17c:	83 c0 01             	add    $0x1,%eax
 17f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 182:	7c b3                	jl     137 <gets+0xf>
 184:	eb 01                	jmp    187 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 186:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 187:	8b 55 f4             	mov    -0xc(%ebp),%edx
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	01 d0                	add    %edx,%eax
 18f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 192:	8b 45 08             	mov    0x8(%ebp),%eax
}
 195:	c9                   	leave  
 196:	c3                   	ret    

00000197 <stat>:

int
stat(char *n, struct stat *st)
{
 197:	55                   	push   %ebp
 198:	89 e5                	mov    %esp,%ebp
 19a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19d:	83 ec 08             	sub    $0x8,%esp
 1a0:	6a 00                	push   $0x0
 1a2:	ff 75 08             	pushl  0x8(%ebp)
 1a5:	e8 0c 01 00 00       	call   2b6 <open>
 1aa:	83 c4 10             	add    $0x10,%esp
 1ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b4:	79 07                	jns    1bd <stat+0x26>
    return -1;
 1b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1bb:	eb 25                	jmp    1e2 <stat+0x4b>
  r = fstat(fd, st);
 1bd:	83 ec 08             	sub    $0x8,%esp
 1c0:	ff 75 0c             	pushl  0xc(%ebp)
 1c3:	ff 75 f4             	pushl  -0xc(%ebp)
 1c6:	e8 03 01 00 00       	call   2ce <fstat>
 1cb:	83 c4 10             	add    $0x10,%esp
 1ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d1:	83 ec 0c             	sub    $0xc,%esp
 1d4:	ff 75 f4             	pushl  -0xc(%ebp)
 1d7:	e8 c2 00 00 00       	call   29e <close>
 1dc:	83 c4 10             	add    $0x10,%esp
  return r;
 1df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e2:	c9                   	leave  
 1e3:	c3                   	ret    

000001e4 <atoi>:

int
atoi(const char *s)
{
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1f1:	eb 25                	jmp    218 <atoi+0x34>
    n = n*10 + *s++ - '0';
 1f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f6:	89 d0                	mov    %edx,%eax
 1f8:	c1 e0 02             	shl    $0x2,%eax
 1fb:	01 d0                	add    %edx,%eax
 1fd:	01 c0                	add    %eax,%eax
 1ff:	89 c1                	mov    %eax,%ecx
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	8d 50 01             	lea    0x1(%eax),%edx
 207:	89 55 08             	mov    %edx,0x8(%ebp)
 20a:	0f b6 00             	movzbl (%eax),%eax
 20d:	0f be c0             	movsbl %al,%eax
 210:	01 c8                	add    %ecx,%eax
 212:	83 e8 30             	sub    $0x30,%eax
 215:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	0f b6 00             	movzbl (%eax),%eax
 21e:	3c 2f                	cmp    $0x2f,%al
 220:	7e 0a                	jle    22c <atoi+0x48>
 222:	8b 45 08             	mov    0x8(%ebp),%eax
 225:	0f b6 00             	movzbl (%eax),%eax
 228:	3c 39                	cmp    $0x39,%al
 22a:	7e c7                	jle    1f3 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 22c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22f:	c9                   	leave  
 230:	c3                   	ret    

00000231 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 231:	55                   	push   %ebp
 232:	89 e5                	mov    %esp,%ebp
 234:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 23d:	8b 45 0c             	mov    0xc(%ebp),%eax
 240:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 243:	eb 17                	jmp    25c <memmove+0x2b>
    *dst++ = *src++;
 245:	8b 45 fc             	mov    -0x4(%ebp),%eax
 248:	8d 50 01             	lea    0x1(%eax),%edx
 24b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 24e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 251:	8d 4a 01             	lea    0x1(%edx),%ecx
 254:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 257:	0f b6 12             	movzbl (%edx),%edx
 25a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25c:	8b 45 10             	mov    0x10(%ebp),%eax
 25f:	8d 50 ff             	lea    -0x1(%eax),%edx
 262:	89 55 10             	mov    %edx,0x10(%ebp)
 265:	85 c0                	test   %eax,%eax
 267:	7f dc                	jg     245 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 269:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26c:	c9                   	leave  
 26d:	c3                   	ret    

0000026e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 26e:	b8 01 00 00 00       	mov    $0x1,%eax
 273:	cd 40                	int    $0x40
 275:	c3                   	ret    

00000276 <exit>:
SYSCALL(exit)
 276:	b8 02 00 00 00       	mov    $0x2,%eax
 27b:	cd 40                	int    $0x40
 27d:	c3                   	ret    

0000027e <wait>:
SYSCALL(wait)
 27e:	b8 03 00 00 00       	mov    $0x3,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <pipe>:
SYSCALL(pipe)
 286:	b8 04 00 00 00       	mov    $0x4,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <read>:
SYSCALL(read)
 28e:	b8 05 00 00 00       	mov    $0x5,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <write>:
SYSCALL(write)
 296:	b8 10 00 00 00       	mov    $0x10,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <close>:
SYSCALL(close)
 29e:	b8 15 00 00 00       	mov    $0x15,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <kill>:
SYSCALL(kill)
 2a6:	b8 06 00 00 00       	mov    $0x6,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <exec>:
SYSCALL(exec)
 2ae:	b8 07 00 00 00       	mov    $0x7,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <open>:
SYSCALL(open)
 2b6:	b8 0f 00 00 00       	mov    $0xf,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <mknod>:
SYSCALL(mknod)
 2be:	b8 11 00 00 00       	mov    $0x11,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <unlink>:
SYSCALL(unlink)
 2c6:	b8 12 00 00 00       	mov    $0x12,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <fstat>:
SYSCALL(fstat)
 2ce:	b8 08 00 00 00       	mov    $0x8,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <link>:
SYSCALL(link)
 2d6:	b8 13 00 00 00       	mov    $0x13,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <mkdir>:
SYSCALL(mkdir)
 2de:	b8 14 00 00 00       	mov    $0x14,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <chdir>:
SYSCALL(chdir)
 2e6:	b8 09 00 00 00       	mov    $0x9,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <dup>:
SYSCALL(dup)
 2ee:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <getpid>:
SYSCALL(getpid)
 2f6:	b8 0b 00 00 00       	mov    $0xb,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <sbrk>:
SYSCALL(sbrk)
 2fe:	b8 0c 00 00 00       	mov    $0xc,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <sleep>:
SYSCALL(sleep)
 306:	b8 0d 00 00 00       	mov    $0xd,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <uptime>:
SYSCALL(uptime)
 30e:	b8 0e 00 00 00       	mov    $0xe,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <halt>:
SYSCALL(halt)
 316:	b8 16 00 00 00       	mov    $0x16,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <getnp>:
SYSCALL(getnp)
 31e:	b8 17 00 00 00       	mov    $0x17,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <sem_create>:
SYSCALL(sem_create)
 326:	b8 18 00 00 00       	mov    $0x18,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <sem_destroy>:
SYSCALL(sem_destroy)
 32e:	b8 19 00 00 00       	mov    $0x19,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <sem_wait>:
SYSCALL(sem_wait)
 336:	b8 1a 00 00 00       	mov    $0x1a,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <sem_signal>:
SYSCALL(sem_signal)
 33e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <clone>:
SYSCALL(clone)
 346:	b8 1c 00 00 00       	mov    $0x1c,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <join>:
SYSCALL(join)
 34e:	b8 1d 00 00 00       	mov    $0x1d,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp
 359:	83 ec 18             	sub    $0x18,%esp
 35c:	8b 45 0c             	mov    0xc(%ebp),%eax
 35f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 362:	83 ec 04             	sub    $0x4,%esp
 365:	6a 01                	push   $0x1
 367:	8d 45 f4             	lea    -0xc(%ebp),%eax
 36a:	50                   	push   %eax
 36b:	ff 75 08             	pushl  0x8(%ebp)
 36e:	e8 23 ff ff ff       	call   296 <write>
 373:	83 c4 10             	add    $0x10,%esp
}
 376:	90                   	nop
 377:	c9                   	leave  
 378:	c3                   	ret    

00000379 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 379:	55                   	push   %ebp
 37a:	89 e5                	mov    %esp,%ebp
 37c:	53                   	push   %ebx
 37d:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 380:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 387:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 38b:	74 17                	je     3a4 <printint+0x2b>
 38d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 391:	79 11                	jns    3a4 <printint+0x2b>
    neg = 1;
 393:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 39a:	8b 45 0c             	mov    0xc(%ebp),%eax
 39d:	f7 d8                	neg    %eax
 39f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a2:	eb 06                	jmp    3aa <printint+0x31>
  } else {
    x = xx;
 3a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3b4:	8d 41 01             	lea    0x1(%ecx),%eax
 3b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c0:	ba 00 00 00 00       	mov    $0x0,%edx
 3c5:	f7 f3                	div    %ebx
 3c7:	89 d0                	mov    %edx,%eax
 3c9:	0f b6 80 30 0b 00 00 	movzbl 0xb30(%eax),%eax
 3d0:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3da:	ba 00 00 00 00       	mov    $0x0,%edx
 3df:	f7 f3                	div    %ebx
 3e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3e8:	75 c7                	jne    3b1 <printint+0x38>
  if(neg)
 3ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3ee:	74 2d                	je     41d <printint+0xa4>
    buf[i++] = '-';
 3f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f3:	8d 50 01             	lea    0x1(%eax),%edx
 3f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3f9:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3fe:	eb 1d                	jmp    41d <printint+0xa4>
    putc(fd, buf[i]);
 400:	8d 55 dc             	lea    -0x24(%ebp),%edx
 403:	8b 45 f4             	mov    -0xc(%ebp),%eax
 406:	01 d0                	add    %edx,%eax
 408:	0f b6 00             	movzbl (%eax),%eax
 40b:	0f be c0             	movsbl %al,%eax
 40e:	83 ec 08             	sub    $0x8,%esp
 411:	50                   	push   %eax
 412:	ff 75 08             	pushl  0x8(%ebp)
 415:	e8 3c ff ff ff       	call   356 <putc>
 41a:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 41d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 421:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 425:	79 d9                	jns    400 <printint+0x87>
    putc(fd, buf[i]);
}
 427:	90                   	nop
 428:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 42b:	c9                   	leave  
 42c:	c3                   	ret    

0000042d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 42d:	55                   	push   %ebp
 42e:	89 e5                	mov    %esp,%ebp
 430:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 433:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 43a:	8d 45 0c             	lea    0xc(%ebp),%eax
 43d:	83 c0 04             	add    $0x4,%eax
 440:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 443:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 44a:	e9 59 01 00 00       	jmp    5a8 <printf+0x17b>
    c = fmt[i] & 0xff;
 44f:	8b 55 0c             	mov    0xc(%ebp),%edx
 452:	8b 45 f0             	mov    -0x10(%ebp),%eax
 455:	01 d0                	add    %edx,%eax
 457:	0f b6 00             	movzbl (%eax),%eax
 45a:	0f be c0             	movsbl %al,%eax
 45d:	25 ff 00 00 00       	and    $0xff,%eax
 462:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 465:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 469:	75 2c                	jne    497 <printf+0x6a>
      if(c == '%'){
 46b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 46f:	75 0c                	jne    47d <printf+0x50>
        state = '%';
 471:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 478:	e9 27 01 00 00       	jmp    5a4 <printf+0x177>
      } else {
        putc(fd, c);
 47d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 480:	0f be c0             	movsbl %al,%eax
 483:	83 ec 08             	sub    $0x8,%esp
 486:	50                   	push   %eax
 487:	ff 75 08             	pushl  0x8(%ebp)
 48a:	e8 c7 fe ff ff       	call   356 <putc>
 48f:	83 c4 10             	add    $0x10,%esp
 492:	e9 0d 01 00 00       	jmp    5a4 <printf+0x177>
      }
    } else if(state == '%'){
 497:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 49b:	0f 85 03 01 00 00    	jne    5a4 <printf+0x177>
      if(c == 'd'){
 4a1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4a5:	75 1e                	jne    4c5 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4aa:	8b 00                	mov    (%eax),%eax
 4ac:	6a 01                	push   $0x1
 4ae:	6a 0a                	push   $0xa
 4b0:	50                   	push   %eax
 4b1:	ff 75 08             	pushl  0x8(%ebp)
 4b4:	e8 c0 fe ff ff       	call   379 <printint>
 4b9:	83 c4 10             	add    $0x10,%esp
        ap++;
 4bc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4c0:	e9 d8 00 00 00       	jmp    59d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4c5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4c9:	74 06                	je     4d1 <printf+0xa4>
 4cb:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4cf:	75 1e                	jne    4ef <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d4:	8b 00                	mov    (%eax),%eax
 4d6:	6a 00                	push   $0x0
 4d8:	6a 10                	push   $0x10
 4da:	50                   	push   %eax
 4db:	ff 75 08             	pushl  0x8(%ebp)
 4de:	e8 96 fe ff ff       	call   379 <printint>
 4e3:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ea:	e9 ae 00 00 00       	jmp    59d <printf+0x170>
      } else if(c == 's'){
 4ef:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4f3:	75 43                	jne    538 <printf+0x10b>
        s = (char*)*ap;
 4f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f8:	8b 00                	mov    (%eax),%eax
 4fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 501:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 505:	75 25                	jne    52c <printf+0xff>
          s = "(null)";
 507:	c7 45 f4 97 08 00 00 	movl   $0x897,-0xc(%ebp)
        while(*s != 0){
 50e:	eb 1c                	jmp    52c <printf+0xff>
          putc(fd, *s);
 510:	8b 45 f4             	mov    -0xc(%ebp),%eax
 513:	0f b6 00             	movzbl (%eax),%eax
 516:	0f be c0             	movsbl %al,%eax
 519:	83 ec 08             	sub    $0x8,%esp
 51c:	50                   	push   %eax
 51d:	ff 75 08             	pushl  0x8(%ebp)
 520:	e8 31 fe ff ff       	call   356 <putc>
 525:	83 c4 10             	add    $0x10,%esp
          s++;
 528:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 52c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52f:	0f b6 00             	movzbl (%eax),%eax
 532:	84 c0                	test   %al,%al
 534:	75 da                	jne    510 <printf+0xe3>
 536:	eb 65                	jmp    59d <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 538:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 53c:	75 1d                	jne    55b <printf+0x12e>
        putc(fd, *ap);
 53e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 541:	8b 00                	mov    (%eax),%eax
 543:	0f be c0             	movsbl %al,%eax
 546:	83 ec 08             	sub    $0x8,%esp
 549:	50                   	push   %eax
 54a:	ff 75 08             	pushl  0x8(%ebp)
 54d:	e8 04 fe ff ff       	call   356 <putc>
 552:	83 c4 10             	add    $0x10,%esp
        ap++;
 555:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 559:	eb 42                	jmp    59d <printf+0x170>
      } else if(c == '%'){
 55b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 55f:	75 17                	jne    578 <printf+0x14b>
        putc(fd, c);
 561:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 564:	0f be c0             	movsbl %al,%eax
 567:	83 ec 08             	sub    $0x8,%esp
 56a:	50                   	push   %eax
 56b:	ff 75 08             	pushl  0x8(%ebp)
 56e:	e8 e3 fd ff ff       	call   356 <putc>
 573:	83 c4 10             	add    $0x10,%esp
 576:	eb 25                	jmp    59d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 578:	83 ec 08             	sub    $0x8,%esp
 57b:	6a 25                	push   $0x25
 57d:	ff 75 08             	pushl  0x8(%ebp)
 580:	e8 d1 fd ff ff       	call   356 <putc>
 585:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58b:	0f be c0             	movsbl %al,%eax
 58e:	83 ec 08             	sub    $0x8,%esp
 591:	50                   	push   %eax
 592:	ff 75 08             	pushl  0x8(%ebp)
 595:	e8 bc fd ff ff       	call   356 <putc>
 59a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 59d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ae:	01 d0                	add    %edx,%eax
 5b0:	0f b6 00             	movzbl (%eax),%eax
 5b3:	84 c0                	test   %al,%al
 5b5:	0f 85 94 fe ff ff    	jne    44f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5bb:	90                   	nop
 5bc:	c9                   	leave  
 5bd:	c3                   	ret    

000005be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5be:	55                   	push   %ebp
 5bf:	89 e5                	mov    %esp,%ebp
 5c1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	83 e8 08             	sub    $0x8,%eax
 5ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5cd:	a1 68 0b 00 00       	mov    0xb68,%eax
 5d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d5:	eb 24                	jmp    5fb <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5da:	8b 00                	mov    (%eax),%eax
 5dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5df:	77 12                	ja     5f3 <free+0x35>
 5e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e7:	77 24                	ja     60d <free+0x4f>
 5e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ec:	8b 00                	mov    (%eax),%eax
 5ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5f1:	77 1a                	ja     60d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f6:	8b 00                	mov    (%eax),%eax
 5f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 601:	76 d4                	jbe    5d7 <free+0x19>
 603:	8b 45 fc             	mov    -0x4(%ebp),%eax
 606:	8b 00                	mov    (%eax),%eax
 608:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 60b:	76 ca                	jbe    5d7 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 60d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 610:	8b 40 04             	mov    0x4(%eax),%eax
 613:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 61a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61d:	01 c2                	add    %eax,%edx
 61f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 622:	8b 00                	mov    (%eax),%eax
 624:	39 c2                	cmp    %eax,%edx
 626:	75 24                	jne    64c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 628:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62b:	8b 50 04             	mov    0x4(%eax),%edx
 62e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 631:	8b 00                	mov    (%eax),%eax
 633:	8b 40 04             	mov    0x4(%eax),%eax
 636:	01 c2                	add    %eax,%edx
 638:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 63e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 641:	8b 00                	mov    (%eax),%eax
 643:	8b 10                	mov    (%eax),%edx
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	89 10                	mov    %edx,(%eax)
 64a:	eb 0a                	jmp    656 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 10                	mov    (%eax),%edx
 651:	8b 45 f8             	mov    -0x8(%ebp),%eax
 654:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 40 04             	mov    0x4(%eax),%eax
 65c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	01 d0                	add    %edx,%eax
 668:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66b:	75 20                	jne    68d <free+0xcf>
    p->s.size += bp->s.size;
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 50 04             	mov    0x4(%eax),%edx
 673:	8b 45 f8             	mov    -0x8(%ebp),%eax
 676:	8b 40 04             	mov    0x4(%eax),%eax
 679:	01 c2                	add    %eax,%edx
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 681:	8b 45 f8             	mov    -0x8(%ebp),%eax
 684:	8b 10                	mov    (%eax),%edx
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	89 10                	mov    %edx,(%eax)
 68b:	eb 08                	jmp    695 <free+0xd7>
  } else
    p->s.ptr = bp;
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 55 f8             	mov    -0x8(%ebp),%edx
 693:	89 10                	mov    %edx,(%eax)
  freep = p;
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	a3 68 0b 00 00       	mov    %eax,0xb68
}
 69d:	90                   	nop
 69e:	c9                   	leave  
 69f:	c3                   	ret    

000006a0 <morecore>:

static Header*
morecore(uint nu)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6a6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6ad:	77 07                	ja     6b6 <morecore+0x16>
    nu = 4096;
 6af:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6b6:	8b 45 08             	mov    0x8(%ebp),%eax
 6b9:	c1 e0 03             	shl    $0x3,%eax
 6bc:	83 ec 0c             	sub    $0xc,%esp
 6bf:	50                   	push   %eax
 6c0:	e8 39 fc ff ff       	call   2fe <sbrk>
 6c5:	83 c4 10             	add    $0x10,%esp
 6c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6cb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6cf:	75 07                	jne    6d8 <morecore+0x38>
    return 0;
 6d1:	b8 00 00 00 00       	mov    $0x0,%eax
 6d6:	eb 26                	jmp    6fe <morecore+0x5e>
  hp = (Header*)p;
 6d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e1:	8b 55 08             	mov    0x8(%ebp),%edx
 6e4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ea:	83 c0 08             	add    $0x8,%eax
 6ed:	83 ec 0c             	sub    $0xc,%esp
 6f0:	50                   	push   %eax
 6f1:	e8 c8 fe ff ff       	call   5be <free>
 6f6:	83 c4 10             	add    $0x10,%esp
  return freep;
 6f9:	a1 68 0b 00 00       	mov    0xb68,%eax
}
 6fe:	c9                   	leave  
 6ff:	c3                   	ret    

00000700 <malloc>:

void*
malloc(uint nbytes)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 706:	8b 45 08             	mov    0x8(%ebp),%eax
 709:	83 c0 07             	add    $0x7,%eax
 70c:	c1 e8 03             	shr    $0x3,%eax
 70f:	83 c0 01             	add    $0x1,%eax
 712:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 715:	a1 68 0b 00 00       	mov    0xb68,%eax
 71a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 71d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 721:	75 23                	jne    746 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 723:	c7 45 f0 60 0b 00 00 	movl   $0xb60,-0x10(%ebp)
 72a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72d:	a3 68 0b 00 00       	mov    %eax,0xb68
 732:	a1 68 0b 00 00       	mov    0xb68,%eax
 737:	a3 60 0b 00 00       	mov    %eax,0xb60
    base.s.size = 0;
 73c:	c7 05 64 0b 00 00 00 	movl   $0x0,0xb64
 743:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 746:	8b 45 f0             	mov    -0x10(%ebp),%eax
 749:	8b 00                	mov    (%eax),%eax
 74b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 74e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 751:	8b 40 04             	mov    0x4(%eax),%eax
 754:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 757:	72 4d                	jb     7a6 <malloc+0xa6>
      if(p->s.size == nunits)
 759:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75c:	8b 40 04             	mov    0x4(%eax),%eax
 75f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 762:	75 0c                	jne    770 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 764:	8b 45 f4             	mov    -0xc(%ebp),%eax
 767:	8b 10                	mov    (%eax),%edx
 769:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76c:	89 10                	mov    %edx,(%eax)
 76e:	eb 26                	jmp    796 <malloc+0x96>
      else {
        p->s.size -= nunits;
 770:	8b 45 f4             	mov    -0xc(%ebp),%eax
 773:	8b 40 04             	mov    0x4(%eax),%eax
 776:	2b 45 ec             	sub    -0x14(%ebp),%eax
 779:	89 c2                	mov    %eax,%edx
 77b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 781:	8b 45 f4             	mov    -0xc(%ebp),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	c1 e0 03             	shl    $0x3,%eax
 78a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 78d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 790:	8b 55 ec             	mov    -0x14(%ebp),%edx
 793:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 796:	8b 45 f0             	mov    -0x10(%ebp),%eax
 799:	a3 68 0b 00 00       	mov    %eax,0xb68
      return (void*)(p + 1);
 79e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a1:	83 c0 08             	add    $0x8,%eax
 7a4:	eb 3b                	jmp    7e1 <malloc+0xe1>
    }
    if(p == freep)
 7a6:	a1 68 0b 00 00       	mov    0xb68,%eax
 7ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ae:	75 1e                	jne    7ce <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7b0:	83 ec 0c             	sub    $0xc,%esp
 7b3:	ff 75 ec             	pushl  -0x14(%ebp)
 7b6:	e8 e5 fe ff ff       	call   6a0 <morecore>
 7bb:	83 c4 10             	add    $0x10,%esp
 7be:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c5:	75 07                	jne    7ce <malloc+0xce>
        return 0;
 7c7:	b8 00 00 00 00       	mov    $0x0,%eax
 7cc:	eb 13                	jmp    7e1 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7dc:	e9 6d ff ff ff       	jmp    74e <malloc+0x4e>
}
 7e1:	c9                   	leave  
 7e2:	c3                   	ret    

000007e3 <hufs_thread_create>:

int thread_num = 0;


int hufs_thread_create(void *func(), void *args)
{
 7e3:	55                   	push   %ebp
 7e4:	89 e5                	mov    %esp,%ebp
 7e6:	83 ec 18             	sub    $0x18,%esp
	void *stack; 
	int pid;

	stack = malloc(4096);
 7e9:	83 ec 0c             	sub    $0xc,%esp
 7ec:	68 00 10 00 00       	push   $0x1000
 7f1:	e8 0a ff ff ff       	call   700 <malloc>
 7f6:	83 c4 10             	add    $0x10,%esp
 7f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (stack==0) return -1;
 7fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 800:	75 07                	jne    809 <hufs_thread_create+0x26>
 802:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 807:	eb 42                	jmp    84b <hufs_thread_create+0x68>

	pid = clone(func, args, stack); 
 809:	83 ec 04             	sub    $0x4,%esp
 80c:	ff 75 f4             	pushl  -0xc(%ebp)
 80f:	ff 75 0c             	pushl  0xc(%ebp)
 812:	ff 75 08             	pushl  0x8(%ebp)
 815:	e8 2c fb ff ff       	call   346 <clone>
 81a:	83 c4 10             	add    $0x10,%esp
 81d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (pid==-1) {
 820:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 824:	75 15                	jne    83b <hufs_thread_create+0x58>
		free(stack);
 826:	83 ec 0c             	sub    $0xc,%esp
 829:	ff 75 f4             	pushl  -0xc(%ebp)
 82c:	e8 8d fd ff ff       	call   5be <free>
 831:	83 c4 10             	add    $0x10,%esp
		return -1;
 834:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 839:	eb 10                	jmp    84b <hufs_thread_create+0x68>
	}

	thread_info[pid].stack = stack; 
 83b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 841:	89 14 85 80 0b 00 00 	mov    %edx,0xb80(,%eax,4)

	return pid; 
 848:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 84b:	c9                   	leave  
 84c:	c3                   	ret    

0000084d <hufs_thread_join>:

int hufs_thread_join(int pid)
{
 84d:	55                   	push   %ebp
 84e:	89 e5                	mov    %esp,%ebp
 850:	83 ec 18             	sub    $0x18,%esp
	void *stack = thread_info[pid].stack;
 853:	8b 45 08             	mov    0x8(%ebp),%eax
 856:	8b 04 85 80 0b 00 00 	mov    0xb80(,%eax,4),%eax
 85d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (stack==0) return -1;
 860:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 864:	75 07                	jne    86d <hufs_thread_join+0x20>
 866:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 86b:	eb 28                	jmp    895 <hufs_thread_join+0x48>

	join(&thread_info[pid].stack);	
 86d:	8b 45 08             	mov    0x8(%ebp),%eax
 870:	c1 e0 02             	shl    $0x2,%eax
 873:	05 80 0b 00 00       	add    $0xb80,%eax
 878:	83 ec 0c             	sub    $0xc,%esp
 87b:	50                   	push   %eax
 87c:	e8 cd fa ff ff       	call   34e <join>
 881:	83 c4 10             	add    $0x10,%esp
	free(stack);
 884:	83 ec 0c             	sub    $0xc,%esp
 887:	ff 75 f4             	pushl  -0xc(%ebp)
 88a:	e8 2f fd ff ff       	call   5be <free>
 88f:	83 c4 10             	add    $0x10,%esp

	return pid;
 892:	8b 45 08             	mov    0x8(%ebp),%eax
}
 895:	c9                   	leave  
 896:	c3                   	ret    
