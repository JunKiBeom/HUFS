
_hufs_thread_test:     file format elf32-i386


Disassembly of section .text:

00000000 <thread>:

uint g_counter;
int sem_id;

void *thread(void *arg)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
	int i;
	uint counter;

	sleep(10);
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	6a 0a                	push   $0xa
   b:	e8 f8 05 00 00       	call   608 <sleep>
  10:	83 c4 10             	add    $0x10,%esp
	printf(1, "thread %d: started...\n", *(int*)arg);
  13:	8b 45 08             	mov    0x8(%ebp),%eax
  16:	8b 00                	mov    (%eax),%eax
  18:	83 ec 04             	sub    $0x4,%esp
  1b:	50                   	push   %eax
  1c:	68 9c 0b 00 00       	push   $0xb9c
  21:	6a 01                	push   $0x1
  23:	e8 07 07 00 00       	call   72f <printf>
  28:	83 c4 10             	add    $0x10,%esp

	for (i=0; i<TARGET_COUNT_PER_THREAD; i++) {
  2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  32:	eb 54                	jmp    88 <thread+0x88>
		sem_wait(sem_id);
  34:	a1 38 10 00 00       	mov    0x1038,%eax
  39:	83 ec 0c             	sub    $0xc,%esp
  3c:	50                   	push   %eax
  3d:	e8 f6 05 00 00       	call   638 <sem_wait>
  42:	83 c4 10             	add    $0x10,%esp
		
		counter = g_counter;
  45:	a1 30 10 00 00       	mov    0x1030,%eax
  4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sleep(0);
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 b1 05 00 00       	call   608 <sleep>
  57:	83 c4 10             	add    $0x10,%esp
		counter++;
  5a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
		sleep(0);
  5e:	83 ec 0c             	sub    $0xc,%esp
  61:	6a 00                	push   $0x0
  63:	e8 a0 05 00 00       	call   608 <sleep>
  68:	83 c4 10             	add    $0x10,%esp
		g_counter = counter;
  6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  6e:	a3 30 10 00 00       	mov    %eax,0x1030

		sem_signal(sem_id);
  73:	a1 38 10 00 00       	mov    0x1038,%eax
  78:	83 ec 0c             	sub    $0xc,%esp
  7b:	50                   	push   %eax
  7c:	e8 bf 05 00 00       	call   640 <sem_signal>
  81:	83 c4 10             	add    $0x10,%esp
	uint counter;

	sleep(10);
	printf(1, "thread %d: started...\n", *(int*)arg);

	for (i=0; i<TARGET_COUNT_PER_THREAD; i++) {
  84:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  88:	a1 34 10 00 00       	mov    0x1034,%eax
  8d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  90:	7c a2                	jl     34 <thread+0x34>
		g_counter = counter;

		sem_signal(sem_id);
	}

	exit();
  92:	e8 e1 04 00 00       	call   578 <exit>

00000097 <main>:
}

