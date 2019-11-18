
_hufs_sem_test:     file format elf32-i386


Disassembly of section .text:

00000000 <counter_init>:
#define COUNTER_FILE "counter"

int sem_id;

int counter_init(char *filename, int value)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
	int fd;

	if ((fd = open(filename, O_CREATE | O_RDWR)) < 0) {
   6:	83 ec 08             	sub    $0x8,%esp
   9:	68 02 02 00 00       	push   $0x202
   e:	ff 75 08             	pushl  0x8(%ebp)
  11:	e8 de 05 00 00       	call   5f4 <open>
  16:	83 c4 10             	add    $0x10,%esp
  19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  20:	79 1a                	jns    3c <counter_init+0x3c>
		printf(1, "counter_init: error initializing file: %s\n", filename);
  22:	83 ec 04             	sub    $0x4,%esp
  25:	ff 75 08             	pushl  0x8(%ebp)
  28:	68 d8 0b 00 00       	push   $0xbd8
  2d:	6a 01                	push   $0x1
  2f:	e8 37 07 00 00       	call   76b <printf>
  34:	83 c4 10             	add    $0x10,%esp
		exit();
  37:	e8 78 05 00 00       	call   5b4 <exit>
	}

	printf(fd, "%d\n", value);
  3c:	83 ec 04             	sub    $0x4,%esp
  3f:	ff 75 0c             	pushl  0xc(%ebp)
  42:	68 03 0c 00 00       	push   $0xc03
  47:	ff 75 f4             	pushl  -0xc(%ebp)
  4a:	e8 1c 07 00 00       	call   76b <printf>
  4f:	83 c4 10             	add    $0x10,%esp
	close(fd);
  52:	83 ec 0c             	sub    $0xc,%esp
  55:	ff 75 f4             	pushl  -0xc(%ebp)
  58:	e8 7f 05 00 00       	call   5dc <close>
  5d:	83 c4 10             	add    $0x10,%esp

	return 0;
  60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  65:	c9                   	leave  
  66:	c3                   	ret    

00000067 <counter_get>:

int counter_get(char *filename)
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	83 ec 38             	sub    $0x38,%esp
	int fd, n, value;
	char buffer[32];

	if ((fd = open(filename, O_CREATE | O_RDWR)) < 0) {
  6d:	83 ec 08             	sub    $0x8,%esp
  70:	68 02 02 00 00       	push   $0x202
  75:	ff 75 08             	pushl  0x8(%ebp)
  78:	e8 77 05 00 00       	call   5f4 <open>
  7d:	83 c4 10             	add    $0x10,%esp
  80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  87:	79 1a                	jns    a3 <counter_get+0x3c>
		printf(1, "counter_get: error opening file: %s\n", filename);
  89:	83 ec 04             	sub    $0x4,%esp
  8c:	ff 75 08             	pushl  0x8(%ebp)
  8f:	68 08 0c 00 00       	push   $0xc08
  94:	6a 01                	push   $0x1
  96:	e8 d0 06 00 00       	call   76b <printf>
  9b:	83 c4 10             	add    $0x10,%esp
		exit();
  9e:	e8 11 05 00 00       	call   5b4 <exit>
	}

	n = read(fd, buffer, 31);
  a3:	83 ec 04             	sub    $0x4,%esp
  a6:	6a 1f                	push   $0x1f
  a8:	8d 45 cc             	lea    -0x34(%ebp),%eax
  ab:	50                   	push   %eax
  ac:	ff 75 f4             	pushl  -0xc(%ebp)
  af:	e8 18 05 00 00       	call   5cc <read>
  b4:	83 c4 10             	add    $0x10,%esp
  b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	buffer[n] = '\0';
  ba:	8d 55 cc             	lea    -0x34(%ebp),%edx
  bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c0:	01 d0                	add    %edx,%eax
  c2:	c6 00 00             	movb   $0x0,(%eax)
	value = atoi(buffer);
  c5:	83 ec 0c             	sub    $0xc,%esp
  c8:	8d 45 cc             	lea    -0x34(%ebp),%eax
  cb:	50                   	push   %eax
  cc:	e8 51 04 00 00       	call   522 <atoi>
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	close(fd);
  d7:	83 ec 0c             	sub    $0xc,%esp
  da:	ff 75 f4             	pushl  -0xc(%ebp)
  dd:	e8 fa 04 00 00       	call   5dc <close>
  e2:	83 c4 10             	add    $0x10,%esp

	return value;
  e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  e8:	c9                   	leave  
  e9:	c3                   	ret    

000000ea <counter_set>:

