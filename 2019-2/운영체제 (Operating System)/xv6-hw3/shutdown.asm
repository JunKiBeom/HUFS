
_shutdown:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
	halt();
  11:	e8 fc 02 00 00       	call   312 <halt>
	exit();
  16:	e8 57 02 00 00       	call   272 <exit>

0000001b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  1b:	55                   	push   %ebp
  1c:	89 e5                	mov    %esp,%ebp
  1e:	57                   	push   %edi
  1f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  23:	8b 55 10             	mov    0x10(%ebp),%edx
  26:	8b 45 0c             	mov    0xc(%ebp),%eax
  29:	89 cb                	mov    %ecx,%ebx
  2b:	89 df                	mov    %ebx,%edi
  2d:	89 d1                	mov    %edx,%ecx
  2f:	fc                   	cld    
  30:	f3 aa                	rep stos %al,%es:(%edi)
  32:	89 ca                	mov    %ecx,%edx
  34:	89 fb                	mov    %edi,%ebx
  36:	89 5d 08             	mov    %ebx,0x8(%ebp)
  39:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  3c:	90                   	nop
  3d:	5b                   	pop    %ebx
  3e:	5f                   	pop    %edi
  3f:	5d                   	pop    %ebp
  40:	c3                   	ret    

00000041 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  41:	55                   	push   %ebp
  42:	89 e5                	mov    %esp,%ebp
  44:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  47:	8b 45 08             	mov    0x8(%ebp),%eax
  4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  4d:	90                   	nop
  4e:	8b 45 08             	mov    0x8(%ebp),%eax
  51:	8d 50 01             	lea    0x1(%eax),%edx
  54:	89 55 08             	mov    %edx,0x8(%ebp)
  57:	8b 55 0c             	mov    0xc(%ebp),%edx
  5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  5d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  60:	0f b6 12             	movzbl (%edx),%edx
  63:	88 10                	mov    %dl,(%eax)
  65:	0f b6 00             	movzbl (%eax),%eax
  68:	84 c0                	test   %al,%al
  6a:	75 e2                	jne    4e <strcpy+0xd>
    ;
  return os;
  6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  6f:	c9                   	leave  
  70:	c3                   	ret    

00000071 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  71:	55                   	push   %ebp
  72:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  74:	eb 08                	jmp    7e <strcmp+0xd>
    p++, q++;
  76:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  7a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  7e:	8b 45 08             	mov    0x8(%ebp),%eax
  81:	0f b6 00             	movzbl (%eax),%eax
  84:	84 c0                	test   %al,%al
  86:	74 10                	je     98 <strcmp+0x27>
  88:	8b 45 08             	mov    0x8(%ebp),%eax
  8b:	0f b6 10             	movzbl (%eax),%edx
  8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  91:	0f b6 00             	movzbl (%eax),%eax
  94:	38 c2                	cmp    %al,%dl
  96:	74 de                	je     76 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	0f b6 00             	movzbl (%eax),%eax
  9e:	0f b6 d0             	movzbl %al,%edx
  a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  a4:	0f b6 00             	movzbl (%eax),%eax
  a7:	0f b6 c0             	movzbl %al,%eax
  aa:	29 c2                	sub    %eax,%edx
  ac:	89 d0                	mov    %edx,%eax
}
  ae:	5d                   	pop    %ebp
  af:	c3                   	ret    

000000b0 <strlen>:

uint
strlen(char *s)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  bd:	eb 04                	jmp    c3 <strlen+0x13>
  bf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  c6:	8b 45 08             	mov    0x8(%ebp),%eax
  c9:	01 d0                	add    %edx,%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	84 c0                	test   %al,%al
  d0:	75 ed                	jne    bf <strlen+0xf>
    ;
  return n;
  d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d5:	c9                   	leave  
  d6:	c3                   	ret    

000000d7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d7:	55                   	push   %ebp
  d8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  da:	8b 45 10             	mov    0x10(%ebp),%eax
  dd:	50                   	push   %eax
  de:	ff 75 0c             	pushl  0xc(%ebp)
  e1:	ff 75 08             	pushl  0x8(%ebp)
  e4:	e8 32 ff ff ff       	call   1b <stosb>
  e9:	83 c4 0c             	add    $0xc,%esp
  return dst;
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  ef:	c9                   	leave  
  f0:	c3                   	ret    