int main(int argc, char **argv)
{
  97:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  9b:	83 e4 f0             	and    $0xfffffff0,%esp
  9e:	ff 71 fc             	pushl  -0x4(%ecx)
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	53                   	push   %ebx
  a5:	51                   	push   %ecx
  a6:	81 ec 10 02 00 00    	sub    $0x210,%esp
  ac:	89 cb                	mov    %ecx,%ebx
	int i;
	int sem_size;
	int final_counter;
	int final_target = NUM_THREADS*TARGET_COUNT_PER_THREAD;
  ae:	8b 15 3c 10 00 00    	mov    0x103c,%edx
  b4:	a1 34 10 00 00       	mov    0x1034,%eax
  b9:	0f af c2             	imul   %edx,%eax
  bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sem_size = NUM_THREADS;
	else
		sem_size = 1;
		*/

	if (argc < 3) {
  bf:	83 3b 02             	cmpl   $0x2,(%ebx)
  c2:	7f 17                	jg     db <main+0x44>
		printf(2, "Usage: hufs_thread_test num_threads count_per_thread");
  c4:	83 ec 08             	sub    $0x8,%esp
  c7:	68 b4 0b 00 00       	push   $0xbb4
  cc:	6a 02                	push   $0x2
  ce:	e8 5c 06 00 00       	call   72f <printf>
  d3:	83 c4 10             	add    $0x10,%esp
		exit();
  d6:	e8 9d 04 00 00       	call   578 <exit>
	}

	NUM_THREADS = atoi(argv[1]);
  db:	8b 43 04             	mov    0x4(%ebx),%eax
  de:	83 c0 04             	add    $0x4,%eax
  e1:	8b 00                	mov    (%eax),%eax
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	50                   	push   %eax
  e7:	e8 fa 03 00 00       	call   4e6 <atoi>
  ec:	83 c4 10             	add    $0x10,%esp
  ef:	a3 3c 10 00 00       	mov    %eax,0x103c
	TARGET_COUNT_PER_THREAD = atoi(argv[2]);
  f4:	8b 43 04             	mov    0x4(%ebx),%eax
  f7:	83 c0 08             	add    $0x8,%eax
  fa:	8b 00                	mov    (%eax),%eax
  fc:	83 ec 0c             	sub    $0xc,%esp
  ff:	50                   	push   %eax
 100:	e8 e1 03 00 00       	call   4e6 <atoi>
 105:	83 c4 10             	add    $0x10,%esp
 108:	a3 34 10 00 00       	mov    %eax,0x1034

	final_target = NUM_THREADS*TARGET_COUNT_PER_THREAD;
 10d:	8b 15 3c 10 00 00    	mov    0x103c,%edx
 113:	a1 34 10 00 00       	mov    0x1034,%eax
 118:	0f af c2             	imul   %edx,%eax
 11b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	//sem_size = NUM_THREADS; 
	sem_size = 1;
 11e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)

	// Initialize semaphore to 1
	if ((sem_id = sem_create(sem_size)) < 0)
 125:	83 ec 0c             	sub    $0xc,%esp
 128:	ff 75 ec             	pushl  -0x14(%ebp)
 12b:	e8 f8 04 00 00       	call   628 <sem_create>
 130:	83 c4 10             	add    $0x10,%esp
 133:	a3 38 10 00 00       	mov    %eax,0x1038
 138:	a1 38 10 00 00       	mov    0x1038,%eax
 13d:	85 c0                	test   %eax,%eax
 13f:	79 17                	jns    158 <main+0xc1>
	{
		printf(1, "main: error initializing semaphore %d\n");
 141:	83 ec 08             	sub    $0x8,%esp
 144:	68 ec 0b 00 00       	push   $0xbec
 149:	6a 01                	push   $0x1
 14b:	e8 df 05 00 00       	call   72f <printf>
 150:	83 c4 10             	add    $0x10,%esp
		exit();
 153:	e8 20 04 00 00       	call   578 <exit>
	}

	// Initialize counter
	g_counter = 0;
 158:	c7 05 30 10 00 00 00 	movl   $0x0,0x1030
 15f:	00 00 00 
	// Args
	int *args[MAX_NUM_THREADS];

	// Allocate stacks and args and make sure we have them all
	// Bail if something fails
	for (i=0; i<NUM_THREADS; i++) {
 162:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 169:	eb 51                	jmp    1bc <main+0x125>

		args[i] = (int*) malloc(4);
 16b:	83 ec 0c             	sub    $0xc,%esp
 16e:	6a 04                	push   $0x4
 170:	e8 8d 08 00 00       	call   a02 <malloc>
 175:	83 c4 10             	add    $0x10,%esp
 178:	89 c2                	mov    %eax,%edx
 17a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17d:	89 94 85 e8 fe ff ff 	mov    %edx,-0x118(%ebp,%eax,4)
		if (!args[i]) {
 184:	8b 45 f4             	mov    -0xc(%ebp),%eax
 187:	8b 84 85 e8 fe ff ff 	mov    -0x118(%ebp,%eax,4),%eax
 18e:	85 c0                	test   %eax,%eax
 190:	75 17                	jne    1a9 <main+0x112>
			printf(1, "main: could not get memory (for arg) for thread %d, exiting...\n");
 192:	83 ec 08             	sub    $0x8,%esp
 195:	68 14 0c 00 00       	push   $0xc14
 19a:	6a 01                	push   $0x1
 19c:	e8 8e 05 00 00       	call   72f <printf>
 1a1:	83 c4 10             	add    $0x10,%esp
			exit();
 1a4:	e8 cf 03 00 00       	call   578 <exit>
		}

		*args[i] = i;
 1a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ac:	8b 84 85 e8 fe ff ff 	mov    -0x118(%ebp,%eax,4),%eax
 1b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1b6:	89 10                	mov    %edx,(%eax)
	// Args
	int *args[MAX_NUM_THREADS];

	// Allocate stacks and args and make sure we have them all
	// Bail if something fails
	for (i=0; i<NUM_THREADS; i++) {
 1b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1bc:	a1 3c 10 00 00       	mov    0x103c,%eax
 1c1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 1c4:	7c a5                	jl     16b <main+0xd4>
		}

		*args[i] = i;
	}

	printf(1, "main: running with %d threads...\n", NUM_THREADS);
 1c6:	a1 3c 10 00 00       	mov    0x103c,%eax
 1cb:	83 ec 04             	sub    $0x4,%esp
 1ce:	50                   	push   %eax
 1cf:	68 54 0c 00 00       	push   $0xc54
 1d4:	6a 01                	push   $0x1
 1d6:	e8 54 05 00 00       	call   72f <printf>
 1db:	83 c4 10             	add    $0x10,%esp

	// Start all children
	int pid[MAX_NUM_THREADS];

	for (i=0; i<NUM_THREADS; i++) {
 1de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1e5:	eb 6e                	jmp    255 <main+0x1be>
		pid[i] = hufs_thread_create(thread, args[i]);
 1e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ea:	8b 84 85 e8 fe ff ff 	mov    -0x118(%ebp,%eax,4),%eax
 1f1:	83 ec 08             	sub    $0x8,%esp
 1f4:	50                   	push   %eax
 1f5:	68 00 00 00 00       	push   $0x0
 1fa:	e8 e6 08 00 00       	call   ae5 <hufs_thread_create>
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	89 c2                	mov    %eax,%edx
 204:	8b 45 f4             	mov    -0xc(%ebp),%eax
 207:	89 94 85 e8 fd ff ff 	mov    %edx,-0x218(%ebp,%eax,4)
		if (pid[i]==-1) {
 20e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 211:	8b 84 85 e8 fd ff ff 	mov    -0x218(%ebp,%eax,4),%eax
 218:	83 f8 ff             	cmp    $0xffffffff,%eax
 21b:	75 17                	jne    234 <main+0x19d>
			printf(1, "main: failed to creat a %d-th thread with pid %d\n", i);
 21d:	83 ec 04             	sub    $0x4,%esp
 220:	ff 75 f4             	pushl  -0xc(%ebp)
 223:	68 78 0c 00 00       	push   $0xc78
 228:	6a 01                	push   $0x1
 22a:	e8 00 05 00 00       	call   72f <printf>
 22f:	83 c4 10             	add    $0x10,%esp
 232:	eb 1d                	jmp    251 <main+0x1ba>
		}
		else printf(1, "main: created thread with pid %d\n", pid[i]);
 234:	8b 45 f4             	mov    -0xc(%ebp),%eax
 237:	8b 84 85 e8 fd ff ff 	mov    -0x218(%ebp,%eax,4),%eax
 23e:	83 ec 04             	sub    $0x4,%esp
 241:	50                   	push   %eax
 242:	68 ac 0c 00 00       	push   $0xcac
 247:	6a 01                	push   $0x1
 249:	e8 e1 04 00 00       	call   72f <printf>
 24e:	83 c4 10             	add    $0x10,%esp
	printf(1, "main: running with %d threads...\n", NUM_THREADS);

	// Start all children
	int pid[MAX_NUM_THREADS];

	for (i=0; i<NUM_THREADS; i++) {
 251:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 255:	a1 3c 10 00 00       	mov    0x103c,%eax
 25a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 25d:	7c 88                	jl     1e7 <main+0x150>
		}
		else printf(1, "main: created thread with pid %d\n", pid[i]);
	}
	
	// Wait for all children
	for (i=0; i<NUM_THREADS; i++) {
 25f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 266:	eb 4e                	jmp    2b6 <main+0x21f>
		printf(1, "before joining... \n");
 268:	83 ec 08             	sub    $0x8,%esp
 26b:	68 ce 0c 00 00       	push   $0xcce
 270:	6a 01                	push   $0x1
 272:	e8 b8 04 00 00       	call   72f <printf>
 277:	83 c4 10             	add    $0x10,%esp
		if (pid[i]!=-1) 
 27a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27d:	8b 84 85 e8 fd ff ff 	mov    -0x218(%ebp,%eax,4),%eax
 284:	83 f8 ff             	cmp    $0xffffffff,%eax
 287:	74 29                	je     2b2 <main+0x21b>
			printf(1, "main: thread %d joined...\n", hufs_thread_join(pid[i]));
 289:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28c:	8b 84 85 e8 fd ff ff 	mov    -0x218(%ebp,%eax,4),%eax
 293:	83 ec 0c             	sub    $0xc,%esp
 296:	50                   	push   %eax
 297:	e8 b3 08 00 00       	call   b4f <hufs_thread_join>
 29c:	83 c4 10             	add    $0x10,%esp
 29f:	83 ec 04             	sub    $0x4,%esp
 2a2:	50                   	push   %eax
 2a3:	68 e2 0c 00 00       	push   $0xce2
 2a8:	6a 01                	push   $0x1
 2aa:	e8 80 04 00 00       	call   72f <printf>
 2af:	83 c4 10             	add    $0x10,%esp
		}
		else printf(1, "main: created thread with pid %d\n", pid[i]);
	}
	
	// Wait for all children
	for (i=0; i<NUM_THREADS; i++) {
 2b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 2b6:	a1 3c 10 00 00       	mov    0x103c,%eax
 2bb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 2be:	7c a8                	jl     268 <main+0x1d1>
		if (pid[i]!=-1) 
			printf(1, "main: thread %d joined...\n", hufs_thread_join(pid[i]));
	}

	// Check the result
	final_counter = g_counter;
 2c0:	a1 30 10 00 00       	mov    0x1030,%eax
 2c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	printf(1, "Final counter is %d, target is %d\n", final_counter, final_target);
 2c8:	ff 75 f0             	pushl  -0x10(%ebp)
 2cb:	ff 75 e8             	pushl  -0x18(%ebp)
 2ce:	68 00 0d 00 00       	push   $0xd00
 2d3:	6a 01                	push   $0x1
 2d5:	e8 55 04 00 00       	call   72f <printf>
 2da:	83 c4 10             	add    $0x10,%esp
	if (final_counter == final_target)
 2dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 2e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 2e3:	75 14                	jne    2f9 <main+0x262>
		printf(1, "TEST PASSED!\n");
 2e5:	83 ec 08             	sub    $0x8,%esp
 2e8:	68 23 0d 00 00       	push   $0xd23
 2ed:	6a 01                	push   $0x1
 2ef:	e8 3b 04 00 00       	call   72f <printf>
 2f4:	83 c4 10             	add    $0x10,%esp
 2f7:	eb 12                	jmp    30b <main+0x274>
	else
		printf(1, "TEST FAILED!\n");
 2f9:	83 ec 08             	sub    $0x8,%esp
 2fc:	68 31 0d 00 00       	push   $0xd31
 301:	6a 01                	push   $0x1
 303:	e8 27 04 00 00       	call   72f <printf>
 308:	83 c4 10             	add    $0x10,%esp
	
	// Clean up semaphore
	sem_destroy(sem_id);
 30b:	a1 38 10 00 00       	mov    0x1038,%eax
 310:	83 ec 0c             	sub    $0xc,%esp
 313:	50                   	push   %eax
 314:	e8 17 03 00 00       	call   630 <sem_destroy>
 319:	83 c4 10             	add    $0x10,%esp

	// Exit
	exit();
 31c:	e8 57 02 00 00       	call   578 <exit>