int counter_set(char *filename, int value)
{
  ea:	55                   	push   %ebp
  eb:	89 e5                	mov    %esp,%ebp
  ed:	83 ec 18             	sub    $0x18,%esp
	int fd;

	if ((fd = open(filename, O_CREATE | O_RDWR)) < 0) {
  f0:	83 ec 08             	sub    $0x8,%esp
  f3:	68 02 02 00 00       	push   $0x202
  f8:	ff 75 08             	pushl  0x8(%ebp)
  fb:	e8 f4 04 00 00       	call   5f4 <open>
 100:	83 c4 10             	add    $0x10,%esp
 103:	89 45 f4             	mov    %eax,-0xc(%ebp)
 106:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 10a:	79 1a                	jns    126 <counter_set+0x3c>
		printf(1, "counter_set: error opening file: %s\n", filename);
 10c:	83 ec 04             	sub    $0x4,%esp
 10f:	ff 75 08             	pushl  0x8(%ebp)
 112:	68 30 0c 00 00       	push   $0xc30
 117:	6a 01                	push   $0x1
 119:	e8 4d 06 00 00       	call   76b <printf>
 11e:	83 c4 10             	add    $0x10,%esp
		exit();
 121:	e8 8e 04 00 00       	call   5b4 <exit>
	}

	printf(fd, "%d\n", value);
 126:	83 ec 04             	sub    $0x4,%esp
 129:	ff 75 0c             	pushl  0xc(%ebp)
 12c:	68 03 0c 00 00       	push   $0xc03
 131:	ff 75 f4             	pushl  -0xc(%ebp)
 134:	e8 32 06 00 00       	call   76b <printf>
 139:	83 c4 10             	add    $0x10,%esp
	close(fd);
 13c:	83 ec 0c             	sub    $0xc,%esp
 13f:	ff 75 f4             	pushl  -0xc(%ebp)
 142:	e8 95 04 00 00       	call   5dc <close>
 147:	83 c4 10             	add    $0x10,%esp

	return value;
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 14d:	c9                   	leave  
 14e:	c3                   	ret    

0000014f <child>:

void child(void)
{
 14f:	55                   	push   %ebp
 150:	89 e5                	mov    %esp,%ebp
 152:	83 ec 18             	sub    $0x18,%esp
	int i;
	int counter;

	printf(1, "Process started...\n");
 155:	83 ec 08             	sub    $0x8,%esp
 158:	68 55 0c 00 00       	push   $0xc55
 15d:	6a 01                	push   $0x1
 15f:	e8 07 06 00 00       	call   76b <printf>
 164:	83 c4 10             	add    $0x10,%esp
	sleep(10);
 167:	83 ec 0c             	sub    $0xc,%esp
 16a:	6a 0a                	push   $0xa
 16c:	e8 d3 04 00 00       	call   644 <sleep>
 171:	83 c4 10             	add    $0x10,%esp

	for (i=0; i<TARGET_COUNT_PER_CHILD; i++) {
 174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17b:	eb 50                	jmp    1cd <child+0x7e>
		sem_wait(sem_id);
 17d:	a1 78 10 00 00       	mov    0x1078,%eax
 182:	83 ec 0c             	sub    $0xc,%esp
 185:	50                   	push   %eax
 186:	e8 e9 04 00 00       	call   674 <sem_wait>
 18b:	83 c4 10             	add    $0x10,%esp

		counter = counter_get("counter");
 18e:	83 ec 0c             	sub    $0xc,%esp
 191:	68 69 0c 00 00       	push   $0xc69
 196:	e8 cc fe ff ff       	call   67 <counter_get>
 19b:	83 c4 10             	add    $0x10,%esp
 19e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		counter++;
 1a1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
		counter_set("counter", counter);
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	ff 75 f0             	pushl  -0x10(%ebp)
 1ab:	68 69 0c 00 00       	push   $0xc69
 1b0:	e8 35 ff ff ff       	call   ea <counter_set>
 1b5:	83 c4 10             	add    $0x10,%esp

		sem_signal(sem_id);
 1b8:	a1 78 10 00 00       	mov    0x1078,%eax
 1bd:	83 ec 0c             	sub    $0xc,%esp
 1c0:	50                   	push   %eax
 1c1:	e8 b6 04 00 00       	call   67c <sem_signal>
 1c6:	83 c4 10             	add    $0x10,%esp
	int counter;

	printf(1, "Process started...\n");
	sleep(10);

	for (i=0; i<TARGET_COUNT_PER_CHILD; i++) {
 1c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1cd:	a1 74 10 00 00       	mov    0x1074,%eax
 1d2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 1d5:	7c a6                	jl     17d <child+0x2e>
		counter_set("counter", counter);

		sem_signal(sem_id);
	}

	exit();
 1d7:	e8 d8 03 00 00       	call   5b4 <exit>

000001dc <main>:
}

int main(int argc, char **argv)
{
 1dc:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 1e0:	83 e4 f0             	and    $0xfffffff0,%esp
 1e3:	ff 71 fc             	pushl  -0x4(%ecx)
 1e6:	55                   	push   %ebp
 1e7:	89 e5                	mov    %esp,%ebp
 1e9:	53                   	push   %ebx
 1ea:	51                   	push   %ecx
 1eb:	83 ec 10             	sub    $0x10,%esp
 1ee:	89 cb                	mov    %ecx,%ebx
	int i;
	int final_counter;
	int final_target;

	if (argc < 3) {
 1f0:	83 3b 02             	cmpl   $0x2,(%ebx)
 1f3:	7f 17                	jg     20c <main+0x30>
		printf(2, "Usage: hufs_thread_test num_procs count_per_proc \n");
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	68 74 0c 00 00       	push   $0xc74
 1fd:	6a 02                	push   $0x2
 1ff:	e8 67 05 00 00       	call   76b <printf>
 204:	83 c4 10             	add    $0x10,%esp
		exit();
 207:	e8 a8 03 00 00       	call   5b4 <exit>
	}

	NUM_CHILDREN = atoi(argv[1]);
 20c:	8b 43 04             	mov    0x4(%ebx),%eax
 20f:	83 c0 04             	add    $0x4,%eax
 212:	8b 00                	mov    (%eax),%eax
 214:	83 ec 0c             	sub    $0xc,%esp
 217:	50                   	push   %eax
 218:	e8 05 03 00 00       	call   522 <atoi>
 21d:	83 c4 10             	add    $0x10,%esp
 220:	a3 70 10 00 00       	mov    %eax,0x1070
	TARGET_COUNT_PER_CHILD = atoi(argv[2]);
 225:	8b 43 04             	mov    0x4(%ebx),%eax
 228:	83 c0 08             	add    $0x8,%eax
 22b:	8b 00                	mov    (%eax),%eax
 22d:	83 ec 0c             	sub    $0xc,%esp
 230:	50                   	push   %eax
 231:	e8 ec 02 00 00       	call   522 <atoi>
 236:	83 c4 10             	add    $0x10,%esp
 239:	a3 74 10 00 00       	mov    %eax,0x1074

	final_target = NUM_CHILDREN*TARGET_COUNT_PER_CHILD;
 23e:	8b 15 70 10 00 00    	mov    0x1070,%edx
 244:	a1 74 10 00 00       	mov    0x1074,%eax
 249:	0f af c2             	imul   %edx,%eax
 24c:	89 45 f0             	mov    %eax,-0x10(%ebp)

	// Initialize semaphore to 1
	if ((sem_id = sem_create(1)) < 0)
 24f:	83 ec 0c             	sub    $0xc,%esp
 252:	6a 01                	push   $0x1
 254:	e8 0b 04 00 00       	call   664 <sem_create>
 259:	83 c4 10             	add    $0x10,%esp
 25c:	a3 78 10 00 00       	mov    %eax,0x1078
 261:	a1 78 10 00 00       	mov    0x1078,%eax
 266:	85 c0                	test   %eax,%eax
 268:	79 17                	jns    281 <main+0xa5>
	{
		printf(1, "main: error initializing semaphore \n");
 26a:	83 ec 08             	sub    $0x8,%esp
 26d:	68 a8 0c 00 00       	push   $0xca8
 272:	6a 01                	push   $0x1
 274:	e8 f2 04 00 00       	call   76b <printf>
 279:	83 c4 10             	add    $0x10,%esp
		exit();
 27c:	e8 33 03 00 00       	call   5b4 <exit>
	}

	// Initialize counter
	counter_init(COUNTER_FILE, 0);
 281:	83 ec 08             	sub    $0x8,%esp
 284:	6a 00                	push   $0x0
 286:	68 69 0c 00 00       	push   $0xc69
 28b:	e8 70 fd ff ff       	call   0 <counter_init>
 290:	83 c4 10             	add    $0x10,%esp

	printf(1, "Running with %d processes...\n", NUM_CHILDREN);
 293:	a1 70 10 00 00       	mov    0x1070,%eax
 298:	83 ec 04             	sub    $0x4,%esp
 29b:	50                   	push   %eax
 29c:	68 cd 0c 00 00       	push   $0xccd
 2a1:	6a 01                	push   $0x1
 2a3:	e8 c3 04 00 00       	call   76b <printf>
 2a8:	83 c4 10             	add    $0x10,%esp

	// Start all children
	for (i=0; i<NUM_CHILDREN; i++) {
 2ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2b2:	eb 17                	jmp    2cb <main+0xef>
		int pid = fork();
 2b4:	e8 f3 02 00 00       	call   5ac <fork>
 2b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (pid == 0)
 2bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 2c0:	75 05                	jne    2c7 <main+0xeb>
			child();
 2c2:	e8 88 fe ff ff       	call   14f <child>
	counter_init(COUNTER_FILE, 0);

	printf(1, "Running with %d processes...\n", NUM_CHILDREN);

	// Start all children
	for (i=0; i<NUM_CHILDREN; i++) {
 2c7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 2cb:	a1 70 10 00 00       	mov    0x1070,%eax
 2d0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 2d3:	7c df                	jl     2b4 <main+0xd8>
		if (pid == 0)
			child();
	}
	
	// Wait for all children
	for (i=0; i<NUM_CHILDREN; i++) {
 2d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2dc:	eb 09                	jmp    2e7 <main+0x10b>
		wait();
 2de:	e8 d9 02 00 00       	call   5bc <wait>
		if (pid == 0)
			child();
	}
	
	// Wait for all children
	for (i=0; i<NUM_CHILDREN; i++) {
 2e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 2e7:	a1 70 10 00 00       	mov    0x1070,%eax
 2ec:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 2ef:	7c ed                	jl     2de <main+0x102>
		wait();
	}

	// Check the result
	final_counter = counter_get(COUNTER_FILE);
 2f1:	83 ec 0c             	sub    $0xc,%esp
 2f4:	68 69 0c 00 00       	push   $0xc69
 2f9:	e8 69 fd ff ff       	call   67 <counter_get>
 2fe:	83 c4 10             	add    $0x10,%esp
 301:	89 45 e8             	mov    %eax,-0x18(%ebp)
	printf(1, "Final counter is %d, target is %d\n", final_counter, final_target);
 304:	ff 75 f0             	pushl  -0x10(%ebp)
 307:	ff 75 e8             	pushl  -0x18(%ebp)
 30a:	68 ec 0c 00 00       	push   $0xcec
 30f:	6a 01                	push   $0x1
 311:	e8 55 04 00 00       	call   76b <printf>
 316:	83 c4 10             	add    $0x10,%esp
	if (final_counter == final_target)
 319:	8b 45 e8             	mov    -0x18(%ebp),%eax
 31c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 31f:	75 14                	jne    335 <main+0x159>
		printf(1, "TEST PASSED!\n");
 321:	83 ec 08             	sub    $0x8,%esp
 324:	68 0f 0d 00 00       	push   $0xd0f
 329:	6a 01                	push   $0x1
 32b:	e8 3b 04 00 00       	call   76b <printf>
 330:	83 c4 10             	add    $0x10,%esp
 333:	eb 12                	jmp    347 <main+0x16b>
	else
		printf(1, "TEST FAILED!\n");
 335:	83 ec 08             	sub    $0x8,%esp
 338:	68 1d 0d 00 00       	push   $0xd1d
 33d:	6a 01                	push   $0x1
 33f:	e8 27 04 00 00       	call   76b <printf>
 344:	83 c4 10             	add    $0x10,%esp
	
	// Clean up semaphore
	sem_destroy(sem_id);
 347:	a1 78 10 00 00       	mov    0x1078,%eax
 34c:	83 ec 0c             	sub    $0xc,%esp
 34f:	50                   	push   %eax
 350:	e8 17 03 00 00       	call   66c <sem_destroy>
 355:	83 c4 10             	add    $0x10,%esp

	// Exit
	exit();
 358:	e8 57 02 00 00       	call   5b4 <exit>

0000035d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 35d:	55                   	push   %ebp
 35e:	89 e5                	mov    %esp,%ebp
 360:	57                   	push   %edi
 361:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 362:	8b 4d 08             	mov    0x8(%ebp),%ecx
 365:	8b 55 10             	mov    0x10(%ebp),%edx
 368:	8b 45 0c             	mov    0xc(%ebp),%eax
 36b:	89 cb                	mov    %ecx,%ebx
 36d:	89 df                	mov    %ebx,%edi
 36f:	89 d1                	mov    %edx,%ecx
 371:	fc                   	cld    
 372:	f3 aa                	rep stos %al,%es:(%edi)
 374:	89 ca                	mov    %ecx,%edx
 376:	89 fb                	mov    %edi,%ebx
 378:	89 5d 08             	mov    %ebx,0x8(%ebp)
 37b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 37e:	90                   	nop
 37f:	5b                   	pop    %ebx
 380:	5f                   	pop    %edi
 381:	5d                   	pop    %ebp
 382:	c3                   	ret    

00000383 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 383:	55                   	push   %ebp
 384:	89 e5                	mov    %esp,%ebp
 386:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 389:	8b 45 08             	mov    0x8(%ebp),%eax
 38c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 38f:	90                   	nop
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	8d 50 01             	lea    0x1(%eax),%edx
 396:	89 55 08             	mov    %edx,0x8(%ebp)
 399:	8b 55 0c             	mov    0xc(%ebp),%edx
 39c:	8d 4a 01             	lea    0x1(%edx),%ecx
 39f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3a2:	0f b6 12             	movzbl (%edx),%edx
 3a5:	88 10                	mov    %dl,(%eax)
 3a7:	0f b6 00             	movzbl (%eax),%eax
 3aa:	84 c0                	test   %al,%al
 3ac:	75 e2                	jne    390 <strcpy+0xd>
    ;
  return os;
 3ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b1:	c9                   	leave  
 3b2:	c3                   	ret    

000003b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3b3:	55                   	push   %ebp
 3b4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3b6:	eb 08                	jmp    3c0 <strcmp+0xd>
    p++, q++;
 3b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3bc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	0f b6 00             	movzbl (%eax),%eax
 3c6:	84 c0                	test   %al,%al
 3c8:	74 10                	je     3da <strcmp+0x27>
 3ca:	8b 45 08             	mov    0x8(%ebp),%eax
 3cd:	0f b6 10             	movzbl (%eax),%edx
 3d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d3:	0f b6 00             	movzbl (%eax),%eax
 3d6:	38 c2                	cmp    %al,%dl
 3d8:	74 de                	je     3b8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3da:	8b 45 08             	mov    0x8(%ebp),%eax
 3dd:	0f b6 00             	movzbl (%eax),%eax
 3e0:	0f b6 d0             	movzbl %al,%edx
 3e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	0f b6 c0             	movzbl %al,%eax
 3ec:	29 c2                	sub    %eax,%edx
 3ee:	89 d0                	mov    %edx,%eax
}
 3f0:	5d                   	pop    %ebp
 3f1:	c3                   	ret    

000003f2 <strlen>:

uint
strlen(char *s)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3ff:	eb 04                	jmp    405 <strlen+0x13>
 401:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 405:	8b 55 fc             	mov    -0x4(%ebp),%edx
 408:	8b 45 08             	mov    0x8(%ebp),%eax
 40b:	01 d0                	add    %edx,%eax
 40d:	0f b6 00             	movzbl (%eax),%eax
 410:	84 c0                	test   %al,%al
 412:	75 ed                	jne    401 <strlen+0xf>
    ;
  return n;
 414:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 417:	c9                   	leave  
 418:	c3                   	ret    

00000419 <memset>:

void*
memset(void *dst, int c, uint n)
{
 419:	55                   	push   %ebp
 41a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 41c:	8b 45 10             	mov    0x10(%ebp),%eax
 41f:	50                   	push   %eax
 420:	ff 75 0c             	pushl  0xc(%ebp)
 423:	ff 75 08             	pushl  0x8(%ebp)
 426:	e8 32 ff ff ff       	call   35d <stosb>
 42b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 431:	c9                   	leave  
 432:	c3                   	ret    

00000433 <strchr>:

char*
strchr(const char *s, char c)
{
 433:	55                   	push   %ebp
 434:	89 e5                	mov    %esp,%ebp
 436:	83 ec 04             	sub    $0x4,%esp
 439:	8b 45 0c             	mov    0xc(%ebp),%eax
 43c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 43f:	eb 14                	jmp    455 <strchr+0x22>
    if(*s == c)
 441:	8b 45 08             	mov    0x8(%ebp),%eax
 444:	0f b6 00             	movzbl (%eax),%eax
 447:	3a 45 fc             	cmp    -0x4(%ebp),%al
 44a:	75 05                	jne    451 <strchr+0x1e>
      return (char*)s;
 44c:	8b 45 08             	mov    0x8(%ebp),%eax
 44f:	eb 13                	jmp    464 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 451:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 455:	8b 45 08             	mov    0x8(%ebp),%eax
 458:	0f b6 00             	movzbl (%eax),%eax
 45b:	84 c0                	test   %al,%al
 45d:	75 e2                	jne    441 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 45f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 464:	c9                   	leave  
 465:	c3                   	ret    

00000466 <gets>:

char*
gets(char *buf, int max)
{
 466:	55                   	push   %ebp
 467:	89 e5                	mov    %esp,%ebp
 469:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 46c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 473:	eb 42                	jmp    4b7 <gets+0x51>
    cc = read(0, &c, 1);
 475:	83 ec 04             	sub    $0x4,%esp
 478:	6a 01                	push   $0x1
 47a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 47d:	50                   	push   %eax
 47e:	6a 00                	push   $0x0
 480:	e8 47 01 00 00       	call   5cc <read>
 485:	83 c4 10             	add    $0x10,%esp
 488:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 48b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 48f:	7e 33                	jle    4c4 <gets+0x5e>
      break;
    buf[i++] = c;
 491:	8b 45 f4             	mov    -0xc(%ebp),%eax
 494:	8d 50 01             	lea    0x1(%eax),%edx
 497:	89 55 f4             	mov    %edx,-0xc(%ebp)
 49a:	89 c2                	mov    %eax,%edx
 49c:	8b 45 08             	mov    0x8(%ebp),%eax
 49f:	01 c2                	add    %eax,%edx
 4a1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4a5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4a7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4ab:	3c 0a                	cmp    $0xa,%al
 4ad:	74 16                	je     4c5 <gets+0x5f>
 4af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b3:	3c 0d                	cmp    $0xd,%al
 4b5:	74 0e                	je     4c5 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ba:	83 c0 01             	add    $0x1,%eax
 4bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4c0:	7c b3                	jl     475 <gets+0xf>
 4c2:	eb 01                	jmp    4c5 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4c4:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
 4cb:	01 d0                	add    %edx,%eax
 4cd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4d3:	c9                   	leave  
 4d4:	c3                   	ret    

000004d5 <stat>:

int
stat(char *n, struct stat *st)
{
 4d5:	55                   	push   %ebp
 4d6:	89 e5                	mov    %esp,%ebp
 4d8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4db:	83 ec 08             	sub    $0x8,%esp
 4de:	6a 00                	push   $0x0
 4e0:	ff 75 08             	pushl  0x8(%ebp)
 4e3:	e8 0c 01 00 00       	call   5f4 <open>
 4e8:	83 c4 10             	add    $0x10,%esp
 4eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f2:	79 07                	jns    4fb <stat+0x26>
    return -1;
 4f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4f9:	eb 25                	jmp    520 <stat+0x4b>
  r = fstat(fd, st);
 4fb:	83 ec 08             	sub    $0x8,%esp
 4fe:	ff 75 0c             	pushl  0xc(%ebp)
 501:	ff 75 f4             	pushl  -0xc(%ebp)
 504:	e8 03 01 00 00       	call   60c <fstat>
 509:	83 c4 10             	add    $0x10,%esp
 50c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 50f:	83 ec 0c             	sub    $0xc,%esp
 512:	ff 75 f4             	pushl  -0xc(%ebp)
 515:	e8 c2 00 00 00       	call   5dc <close>
 51a:	83 c4 10             	add    $0x10,%esp
  return r;
 51d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 520:	c9                   	leave  
 521:	c3                   	ret    

00000522 <atoi>:

int
atoi(const char *s)
{
 522:	55                   	push   %ebp
 523:	89 e5                	mov    %esp,%ebp
 525:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 528:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 52f:	eb 25                	jmp    556 <atoi+0x34>
    n = n*10 + *s++ - '0';
 531:	8b 55 fc             	mov    -0x4(%ebp),%edx
 534:	89 d0                	mov    %edx,%eax
 536:	c1 e0 02             	shl    $0x2,%eax
 539:	01 d0                	add    %edx,%eax
 53b:	01 c0                	add    %eax,%eax
 53d:	89 c1                	mov    %eax,%ecx
 53f:	8b 45 08             	mov    0x8(%ebp),%eax
 542:	8d 50 01             	lea    0x1(%eax),%edx
 545:	89 55 08             	mov    %edx,0x8(%ebp)
 548:	0f b6 00             	movzbl (%eax),%eax
 54b:	0f be c0             	movsbl %al,%eax
 54e:	01 c8                	add    %ecx,%eax
 550:	83 e8 30             	sub    $0x30,%eax
 553:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 556:	8b 45 08             	mov    0x8(%ebp),%eax
 559:	0f b6 00             	movzbl (%eax),%eax
 55c:	3c 2f                	cmp    $0x2f,%al
 55e:	7e 0a                	jle    56a <atoi+0x48>
 560:	8b 45 08             	mov    0x8(%ebp),%eax
 563:	0f b6 00             	movzbl (%eax),%eax
 566:	3c 39                	cmp    $0x39,%al
 568:	7e c7                	jle    531 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 56a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 56d:	c9                   	leave  
 56e:	c3                   	ret    

0000056f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 56f:	55                   	push   %ebp
 570:	89 e5                	mov    %esp,%ebp
 572:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 575:	8b 45 08             	mov    0x8(%ebp),%eax
 578:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 57b:	8b 45 0c             	mov    0xc(%ebp),%eax
 57e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 581:	eb 17                	jmp    59a <memmove+0x2b>
    *dst++ = *src++;
 583:	8b 45 fc             	mov    -0x4(%ebp),%eax
 586:	8d 50 01             	lea    0x1(%eax),%edx
 589:	89 55 fc             	mov    %edx,-0x4(%ebp)
 58c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 58f:	8d 4a 01             	lea    0x1(%edx),%ecx
 592:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 595:	0f b6 12             	movzbl (%edx),%edx
 598:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 59a:	8b 45 10             	mov    0x10(%ebp),%eax
 59d:	8d 50 ff             	lea    -0x1(%eax),%edx
 5a0:	89 55 10             	mov    %edx,0x10(%ebp)
 5a3:	85 c0                	test   %eax,%eax
 5a5:	7f dc                	jg     583 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5aa:	c9                   	leave  
 5ab:	c3                   	ret    

000005ac <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5ac:	b8 01 00 00 00       	mov    $0x1,%eax
 5b1:	cd 40                	int    $0x40
 5b3:	c3                   	ret    

000005b4 <exit>:
SYSCALL(exit)
 5b4:	b8 02 00 00 00       	mov    $0x2,%eax
 5b9:	cd 40                	int    $0x40
 5bb:	c3                   	ret    

000005bc <wait>:
SYSCALL(wait)
 5bc:	b8 03 00 00 00       	mov    $0x3,%eax
 5c1:	cd 40                	int    $0x40
 5c3:	c3                   	ret    

000005c4 <pipe>:
SYSCALL(pipe)
 5c4:	b8 04 00 00 00       	mov    $0x4,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <read>:
SYSCALL(read)
 5cc:	b8 05 00 00 00       	mov    $0x5,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <write>:
SYSCALL(write)
 5d4:	b8 10 00 00 00       	mov    $0x10,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <close>:
SYSCALL(close)
 5dc:	b8 15 00 00 00       	mov    $0x15,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <kill>:
SYSCALL(kill)
 5e4:	b8 06 00 00 00       	mov    $0x6,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <exec>:
SYSCALL(exec)
 5ec:	b8 07 00 00 00       	mov    $0x7,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <open>:
SYSCALL(open)
 5f4:	b8 0f 00 00 00       	mov    $0xf,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <mknod>:
SYSCALL(mknod)
 5fc:	b8 11 00 00 00       	mov    $0x11,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <unlink>:
SYSCALL(unlink)
 604:	b8 12 00 00 00       	mov    $0x12,%eax
 609:	cd 40                	int    $0x40
 60b:	c3                   	ret    

0000060c <fstat>:
SYSCALL(fstat)
 60c:	b8 08 00 00 00       	mov    $0x8,%eax
 611:	cd 40                	int    $0x40
 613:	c3                   	ret    

00000614 <link>:
SYSCALL(link)
 614:	b8 13 00 00 00       	mov    $0x13,%eax
 619:	cd 40                	int    $0x40
 61b:	c3                   	ret    

0000061c <mkdir>:
SYSCALL(mkdir)
 61c:	b8 14 00 00 00       	mov    $0x14,%eax
 621:	cd 40                	int    $0x40
 623:	c3                   	ret    

00000624 <chdir>:
SYSCALL(chdir)
 624:	b8 09 00 00 00       	mov    $0x9,%eax
 629:	cd 40                	int    $0x40
 62b:	c3                   	ret    

0000062c <dup>:
SYSCALL(dup)
 62c:	b8 0a 00 00 00       	mov    $0xa,%eax
 631:	cd 40                	int    $0x40
 633:	c3                   	ret    

00000634 <getpid>:
SYSCALL(getpid)
 634:	b8 0b 00 00 00       	mov    $0xb,%eax
 639:	cd 40                	int    $0x40
 63b:	c3                   	ret    

0000063c <sbrk>:
SYSCALL(sbrk)
 63c:	b8 0c 00 00 00       	mov    $0xc,%eax
 641:	cd 40                	int    $0x40
 643:	c3                   	ret    

00000644 <sleep>:
SYSCALL(sleep)
 644:	b8 0d 00 00 00       	mov    $0xd,%eax
 649:	cd 40                	int    $0x40
 64b:	c3                   	ret    

0000064c <uptime>:
SYSCALL(uptime)
 64c:	b8 0e 00 00 00       	mov    $0xe,%eax
 651:	cd 40                	int    $0x40
 653:	c3                   	ret    

00000654 <halt>:
SYSCALL(halt)
 654:	b8 16 00 00 00       	mov    $0x16,%eax
 659:	cd 40                	int    $0x40
 65b:	c3                   	ret    

0000065c <getnp>:
SYSCALL(getnp)
 65c:	b8 17 00 00 00       	mov    $0x17,%eax
 661:	cd 40                	int    $0x40
 663:	c3                   	ret    

00000664 <sem_create>:
SYSCALL(sem_create)
 664:	b8 18 00 00 00       	mov    $0x18,%eax
 669:	cd 40                	int    $0x40
 66b:	c3                   	ret    

0000066c <sem_destroy>:
SYSCALL(sem_destroy)
 66c:	b8 19 00 00 00       	mov    $0x19,%eax
 671:	cd 40                	int    $0x40
 673:	c3                   	ret    

00000674 <sem_wait>:
SYSCALL(sem_wait)
 674:	b8 1a 00 00 00       	mov    $0x1a,%eax
 679:	cd 40                	int    $0x40
 67b:	c3                   	ret    

0000067c <sem_signal>:
SYSCALL(sem_signal)
 67c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 681:	cd 40                	int    $0x40
 683:	c3                   	ret    

00000684 <clone>:
SYSCALL(clone)
 684:	b8 1c 00 00 00       	mov    $0x1c,%eax
 689:	cd 40                	int    $0x40
 68b:	c3                   	ret    

0000068c <join>:
SYSCALL(join)
 68c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 691:	cd 40                	int    $0x40
 693:	c3                   	ret    

00000694 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 694:	55                   	push   %ebp
 695:	89 e5                	mov    %esp,%ebp
 697:	83 ec 18             	sub    $0x18,%esp
 69a:	8b 45 0c             	mov    0xc(%ebp),%eax
 69d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6a0:	83 ec 04             	sub    $0x4,%esp
 6a3:	6a 01                	push   $0x1
 6a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6a8:	50                   	push   %eax
 6a9:	ff 75 08             	pushl  0x8(%ebp)
 6ac:	e8 23 ff ff ff       	call   5d4 <write>
 6b1:	83 c4 10             	add    $0x10,%esp
}
 6b4:	90                   	nop
 6b5:	c9                   	leave  
 6b6:	c3                   	ret    

000006b7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6b7:	55                   	push   %ebp
 6b8:	89 e5                	mov    %esp,%ebp
 6ba:	53                   	push   %ebx
 6bb:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6c5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6c9:	74 17                	je     6e2 <printint+0x2b>
 6cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6cf:	79 11                	jns    6e2 <printint+0x2b>
    neg = 1;
 6d1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6db:	f7 d8                	neg    %eax
 6dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6e0:	eb 06                	jmp    6e8 <printint+0x31>
  } else {
    x = xx;
 6e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6ef:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6f2:	8d 41 01             	lea    0x1(%ecx),%eax
 6f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6fe:	ba 00 00 00 00       	mov    $0x0,%edx
 703:	f7 f3                	div    %ebx
 705:	89 d0                	mov    %edx,%eax
 707:	0f b6 80 3c 10 00 00 	movzbl 0x103c(%eax),%eax
 70e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 712:	8b 5d 10             	mov    0x10(%ebp),%ebx
 715:	8b 45 ec             	mov    -0x14(%ebp),%eax
 718:	ba 00 00 00 00       	mov    $0x0,%edx
 71d:	f7 f3                	div    %ebx
 71f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 722:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 726:	75 c7                	jne    6ef <printint+0x38>
  if(neg)
 728:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 72c:	74 2d                	je     75b <printint+0xa4>
    buf[i++] = '-';
 72e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 731:	8d 50 01             	lea    0x1(%eax),%edx
 734:	89 55 f4             	mov    %edx,-0xc(%ebp)
 737:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 73c:	eb 1d                	jmp    75b <printint+0xa4>
    putc(fd, buf[i]);
 73e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 741:	8b 45 f4             	mov    -0xc(%ebp),%eax
 744:	01 d0                	add    %edx,%eax
 746:	0f b6 00             	movzbl (%eax),%eax
 749:	0f be c0             	movsbl %al,%eax
 74c:	83 ec 08             	sub    $0x8,%esp
 74f:	50                   	push   %eax
 750:	ff 75 08             	pushl  0x8(%ebp)
 753:	e8 3c ff ff ff       	call   694 <putc>
 758:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 75b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 75f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 763:	79 d9                	jns    73e <printint+0x87>
    putc(fd, buf[i]);
}
 765:	90                   	nop
 766:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 769:	c9                   	leave  
 76a:	c3                   	ret    

0000076b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 76b:	55                   	push   %ebp
 76c:	89 e5                	mov    %esp,%ebp
 76e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 771:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 778:	8d 45 0c             	lea    0xc(%ebp),%eax
 77b:	83 c0 04             	add    $0x4,%eax
 77e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 781:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 788:	e9 59 01 00 00       	jmp    8e6 <printf+0x17b>
    c = fmt[i] & 0xff;
 78d:	8b 55 0c             	mov    0xc(%ebp),%edx
 790:	8b 45 f0             	mov    -0x10(%ebp),%eax
 793:	01 d0                	add    %edx,%eax
 795:	0f b6 00             	movzbl (%eax),%eax
 798:	0f be c0             	movsbl %al,%eax
 79b:	25 ff 00 00 00       	and    $0xff,%eax
 7a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7a7:	75 2c                	jne    7d5 <printf+0x6a>
      if(c == '%'){
 7a9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7ad:	75 0c                	jne    7bb <printf+0x50>
        state = '%';
 7af:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7b6:	e9 27 01 00 00       	jmp    8e2 <printf+0x177>
      } else {
        putc(fd, c);
 7bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7be:	0f be c0             	movsbl %al,%eax
 7c1:	83 ec 08             	sub    $0x8,%esp
 7c4:	50                   	push   %eax
 7c5:	ff 75 08             	pushl  0x8(%ebp)
 7c8:	e8 c7 fe ff ff       	call   694 <putc>
 7cd:	83 c4 10             	add    $0x10,%esp
 7d0:	e9 0d 01 00 00       	jmp    8e2 <printf+0x177>
      }
    } else if(state == '%'){
 7d5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7d9:	0f 85 03 01 00 00    	jne    8e2 <printf+0x177>
      if(c == 'd'){
 7df:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7e3:	75 1e                	jne    803 <printf+0x98>
        printint(fd, *ap, 10, 1);
 7e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e8:	8b 00                	mov    (%eax),%eax
 7ea:	6a 01                	push   $0x1
 7ec:	6a 0a                	push   $0xa
 7ee:	50                   	push   %eax
 7ef:	ff 75 08             	pushl  0x8(%ebp)
 7f2:	e8 c0 fe ff ff       	call   6b7 <printint>
 7f7:	83 c4 10             	add    $0x10,%esp
        ap++;
 7fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7fe:	e9 d8 00 00 00       	jmp    8db <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 803:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 807:	74 06                	je     80f <printf+0xa4>
 809:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 80d:	75 1e                	jne    82d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 80f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 812:	8b 00                	mov    (%eax),%eax
 814:	6a 00                	push   $0x0
 816:	6a 10                	push   $0x10
 818:	50                   	push   %eax
 819:	ff 75 08             	pushl  0x8(%ebp)
 81c:	e8 96 fe ff ff       	call   6b7 <printint>
 821:	83 c4 10             	add    $0x10,%esp
        ap++;
 824:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 828:	e9 ae 00 00 00       	jmp    8db <printf+0x170>
      } else if(c == 's'){
 82d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 831:	75 43                	jne    876 <printf+0x10b>
        s = (char*)*ap;
 833:	8b 45 e8             	mov    -0x18(%ebp),%eax
 836:	8b 00                	mov    (%eax),%eax
 838:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 83b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 83f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 843:	75 25                	jne    86a <printf+0xff>
          s = "(null)";
 845:	c7 45 f4 2b 0d 00 00 	movl   $0xd2b,-0xc(%ebp)
        while(*s != 0){
 84c:	eb 1c                	jmp    86a <printf+0xff>
          putc(fd, *s);
 84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 851:	0f b6 00             	movzbl (%eax),%eax
 854:	0f be c0             	movsbl %al,%eax
 857:	83 ec 08             	sub    $0x8,%esp
 85a:	50                   	push   %eax
 85b:	ff 75 08             	pushl  0x8(%ebp)
 85e:	e8 31 fe ff ff       	call   694 <putc>
 863:	83 c4 10             	add    $0x10,%esp
          s++;
 866:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 86a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86d:	0f b6 00             	movzbl (%eax),%eax
 870:	84 c0                	test   %al,%al
 872:	75 da                	jne    84e <printf+0xe3>
 874:	eb 65                	jmp    8db <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 876:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 87a:	75 1d                	jne    899 <printf+0x12e>
        putc(fd, *ap);
 87c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 87f:	8b 00                	mov    (%eax),%eax
 881:	0f be c0             	movsbl %al,%eax
 884:	83 ec 08             	sub    $0x8,%esp
 887:	50                   	push   %eax
 888:	ff 75 08             	pushl  0x8(%ebp)
 88b:	e8 04 fe ff ff       	call   694 <putc>
 890:	83 c4 10             	add    $0x10,%esp
        ap++;
 893:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 897:	eb 42                	jmp    8db <printf+0x170>
      } else if(c == '%'){
 899:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 89d:	75 17                	jne    8b6 <printf+0x14b>
        putc(fd, c);
 89f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8a2:	0f be c0             	movsbl %al,%eax
 8a5:	83 ec 08             	sub    $0x8,%esp
 8a8:	50                   	push   %eax
 8a9:	ff 75 08             	pushl  0x8(%ebp)
 8ac:	e8 e3 fd ff ff       	call   694 <putc>
 8b1:	83 c4 10             	add    $0x10,%esp
 8b4:	eb 25                	jmp    8db <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8b6:	83 ec 08             	sub    $0x8,%esp
 8b9:	6a 25                	push   $0x25
 8bb:	ff 75 08             	pushl  0x8(%ebp)
 8be:	e8 d1 fd ff ff       	call   694 <putc>
 8c3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c9:	0f be c0             	movsbl %al,%eax
 8cc:	83 ec 08             	sub    $0x8,%esp
 8cf:	50                   	push   %eax
 8d0:	ff 75 08             	pushl  0x8(%ebp)
 8d3:	e8 bc fd ff ff       	call   694 <putc>
 8d8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8e2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8e6:	8b 55 0c             	mov    0xc(%ebp),%edx
 8e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ec:	01 d0                	add    %edx,%eax
 8ee:	0f b6 00             	movzbl (%eax),%eax
 8f1:	84 c0                	test   %al,%al
 8f3:	0f 85 94 fe ff ff    	jne    78d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8f9:	90                   	nop
 8fa:	c9                   	leave  
 8fb:	c3                   	ret    

000008fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8fc:	55                   	push   %ebp
 8fd:	89 e5                	mov    %esp,%ebp
 8ff:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 902:	8b 45 08             	mov    0x8(%ebp),%eax
 905:	83 e8 08             	sub    $0x8,%eax
 908:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90b:	a1 68 10 00 00       	mov    0x1068,%eax
 910:	89 45 fc             	mov    %eax,-0x4(%ebp)
 913:	eb 24                	jmp    939 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 915:	8b 45 fc             	mov    -0x4(%ebp),%eax
 918:	8b 00                	mov    (%eax),%eax
 91a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 91d:	77 12                	ja     931 <free+0x35>
 91f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 922:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 925:	77 24                	ja     94b <free+0x4f>
 927:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92a:	8b 00                	mov    (%eax),%eax
 92c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 92f:	77 1a                	ja     94b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 931:	8b 45 fc             	mov    -0x4(%ebp),%eax
 934:	8b 00                	mov    (%eax),%eax
 936:	89 45 fc             	mov    %eax,-0x4(%ebp)
 939:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 93f:	76 d4                	jbe    915 <free+0x19>
 941:	8b 45 fc             	mov    -0x4(%ebp),%eax
 944:	8b 00                	mov    (%eax),%eax
 946:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 949:	76 ca                	jbe    915 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 94b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94e:	8b 40 04             	mov    0x4(%eax),%eax
 951:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 958:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95b:	01 c2                	add    %eax,%edx
 95d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 960:	8b 00                	mov    (%eax),%eax
 962:	39 c2                	cmp    %eax,%edx
 964:	75 24                	jne    98a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 966:	8b 45 f8             	mov    -0x8(%ebp),%eax
 969:	8b 50 04             	mov    0x4(%eax),%edx
 96c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96f:	8b 00                	mov    (%eax),%eax
 971:	8b 40 04             	mov    0x4(%eax),%eax
 974:	01 c2                	add    %eax,%edx
 976:	8b 45 f8             	mov    -0x8(%ebp),%eax
 979:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 97c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97f:	8b 00                	mov    (%eax),%eax
 981:	8b 10                	mov    (%eax),%edx
 983:	8b 45 f8             	mov    -0x8(%ebp),%eax
 986:	89 10                	mov    %edx,(%eax)
 988:	eb 0a                	jmp    994 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 98a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98d:	8b 10                	mov    (%eax),%edx
 98f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 992:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 994:	8b 45 fc             	mov    -0x4(%ebp),%eax
 997:	8b 40 04             	mov    0x4(%eax),%eax
 99a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a4:	01 d0                	add    %edx,%eax
 9a6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9a9:	75 20                	jne    9cb <free+0xcf>
    p->s.size += bp->s.size;
 9ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ae:	8b 50 04             	mov    0x4(%eax),%edx
 9b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b4:	8b 40 04             	mov    0x4(%eax),%eax
 9b7:	01 c2                	add    %eax,%edx
 9b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c2:	8b 10                	mov    (%eax),%edx
 9c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c7:	89 10                	mov    %edx,(%eax)
 9c9:	eb 08                	jmp    9d3 <free+0xd7>
  } else
    p->s.ptr = bp;
 9cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ce:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9d1:	89 10                	mov    %edx,(%eax)
  freep = p;
 9d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d6:	a3 68 10 00 00       	mov    %eax,0x1068
}
 9db:	90                   	nop
 9dc:	c9                   	leave  
 9dd:	c3                   	ret    

000009de <morecore>:

static Header*
morecore(uint nu)
{
 9de:	55                   	push   %ebp
 9df:	89 e5                	mov    %esp,%ebp
 9e1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9e4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9eb:	77 07                	ja     9f4 <morecore+0x16>
    nu = 4096;
 9ed:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9f4:	8b 45 08             	mov    0x8(%ebp),%eax
 9f7:	c1 e0 03             	shl    $0x3,%eax
 9fa:	83 ec 0c             	sub    $0xc,%esp
 9fd:	50                   	push   %eax
 9fe:	e8 39 fc ff ff       	call   63c <sbrk>
 a03:	83 c4 10             	add    $0x10,%esp
 a06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a09:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a0d:	75 07                	jne    a16 <morecore+0x38>
    return 0;
 a0f:	b8 00 00 00 00       	mov    $0x0,%eax
 a14:	eb 26                	jmp    a3c <morecore+0x5e>
  hp = (Header*)p;
 a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1f:	8b 55 08             	mov    0x8(%ebp),%edx
 a22:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a28:	83 c0 08             	add    $0x8,%eax
 a2b:	83 ec 0c             	sub    $0xc,%esp
 a2e:	50                   	push   %eax
 a2f:	e8 c8 fe ff ff       	call   8fc <free>
 a34:	83 c4 10             	add    $0x10,%esp
  return freep;
 a37:	a1 68 10 00 00       	mov    0x1068,%eax
}
 a3c:	c9                   	leave  
 a3d:	c3                   	ret    

00000a3e <malloc>:

void*
malloc(uint nbytes)
{
 a3e:	55                   	push   %ebp
 a3f:	89 e5                	mov    %esp,%ebp
 a41:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a44:	8b 45 08             	mov    0x8(%ebp),%eax
 a47:	83 c0 07             	add    $0x7,%eax
 a4a:	c1 e8 03             	shr    $0x3,%eax
 a4d:	83 c0 01             	add    $0x1,%eax
 a50:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a53:	a1 68 10 00 00       	mov    0x1068,%eax
 a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a5f:	75 23                	jne    a84 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a61:	c7 45 f0 60 10 00 00 	movl   $0x1060,-0x10(%ebp)
 a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a6b:	a3 68 10 00 00       	mov    %eax,0x1068
 a70:	a1 68 10 00 00       	mov    0x1068,%eax
 a75:	a3 60 10 00 00       	mov    %eax,0x1060
    base.s.size = 0;
 a7a:	c7 05 64 10 00 00 00 	movl   $0x0,0x1064
 a81:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a87:	8b 00                	mov    (%eax),%eax
 a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8f:	8b 40 04             	mov    0x4(%eax),%eax
 a92:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a95:	72 4d                	jb     ae4 <malloc+0xa6>
      if(p->s.size == nunits)
 a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9a:	8b 40 04             	mov    0x4(%eax),%eax
 a9d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aa0:	75 0c                	jne    aae <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa5:	8b 10                	mov    (%eax),%edx
 aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aaa:	89 10                	mov    %edx,(%eax)
 aac:	eb 26                	jmp    ad4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab1:	8b 40 04             	mov    0x4(%eax),%eax
 ab4:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ab7:	89 c2                	mov    %eax,%edx
 ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac2:	8b 40 04             	mov    0x4(%eax),%eax
 ac5:	c1 e0 03             	shl    $0x3,%eax
 ac8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ace:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ad1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad7:	a3 68 10 00 00       	mov    %eax,0x1068
      return (void*)(p + 1);
 adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 adf:	83 c0 08             	add    $0x8,%eax
 ae2:	eb 3b                	jmp    b1f <malloc+0xe1>
    }
    if(p == freep)
 ae4:	a1 68 10 00 00       	mov    0x1068,%eax
 ae9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 aec:	75 1e                	jne    b0c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 aee:	83 ec 0c             	sub    $0xc,%esp
 af1:	ff 75 ec             	pushl  -0x14(%ebp)
 af4:	e8 e5 fe ff ff       	call   9de <morecore>
 af9:	83 c4 10             	add    $0x10,%esp
 afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b03:	75 07                	jne    b0c <malloc+0xce>
        return 0;
 b05:	b8 00 00 00 00       	mov    $0x0,%eax
 b0a:	eb 13                	jmp    b1f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b15:	8b 00                	mov    (%eax),%eax
 b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b1a:	e9 6d ff ff ff       	jmp    a8c <malloc+0x4e>
}
 b1f:	c9                   	leave  
 b20:	c3                   	ret    

00000b21 <hufs_thread_create>:

int thread_num = 0;


int hufs_thread_create(void *func(), void *args)
{
 b21:	55                   	push   %ebp
 b22:	89 e5                	mov    %esp,%ebp
 b24:	83 ec 18             	sub    $0x18,%esp
	void *stack; 
	int pid;

	stack = malloc(4096);
 b27:	83 ec 0c             	sub    $0xc,%esp
 b2a:	68 00 10 00 00       	push   $0x1000
 b2f:	e8 0a ff ff ff       	call   a3e <malloc>
 b34:	83 c4 10             	add    $0x10,%esp
 b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (stack==0) return -1;
 b3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b3e:	75 07                	jne    b47 <hufs_thread_create+0x26>
 b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 b45:	eb 42                	jmp    b89 <hufs_thread_create+0x68>

	pid = clone(func, args, stack); 
 b47:	83 ec 04             	sub    $0x4,%esp
 b4a:	ff 75 f4             	pushl  -0xc(%ebp)
 b4d:	ff 75 0c             	pushl  0xc(%ebp)
 b50:	ff 75 08             	pushl  0x8(%ebp)
 b53:	e8 2c fb ff ff       	call   684 <clone>
 b58:	83 c4 10             	add    $0x10,%esp
 b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (pid==-1) {
 b5e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 b62:	75 15                	jne    b79 <hufs_thread_create+0x58>
		free(stack);
 b64:	83 ec 0c             	sub    $0xc,%esp
 b67:	ff 75 f4             	pushl  -0xc(%ebp)
 b6a:	e8 8d fd ff ff       	call   8fc <free>
 b6f:	83 c4 10             	add    $0x10,%esp
		return -1;
 b72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 b77:	eb 10                	jmp    b89 <hufs_thread_create+0x68>
	}

	thread_info[pid].stack = stack; 
 b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b7f:	89 14 85 80 10 00 00 	mov    %edx,0x1080(,%eax,4)

	return pid; 
 b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 b89:	c9                   	leave  
 b8a:	c3                   	ret    

00000b8b <hufs_thread_join>:

int hufs_thread_join(int pid)
{
 b8b:	55                   	push   %ebp
 b8c:	89 e5                	mov    %esp,%ebp
 b8e:	83 ec 18             	sub    $0x18,%esp
	void *stack = thread_info[pid].stack;
 b91:	8b 45 08             	mov    0x8(%ebp),%eax
 b94:	8b 04 85 80 10 00 00 	mov    0x1080(,%eax,4),%eax
 b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (stack==0) return -1;
 b9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ba2:	75 07                	jne    bab <hufs_thread_join+0x20>
 ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 ba9:	eb 28                	jmp    bd3 <hufs_thread_join+0x48>

	join(&thread_info[pid].stack);	
 bab:	8b 45 08             	mov    0x8(%ebp),%eax
 bae:	c1 e0 02             	shl    $0x2,%eax
 bb1:	05 80 10 00 00       	add    $0x1080,%eax
 bb6:	83 ec 0c             	sub    $0xc,%esp
 bb9:	50                   	push   %eax
 bba:	e8 cd fa ff ff       	call   68c <join>
 bbf:	83 c4 10             	add    $0x10,%esp
	free(stack);
 bc2:	83 ec 0c             	sub    $0xc,%esp
 bc5:	ff 75 f4             	pushl  -0xc(%ebp)
 bc8:	e8 2f fd ff ff       	call   8fc <free>
 bcd:	83 c4 10             	add    $0x10,%esp

	return pid;
 bd0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 bd3:	c9                   	leave  
 bd4:	c3                   	ret    