000000f1 <strchr>:

char*
strchr(const char *s, char c)
{
  f1:	55                   	push   %ebp
  f2:	89 e5                	mov    %esp,%ebp
  f4:	83 ec 04             	sub    $0x4,%esp
  f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  fa:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
  fd:	eb 14                	jmp    113 <strchr+0x22>
    if(*s == c)
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	0f b6 00             	movzbl (%eax),%eax
 105:	3a 45 fc             	cmp    -0x4(%ebp),%al
 108:	75 05                	jne    10f <strchr+0x1e>
      return (char*)s;
 10a:	8b 45 08             	mov    0x8(%ebp),%eax
 10d:	eb 13                	jmp    122 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 10f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	0f b6 00             	movzbl (%eax),%eax
 119:	84 c0                	test   %al,%al
 11b:	75 e2                	jne    ff <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 11d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 122:	c9                   	leave  
 123:	c3                   	ret    

00000124 <gets>:

char*
gets(char *buf, int max)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 131:	eb 42                	jmp    175 <gets+0x51>
    cc = read(0, &c, 1);
 133:	83 ec 04             	sub    $0x4,%esp
 136:	6a 01                	push   $0x1
 138:	8d 45 ef             	lea    -0x11(%ebp),%eax
 13b:	50                   	push   %eax
 13c:	6a 00                	push   $0x0
 13e:	e8 47 01 00 00       	call   28a <read>
 143:	83 c4 10             	add    $0x10,%esp
 146:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 149:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 14d:	7e 33                	jle    182 <gets+0x5e>
      break;
    buf[i++] = c;
 14f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 152:	8d 50 01             	lea    0x1(%eax),%edx
 155:	89 55 f4             	mov    %edx,-0xc(%ebp)
 158:	89 c2                	mov    %eax,%edx
 15a:	8b 45 08             	mov    0x8(%ebp),%eax
 15d:	01 c2                	add    %eax,%edx
 15f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 163:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 165:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 169:	3c 0a                	cmp    $0xa,%al
 16b:	74 16                	je     183 <gets+0x5f>
 16d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 171:	3c 0d                	cmp    $0xd,%al
 173:	74 0e                	je     183 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 175:	8b 45 f4             	mov    -0xc(%ebp),%eax
 178:	83 c0 01             	add    $0x1,%eax
 17b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 17e:	7c b3                	jl     133 <gets+0xf>
 180:	eb 01                	jmp    183 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 182:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 183:	8b 55 f4             	mov    -0xc(%ebp),%edx
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	01 d0                	add    %edx,%eax
 18b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 191:	c9                   	leave  
 192:	c3                   	ret    

00000193 <stat>:

int
stat(char *n, struct stat *st)
{
 193:	55                   	push   %ebp
 194:	89 e5                	mov    %esp,%ebp
 196:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 199:	83 ec 08             	sub    $0x8,%esp
 19c:	6a 00                	push   $0x0
 19e:	ff 75 08             	pushl  0x8(%ebp)
 1a1:	e8 0c 01 00 00       	call   2b2 <open>
 1a6:	83 c4 10             	add    $0x10,%esp
 1a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b0:	79 07                	jns    1b9 <stat+0x26>
    return -1;
 1b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1b7:	eb 25                	jmp    1de <stat+0x4b>
  r = fstat(fd, st);
 1b9:	83 ec 08             	sub    $0x8,%esp
 1bc:	ff 75 0c             	pushl  0xc(%ebp)
 1bf:	ff 75 f4             	pushl  -0xc(%ebp)
 1c2:	e8 03 01 00 00       	call   2ca <fstat>
 1c7:	83 c4 10             	add    $0x10,%esp
 1ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1cd:	83 ec 0c             	sub    $0xc,%esp
 1d0:	ff 75 f4             	pushl  -0xc(%ebp)
 1d3:	e8 c2 00 00 00       	call   29a <close>
 1d8:	83 c4 10             	add    $0x10,%esp
  return r;
 1db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1de:	c9                   	leave  
 1df:	c3                   	ret    

000001e0 <atoi>:

int
atoi(const char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1ed:	eb 25                	jmp    214 <atoi+0x34>
    n = n*10 + *s++ - '0';
 1ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f2:	89 d0                	mov    %edx,%eax
 1f4:	c1 e0 02             	shl    $0x2,%eax
 1f7:	01 d0                	add    %edx,%eax
 1f9:	01 c0                	add    %eax,%eax
 1fb:	89 c1                	mov    %eax,%ecx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	8d 50 01             	lea    0x1(%eax),%edx
 203:	89 55 08             	mov    %edx,0x8(%ebp)
 206:	0f b6 00             	movzbl (%eax),%eax
 209:	0f be c0             	movsbl %al,%eax
 20c:	01 c8                	add    %ecx,%eax
 20e:	83 e8 30             	sub    $0x30,%eax
 211:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	3c 2f                	cmp    $0x2f,%al
 21c:	7e 0a                	jle    228 <atoi+0x48>
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
 221:	0f b6 00             	movzbl (%eax),%eax
 224:	3c 39                	cmp    $0x39,%al
 226:	7e c7                	jle    1ef <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 228:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22b:	c9                   	leave  
 22c:	c3                   	ret    

0000022d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 22d:	55                   	push   %ebp
 22e:	89 e5                	mov    %esp,%ebp
 230:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 23f:	eb 17                	jmp    258 <memmove+0x2b>
    *dst++ = *src++;
 241:	8b 45 fc             	mov    -0x4(%ebp),%eax
 244:	8d 50 01             	lea    0x1(%eax),%edx
 247:	89 55 fc             	mov    %edx,-0x4(%ebp)
 24a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 24d:	8d 4a 01             	lea    0x1(%edx),%ecx
 250:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 253:	0f b6 12             	movzbl (%edx),%edx
 256:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 258:	8b 45 10             	mov    0x10(%ebp),%eax
 25b:	8d 50 ff             	lea    -0x1(%eax),%edx
 25e:	89 55 10             	mov    %edx,0x10(%ebp)
 261:	85 c0                	test   %eax,%eax
 263:	7f dc                	jg     241 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 265:	8b 45 08             	mov    0x8(%ebp),%eax
}
 268:	c9                   	leave  
 269:	c3                   	ret    

0000026a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 26a:	b8 01 00 00 00       	mov    $0x1,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <exit>:
SYSCALL(exit)
 272:	b8 02 00 00 00       	mov    $0x2,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <wait>:
SYSCALL(wait)
 27a:	b8 03 00 00 00       	mov    $0x3,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <pipe>:
SYSCALL(pipe)
 282:	b8 04 00 00 00       	mov    $0x4,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <read>:
SYSCALL(read)
 28a:	b8 05 00 00 00       	mov    $0x5,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <write>:
SYSCALL(write)
 292:	b8 10 00 00 00       	mov    $0x10,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <close>:
SYSCALL(close)
 29a:	b8 15 00 00 00       	mov    $0x15,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <kill>:
SYSCALL(kill)
 2a2:	b8 06 00 00 00       	mov    $0x6,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <exec>:
SYSCALL(exec)
 2aa:	b8 07 00 00 00       	mov    $0x7,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <open>:
SYSCALL(open)
 2b2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <mknod>:
SYSCALL(mknod)
 2ba:	b8 11 00 00 00       	mov    $0x11,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <unlink>:
SYSCALL(unlink)
 2c2:	b8 12 00 00 00       	mov    $0x12,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <fstat>:
SYSCALL(fstat)
 2ca:	b8 08 00 00 00       	mov    $0x8,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <link>:
SYSCALL(link)
 2d2:	b8 13 00 00 00       	mov    $0x13,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <mkdir>:
SYSCALL(mkdir)
 2da:	b8 14 00 00 00       	mov    $0x14,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <chdir>:
SYSCALL(chdir)
 2e2:	b8 09 00 00 00       	mov    $0x9,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <dup>:
SYSCALL(dup)
 2ea:	b8 0a 00 00 00       	mov    $0xa,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <getpid>:
SYSCALL(getpid)
 2f2:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <sbrk>:
SYSCALL(sbrk)
 2fa:	b8 0c 00 00 00       	mov    $0xc,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <sleep>:
SYSCALL(sleep)
 302:	b8 0d 00 00 00       	mov    $0xd,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <uptime>:
SYSCALL(uptime)
 30a:	b8 0e 00 00 00       	mov    $0xe,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <halt>:
SYSCALL(halt)
 312:	b8 16 00 00 00       	mov    $0x16,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <getnp>:
SYSCALL(getnp)
 31a:	b8 17 00 00 00       	mov    $0x17,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <sem_create>:
SYSCALL(sem_create)
 322:	b8 18 00 00 00       	mov    $0x18,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <sem_destroy>:
SYSCALL(sem_destroy)
 32a:	b8 19 00 00 00       	mov    $0x19,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <sem_wait>:
SYSCALL(sem_wait)
 332:	b8 1a 00 00 00       	mov    $0x1a,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <sem_signal>:
SYSCALL(sem_signal)
 33a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <clone>:
SYSCALL(clone)
 342:	b8 1c 00 00 00       	mov    $0x1c,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <join>:
SYSCALL(join)
 34a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 352:	55                   	push   %ebp
 353:	89 e5                	mov    %esp,%ebp
 355:	83 ec 18             	sub    $0x18,%esp
 358:	8b 45 0c             	mov    0xc(%ebp),%eax
 35b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 35e:	83 ec 04             	sub    $0x4,%esp
 361:	6a 01                	push   $0x1
 363:	8d 45 f4             	lea    -0xc(%ebp),%eax
 366:	50                   	push   %eax
 367:	ff 75 08             	pushl  0x8(%ebp)
 36a:	e8 23 ff ff ff       	call   292 <write>
 36f:	83 c4 10             	add    $0x10,%esp
}
 372:	90                   	nop
 373:	c9                   	leave  
 374:	c3                   	ret    

00000375 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 375:	55                   	push   %ebp
 376:	89 e5                	mov    %esp,%ebp
 378:	53                   	push   %ebx
 379:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 37c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 383:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 387:	74 17                	je     3a0 <printint+0x2b>
 389:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 38d:	79 11                	jns    3a0 <printint+0x2b>
    neg = 1;
 38f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 396:	8b 45 0c             	mov    0xc(%ebp),%eax
 399:	f7 d8                	neg    %eax
 39b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 39e:	eb 06                	jmp    3a6 <printint+0x31>
  } else {
    x = xx;
 3a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3ad:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3b0:	8d 41 01             	lea    0x1(%ecx),%eax
 3b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3bc:	ba 00 00 00 00       	mov    $0x0,%edx
 3c1:	f7 f3                	div    %ebx
 3c3:	89 d0                	mov    %edx,%eax
 3c5:	0f b6 80 24 0b 00 00 	movzbl 0xb24(%eax),%eax
 3cc:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d6:	ba 00 00 00 00       	mov    $0x0,%edx
 3db:	f7 f3                	div    %ebx
 3dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3e4:	75 c7                	jne    3ad <printint+0x38>
  if(neg)
 3e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3ea:	74 2d                	je     419 <printint+0xa4>
    buf[i++] = '-';
 3ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ef:	8d 50 01             	lea    0x1(%eax),%edx
 3f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3f5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3fa:	eb 1d                	jmp    419 <printint+0xa4>
    putc(fd, buf[i]);
 3fc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 402:	01 d0                	add    %edx,%eax
 404:	0f b6 00             	movzbl (%eax),%eax
 407:	0f be c0             	movsbl %al,%eax
 40a:	83 ec 08             	sub    $0x8,%esp
 40d:	50                   	push   %eax
 40e:	ff 75 08             	pushl  0x8(%ebp)
 411:	e8 3c ff ff ff       	call   352 <putc>
 416:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 419:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 41d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 421:	79 d9                	jns    3fc <printint+0x87>
    putc(fd, buf[i]);
}
 423:	90                   	nop
 424:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 427:	c9                   	leave  
 428:	c3                   	ret    