00000321 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	57                   	push   %edi
 325:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 326:	8b 4d 08             	mov    0x8(%ebp),%ecx
 329:	8b 55 10             	mov    0x10(%ebp),%edx
 32c:	8b 45 0c             	mov    0xc(%ebp),%eax
 32f:	89 cb                	mov    %ecx,%ebx
 331:	89 df                	mov    %ebx,%edi
 333:	89 d1                	mov    %edx,%ecx
 335:	fc                   	cld    
 336:	f3 aa                	rep stos %al,%es:(%edi)
 338:	89 ca                	mov    %ecx,%edx
 33a:	89 fb                	mov    %edi,%ebx
 33c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 33f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 342:	90                   	nop
 343:	5b                   	pop    %ebx
 344:	5f                   	pop    %edi
 345:	5d                   	pop    %ebp
 346:	c3                   	ret    

00000347 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 347:	55                   	push   %ebp
 348:	89 e5                	mov    %esp,%ebp
 34a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 34d:	8b 45 08             	mov    0x8(%ebp),%eax
 350:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 353:	90                   	nop
 354:	8b 45 08             	mov    0x8(%ebp),%eax
 357:	8d 50 01             	lea    0x1(%eax),%edx
 35a:	89 55 08             	mov    %edx,0x8(%ebp)
 35d:	8b 55 0c             	mov    0xc(%ebp),%edx
 360:	8d 4a 01             	lea    0x1(%edx),%ecx
 363:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 366:	0f b6 12             	movzbl (%edx),%edx
 369:	88 10                	mov    %dl,(%eax)
 36b:	0f b6 00             	movzbl (%eax),%eax
 36e:	84 c0                	test   %al,%al
 370:	75 e2                	jne    354 <strcpy+0xd>
    ;
  return os;
 372:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 375:	c9                   	leave  
 376:	c3                   	ret    

00000377 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 377:	55                   	push   %ebp
 378:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 37a:	eb 08                	jmp    384 <strcmp+0xd>
    p++, q++;
 37c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 380:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 384:	8b 45 08             	mov    0x8(%ebp),%eax
 387:	0f b6 00             	movzbl (%eax),%eax
 38a:	84 c0                	test   %al,%al
 38c:	74 10                	je     39e <strcmp+0x27>
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	0f b6 10             	movzbl (%eax),%edx
 394:	8b 45 0c             	mov    0xc(%ebp),%eax
 397:	0f b6 00             	movzbl (%eax),%eax
 39a:	38 c2                	cmp    %al,%dl
 39c:	74 de                	je     37c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 39e:	8b 45 08             	mov    0x8(%ebp),%eax
 3a1:	0f b6 00             	movzbl (%eax),%eax
 3a4:	0f b6 d0             	movzbl %al,%edx
 3a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3aa:	0f b6 00             	movzbl (%eax),%eax
 3ad:	0f b6 c0             	movzbl %al,%eax
 3b0:	29 c2                	sub    %eax,%edx
 3b2:	89 d0                	mov    %edx,%eax
}
 3b4:	5d                   	pop    %ebp
 3b5:	c3                   	ret    

000003b6 <strlen>:

uint
strlen(char *s)
{
 3b6:	55                   	push   %ebp
 3b7:	89 e5                	mov    %esp,%ebp
 3b9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3c3:	eb 04                	jmp    3c9 <strlen+0x13>
 3c5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3cc:	8b 45 08             	mov    0x8(%ebp),%eax
 3cf:	01 d0                	add    %edx,%eax
 3d1:	0f b6 00             	movzbl (%eax),%eax
 3d4:	84 c0                	test   %al,%al
 3d6:	75 ed                	jne    3c5 <strlen+0xf>
    ;
  return n;
 3d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3db:	c9                   	leave  
 3dc:	c3                   	ret    

000003dd <memset>:

void*
memset(void *dst, int c, uint n)
{
 3dd:	55                   	push   %ebp
 3de:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3e0:	8b 45 10             	mov    0x10(%ebp),%eax
 3e3:	50                   	push   %eax
 3e4:	ff 75 0c             	pushl  0xc(%ebp)
 3e7:	ff 75 08             	pushl  0x8(%ebp)
 3ea:	e8 32 ff ff ff       	call   321 <stosb>
 3ef:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f5:	c9                   	leave  
 3f6:	c3                   	ret    

000003f7 <strchr>:

char*
strchr(const char *s, char c)
{
 3f7:	55                   	push   %ebp
 3f8:	89 e5                	mov    %esp,%ebp
 3fa:	83 ec 04             	sub    $0x4,%esp
 3fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 400:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 403:	eb 14                	jmp    419 <strchr+0x22>
    if(*s == c)
 405:	8b 45 08             	mov    0x8(%ebp),%eax
 408:	0f b6 00             	movzbl (%eax),%eax
 40b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 40e:	75 05                	jne    415 <strchr+0x1e>
      return (char*)s;
 410:	8b 45 08             	mov    0x8(%ebp),%eax
 413:	eb 13                	jmp    428 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 415:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 419:	8b 45 08             	mov    0x8(%ebp),%eax
 41c:	0f b6 00             	movzbl (%eax),%eax
 41f:	84 c0                	test   %al,%al
 421:	75 e2                	jne    405 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 423:	b8 00 00 00 00       	mov    $0x0,%eax
}
 428:	c9                   	leave  
 429:	c3                   	ret    

0000042a <gets>:

char*
gets(char *buf, int max)
{
 42a:	55                   	push   %ebp
 42b:	89 e5                	mov    %esp,%ebp
 42d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 430:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 437:	eb 42                	jmp    47b <gets+0x51>
    cc = read(0, &c, 1);
 439:	83 ec 04             	sub    $0x4,%esp
 43c:	6a 01                	push   $0x1
 43e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 441:	50                   	push   %eax
 442:	6a 00                	push   $0x0
 444:	e8 47 01 00 00       	call   590 <read>
 449:	83 c4 10             	add    $0x10,%esp
 44c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 44f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 453:	7e 33                	jle    488 <gets+0x5e>
      break;
    buf[i++] = c;
 455:	8b 45 f4             	mov    -0xc(%ebp),%eax
 458:	8d 50 01             	lea    0x1(%eax),%edx
 45b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 45e:	89 c2                	mov    %eax,%edx
 460:	8b 45 08             	mov    0x8(%ebp),%eax
 463:	01 c2                	add    %eax,%edx
 465:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 469:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 46b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 46f:	3c 0a                	cmp    $0xa,%al
 471:	74 16                	je     489 <gets+0x5f>
 473:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 477:	3c 0d                	cmp    $0xd,%al
 479:	74 0e                	je     489 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47e:	83 c0 01             	add    $0x1,%eax
 481:	3b 45 0c             	cmp    0xc(%ebp),%eax
 484:	7c b3                	jl     439 <gets+0xf>
 486:	eb 01                	jmp    489 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 488:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 489:	8b 55 f4             	mov    -0xc(%ebp),%edx
 48c:	8b 45 08             	mov    0x8(%ebp),%eax
 48f:	01 d0                	add    %edx,%eax
 491:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 494:	8b 45 08             	mov    0x8(%ebp),%eax
}
 497:	c9                   	leave  
 498:	c3                   	ret    

00000499 <stat>:

int
stat(char *n, struct stat *st)
{
 499:	55                   	push   %ebp
 49a:	89 e5                	mov    %esp,%ebp
 49c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 49f:	83 ec 08             	sub    $0x8,%esp
 4a2:	6a 00                	push   $0x0
 4a4:	ff 75 08             	pushl  0x8(%ebp)
 4a7:	e8 0c 01 00 00       	call   5b8 <open>
 4ac:	83 c4 10             	add    $0x10,%esp
 4af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b6:	79 07                	jns    4bf <stat+0x26>
    return -1;
 4b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4bd:	eb 25                	jmp    4e4 <stat+0x4b>
  r = fstat(fd, st);
 4bf:	83 ec 08             	sub    $0x8,%esp
 4c2:	ff 75 0c             	pushl  0xc(%ebp)
 4c5:	ff 75 f4             	pushl  -0xc(%ebp)
 4c8:	e8 03 01 00 00       	call   5d0 <fstat>
 4cd:	83 c4 10             	add    $0x10,%esp
 4d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4d3:	83 ec 0c             	sub    $0xc,%esp
 4d6:	ff 75 f4             	pushl  -0xc(%ebp)
 4d9:	e8 c2 00 00 00       	call   5a0 <close>
 4de:	83 c4 10             	add    $0x10,%esp
  return r;
 4e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4e4:	c9                   	leave  
 4e5:	c3                   	ret    

000004e6 <atoi>:

int
atoi(const char *s)
{
 4e6:	55                   	push   %ebp
 4e7:	89 e5                	mov    %esp,%ebp
 4e9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4f3:	eb 25                	jmp    51a <atoi+0x34>
    n = n*10 + *s++ - '0';
 4f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4f8:	89 d0                	mov    %edx,%eax
 4fa:	c1 e0 02             	shl    $0x2,%eax
 4fd:	01 d0                	add    %edx,%eax
 4ff:	01 c0                	add    %eax,%eax
 501:	89 c1                	mov    %eax,%ecx
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	8d 50 01             	lea    0x1(%eax),%edx
 509:	89 55 08             	mov    %edx,0x8(%ebp)
 50c:	0f b6 00             	movzbl (%eax),%eax
 50f:	0f be c0             	movsbl %al,%eax
 512:	01 c8                	add    %ecx,%eax
 514:	83 e8 30             	sub    $0x30,%eax
 517:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 51a:	8b 45 08             	mov    0x8(%ebp),%eax
 51d:	0f b6 00             	movzbl (%eax),%eax
 520:	3c 2f                	cmp    $0x2f,%al
 522:	7e 0a                	jle    52e <atoi+0x48>
 524:	8b 45 08             	mov    0x8(%ebp),%eax
 527:	0f b6 00             	movzbl (%eax),%eax
 52a:	3c 39                	cmp    $0x39,%al
 52c:	7e c7                	jle    4f5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 52e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 531:	c9                   	leave  
 532:	c3                   	ret    

00000533 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 533:	55                   	push   %ebp
 534:	89 e5                	mov    %esp,%ebp
 536:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 53f:	8b 45 0c             	mov    0xc(%ebp),%eax
 542:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 545:	eb 17                	jmp    55e <memmove+0x2b>
    *dst++ = *src++;
 547:	8b 45 fc             	mov    -0x4(%ebp),%eax
 54a:	8d 50 01             	lea    0x1(%eax),%edx
 54d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 550:	8b 55 f8             	mov    -0x8(%ebp),%edx
 553:	8d 4a 01             	lea    0x1(%edx),%ecx
 556:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 559:	0f b6 12             	movzbl (%edx),%edx
 55c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 55e:	8b 45 10             	mov    0x10(%ebp),%eax
 561:	8d 50 ff             	lea    -0x1(%eax),%edx
 564:	89 55 10             	mov    %edx,0x10(%ebp)
 567:	85 c0                	test   %eax,%eax
 569:	7f dc                	jg     547 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 56b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 56e:	c9                   	leave  
 56f:	c3                   	ret    

00000570 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 570:	b8 01 00 00 00       	mov    $0x1,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <exit>:
SYSCALL(exit)
 578:	b8 02 00 00 00       	mov    $0x2,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <wait>:
SYSCALL(wait)
 580:	b8 03 00 00 00       	mov    $0x3,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <pipe>:
SYSCALL(pipe)
 588:	b8 04 00 00 00       	mov    $0x4,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <read>:
SYSCALL(read)
 590:	b8 05 00 00 00       	mov    $0x5,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <write>:
SYSCALL(write)
 598:	b8 10 00 00 00       	mov    $0x10,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <close>:
SYSCALL(close)
 5a0:	b8 15 00 00 00       	mov    $0x15,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <kill>:
SYSCALL(kill)
 5a8:	b8 06 00 00 00       	mov    $0x6,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <exec>:
SYSCALL(exec)
 5b0:	b8 07 00 00 00       	mov    $0x7,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <open>:
SYSCALL(open)
 5b8:	b8 0f 00 00 00       	mov    $0xf,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <mknod>:
SYSCALL(mknod)
 5c0:	b8 11 00 00 00       	mov    $0x11,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <unlink>:
SYSCALL(unlink)
 5c8:	b8 12 00 00 00       	mov    $0x12,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <fstat>:
SYSCALL(fstat)
 5d0:	b8 08 00 00 00       	mov    $0x8,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <link>:
SYSCALL(link)
 5d8:	b8 13 00 00 00       	mov    $0x13,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <mkdir>:
SYSCALL(mkdir)
 5e0:	b8 14 00 00 00       	mov    $0x14,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <chdir>:
SYSCALL(chdir)
 5e8:	b8 09 00 00 00       	mov    $0x9,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <dup>:
SYSCALL(dup)
 5f0:	b8 0a 00 00 00       	mov    $0xa,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <getpid>:
SYSCALL(getpid)
 5f8:	b8 0b 00 00 00       	mov    $0xb,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <sbrk>:
SYSCALL(sbrk)
 600:	b8 0c 00 00 00       	mov    $0xc,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <sleep>:
SYSCALL(sleep)
 608:	b8 0d 00 00 00       	mov    $0xd,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <uptime>:
SYSCALL(uptime)
 610:	b8 0e 00 00 00       	mov    $0xe,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <halt>:
SYSCALL(halt)
 618:	b8 16 00 00 00       	mov    $0x16,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <getnp>:
SYSCALL(getnp)
 620:	b8 17 00 00 00       	mov    $0x17,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <sem_create>:
SYSCALL(sem_create)
 628:	b8 18 00 00 00       	mov    $0x18,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <sem_destroy>:
SYSCALL(sem_destroy)
 630:	b8 19 00 00 00       	mov    $0x19,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    

00000638 <sem_wait>:
SYSCALL(sem_wait)
 638:	b8 1a 00 00 00       	mov    $0x1a,%eax
 63d:	cd 40                	int    $0x40
 63f:	c3                   	ret    

00000640 <sem_signal>:
SYSCALL(sem_signal)
 640:	b8 1b 00 00 00       	mov    $0x1b,%eax
 645:	cd 40                	int    $0x40
 647:	c3                   	ret    

00000648 <clone>:
SYSCALL(clone)
 648:	b8 1c 00 00 00       	mov    $0x1c,%eax
 64d:	cd 40                	int    $0x40
 64f:	c3                   	ret    

00000650 <join>:
SYSCALL(join)
 650:	b8 1d 00 00 00       	mov    $0x1d,%eax
 655:	cd 40                	int    $0x40
 657:	c3                   	ret    

00000658 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 658:	55                   	push   %ebp
 659:	89 e5                	mov    %esp,%ebp
 65b:	83 ec 18             	sub    $0x18,%esp
 65e:	8b 45 0c             	mov    0xc(%ebp),%eax
 661:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 664:	83 ec 04             	sub    $0x4,%esp
 667:	6a 01                	push   $0x1
 669:	8d 45 f4             	lea    -0xc(%ebp),%eax
 66c:	50                   	push   %eax
 66d:	ff 75 08             	pushl  0x8(%ebp)
 670:	e8 23 ff ff ff       	call   598 <write>
 675:	83 c4 10             	add    $0x10,%esp
}
 678:	90                   	nop
 679:	c9                   	leave  
 67a:	c3                   	ret    

0000067b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 67b:	55                   	push   %ebp
 67c:	89 e5                	mov    %esp,%ebp
 67e:	53                   	push   %ebx
 67f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 682:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 689:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 68d:	74 17                	je     6a6 <printint+0x2b>
 68f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 693:	79 11                	jns    6a6 <printint+0x2b>
    neg = 1;
 695:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 69c:	8b 45 0c             	mov    0xc(%ebp),%eax
 69f:	f7 d8                	neg    %eax
 6a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6a4:	eb 06                	jmp    6ac <printint+0x31>
  } else {
    x = xx;
 6a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6b3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6b6:	8d 41 01             	lea    0x1(%ecx),%eax
 6b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6c2:	ba 00 00 00 00       	mov    $0x0,%edx
 6c7:	f7 f3                	div    %ebx
 6c9:	89 d0                	mov    %edx,%eax
 6cb:	0f b6 80 f0 0f 00 00 	movzbl 0xff0(%eax),%eax
 6d2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6dc:	ba 00 00 00 00       	mov    $0x0,%edx
 6e1:	f7 f3                	div    %ebx
 6e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6ea:	75 c7                	jne    6b3 <printint+0x38>
  if(neg)
 6ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6f0:	74 2d                	je     71f <printint+0xa4>
    buf[i++] = '-';
 6f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f5:	8d 50 01             	lea    0x1(%eax),%edx
 6f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6fb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 700:	eb 1d                	jmp    71f <printint+0xa4>
    putc(fd, buf[i]);
 702:	8d 55 dc             	lea    -0x24(%ebp),%edx
 705:	8b 45 f4             	mov    -0xc(%ebp),%eax
 708:	01 d0                	add    %edx,%eax
 70a:	0f b6 00             	movzbl (%eax),%eax
 70d:	0f be c0             	movsbl %al,%eax
 710:	83 ec 08             	sub    $0x8,%esp
 713:	50                   	push   %eax
 714:	ff 75 08             	pushl  0x8(%ebp)
 717:	e8 3c ff ff ff       	call   658 <putc>
 71c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 71f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 723:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 727:	79 d9                	jns    702 <printint+0x87>
    putc(fd, buf[i]);
}
 729:	90                   	nop
 72a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 72d:	c9                   	leave  
 72e:	c3                   	ret    

0000072f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 72f:	55                   	push   %ebp
 730:	89 e5                	mov    %esp,%ebp
 732:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 735:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 73c:	8d 45 0c             	lea    0xc(%ebp),%eax
 73f:	83 c0 04             	add    $0x4,%eax
 742:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 745:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 74c:	e9 59 01 00 00       	jmp    8aa <printf+0x17b>
    c = fmt[i] & 0xff;
 751:	8b 55 0c             	mov    0xc(%ebp),%edx
 754:	8b 45 f0             	mov    -0x10(%ebp),%eax
 757:	01 d0                	add    %edx,%eax
 759:	0f b6 00             	movzbl (%eax),%eax
 75c:	0f be c0             	movsbl %al,%eax
 75f:	25 ff 00 00 00       	and    $0xff,%eax
 764:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 767:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 76b:	75 2c                	jne    799 <printf+0x6a>
      if(c == '%'){
 76d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 771:	75 0c                	jne    77f <printf+0x50>
        state = '%';
 773:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 77a:	e9 27 01 00 00       	jmp    8a6 <printf+0x177>
      } else {
        putc(fd, c);
 77f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 782:	0f be c0             	movsbl %al,%eax
 785:	83 ec 08             	sub    $0x8,%esp
 788:	50                   	push   %eax
 789:	ff 75 08             	pushl  0x8(%ebp)
 78c:	e8 c7 fe ff ff       	call   658 <putc>
 791:	83 c4 10             	add    $0x10,%esp
 794:	e9 0d 01 00 00       	jmp    8a6 <printf+0x177>
      }
    } else if(state == '%'){
 799:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 79d:	0f 85 03 01 00 00    	jne    8a6 <printf+0x177>
      if(c == 'd'){
 7a3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7a7:	75 1e                	jne    7c7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 7a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ac:	8b 00                	mov    (%eax),%eax
 7ae:	6a 01                	push   $0x1
 7b0:	6a 0a                	push   $0xa
 7b2:	50                   	push   %eax
 7b3:	ff 75 08             	pushl  0x8(%ebp)
 7b6:	e8 c0 fe ff ff       	call   67b <printint>
 7bb:	83 c4 10             	add    $0x10,%esp
        ap++;
 7be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7c2:	e9 d8 00 00 00       	jmp    89f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7c7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7cb:	74 06                	je     7d3 <printf+0xa4>
 7cd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7d1:	75 1e                	jne    7f1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d6:	8b 00                	mov    (%eax),%eax
 7d8:	6a 00                	push   $0x0
 7da:	6a 10                	push   $0x10
 7dc:	50                   	push   %eax
 7dd:	ff 75 08             	pushl  0x8(%ebp)
 7e0:	e8 96 fe ff ff       	call   67b <printint>
 7e5:	83 c4 10             	add    $0x10,%esp
        ap++;
 7e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ec:	e9 ae 00 00 00       	jmp    89f <printf+0x170>
      } else if(c == 's'){
 7f1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7f5:	75 43                	jne    83a <printf+0x10b>
        s = (char*)*ap;
 7f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7fa:	8b 00                	mov    (%eax),%eax
 7fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 803:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 807:	75 25                	jne    82e <printf+0xff>
          s = "(null)";
 809:	c7 45 f4 3f 0d 00 00 	movl   $0xd3f,-0xc(%ebp)
        while(*s != 0){
 810:	eb 1c                	jmp    82e <printf+0xff>
          putc(fd, *s);
 812:	8b 45 f4             	mov    -0xc(%ebp),%eax
 815:	0f b6 00             	movzbl (%eax),%eax
 818:	0f be c0             	movsbl %al,%eax
 81b:	83 ec 08             	sub    $0x8,%esp
 81e:	50                   	push   %eax
 81f:	ff 75 08             	pushl  0x8(%ebp)
 822:	e8 31 fe ff ff       	call   658 <putc>
 827:	83 c4 10             	add    $0x10,%esp
          s++;
 82a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	0f b6 00             	movzbl (%eax),%eax
 834:	84 c0                	test   %al,%al
 836:	75 da                	jne    812 <printf+0xe3>
 838:	eb 65                	jmp    89f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 83a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 83e:	75 1d                	jne    85d <printf+0x12e>
        putc(fd, *ap);
 840:	8b 45 e8             	mov    -0x18(%ebp),%eax
 843:	8b 00                	mov    (%eax),%eax
 845:	0f be c0             	movsbl %al,%eax
 848:	83 ec 08             	sub    $0x8,%esp
 84b:	50                   	push   %eax
 84c:	ff 75 08             	pushl  0x8(%ebp)
 84f:	e8 04 fe ff ff       	call   658 <putc>
 854:	83 c4 10             	add    $0x10,%esp
        ap++;
 857:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 85b:	eb 42                	jmp    89f <printf+0x170>
      } else if(c == '%'){
 85d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 861:	75 17                	jne    87a <printf+0x14b>
        putc(fd, c);
 863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 866:	0f be c0             	movsbl %al,%eax
 869:	83 ec 08             	sub    $0x8,%esp
 86c:	50                   	push   %eax
 86d:	ff 75 08             	pushl  0x8(%ebp)
 870:	e8 e3 fd ff ff       	call   658 <putc>
 875:	83 c4 10             	add    $0x10,%esp
 878:	eb 25                	jmp    89f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 87a:	83 ec 08             	sub    $0x8,%esp
 87d:	6a 25                	push   $0x25
 87f:	ff 75 08             	pushl  0x8(%ebp)
 882:	e8 d1 fd ff ff       	call   658 <putc>
 887:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 88a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 88d:	0f be c0             	movsbl %al,%eax
 890:	83 ec 08             	sub    $0x8,%esp
 893:	50                   	push   %eax
 894:	ff 75 08             	pushl  0x8(%ebp)
 897:	e8 bc fd ff ff       	call   658 <putc>
 89c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 89f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8a6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8aa:	8b 55 0c             	mov    0xc(%ebp),%edx
 8ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b0:	01 d0                	add    %edx,%eax
 8b2:	0f b6 00             	movzbl (%eax),%eax
 8b5:	84 c0                	test   %al,%al
 8b7:	0f 85 94 fe ff ff    	jne    751 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8bd:	90                   	nop
 8be:	c9                   	leave  
 8bf:	c3                   	ret    

000008c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c0:	55                   	push   %ebp
 8c1:	89 e5                	mov    %esp,%ebp
 8c3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c6:	8b 45 08             	mov    0x8(%ebp),%eax
 8c9:	83 e8 08             	sub    $0x8,%eax
 8cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8cf:	a1 28 10 00 00       	mov    0x1028,%eax
 8d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8d7:	eb 24                	jmp    8fd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8dc:	8b 00                	mov    (%eax),%eax
 8de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8e1:	77 12                	ja     8f5 <free+0x35>
 8e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8e9:	77 24                	ja     90f <free+0x4f>
 8eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ee:	8b 00                	mov    (%eax),%eax
 8f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f3:	77 1a                	ja     90f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f8:	8b 00                	mov    (%eax),%eax
 8fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 900:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 903:	76 d4                	jbe    8d9 <free+0x19>
 905:	8b 45 fc             	mov    -0x4(%ebp),%eax
 908:	8b 00                	mov    (%eax),%eax
 90a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 90d:	76 ca                	jbe    8d9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 90f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 912:	8b 40 04             	mov    0x4(%eax),%eax
 915:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 91c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91f:	01 c2                	add    %eax,%edx
 921:	8b 45 fc             	mov    -0x4(%ebp),%eax
 924:	8b 00                	mov    (%eax),%eax
 926:	39 c2                	cmp    %eax,%edx
 928:	75 24                	jne    94e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 92a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92d:	8b 50 04             	mov    0x4(%eax),%edx
 930:	8b 45 fc             	mov    -0x4(%ebp),%eax
 933:	8b 00                	mov    (%eax),%eax
 935:	8b 40 04             	mov    0x4(%eax),%eax
 938:	01 c2                	add    %eax,%edx
 93a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 940:	8b 45 fc             	mov    -0x4(%ebp),%eax
 943:	8b 00                	mov    (%eax),%eax
 945:	8b 10                	mov    (%eax),%edx
 947:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94a:	89 10                	mov    %edx,(%eax)
 94c:	eb 0a                	jmp    958 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 94e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 951:	8b 10                	mov    (%eax),%edx
 953:	8b 45 f8             	mov    -0x8(%ebp),%eax
 956:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 958:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95b:	8b 40 04             	mov    0x4(%eax),%eax
 95e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 965:	8b 45 fc             	mov    -0x4(%ebp),%eax
 968:	01 d0                	add    %edx,%eax
 96a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 96d:	75 20                	jne    98f <free+0xcf>
    p->s.size += bp->s.size;
 96f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 972:	8b 50 04             	mov    0x4(%eax),%edx
 975:	8b 45 f8             	mov    -0x8(%ebp),%eax
 978:	8b 40 04             	mov    0x4(%eax),%eax
 97b:	01 c2                	add    %eax,%edx
 97d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 980:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 983:	8b 45 f8             	mov    -0x8(%ebp),%eax
 986:	8b 10                	mov    (%eax),%edx
 988:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98b:	89 10                	mov    %edx,(%eax)
 98d:	eb 08                	jmp    997 <free+0xd7>
  } else
    p->s.ptr = bp;
 98f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 992:	8b 55 f8             	mov    -0x8(%ebp),%edx
 995:	89 10                	mov    %edx,(%eax)
  freep = p;
 997:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99a:	a3 28 10 00 00       	mov    %eax,0x1028
}
 99f:	90                   	nop
 9a0:	c9                   	leave  
 9a1:	c3                   	ret    

000009a2 <morecore>:

static Header*
morecore(uint nu)
{
 9a2:	55                   	push   %ebp
 9a3:	89 e5                	mov    %esp,%ebp
 9a5:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9a8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9af:	77 07                	ja     9b8 <morecore+0x16>
    nu = 4096;
 9b1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9b8:	8b 45 08             	mov    0x8(%ebp),%eax
 9bb:	c1 e0 03             	shl    $0x3,%eax
 9be:	83 ec 0c             	sub    $0xc,%esp
 9c1:	50                   	push   %eax
 9c2:	e8 39 fc ff ff       	call   600 <sbrk>
 9c7:	83 c4 10             	add    $0x10,%esp
 9ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9cd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9d1:	75 07                	jne    9da <morecore+0x38>
    return 0;
 9d3:	b8 00 00 00 00       	mov    $0x0,%eax
 9d8:	eb 26                	jmp    a00 <morecore+0x5e>
  hp = (Header*)p;
 9da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e3:	8b 55 08             	mov    0x8(%ebp),%edx
 9e6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ec:	83 c0 08             	add    $0x8,%eax
 9ef:	83 ec 0c             	sub    $0xc,%esp
 9f2:	50                   	push   %eax
 9f3:	e8 c8 fe ff ff       	call   8c0 <free>
 9f8:	83 c4 10             	add    $0x10,%esp
  return freep;
 9fb:	a1 28 10 00 00       	mov    0x1028,%eax
}
 a00:	c9                   	leave  
 a01:	c3                   	ret    

00000a02 <malloc>:

void*
malloc(uint nbytes)
{
 a02:	55                   	push   %ebp
 a03:	89 e5                	mov    %esp,%ebp
 a05:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a08:	8b 45 08             	mov    0x8(%ebp),%eax
 a0b:	83 c0 07             	add    $0x7,%eax
 a0e:	c1 e8 03             	shr    $0x3,%eax
 a11:	83 c0 01             	add    $0x1,%eax
 a14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a17:	a1 28 10 00 00       	mov    0x1028,%eax
 a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a23:	75 23                	jne    a48 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a25:	c7 45 f0 20 10 00 00 	movl   $0x1020,-0x10(%ebp)
 a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2f:	a3 28 10 00 00       	mov    %eax,0x1028
 a34:	a1 28 10 00 00       	mov    0x1028,%eax
 a39:	a3 20 10 00 00       	mov    %eax,0x1020
    base.s.size = 0;
 a3e:	c7 05 24 10 00 00 00 	movl   $0x0,0x1024
 a45:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a4b:	8b 00                	mov    (%eax),%eax
 a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a53:	8b 40 04             	mov    0x4(%eax),%eax
 a56:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a59:	72 4d                	jb     aa8 <malloc+0xa6>
      if(p->s.size == nunits)
 a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5e:	8b 40 04             	mov    0x4(%eax),%eax
 a61:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a64:	75 0c                	jne    a72 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a69:	8b 10                	mov    (%eax),%edx
 a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a6e:	89 10                	mov    %edx,(%eax)
 a70:	eb 26                	jmp    a98 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a75:	8b 40 04             	mov    0x4(%eax),%eax
 a78:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a7b:	89 c2                	mov    %eax,%edx
 a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a80:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a86:	8b 40 04             	mov    0x4(%eax),%eax
 a89:	c1 e0 03             	shl    $0x3,%eax
 a8c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a92:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a95:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a9b:	a3 28 10 00 00       	mov    %eax,0x1028
      return (void*)(p + 1);
 aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa3:	83 c0 08             	add    $0x8,%eax
 aa6:	eb 3b                	jmp    ae3 <malloc+0xe1>
    }
    if(p == freep)
 aa8:	a1 28 10 00 00       	mov    0x1028,%eax
 aad:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ab0:	75 1e                	jne    ad0 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 ab2:	83 ec 0c             	sub    $0xc,%esp
 ab5:	ff 75 ec             	pushl  -0x14(%ebp)
 ab8:	e8 e5 fe ff ff       	call   9a2 <morecore>
 abd:	83 c4 10             	add    $0x10,%esp
 ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ac3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ac7:	75 07                	jne    ad0 <malloc+0xce>
        return 0;
 ac9:	b8 00 00 00 00       	mov    $0x0,%eax
 ace:	eb 13                	jmp    ae3 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad9:	8b 00                	mov    (%eax),%eax
 adb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ade:	e9 6d ff ff ff       	jmp    a50 <malloc+0x4e>
}
 ae3:	c9                   	leave  
 ae4:	c3                   	ret    

00000ae5 <hufs_thread_create>:

int thread_num = 0;


int hufs_thread_create(void *func(), void *args)
{
 ae5:	55                   	push   %ebp
 ae6:	89 e5                	mov    %esp,%ebp
 ae8:	83 ec 18             	sub    $0x18,%esp
	void *stack; 
	int pid;

	stack = malloc(4096);
 aeb:	83 ec 0c             	sub    $0xc,%esp
 aee:	68 00 10 00 00       	push   $0x1000
 af3:	e8 0a ff ff ff       	call   a02 <malloc>
 af8:	83 c4 10             	add    $0x10,%esp
 afb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (stack==0) return -1;
 afe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b02:	75 07                	jne    b0b <hufs_thread_create+0x26>
 b04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 b09:	eb 42                	jmp    b4d <hufs_thread_create+0x68>

	pid = clone(func, args, stack); 
 b0b:	83 ec 04             	sub    $0x4,%esp
 b0e:	ff 75 f4             	pushl  -0xc(%ebp)
 b11:	ff 75 0c             	pushl  0xc(%ebp)
 b14:	ff 75 08             	pushl  0x8(%ebp)
 b17:	e8 2c fb ff ff       	call   648 <clone>
 b1c:	83 c4 10             	add    $0x10,%esp
 b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (pid==-1) {
 b22:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 b26:	75 15                	jne    b3d <hufs_thread_create+0x58>
		free(stack);
 b28:	83 ec 0c             	sub    $0xc,%esp
 b2b:	ff 75 f4             	pushl  -0xc(%ebp)
 b2e:	e8 8d fd ff ff       	call   8c0 <free>
 b33:	83 c4 10             	add    $0x10,%esp
		return -1;
 b36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 b3b:	eb 10                	jmp    b4d <hufs_thread_create+0x68>
	}

	thread_info[pid].stack = stack; 
 b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b43:	89 14 85 40 10 00 00 	mov    %edx,0x1040(,%eax,4)

	return pid; 
 b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 b4d:	c9                   	leave  
 b4e:	c3                   	ret    

00000b4f <hufs_thread_join>:

int hufs_thread_join(int pid)
{
 b4f:	55                   	push   %ebp
 b50:	89 e5                	mov    %esp,%ebp
 b52:	83 ec 18             	sub    $0x18,%esp
	void *stack = thread_info[pid].stack;
 b55:	8b 45 08             	mov    0x8(%ebp),%eax
 b58:	8b 04 85 40 10 00 00 	mov    0x1040(,%eax,4),%eax
 b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (stack==0) return -1;
 b62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b66:	75 07                	jne    b6f <hufs_thread_join+0x20>
 b68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 b6d:	eb 28                	jmp    b97 <hufs_thread_join+0x48>

	join(&thread_info[pid].stack);	
 b6f:	8b 45 08             	mov    0x8(%ebp),%eax
 b72:	c1 e0 02             	shl    $0x2,%eax
 b75:	05 40 10 00 00       	add    $0x1040,%eax
 b7a:	83 ec 0c             	sub    $0xc,%esp
 b7d:	50                   	push   %eax
 b7e:	e8 cd fa ff ff       	call   650 <join>
 b83:	83 c4 10             	add    $0x10,%esp
	free(stack);
 b86:	83 ec 0c             	sub    $0xc,%esp
 b89:	ff 75 f4             	pushl  -0xc(%ebp)
 b8c:	e8 2f fd ff ff       	call   8c0 <free>
 b91:	83 c4 10             	add    $0x10,%esp

	return pid;
 b94:	8b 45 08             	mov    0x8(%ebp),%eax
}
 b97:	c9                   	leave  
 b98:	c3                   	ret    
