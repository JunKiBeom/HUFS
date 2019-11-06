
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
	int num = getnp();
  11:	e8 39 03 00 00       	call   34f <getnp>
  16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int pid ;

	pid = getpid();
  19:	e8 09 03 00 00       	call   327 <getpid>
  1e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	printf(1, "current number of running processes is %d \n", num);
  21:	83 ec 04             	sub    $0x4,%esp
  24:	ff 75 f4             	pushl  -0xc(%ebp)
  27:	68 c8 08 00 00       	push   $0x8c8
  2c:	6a 01                	push   $0x1
  2e:	e8 2b 04 00 00       	call   45e <printf>
  33:	83 c4 10             	add    $0x10,%esp
	printf(1, "current pid is %d \n", pid);
  36:	83 ec 04             	sub    $0x4,%esp
  39:	ff 75 f0             	pushl  -0x10(%ebp)
  3c:	68 f4 08 00 00       	push   $0x8f4
  41:	6a 01                	push   $0x1
  43:	e8 16 04 00 00       	call   45e <printf>
  48:	83 c4 10             	add    $0x10,%esp

	exit();
  4b:	e8 57 02 00 00       	call   2a7 <exit>

00000050 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	57                   	push   %edi
  54:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  58:	8b 55 10             	mov    0x10(%ebp),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	89 cb                	mov    %ecx,%ebx
  60:	89 df                	mov    %ebx,%edi
  62:	89 d1                	mov    %edx,%ecx
  64:	fc                   	cld    
  65:	f3 aa                	rep stos %al,%es:(%edi)
  67:	89 ca                	mov    %ecx,%edx
  69:	89 fb                	mov    %edi,%ebx
  6b:	89 5d 08             	mov    %ebx,0x8(%ebp)
  6e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  71:	90                   	nop
  72:	5b                   	pop    %ebx
  73:	5f                   	pop    %edi
  74:	5d                   	pop    %ebp
  75:	c3                   	ret    

00000076 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  76:	55                   	push   %ebp
  77:	89 e5                	mov    %esp,%ebp
  79:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  7c:	8b 45 08             	mov    0x8(%ebp),%eax
  7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  82:	90                   	nop
  83:	8b 45 08             	mov    0x8(%ebp),%eax
  86:	8d 50 01             	lea    0x1(%eax),%edx
  89:	89 55 08             	mov    %edx,0x8(%ebp)
  8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  8f:	8d 4a 01             	lea    0x1(%edx),%ecx
  92:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  95:	0f b6 12             	movzbl (%edx),%edx
  98:	88 10                	mov    %dl,(%eax)
  9a:	0f b6 00             	movzbl (%eax),%eax
  9d:	84 c0                	test   %al,%al
  9f:	75 e2                	jne    83 <strcpy+0xd>
    ;
  return os;
  a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  a4:	c9                   	leave  
  a5:	c3                   	ret    

000000a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a6:	55                   	push   %ebp
  a7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  a9:	eb 08                	jmp    b3 <strcmp+0xd>
    p++, q++;
  ab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  af:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  b3:	8b 45 08             	mov    0x8(%ebp),%eax
  b6:	0f b6 00             	movzbl (%eax),%eax
  b9:	84 c0                	test   %al,%al
  bb:	74 10                	je     cd <strcmp+0x27>
  bd:	8b 45 08             	mov    0x8(%ebp),%eax
  c0:	0f b6 10             	movzbl (%eax),%edx
  c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  c6:	0f b6 00             	movzbl (%eax),%eax
  c9:	38 c2                	cmp    %al,%dl
  cb:	74 de                	je     ab <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  cd:	8b 45 08             	mov    0x8(%ebp),%eax
  d0:	0f b6 00             	movzbl (%eax),%eax
  d3:	0f b6 d0             	movzbl %al,%edx
  d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  d9:	0f b6 00             	movzbl (%eax),%eax
  dc:	0f b6 c0             	movzbl %al,%eax
  df:	29 c2                	sub    %eax,%edx
  e1:	89 d0                	mov    %edx,%eax
}
  e3:	5d                   	pop    %ebp
  e4:	c3                   	ret    

000000e5 <strlen>:

uint
strlen(char *s)
{
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  e8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  f2:	eb 04                	jmp    f8 <strlen+0x13>
  f4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	01 d0                	add    %edx,%eax
 100:	0f b6 00             	movzbl (%eax),%eax
 103:	84 c0                	test   %al,%al
 105:	75 ed                	jne    f4 <strlen+0xf>
    ;
  return n;
 107:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 10a:	c9                   	leave  
 10b:	c3                   	ret    

0000010c <memset>:

void*
memset(void *dst, int c, uint n)
{
 10c:	55                   	push   %ebp
 10d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 10f:	8b 45 10             	mov    0x10(%ebp),%eax
 112:	50                   	push   %eax
 113:	ff 75 0c             	pushl  0xc(%ebp)
 116:	ff 75 08             	pushl  0x8(%ebp)
 119:	e8 32 ff ff ff       	call   50 <stosb>
 11e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 121:	8b 45 08             	mov    0x8(%ebp),%eax
}
 124:	c9                   	leave  
 125:	c3                   	ret    

00000126 <strchr>:

char*
strchr(const char *s, char c)
{
 126:	55                   	push   %ebp
 127:	89 e5                	mov    %esp,%ebp
 129:	83 ec 04             	sub    $0x4,%esp
 12c:	8b 45 0c             	mov    0xc(%ebp),%eax
 12f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 132:	eb 14                	jmp    148 <strchr+0x22>
    if(*s == c)
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	0f b6 00             	movzbl (%eax),%eax
 13a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 13d:	75 05                	jne    144 <strchr+0x1e>
      return (char*)s;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	eb 13                	jmp    157 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 144:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	84 c0                	test   %al,%al
 150:	75 e2                	jne    134 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 152:	b8 00 00 00 00       	mov    $0x0,%eax
}
 157:	c9                   	leave  
 158:	c3                   	ret    

00000159 <gets>:

char*
gets(char *buf, int max)
{
 159:	55                   	push   %ebp
 15a:	89 e5                	mov    %esp,%ebp
 15c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 166:	eb 42                	jmp    1aa <gets+0x51>
    cc = read(0, &c, 1);
 168:	83 ec 04             	sub    $0x4,%esp
 16b:	6a 01                	push   $0x1
 16d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 170:	50                   	push   %eax
 171:	6a 00                	push   $0x0
 173:	e8 47 01 00 00       	call   2bf <read>
 178:	83 c4 10             	add    $0x10,%esp
 17b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 17e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 182:	7e 33                	jle    1b7 <gets+0x5e>
      break;
    buf[i++] = c;
 184:	8b 45 f4             	mov    -0xc(%ebp),%eax
 187:	8d 50 01             	lea    0x1(%eax),%edx
 18a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 18d:	89 c2                	mov    %eax,%edx
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
 192:	01 c2                	add    %eax,%edx
 194:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 198:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 19a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 19e:	3c 0a                	cmp    $0xa,%al
 1a0:	74 16                	je     1b8 <gets+0x5f>
 1a2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a6:	3c 0d                	cmp    $0xd,%al
 1a8:	74 0e                	je     1b8 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ad:	83 c0 01             	add    $0x1,%eax
 1b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1b3:	7c b3                	jl     168 <gets+0xf>
 1b5:	eb 01                	jmp    1b8 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1b7:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1bb:	8b 45 08             	mov    0x8(%ebp),%eax
 1be:	01 d0                	add    %edx,%eax
 1c0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c6:	c9                   	leave  
 1c7:	c3                   	ret    

000001c8 <stat>:

int
stat(char *n, struct stat *st)
{
 1c8:	55                   	push   %ebp
 1c9:	89 e5                	mov    %esp,%ebp
 1cb:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ce:	83 ec 08             	sub    $0x8,%esp
 1d1:	6a 00                	push   $0x0
 1d3:	ff 75 08             	pushl  0x8(%ebp)
 1d6:	e8 0c 01 00 00       	call   2e7 <open>
 1db:	83 c4 10             	add    $0x10,%esp
 1de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1e5:	79 07                	jns    1ee <stat+0x26>
    return -1;
 1e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1ec:	eb 25                	jmp    213 <stat+0x4b>
  r = fstat(fd, st);
 1ee:	83 ec 08             	sub    $0x8,%esp
 1f1:	ff 75 0c             	pushl  0xc(%ebp)
 1f4:	ff 75 f4             	pushl  -0xc(%ebp)
 1f7:	e8 03 01 00 00       	call   2ff <fstat>
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 202:	83 ec 0c             	sub    $0xc,%esp
 205:	ff 75 f4             	pushl  -0xc(%ebp)
 208:	e8 c2 00 00 00       	call   2cf <close>
 20d:	83 c4 10             	add    $0x10,%esp
  return r;
 210:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 213:	c9                   	leave  
 214:	c3                   	ret    

00000215 <atoi>:

int
atoi(const char *s)
{
 215:	55                   	push   %ebp
 216:	89 e5                	mov    %esp,%ebp
 218:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 21b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 222:	eb 25                	jmp    249 <atoi+0x34>
    n = n*10 + *s++ - '0';
 224:	8b 55 fc             	mov    -0x4(%ebp),%edx
 227:	89 d0                	mov    %edx,%eax
 229:	c1 e0 02             	shl    $0x2,%eax
 22c:	01 d0                	add    %edx,%eax
 22e:	01 c0                	add    %eax,%eax
 230:	89 c1                	mov    %eax,%ecx
 232:	8b 45 08             	mov    0x8(%ebp),%eax
 235:	8d 50 01             	lea    0x1(%eax),%edx
 238:	89 55 08             	mov    %edx,0x8(%ebp)
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	0f be c0             	movsbl %al,%eax
 241:	01 c8                	add    %ecx,%eax
 243:	83 e8 30             	sub    $0x30,%eax
 246:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 249:	8b 45 08             	mov    0x8(%ebp),%eax
 24c:	0f b6 00             	movzbl (%eax),%eax
 24f:	3c 2f                	cmp    $0x2f,%al
 251:	7e 0a                	jle    25d <atoi+0x48>
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	0f b6 00             	movzbl (%eax),%eax
 259:	3c 39                	cmp    $0x39,%al
 25b:	7e c7                	jle    224 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 25d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 260:	c9                   	leave  
 261:	c3                   	ret    

00000262 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 262:	55                   	push   %ebp
 263:	89 e5                	mov    %esp,%ebp
 265:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 26e:	8b 45 0c             	mov    0xc(%ebp),%eax
 271:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 274:	eb 17                	jmp    28d <memmove+0x2b>
    *dst++ = *src++;
 276:	8b 45 fc             	mov    -0x4(%ebp),%eax
 279:	8d 50 01             	lea    0x1(%eax),%edx
 27c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 27f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 282:	8d 4a 01             	lea    0x1(%edx),%ecx
 285:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 288:	0f b6 12             	movzbl (%edx),%edx
 28b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 28d:	8b 45 10             	mov    0x10(%ebp),%eax
 290:	8d 50 ff             	lea    -0x1(%eax),%edx
 293:	89 55 10             	mov    %edx,0x10(%ebp)
 296:	85 c0                	test   %eax,%eax
 298:	7f dc                	jg     276 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29d:	c9                   	leave  
 29e:	c3                   	ret    

0000029f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 29f:	b8 01 00 00 00       	mov    $0x1,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <exit>:
SYSCALL(exit)
 2a7:	b8 02 00 00 00       	mov    $0x2,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <wait>:
SYSCALL(wait)
 2af:	b8 03 00 00 00       	mov    $0x3,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <pipe>:
SYSCALL(pipe)
 2b7:	b8 04 00 00 00       	mov    $0x4,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <read>:
SYSCALL(read)
 2bf:	b8 05 00 00 00       	mov    $0x5,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <write>:
SYSCALL(write)
 2c7:	b8 10 00 00 00       	mov    $0x10,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <close>:
SYSCALL(close)
 2cf:	b8 15 00 00 00       	mov    $0x15,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <kill>:
SYSCALL(kill)
 2d7:	b8 06 00 00 00       	mov    $0x6,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <exec>:
SYSCALL(exec)
 2df:	b8 07 00 00 00       	mov    $0x7,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <open>:
SYSCALL(open)
 2e7:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <mknod>:
SYSCALL(mknod)
 2ef:	b8 11 00 00 00       	mov    $0x11,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <unlink>:
SYSCALL(unlink)
 2f7:	b8 12 00 00 00       	mov    $0x12,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <fstat>:
SYSCALL(fstat)
 2ff:	b8 08 00 00 00       	mov    $0x8,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <link>:
SYSCALL(link)
 307:	b8 13 00 00 00       	mov    $0x13,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <mkdir>:
SYSCALL(mkdir)
 30f:	b8 14 00 00 00       	mov    $0x14,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <chdir>:
SYSCALL(chdir)
 317:	b8 09 00 00 00       	mov    $0x9,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <dup>:
SYSCALL(dup)
 31f:	b8 0a 00 00 00       	mov    $0xa,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <getpid>:
SYSCALL(getpid)
 327:	b8 0b 00 00 00       	mov    $0xb,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <sbrk>:
SYSCALL(sbrk)
 32f:	b8 0c 00 00 00       	mov    $0xc,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <sleep>:
SYSCALL(sleep)
 337:	b8 0d 00 00 00       	mov    $0xd,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <uptime>:
SYSCALL(uptime)
 33f:	b8 0e 00 00 00       	mov    $0xe,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <halt>:
SYSCALL(halt)
 347:	b8 16 00 00 00       	mov    $0x16,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <getnp>:
SYSCALL(getnp)
 34f:	b8 17 00 00 00       	mov    $0x17,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <sem_create>:
SYSCALL(sem_create)
 357:	b8 18 00 00 00       	mov    $0x18,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <sem_destroy>:
SYSCALL(sem_destroy)
 35f:	b8 19 00 00 00       	mov    $0x19,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <sem_wait>:
SYSCALL(sem_wait)
 367:	b8 1a 00 00 00       	mov    $0x1a,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <sem_signal>:
SYSCALL(sem_signal)
 36f:	b8 1b 00 00 00       	mov    $0x1b,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <clone>:
SYSCALL(clone)
 377:	b8 1c 00 00 00       	mov    $0x1c,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <join>:
SYSCALL(join)
 37f:	b8 1d 00 00 00       	mov    $0x1d,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 387:	55                   	push   %ebp
 388:	89 e5                	mov    %esp,%ebp
 38a:	83 ec 18             	sub    $0x18,%esp
 38d:	8b 45 0c             	mov    0xc(%ebp),%eax
 390:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 393:	83 ec 04             	sub    $0x4,%esp
 396:	6a 01                	push   $0x1
 398:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39b:	50                   	push   %eax
 39c:	ff 75 08             	pushl  0x8(%ebp)
 39f:	e8 23 ff ff ff       	call   2c7 <write>
 3a4:	83 c4 10             	add    $0x10,%esp
}
 3a7:	90                   	nop
 3a8:	c9                   	leave  
 3a9:	c3                   	ret    

000003aa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3aa:	55                   	push   %ebp
 3ab:	89 e5                	mov    %esp,%ebp
 3ad:	53                   	push   %ebx
 3ae:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3bc:	74 17                	je     3d5 <printint+0x2b>
 3be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c2:	79 11                	jns    3d5 <printint+0x2b>
    neg = 1;
 3c4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ce:	f7 d8                	neg    %eax
 3d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d3:	eb 06                	jmp    3db <printint+0x31>
  } else {
    x = xx;
 3d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3e5:	8d 41 01             	lea    0x1(%ecx),%eax
 3e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f1:	ba 00 00 00 00       	mov    $0x0,%edx
 3f6:	f7 f3                	div    %ebx
 3f8:	89 d0                	mov    %edx,%eax
 3fa:	0f b6 80 98 0b 00 00 	movzbl 0xb98(%eax),%eax
 401:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 405:	8b 5d 10             	mov    0x10(%ebp),%ebx
 408:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40b:	ba 00 00 00 00       	mov    $0x0,%edx
 410:	f7 f3                	div    %ebx
 412:	89 45 ec             	mov    %eax,-0x14(%ebp)
 415:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 419:	75 c7                	jne    3e2 <printint+0x38>
  if(neg)
 41b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 41f:	74 2d                	je     44e <printint+0xa4>
    buf[i++] = '-';
 421:	8b 45 f4             	mov    -0xc(%ebp),%eax
 424:	8d 50 01             	lea    0x1(%eax),%edx
 427:	89 55 f4             	mov    %edx,-0xc(%ebp)
 42a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 42f:	eb 1d                	jmp    44e <printint+0xa4>
    putc(fd, buf[i]);
 431:	8d 55 dc             	lea    -0x24(%ebp),%edx
 434:	8b 45 f4             	mov    -0xc(%ebp),%eax
 437:	01 d0                	add    %edx,%eax
 439:	0f b6 00             	movzbl (%eax),%eax
 43c:	0f be c0             	movsbl %al,%eax
 43f:	83 ec 08             	sub    $0x8,%esp
 442:	50                   	push   %eax
 443:	ff 75 08             	pushl  0x8(%ebp)
 446:	e8 3c ff ff ff       	call   387 <putc>
 44b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 44e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 452:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 456:	79 d9                	jns    431 <printint+0x87>
    putc(fd, buf[i]);
}
 458:	90                   	nop
 459:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 45c:	c9                   	leave  
 45d:	c3                   	ret    

0000045e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 45e:	55                   	push   %ebp
 45f:	89 e5                	mov    %esp,%ebp
 461:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 464:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 46b:	8d 45 0c             	lea    0xc(%ebp),%eax
 46e:	83 c0 04             	add    $0x4,%eax
 471:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 474:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 47b:	e9 59 01 00 00       	jmp    5d9 <printf+0x17b>
    c = fmt[i] & 0xff;
 480:	8b 55 0c             	mov    0xc(%ebp),%edx
 483:	8b 45 f0             	mov    -0x10(%ebp),%eax
 486:	01 d0                	add    %edx,%eax
 488:	0f b6 00             	movzbl (%eax),%eax
 48b:	0f be c0             	movsbl %al,%eax
 48e:	25 ff 00 00 00       	and    $0xff,%eax
 493:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 496:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49a:	75 2c                	jne    4c8 <printf+0x6a>
      if(c == '%'){
 49c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a0:	75 0c                	jne    4ae <printf+0x50>
        state = '%';
 4a2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a9:	e9 27 01 00 00       	jmp    5d5 <printf+0x177>
      } else {
        putc(fd, c);
 4ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b1:	0f be c0             	movsbl %al,%eax
 4b4:	83 ec 08             	sub    $0x8,%esp
 4b7:	50                   	push   %eax
 4b8:	ff 75 08             	pushl  0x8(%ebp)
 4bb:	e8 c7 fe ff ff       	call   387 <putc>
 4c0:	83 c4 10             	add    $0x10,%esp
 4c3:	e9 0d 01 00 00       	jmp    5d5 <printf+0x177>
      }
    } else if(state == '%'){
 4c8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4cc:	0f 85 03 01 00 00    	jne    5d5 <printf+0x177>
      if(c == 'd'){
 4d2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d6:	75 1e                	jne    4f6 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4db:	8b 00                	mov    (%eax),%eax
 4dd:	6a 01                	push   $0x1
 4df:	6a 0a                	push   $0xa
 4e1:	50                   	push   %eax
 4e2:	ff 75 08             	pushl  0x8(%ebp)
 4e5:	e8 c0 fe ff ff       	call   3aa <printint>
 4ea:	83 c4 10             	add    $0x10,%esp
        ap++;
 4ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f1:	e9 d8 00 00 00       	jmp    5ce <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4f6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4fa:	74 06                	je     502 <printf+0xa4>
 4fc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 500:	75 1e                	jne    520 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 502:	8b 45 e8             	mov    -0x18(%ebp),%eax
 505:	8b 00                	mov    (%eax),%eax
 507:	6a 00                	push   $0x0
 509:	6a 10                	push   $0x10
 50b:	50                   	push   %eax
 50c:	ff 75 08             	pushl  0x8(%ebp)
 50f:	e8 96 fe ff ff       	call   3aa <printint>
 514:	83 c4 10             	add    $0x10,%esp
        ap++;
 517:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51b:	e9 ae 00 00 00       	jmp    5ce <printf+0x170>
      } else if(c == 's'){
 520:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 524:	75 43                	jne    569 <printf+0x10b>
        s = (char*)*ap;
 526:	8b 45 e8             	mov    -0x18(%ebp),%eax
 529:	8b 00                	mov    (%eax),%eax
 52b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 52e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 532:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 536:	75 25                	jne    55d <printf+0xff>
          s = "(null)";
 538:	c7 45 f4 08 09 00 00 	movl   $0x908,-0xc(%ebp)
        while(*s != 0){
 53f:	eb 1c                	jmp    55d <printf+0xff>
          putc(fd, *s);
 541:	8b 45 f4             	mov    -0xc(%ebp),%eax
 544:	0f b6 00             	movzbl (%eax),%eax
 547:	0f be c0             	movsbl %al,%eax
 54a:	83 ec 08             	sub    $0x8,%esp
 54d:	50                   	push   %eax
 54e:	ff 75 08             	pushl  0x8(%ebp)
 551:	e8 31 fe ff ff       	call   387 <putc>
 556:	83 c4 10             	add    $0x10,%esp
          s++;
 559:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 55d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 560:	0f b6 00             	movzbl (%eax),%eax
 563:	84 c0                	test   %al,%al
 565:	75 da                	jne    541 <printf+0xe3>
 567:	eb 65                	jmp    5ce <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 569:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 56d:	75 1d                	jne    58c <printf+0x12e>
        putc(fd, *ap);
 56f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 572:	8b 00                	mov    (%eax),%eax
 574:	0f be c0             	movsbl %al,%eax
 577:	83 ec 08             	sub    $0x8,%esp
 57a:	50                   	push   %eax
 57b:	ff 75 08             	pushl  0x8(%ebp)
 57e:	e8 04 fe ff ff       	call   387 <putc>
 583:	83 c4 10             	add    $0x10,%esp
        ap++;
 586:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58a:	eb 42                	jmp    5ce <printf+0x170>
      } else if(c == '%'){
 58c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 590:	75 17                	jne    5a9 <printf+0x14b>
        putc(fd, c);
 592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 595:	0f be c0             	movsbl %al,%eax
 598:	83 ec 08             	sub    $0x8,%esp
 59b:	50                   	push   %eax
 59c:	ff 75 08             	pushl  0x8(%ebp)
 59f:	e8 e3 fd ff ff       	call   387 <putc>
 5a4:	83 c4 10             	add    $0x10,%esp
 5a7:	eb 25                	jmp    5ce <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a9:	83 ec 08             	sub    $0x8,%esp
 5ac:	6a 25                	push   $0x25
 5ae:	ff 75 08             	pushl  0x8(%ebp)
 5b1:	e8 d1 fd ff ff       	call   387 <putc>
 5b6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bc:	0f be c0             	movsbl %al,%eax
 5bf:	83 ec 08             	sub    $0x8,%esp
 5c2:	50                   	push   %eax
 5c3:	ff 75 08             	pushl  0x8(%ebp)
 5c6:	e8 bc fd ff ff       	call   387 <putc>
 5cb:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5d9:	8b 55 0c             	mov    0xc(%ebp),%edx
 5dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5df:	01 d0                	add    %edx,%eax
 5e1:	0f b6 00             	movzbl (%eax),%eax
 5e4:	84 c0                	test   %al,%al
 5e6:	0f 85 94 fe ff ff    	jne    480 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5ec:	90                   	nop
 5ed:	c9                   	leave  
 5ee:	c3                   	ret    

000005ef <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ef:	55                   	push   %ebp
 5f0:	89 e5                	mov    %esp,%ebp
 5f2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f5:	8b 45 08             	mov    0x8(%ebp),%eax
 5f8:	83 e8 08             	sub    $0x8,%eax
 5fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fe:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 603:	89 45 fc             	mov    %eax,-0x4(%ebp)
 606:	eb 24                	jmp    62c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 608:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 610:	77 12                	ja     624 <free+0x35>
 612:	8b 45 f8             	mov    -0x8(%ebp),%eax
 615:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 618:	77 24                	ja     63e <free+0x4f>
 61a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61d:	8b 00                	mov    (%eax),%eax
 61f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 622:	77 1a                	ja     63e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 624:	8b 45 fc             	mov    -0x4(%ebp),%eax
 627:	8b 00                	mov    (%eax),%eax
 629:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 632:	76 d4                	jbe    608 <free+0x19>
 634:	8b 45 fc             	mov    -0x4(%ebp),%eax
 637:	8b 00                	mov    (%eax),%eax
 639:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63c:	76 ca                	jbe    608 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 63e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 641:	8b 40 04             	mov    0x4(%eax),%eax
 644:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 64b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64e:	01 c2                	add    %eax,%edx
 650:	8b 45 fc             	mov    -0x4(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	39 c2                	cmp    %eax,%edx
 657:	75 24                	jne    67d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 659:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65c:	8b 50 04             	mov    0x4(%eax),%edx
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	8b 00                	mov    (%eax),%eax
 664:	8b 40 04             	mov    0x4(%eax),%eax
 667:	01 c2                	add    %eax,%edx
 669:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	8b 00                	mov    (%eax),%eax
 674:	8b 10                	mov    (%eax),%edx
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	89 10                	mov    %edx,(%eax)
 67b:	eb 0a                	jmp    687 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 10                	mov    (%eax),%edx
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 687:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68a:	8b 40 04             	mov    0x4(%eax),%eax
 68d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	01 d0                	add    %edx,%eax
 699:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69c:	75 20                	jne    6be <free+0xcf>
    p->s.size += bp->s.size;
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 50 04             	mov    0x4(%eax),%edx
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	8b 40 04             	mov    0x4(%eax),%eax
 6aa:	01 c2                	add    %eax,%edx
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b5:	8b 10                	mov    (%eax),%edx
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	89 10                	mov    %edx,(%eax)
 6bc:	eb 08                	jmp    6c6 <free+0xd7>
  } else
    p->s.ptr = bp;
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6c4:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	a3 c8 0b 00 00       	mov    %eax,0xbc8
}
 6ce:	90                   	nop
 6cf:	c9                   	leave  
 6d0:	c3                   	ret    

000006d1 <morecore>:

static Header*
morecore(uint nu)
{
 6d1:	55                   	push   %ebp
 6d2:	89 e5                	mov    %esp,%ebp
 6d4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6de:	77 07                	ja     6e7 <morecore+0x16>
    nu = 4096;
 6e0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ea:	c1 e0 03             	shl    $0x3,%eax
 6ed:	83 ec 0c             	sub    $0xc,%esp
 6f0:	50                   	push   %eax
 6f1:	e8 39 fc ff ff       	call   32f <sbrk>
 6f6:	83 c4 10             	add    $0x10,%esp
 6f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6fc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 700:	75 07                	jne    709 <morecore+0x38>
    return 0;
 702:	b8 00 00 00 00       	mov    $0x0,%eax
 707:	eb 26                	jmp    72f <morecore+0x5e>
  hp = (Header*)p;
 709:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 70f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 712:	8b 55 08             	mov    0x8(%ebp),%edx
 715:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 718:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71b:	83 c0 08             	add    $0x8,%eax
 71e:	83 ec 0c             	sub    $0xc,%esp
 721:	50                   	push   %eax
 722:	e8 c8 fe ff ff       	call   5ef <free>
 727:	83 c4 10             	add    $0x10,%esp
  return freep;
 72a:	a1 c8 0b 00 00       	mov    0xbc8,%eax
}
 72f:	c9                   	leave  
 730:	c3                   	ret    

00000731 <malloc>:

void*
malloc(uint nbytes)
{
 731:	55                   	push   %ebp
 732:	89 e5                	mov    %esp,%ebp
 734:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 737:	8b 45 08             	mov    0x8(%ebp),%eax
 73a:	83 c0 07             	add    $0x7,%eax
 73d:	c1 e8 03             	shr    $0x3,%eax
 740:	83 c0 01             	add    $0x1,%eax
 743:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 746:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 74b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 74e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 752:	75 23                	jne    777 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 754:	c7 45 f0 c0 0b 00 00 	movl   $0xbc0,-0x10(%ebp)
 75b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75e:	a3 c8 0b 00 00       	mov    %eax,0xbc8
 763:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 768:	a3 c0 0b 00 00       	mov    %eax,0xbc0
    base.s.size = 0;
 76d:	c7 05 c4 0b 00 00 00 	movl   $0x0,0xbc4
 774:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 777:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77a:	8b 00                	mov    (%eax),%eax
 77c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	8b 40 04             	mov    0x4(%eax),%eax
 785:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 788:	72 4d                	jb     7d7 <malloc+0xa6>
      if(p->s.size == nunits)
 78a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78d:	8b 40 04             	mov    0x4(%eax),%eax
 790:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 793:	75 0c                	jne    7a1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 795:	8b 45 f4             	mov    -0xc(%ebp),%eax
 798:	8b 10                	mov    (%eax),%edx
 79a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79d:	89 10                	mov    %edx,(%eax)
 79f:	eb 26                	jmp    7c7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	8b 40 04             	mov    0x4(%eax),%eax
 7a7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7aa:	89 c2                	mov    %eax,%edx
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	8b 40 04             	mov    0x4(%eax),%eax
 7b8:	c1 e0 03             	shl    $0x3,%eax
 7bb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ca:	a3 c8 0b 00 00       	mov    %eax,0xbc8
      return (void*)(p + 1);
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	83 c0 08             	add    $0x8,%eax
 7d5:	eb 3b                	jmp    812 <malloc+0xe1>
    }
    if(p == freep)
 7d7:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 7dc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7df:	75 1e                	jne    7ff <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7e1:	83 ec 0c             	sub    $0xc,%esp
 7e4:	ff 75 ec             	pushl  -0x14(%ebp)
 7e7:	e8 e5 fe ff ff       	call   6d1 <morecore>
 7ec:	83 c4 10             	add    $0x10,%esp
 7ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f6:	75 07                	jne    7ff <malloc+0xce>
        return 0;
 7f8:	b8 00 00 00 00       	mov    $0x0,%eax
 7fd:	eb 13                	jmp    812 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	89 45 f0             	mov    %eax,-0x10(%ebp)
 805:	8b 45 f4             	mov    -0xc(%ebp),%eax
 808:	8b 00                	mov    (%eax),%eax
 80a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 80d:	e9 6d ff ff ff       	jmp    77f <malloc+0x4e>
}
 812:	c9                   	leave  
 813:	c3                   	ret    

00000814 <hufs_thread_create>:

int thread_num = 0;


int hufs_thread_create(void *func(), void *args)
{
 814:	55                   	push   %ebp
 815:	89 e5                	mov    %esp,%ebp
 817:	83 ec 18             	sub    $0x18,%esp
	void *stack; 
	int pid;

	stack = malloc(4096);
 81a:	83 ec 0c             	sub    $0xc,%esp
 81d:	68 00 10 00 00       	push   $0x1000
 822:	e8 0a ff ff ff       	call   731 <malloc>
 827:	83 c4 10             	add    $0x10,%esp
 82a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (stack==0) return -1;
 82d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 831:	75 07                	jne    83a <hufs_thread_create+0x26>
 833:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 838:	eb 42                	jmp    87c <hufs_thread_create+0x68>

	pid = clone(func, args, stack); 
 83a:	83 ec 04             	sub    $0x4,%esp
 83d:	ff 75 f4             	pushl  -0xc(%ebp)
 840:	ff 75 0c             	pushl  0xc(%ebp)
 843:	ff 75 08             	pushl  0x8(%ebp)
 846:	e8 2c fb ff ff       	call   377 <clone>
 84b:	83 c4 10             	add    $0x10,%esp
 84e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (pid==-1) {
 851:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 855:	75 15                	jne    86c <hufs_thread_create+0x58>
		free(stack);
 857:	83 ec 0c             	sub    $0xc,%esp
 85a:	ff 75 f4             	pushl  -0xc(%ebp)
 85d:	e8 8d fd ff ff       	call   5ef <free>
 862:	83 c4 10             	add    $0x10,%esp
		return -1;
 865:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 86a:	eb 10                	jmp    87c <hufs_thread_create+0x68>
	}

	thread_info[pid].stack = stack; 
 86c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 872:	89 14 85 e0 0b 00 00 	mov    %edx,0xbe0(,%eax,4)

	return pid; 
 879:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 87c:	c9                   	leave  
 87d:	c3                   	ret    

0000087e <hufs_thread_join>:

int hufs_thread_join(int pid)
{
 87e:	55                   	push   %ebp
 87f:	89 e5                	mov    %esp,%ebp
 881:	83 ec 18             	sub    $0x18,%esp
	void *stack = thread_info[pid].stack;
 884:	8b 45 08             	mov    0x8(%ebp),%eax
 887:	8b 04 85 e0 0b 00 00 	mov    0xbe0(,%eax,4),%eax
 88e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (stack==0) return -1;
 891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 895:	75 07                	jne    89e <hufs_thread_join+0x20>
 897:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 89c:	eb 28                	jmp    8c6 <hufs_thread_join+0x48>

	join(&thread_info[pid].stack);	
 89e:	8b 45 08             	mov    0x8(%ebp),%eax
 8a1:	c1 e0 02             	shl    $0x2,%eax
 8a4:	05 e0 0b 00 00       	add    $0xbe0,%eax
 8a9:	83 ec 0c             	sub    $0xc,%esp
 8ac:	50                   	push   %eax
 8ad:	e8 cd fa ff ff       	call   37f <join>
 8b2:	83 c4 10             	add    $0x10,%esp
	free(stack);
 8b5:	83 ec 0c             	sub    $0xc,%esp
 8b8:	ff 75 f4             	pushl  -0xc(%ebp)
 8bb:	e8 2f fd ff ff       	call   5ef <free>
 8c0:	83 c4 10             	add    $0x10,%esp

	return pid;
 8c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8c6:	c9                   	leave  
 8c7:	c3                   	ret    