00000429 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 429:	55                   	push   %ebp
 42a:	89 e5                	mov    %esp,%ebp
 42c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 42f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 436:	8d 45 0c             	lea    0xc(%ebp),%eax
 439:	83 c0 04             	add    $0x4,%eax
 43c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 43f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 446:	e9 59 01 00 00       	jmp    5a4 <printf+0x17b>
    c = fmt[i] & 0xff;
 44b:	8b 55 0c             	mov    0xc(%ebp),%edx
 44e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 451:	01 d0                	add    %edx,%eax
 453:	0f b6 00             	movzbl (%eax),%eax
 456:	0f be c0             	movsbl %al,%eax
 459:	25 ff 00 00 00       	and    $0xff,%eax
 45e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 461:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 465:	75 2c                	jne    493 <printf+0x6a>
      if(c == '%'){
 467:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 46b:	75 0c                	jne    479 <printf+0x50>
        state = '%';
 46d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 474:	e9 27 01 00 00       	jmp    5a0 <printf+0x177>
      } else {
        putc(fd, c);
 479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 47c:	0f be c0             	movsbl %al,%eax
 47f:	83 ec 08             	sub    $0x8,%esp
 482:	50                   	push   %eax
 483:	ff 75 08             	pushl  0x8(%ebp)
 486:	e8 c7 fe ff ff       	call   352 <putc>
 48b:	83 c4 10             	add    $0x10,%esp
 48e:	e9 0d 01 00 00       	jmp    5a0 <printf+0x177>
      }
    } else if(state == '%'){
 493:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 497:	0f 85 03 01 00 00    	jne    5a0 <printf+0x177>
      if(c == 'd'){
 49d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4a1:	75 1e                	jne    4c1 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a6:	8b 00                	mov    (%eax),%eax
 4a8:	6a 01                	push   $0x1
 4aa:	6a 0a                	push   $0xa
 4ac:	50                   	push   %eax
 4ad:	ff 75 08             	pushl  0x8(%ebp)
 4b0:	e8 c0 fe ff ff       	call   375 <printint>
 4b5:	83 c4 10             	add    $0x10,%esp
        ap++;
 4b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4bc:	e9 d8 00 00 00       	jmp    599 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4c1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4c5:	74 06                	je     4cd <printf+0xa4>
 4c7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4cb:	75 1e                	jne    4eb <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d0:	8b 00                	mov    (%eax),%eax
 4d2:	6a 00                	push   $0x0
 4d4:	6a 10                	push   $0x10
 4d6:	50                   	push   %eax
 4d7:	ff 75 08             	pushl  0x8(%ebp)
 4da:	e8 96 fe ff ff       	call   375 <printint>
 4df:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e6:	e9 ae 00 00 00       	jmp    599 <printf+0x170>
      } else if(c == 's'){
 4eb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4ef:	75 43                	jne    534 <printf+0x10b>
        s = (char*)*ap;
 4f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f4:	8b 00                	mov    (%eax),%eax
 4f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 501:	75 25                	jne    528 <printf+0xff>
          s = "(null)";
 503:	c7 45 f4 93 08 00 00 	movl   $0x893,-0xc(%ebp)
        while(*s != 0){
 50a:	eb 1c                	jmp    528 <printf+0xff>
          putc(fd, *s);
 50c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50f:	0f b6 00             	movzbl (%eax),%eax
 512:	0f be c0             	movsbl %al,%eax
 515:	83 ec 08             	sub    $0x8,%esp
 518:	50                   	push   %eax
 519:	ff 75 08             	pushl  0x8(%ebp)
 51c:	e8 31 fe ff ff       	call   352 <putc>
 521:	83 c4 10             	add    $0x10,%esp
          s++;
 524:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 528:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52b:	0f b6 00             	movzbl (%eax),%eax
 52e:	84 c0                	test   %al,%al
 530:	75 da                	jne    50c <printf+0xe3>
 532:	eb 65                	jmp    599 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 534:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 538:	75 1d                	jne    557 <printf+0x12e>
        putc(fd, *ap);
 53a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53d:	8b 00                	mov    (%eax),%eax
 53f:	0f be c0             	movsbl %al,%eax
 542:	83 ec 08             	sub    $0x8,%esp
 545:	50                   	push   %eax
 546:	ff 75 08             	pushl  0x8(%ebp)
 549:	e8 04 fe ff ff       	call   352 <putc>
 54e:	83 c4 10             	add    $0x10,%esp
        ap++;
 551:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 555:	eb 42                	jmp    599 <printf+0x170>
      } else if(c == '%'){
 557:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 55b:	75 17                	jne    574 <printf+0x14b>
        putc(fd, c);
 55d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 560:	0f be c0             	movsbl %al,%eax
 563:	83 ec 08             	sub    $0x8,%esp
 566:	50                   	push   %eax
 567:	ff 75 08             	pushl  0x8(%ebp)
 56a:	e8 e3 fd ff ff       	call   352 <putc>
 56f:	83 c4 10             	add    $0x10,%esp
 572:	eb 25                	jmp    599 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 574:	83 ec 08             	sub    $0x8,%esp
 577:	6a 25                	push   $0x25
 579:	ff 75 08             	pushl  0x8(%ebp)
 57c:	e8 d1 fd ff ff       	call   352 <putc>
 581:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 587:	0f be c0             	movsbl %al,%eax
 58a:	83 ec 08             	sub    $0x8,%esp
 58d:	50                   	push   %eax
 58e:	ff 75 08             	pushl  0x8(%ebp)
 591:	e8 bc fd ff ff       	call   352 <putc>
 596:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 599:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5a4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5aa:	01 d0                	add    %edx,%eax
 5ac:	0f b6 00             	movzbl (%eax),%eax
 5af:	84 c0                	test   %al,%al
 5b1:	0f 85 94 fe ff ff    	jne    44b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5b7:	90                   	nop
 5b8:	c9                   	leave  
 5b9:	c3                   	ret    

000005ba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ba:	55                   	push   %ebp
 5bb:	89 e5                	mov    %esp,%ebp
 5bd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c0:	8b 45 08             	mov    0x8(%ebp),%eax
 5c3:	83 e8 08             	sub    $0x8,%eax
 5c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c9:	a1 48 0b 00 00       	mov    0xb48,%eax
 5ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d1:	eb 24                	jmp    5f7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d6:	8b 00                	mov    (%eax),%eax
 5d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5db:	77 12                	ja     5ef <free+0x35>
 5dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e3:	77 24                	ja     609 <free+0x4f>
 5e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e8:	8b 00                	mov    (%eax),%eax
 5ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5ed:	77 1a                	ja     609 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f2:	8b 00                	mov    (%eax),%eax
 5f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5fd:	76 d4                	jbe    5d3 <free+0x19>
 5ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 602:	8b 00                	mov    (%eax),%eax
 604:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 607:	76 ca                	jbe    5d3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 609:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60c:	8b 40 04             	mov    0x4(%eax),%eax
 60f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 616:	8b 45 f8             	mov    -0x8(%ebp),%eax
 619:	01 c2                	add    %eax,%edx
 61b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61e:	8b 00                	mov    (%eax),%eax
 620:	39 c2                	cmp    %eax,%edx
 622:	75 24                	jne    648 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 624:	8b 45 f8             	mov    -0x8(%ebp),%eax
 627:	8b 50 04             	mov    0x4(%eax),%edx
 62a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62d:	8b 00                	mov    (%eax),%eax
 62f:	8b 40 04             	mov    0x4(%eax),%eax
 632:	01 c2                	add    %eax,%edx
 634:	8b 45 f8             	mov    -0x8(%ebp),%eax
 637:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	8b 00                	mov    (%eax),%eax
 63f:	8b 10                	mov    (%eax),%edx
 641:	8b 45 f8             	mov    -0x8(%ebp),%eax
 644:	89 10                	mov    %edx,(%eax)
 646:	eb 0a                	jmp    652 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 10                	mov    (%eax),%edx
 64d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 650:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 652:	8b 45 fc             	mov    -0x4(%ebp),%eax
 655:	8b 40 04             	mov    0x4(%eax),%eax
 658:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	01 d0                	add    %edx,%eax
 664:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 667:	75 20                	jne    689 <free+0xcf>
    p->s.size += bp->s.size;
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 50 04             	mov    0x4(%eax),%edx
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	8b 40 04             	mov    0x4(%eax),%eax
 675:	01 c2                	add    %eax,%edx
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	8b 10                	mov    (%eax),%edx
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	89 10                	mov    %edx,(%eax)
 687:	eb 08                	jmp    691 <free+0xd7>
  } else
    p->s.ptr = bp;
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 68f:	89 10                	mov    %edx,(%eax)
  freep = p;
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	a3 48 0b 00 00       	mov    %eax,0xb48
}
 699:	90                   	nop
 69a:	c9                   	leave  
 69b:	c3                   	ret    

0000069c <morecore>:

static Header*
morecore(uint nu)
{
 69c:	55                   	push   %ebp
 69d:	89 e5                	mov    %esp,%ebp
 69f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6a2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6a9:	77 07                	ja     6b2 <morecore+0x16>
    nu = 4096;
 6ab:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6b2:	8b 45 08             	mov    0x8(%ebp),%eax
 6b5:	c1 e0 03             	shl    $0x3,%eax
 6b8:	83 ec 0c             	sub    $0xc,%esp
 6bb:	50                   	push   %eax
 6bc:	e8 39 fc ff ff       	call   2fa <sbrk>
 6c1:	83 c4 10             	add    $0x10,%esp
 6c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6c7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6cb:	75 07                	jne    6d4 <morecore+0x38>
    return 0;
 6cd:	b8 00 00 00 00       	mov    $0x0,%eax
 6d2:	eb 26                	jmp    6fa <morecore+0x5e>
  hp = (Header*)p;
 6d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6dd:	8b 55 08             	mov    0x8(%ebp),%edx
 6e0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e6:	83 c0 08             	add    $0x8,%eax
 6e9:	83 ec 0c             	sub    $0xc,%esp
 6ec:	50                   	push   %eax
 6ed:	e8 c8 fe ff ff       	call   5ba <free>
 6f2:	83 c4 10             	add    $0x10,%esp
  return freep;
 6f5:	a1 48 0b 00 00       	mov    0xb48,%eax
}
 6fa:	c9                   	leave  
 6fb:	c3                   	ret    

000006fc <malloc>:

void*
malloc(uint nbytes)
{
 6fc:	55                   	push   %ebp
 6fd:	89 e5                	mov    %esp,%ebp
 6ff:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 702:	8b 45 08             	mov    0x8(%ebp),%eax
 705:	83 c0 07             	add    $0x7,%eax
 708:	c1 e8 03             	shr    $0x3,%eax
 70b:	83 c0 01             	add    $0x1,%eax
 70e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 711:	a1 48 0b 00 00       	mov    0xb48,%eax
 716:	89 45 f0             	mov    %eax,-0x10(%ebp)
 719:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 71d:	75 23                	jne    742 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 71f:	c7 45 f0 40 0b 00 00 	movl   $0xb40,-0x10(%ebp)
 726:	8b 45 f0             	mov    -0x10(%ebp),%eax
 729:	a3 48 0b 00 00       	mov    %eax,0xb48
 72e:	a1 48 0b 00 00       	mov    0xb48,%eax
 733:	a3 40 0b 00 00       	mov    %eax,0xb40
    base.s.size = 0;
 738:	c7 05 44 0b 00 00 00 	movl   $0x0,0xb44
 73f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 742:	8b 45 f0             	mov    -0x10(%ebp),%eax
 745:	8b 00                	mov    (%eax),%eax
 747:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 74a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74d:	8b 40 04             	mov    0x4(%eax),%eax
 750:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 753:	72 4d                	jb     7a2 <malloc+0xa6>
      if(p->s.size == nunits)
 755:	8b 45 f4             	mov    -0xc(%ebp),%eax
 758:	8b 40 04             	mov    0x4(%eax),%eax
 75b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 75e:	75 0c                	jne    76c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 760:	8b 45 f4             	mov    -0xc(%ebp),%eax
 763:	8b 10                	mov    (%eax),%edx
 765:	8b 45 f0             	mov    -0x10(%ebp),%eax
 768:	89 10                	mov    %edx,(%eax)
 76a:	eb 26                	jmp    792 <malloc+0x96>
      else {
        p->s.size -= nunits;
 76c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76f:	8b 40 04             	mov    0x4(%eax),%eax
 772:	2b 45 ec             	sub    -0x14(%ebp),%eax
 775:	89 c2                	mov    %eax,%edx
 777:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 77d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 780:	8b 40 04             	mov    0x4(%eax),%eax
 783:	c1 e0 03             	shl    $0x3,%eax
 786:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 78f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 792:	8b 45 f0             	mov    -0x10(%ebp),%eax
 795:	a3 48 0b 00 00       	mov    %eax,0xb48
      return (void*)(p + 1);
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	83 c0 08             	add    $0x8,%eax
 7a0:	eb 3b                	jmp    7dd <malloc+0xe1>
    }
    if(p == freep)
 7a2:	a1 48 0b 00 00       	mov    0xb48,%eax
 7a7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7aa:	75 1e                	jne    7ca <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7ac:	83 ec 0c             	sub    $0xc,%esp
 7af:	ff 75 ec             	pushl  -0x14(%ebp)
 7b2:	e8 e5 fe ff ff       	call   69c <morecore>
 7b7:	83 c4 10             	add    $0x10,%esp
 7ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c1:	75 07                	jne    7ca <malloc+0xce>
        return 0;
 7c3:	b8 00 00 00 00       	mov    $0x0,%eax
 7c8:	eb 13                	jmp    7dd <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	8b 00                	mov    (%eax),%eax
 7d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7d8:	e9 6d ff ff ff       	jmp    74a <malloc+0x4e>
}
 7dd:	c9                   	leave  
 7de:	c3                   	ret    

000007df <hufs_thread_create>:

int thread_num = 0;


int hufs_thread_create(void *func(), void *args)
{
 7df:	55                   	push   %ebp
 7e0:	89 e5                	mov    %esp,%ebp
 7e2:	83 ec 18             	sub    $0x18,%esp
	void *stack; 
	int pid;

	stack = malloc(4096);
 7e5:	83 ec 0c             	sub    $0xc,%esp
 7e8:	68 00 10 00 00       	push   $0x1000
 7ed:	e8 0a ff ff ff       	call   6fc <malloc>
 7f2:	83 c4 10             	add    $0x10,%esp
 7f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (stack==0) return -1;
 7f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7fc:	75 07                	jne    805 <hufs_thread_create+0x26>
 7fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 803:	eb 42                	jmp    847 <hufs_thread_create+0x68>

	pid = clone(func, args, stack); 
 805:	83 ec 04             	sub    $0x4,%esp
 808:	ff 75 f4             	pushl  -0xc(%ebp)
 80b:	ff 75 0c             	pushl  0xc(%ebp)
 80e:	ff 75 08             	pushl  0x8(%ebp)
 811:	e8 2c fb ff ff       	call   342 <clone>
 816:	83 c4 10             	add    $0x10,%esp
 819:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (pid==-1) {
 81c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 820:	75 15                	jne    837 <hufs_thread_create+0x58>
		free(stack);
 822:	83 ec 0c             	sub    $0xc,%esp
 825:	ff 75 f4             	pushl  -0xc(%ebp)
 828:	e8 8d fd ff ff       	call   5ba <free>
 82d:	83 c4 10             	add    $0x10,%esp
		return -1;
 830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 835:	eb 10                	jmp    847 <hufs_thread_create+0x68>
	}

	thread_info[pid].stack = stack; 
 837:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 83d:	89 14 85 60 0b 00 00 	mov    %edx,0xb60(,%eax,4)

	return pid; 
 844:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 847:	c9                   	leave  
 848:	c3                   	ret    

00000849 <hufs_thread_join>:

int hufs_thread_join(int pid)
{
 849:	55                   	push   %ebp
 84a:	89 e5                	mov    %esp,%ebp
 84c:	83 ec 18             	sub    $0x18,%esp
	void *stack = thread_info[pid].stack;
 84f:	8b 45 08             	mov    0x8(%ebp),%eax
 852:	8b 04 85 60 0b 00 00 	mov    0xb60(,%eax,4),%eax
 859:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (stack==0) return -1;
 85c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 860:	75 07                	jne    869 <hufs_thread_join+0x20>
 862:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 867:	eb 28                	jmp    891 <hufs_thread_join+0x48>

	join(&thread_info[pid].stack);	
 869:	8b 45 08             	mov    0x8(%ebp),%eax
 86c:	c1 e0 02             	shl    $0x2,%eax
 86f:	05 60 0b 00 00       	add    $0xb60,%eax
 874:	83 ec 0c             	sub    $0xc,%esp
 877:	50                   	push   %eax
 878:	e8 cd fa ff ff       	call   34a <join>
 87d:	83 c4 10             	add    $0x10,%esp
	free(stack);
 880:	83 ec 0c             	sub    $0xc,%esp
 883:	ff 75 f4             	pushl  -0xc(%ebp)
 886:	e8 2f fd ff ff       	call   5ba <free>
 88b:	83 c4 10             	add    $0x10,%esp

	return pid;
 88e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 891:	c9                   	leave  
 892:	c3                   	ret    
