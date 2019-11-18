
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp
8010002d:	b8 d6 37 10 80       	mov    $0x801037d6,%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 9c 90 10 80       	push   $0x8010909c
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 b5 53 00 00       	call   80105401 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 15 11 80 84 	movl   $0x80111584,0x80111590
80100056:	15 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 15 11 80 84 	movl   $0x80111584,0x80111594
80100060:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 15 11 80       	mov    0x80111594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 15 11 80       	mov    %eax,0x80111594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 15 11 80       	mov    $0x80111584,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 80 d6 10 80       	push   $0x8010d680
801000c1:	e8 5d 53 00 00       	call   80105423 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 94 15 11 80       	mov    0x80111594,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->sector == sector){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 80 d6 10 80       	push   $0x8010d680
8010010c:	e8 79 53 00 00       	call   8010548a <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 d6 10 80       	push   $0x8010d680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 53 4b 00 00       	call   80104c7f <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 90 15 11 80       	mov    0x80111590,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 80 d6 10 80       	push   $0x8010d680
80100188:	e8 fd 52 00 00       	call   8010548a <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 a3 90 10 80       	push   $0x801090a3
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, sector);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 85 26 00 00       	call   8010286c <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 b4 90 10 80       	push   $0x801090b4
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 44 26 00 00       	call   8010286c <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 bb 90 10 80       	push   $0x801090bb
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 d6 10 80       	push   $0x8010d680
80100255:	e8 c9 51 00 00       	call   80105423 <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 94 15 11 80       	mov    0x80111594,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 15 11 80       	mov    %eax,0x80111594

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 af 4a 00 00       	call   80104d6d <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 d6 10 80       	push   $0x8010d680
801002c9:	e8 bc 51 00 00       	call   8010548a <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 c3 03 00 00       	call   80100776 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 c5 10 80       	push   $0x8010c5e0
801003e2:	e8 3c 50 00 00       	call   80105423 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 c2 90 10 80       	push   $0x801090c2
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 55 03 00 00       	call   80100776 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec cb 90 10 80 	movl   $0x801090cb,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 8e 02 00 00       	call   80100776 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 71 02 00 00       	call   80100776 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 62 02 00 00       	call   80100776 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 54 02 00 00       	call   80100776 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 e0 c5 10 80       	push   $0x8010c5e0
8010055b:	e8 2a 4f 00 00       	call   8010548a <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 d2 90 10 80       	push   $0x801090d2
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 e1 90 10 80       	push   $0x801090e1
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 15 4f 00 00       	call   801054dc <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 e3 90 10 80       	push   $0x801090e3
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)
  
  if((pos/80) >= 24){  // Scroll up.
801006b8:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006bf:	7e 4c                	jle    8010070d <cgaputc+0x10c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006c1:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006c6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006cc:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006d1:	83 ec 04             	sub    $0x4,%esp
801006d4:	68 60 0e 00 00       	push   $0xe60
801006d9:	52                   	push   %edx
801006da:	50                   	push   %eax
801006db:	e8 65 50 00 00       	call   80105745 <memmove>
801006e0:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006e3:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006e7:	b8 80 07 00 00       	mov    $0x780,%eax
801006ec:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006ef:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006f2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006f7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006fa:	01 c9                	add    %ecx,%ecx
801006fc:	01 c8                	add    %ecx,%eax
801006fe:	83 ec 04             	sub    $0x4,%esp
80100701:	52                   	push   %edx
80100702:	6a 00                	push   $0x0
80100704:	50                   	push   %eax
80100705:	e8 7c 4f 00 00       	call   80105686 <memset>
8010070a:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
8010070d:	83 ec 08             	sub    $0x8,%esp
80100710:	6a 0e                	push   $0xe
80100712:	68 d4 03 00 00       	push   $0x3d4
80100717:	e8 d5 fb ff ff       	call   801002f1 <outb>
8010071c:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010071f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100722:	c1 f8 08             	sar    $0x8,%eax
80100725:	0f b6 c0             	movzbl %al,%eax
80100728:	83 ec 08             	sub    $0x8,%esp
8010072b:	50                   	push   %eax
8010072c:	68 d5 03 00 00       	push   $0x3d5
80100731:	e8 bb fb ff ff       	call   801002f1 <outb>
80100736:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100739:	83 ec 08             	sub    $0x8,%esp
8010073c:	6a 0f                	push   $0xf
8010073e:	68 d4 03 00 00       	push   $0x3d4
80100743:	e8 a9 fb ff ff       	call   801002f1 <outb>
80100748:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010074b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010074e:	0f b6 c0             	movzbl %al,%eax
80100751:	83 ec 08             	sub    $0x8,%esp
80100754:	50                   	push   %eax
80100755:	68 d5 03 00 00       	push   $0x3d5
8010075a:	e8 92 fb ff ff       	call   801002f1 <outb>
8010075f:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100762:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100767:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010076a:	01 d2                	add    %edx,%edx
8010076c:	01 d0                	add    %edx,%eax
8010076e:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100773:	90                   	nop
80100774:	c9                   	leave  
80100775:	c3                   	ret    

80100776 <consputc>:

void
consputc(int c)
{
80100776:	55                   	push   %ebp
80100777:	89 e5                	mov    %esp,%ebp
80100779:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
8010077c:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
80100781:	85 c0                	test   %eax,%eax
80100783:	74 07                	je     8010078c <consputc+0x16>
    cli();
80100785:	e8 86 fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
8010078a:	eb fe                	jmp    8010078a <consputc+0x14>
  }

  if(c == BACKSPACE){
8010078c:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100793:	75 29                	jne    801007be <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100795:	83 ec 0c             	sub    $0xc,%esp
80100798:	6a 08                	push   $0x8
8010079a:	e8 0b 6a 00 00       	call   801071aa <uartputc>
8010079f:	83 c4 10             	add    $0x10,%esp
801007a2:	83 ec 0c             	sub    $0xc,%esp
801007a5:	6a 20                	push   $0x20
801007a7:	e8 fe 69 00 00       	call   801071aa <uartputc>
801007ac:	83 c4 10             	add    $0x10,%esp
801007af:	83 ec 0c             	sub    $0xc,%esp
801007b2:	6a 08                	push   $0x8
801007b4:	e8 f1 69 00 00       	call   801071aa <uartputc>
801007b9:	83 c4 10             	add    $0x10,%esp
801007bc:	eb 0e                	jmp    801007cc <consputc+0x56>
  } else
    uartputc(c);
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	ff 75 08             	pushl  0x8(%ebp)
801007c4:	e8 e1 69 00 00       	call   801071aa <uartputc>
801007c9:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007cc:	83 ec 0c             	sub    $0xc,%esp
801007cf:	ff 75 08             	pushl  0x8(%ebp)
801007d2:	e8 2a fe ff ff       	call   80100601 <cgaputc>
801007d7:	83 c4 10             	add    $0x10,%esp
}
801007da:	90                   	nop
801007db:	c9                   	leave  
801007dc:	c3                   	ret    

801007dd <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007dd:	55                   	push   %ebp
801007de:	89 e5                	mov    %esp,%ebp
801007e0:	83 ec 18             	sub    $0x18,%esp
  int c;

  acquire(&input.lock);
801007e3:	83 ec 0c             	sub    $0xc,%esp
801007e6:	68 a0 17 11 80       	push   $0x801117a0
801007eb:	e8 33 4c 00 00       	call   80105423 <acquire>
801007f0:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801007f3:	e9 42 01 00 00       	jmp    8010093a <consoleintr+0x15d>
    switch(c){
801007f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007fb:	83 f8 10             	cmp    $0x10,%eax
801007fe:	74 1e                	je     8010081e <consoleintr+0x41>
80100800:	83 f8 10             	cmp    $0x10,%eax
80100803:	7f 0a                	jg     8010080f <consoleintr+0x32>
80100805:	83 f8 08             	cmp    $0x8,%eax
80100808:	74 69                	je     80100873 <consoleintr+0x96>
8010080a:	e9 99 00 00 00       	jmp    801008a8 <consoleintr+0xcb>
8010080f:	83 f8 15             	cmp    $0x15,%eax
80100812:	74 31                	je     80100845 <consoleintr+0x68>
80100814:	83 f8 7f             	cmp    $0x7f,%eax
80100817:	74 5a                	je     80100873 <consoleintr+0x96>
80100819:	e9 8a 00 00 00       	jmp    801008a8 <consoleintr+0xcb>
    case C('P'):  // Process listing.
      procdump();
8010081e:	e8 08 46 00 00       	call   80104e2b <procdump>
      break;
80100823:	e9 12 01 00 00       	jmp    8010093a <consoleintr+0x15d>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100828:	a1 5c 18 11 80       	mov    0x8011185c,%eax
8010082d:	83 e8 01             	sub    $0x1,%eax
80100830:	a3 5c 18 11 80       	mov    %eax,0x8011185c
        consputc(BACKSPACE);
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 00 01 00 00       	push   $0x100
8010083d:	e8 34 ff ff ff       	call   80100776 <consputc>
80100842:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100845:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
8010084b:	a1 58 18 11 80       	mov    0x80111858,%eax
80100850:	39 c2                	cmp    %eax,%edx
80100852:	0f 84 e2 00 00 00    	je     8010093a <consoleintr+0x15d>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100858:	a1 5c 18 11 80       	mov    0x8011185c,%eax
8010085d:	83 e8 01             	sub    $0x1,%eax
80100860:	83 e0 7f             	and    $0x7f,%eax
80100863:	0f b6 80 d4 17 11 80 	movzbl -0x7feee82c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010086a:	3c 0a                	cmp    $0xa,%al
8010086c:	75 ba                	jne    80100828 <consoleintr+0x4b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010086e:	e9 c7 00 00 00       	jmp    8010093a <consoleintr+0x15d>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100873:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
80100879:	a1 58 18 11 80       	mov    0x80111858,%eax
8010087e:	39 c2                	cmp    %eax,%edx
80100880:	0f 84 b4 00 00 00    	je     8010093a <consoleintr+0x15d>
        input.e--;
80100886:	a1 5c 18 11 80       	mov    0x8011185c,%eax
8010088b:	83 e8 01             	sub    $0x1,%eax
8010088e:	a3 5c 18 11 80       	mov    %eax,0x8011185c
        consputc(BACKSPACE);
80100893:	83 ec 0c             	sub    $0xc,%esp
80100896:	68 00 01 00 00       	push   $0x100
8010089b:	e8 d6 fe ff ff       	call   80100776 <consputc>
801008a0:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008a3:	e9 92 00 00 00       	jmp    8010093a <consoleintr+0x15d>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801008ac:	0f 84 87 00 00 00    	je     80100939 <consoleintr+0x15c>
801008b2:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
801008b8:	a1 54 18 11 80       	mov    0x80111854,%eax
801008bd:	29 c2                	sub    %eax,%edx
801008bf:	89 d0                	mov    %edx,%eax
801008c1:	83 f8 7f             	cmp    $0x7f,%eax
801008c4:	77 73                	ja     80100939 <consoleintr+0x15c>
        c = (c == '\r') ? '\n' : c;
801008c6:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801008ca:	74 05                	je     801008d1 <consoleintr+0xf4>
801008cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008cf:	eb 05                	jmp    801008d6 <consoleintr+0xf9>
801008d1:	b8 0a 00 00 00       	mov    $0xa,%eax
801008d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008d9:	a1 5c 18 11 80       	mov    0x8011185c,%eax
801008de:	8d 50 01             	lea    0x1(%eax),%edx
801008e1:	89 15 5c 18 11 80    	mov    %edx,0x8011185c
801008e7:	83 e0 7f             	and    $0x7f,%eax
801008ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008ed:	88 90 d4 17 11 80    	mov    %dl,-0x7feee82c(%eax)
        consputc(c);
801008f3:	83 ec 0c             	sub    $0xc,%esp
801008f6:	ff 75 f4             	pushl  -0xc(%ebp)
801008f9:	e8 78 fe ff ff       	call   80100776 <consputc>
801008fe:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100901:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
80100905:	74 18                	je     8010091f <consoleintr+0x142>
80100907:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
8010090b:	74 12                	je     8010091f <consoleintr+0x142>
8010090d:	a1 5c 18 11 80       	mov    0x8011185c,%eax
80100912:	8b 15 54 18 11 80    	mov    0x80111854,%edx
80100918:	83 ea 80             	sub    $0xffffff80,%edx
8010091b:	39 d0                	cmp    %edx,%eax
8010091d:	75 1a                	jne    80100939 <consoleintr+0x15c>
          input.w = input.e;
8010091f:	a1 5c 18 11 80       	mov    0x8011185c,%eax
80100924:	a3 58 18 11 80       	mov    %eax,0x80111858
          wakeup(&input.r);
80100929:	83 ec 0c             	sub    $0xc,%esp
8010092c:	68 54 18 11 80       	push   $0x80111854
80100931:	e8 37 44 00 00       	call   80104d6d <wakeup>
80100936:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100939:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
8010093a:	8b 45 08             	mov    0x8(%ebp),%eax
8010093d:	ff d0                	call   *%eax
8010093f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100942:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100946:	0f 89 ac fe ff ff    	jns    801007f8 <consoleintr+0x1b>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010094c:	83 ec 0c             	sub    $0xc,%esp
8010094f:	68 a0 17 11 80       	push   $0x801117a0
80100954:	e8 31 4b 00 00       	call   8010548a <release>
80100959:	83 c4 10             	add    $0x10,%esp
}
8010095c:	90                   	nop
8010095d:	c9                   	leave  
8010095e:	c3                   	ret    

8010095f <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010095f:	55                   	push   %ebp
80100960:	89 e5                	mov    %esp,%ebp
80100962:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100965:	83 ec 0c             	sub    $0xc,%esp
80100968:	ff 75 08             	pushl  0x8(%ebp)
8010096b:	e8 f3 10 00 00       	call   80101a63 <iunlock>
80100970:	83 c4 10             	add    $0x10,%esp
  target = n;
80100973:	8b 45 10             	mov    0x10(%ebp),%eax
80100976:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100979:	83 ec 0c             	sub    $0xc,%esp
8010097c:	68 a0 17 11 80       	push   $0x801117a0
80100981:	e8 9d 4a 00 00       	call   80105423 <acquire>
80100986:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100989:	e9 ac 00 00 00       	jmp    80100a3a <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
8010098e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100994:	8b 40 24             	mov    0x24(%eax),%eax
80100997:	85 c0                	test   %eax,%eax
80100999:	74 28                	je     801009c3 <consoleread+0x64>
        release(&input.lock);
8010099b:	83 ec 0c             	sub    $0xc,%esp
8010099e:	68 a0 17 11 80       	push   $0x801117a0
801009a3:	e8 e2 4a 00 00       	call   8010548a <release>
801009a8:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009ab:	83 ec 0c             	sub    $0xc,%esp
801009ae:	ff 75 08             	pushl  0x8(%ebp)
801009b1:	e8 55 0f 00 00       	call   8010190b <ilock>
801009b6:	83 c4 10             	add    $0x10,%esp
        return -1;
801009b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009be:	e9 ab 00 00 00       	jmp    80100a6e <consoleread+0x10f>
      }
      sleep(&input.r, &input.lock);
801009c3:	83 ec 08             	sub    $0x8,%esp
801009c6:	68 a0 17 11 80       	push   $0x801117a0
801009cb:	68 54 18 11 80       	push   $0x80111854
801009d0:	e8 aa 42 00 00       	call   80104c7f <sleep>
801009d5:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
801009d8:	8b 15 54 18 11 80    	mov    0x80111854,%edx
801009de:	a1 58 18 11 80       	mov    0x80111858,%eax
801009e3:	39 c2                	cmp    %eax,%edx
801009e5:	74 a7                	je     8010098e <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009e7:	a1 54 18 11 80       	mov    0x80111854,%eax
801009ec:	8d 50 01             	lea    0x1(%eax),%edx
801009ef:	89 15 54 18 11 80    	mov    %edx,0x80111854
801009f5:	83 e0 7f             	and    $0x7f,%eax
801009f8:	0f b6 80 d4 17 11 80 	movzbl -0x7feee82c(%eax),%eax
801009ff:	0f be c0             	movsbl %al,%eax
80100a02:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a05:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a09:	75 17                	jne    80100a22 <consoleread+0xc3>
      if(n < target){
80100a0b:	8b 45 10             	mov    0x10(%ebp),%eax
80100a0e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a11:	73 2f                	jae    80100a42 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a13:	a1 54 18 11 80       	mov    0x80111854,%eax
80100a18:	83 e8 01             	sub    $0x1,%eax
80100a1b:	a3 54 18 11 80       	mov    %eax,0x80111854
      }
      break;
80100a20:	eb 20                	jmp    80100a42 <consoleread+0xe3>
    }
    *dst++ = c;
80100a22:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a25:	8d 50 01             	lea    0x1(%eax),%edx
80100a28:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a2e:	88 10                	mov    %dl,(%eax)
    --n;
80100a30:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a34:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a38:	74 0b                	je     80100a45 <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
80100a3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a3e:	7f 98                	jg     801009d8 <consoleread+0x79>
80100a40:	eb 04                	jmp    80100a46 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a42:	90                   	nop
80100a43:	eb 01                	jmp    80100a46 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a45:	90                   	nop
  }
  release(&input.lock);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	68 a0 17 11 80       	push   $0x801117a0
80100a4e:	e8 37 4a 00 00       	call   8010548a <release>
80100a53:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a56:	83 ec 0c             	sub    $0xc,%esp
80100a59:	ff 75 08             	pushl  0x8(%ebp)
80100a5c:	e8 aa 0e 00 00       	call   8010190b <ilock>
80100a61:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a64:	8b 45 10             	mov    0x10(%ebp),%eax
80100a67:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a6a:	29 c2                	sub    %eax,%edx
80100a6c:	89 d0                	mov    %edx,%eax
}
80100a6e:	c9                   	leave  
80100a6f:	c3                   	ret    

80100a70 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a70:	55                   	push   %ebp
80100a71:	89 e5                	mov    %esp,%ebp
80100a73:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a76:	83 ec 0c             	sub    $0xc,%esp
80100a79:	ff 75 08             	pushl  0x8(%ebp)
80100a7c:	e8 e2 0f 00 00       	call   80101a63 <iunlock>
80100a81:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100a84:	83 ec 0c             	sub    $0xc,%esp
80100a87:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a8c:	e8 92 49 00 00       	call   80105423 <acquire>
80100a91:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100a94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a9b:	eb 21                	jmp    80100abe <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100a9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100aa3:	01 d0                	add    %edx,%eax
80100aa5:	0f b6 00             	movzbl (%eax),%eax
80100aa8:	0f be c0             	movsbl %al,%eax
80100aab:	0f b6 c0             	movzbl %al,%eax
80100aae:	83 ec 0c             	sub    $0xc,%esp
80100ab1:	50                   	push   %eax
80100ab2:	e8 bf fc ff ff       	call   80100776 <consputc>
80100ab7:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100aba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ac1:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ac4:	7c d7                	jl     80100a9d <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100ac6:	83 ec 0c             	sub    $0xc,%esp
80100ac9:	68 e0 c5 10 80       	push   $0x8010c5e0
80100ace:	e8 b7 49 00 00       	call   8010548a <release>
80100ad3:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ad6:	83 ec 0c             	sub    $0xc,%esp
80100ad9:	ff 75 08             	pushl  0x8(%ebp)
80100adc:	e8 2a 0e 00 00       	call   8010190b <ilock>
80100ae1:	83 c4 10             	add    $0x10,%esp

  return n;
80100ae4:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ae7:	c9                   	leave  
80100ae8:	c3                   	ret    

80100ae9 <consoleinit>:

void
consoleinit(void)
{
80100ae9:	55                   	push   %ebp
80100aea:	89 e5                	mov    %esp,%ebp
80100aec:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100aef:	83 ec 08             	sub    $0x8,%esp
80100af2:	68 e7 90 10 80       	push   $0x801090e7
80100af7:	68 e0 c5 10 80       	push   $0x8010c5e0
80100afc:	e8 00 49 00 00       	call   80105401 <initlock>
80100b01:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100b04:	83 ec 08             	sub    $0x8,%esp
80100b07:	68 ef 90 10 80       	push   $0x801090ef
80100b0c:	68 a0 17 11 80       	push   $0x801117a0
80100b11:	e8 eb 48 00 00       	call   80105401 <initlock>
80100b16:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b19:	c7 05 0c 22 11 80 70 	movl   $0x80100a70,0x8011220c
80100b20:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b23:	c7 05 08 22 11 80 5f 	movl   $0x8010095f,0x80112208
80100b2a:	09 10 80 
  cons.locking = 1;
80100b2d:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100b34:	00 00 00 

  picenable(IRQ_KBD);
80100b37:	83 ec 0c             	sub    $0xc,%esp
80100b3a:	6a 01                	push   $0x1
80100b3c:	e8 3b 33 00 00       	call   80103e7c <picenable>
80100b41:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b44:	83 ec 08             	sub    $0x8,%esp
80100b47:	6a 00                	push   $0x0
80100b49:	6a 01                	push   $0x1
80100b4b:	e8 e9 1e 00 00       	call   80102a39 <ioapicenable>
80100b50:	83 c4 10             	add    $0x10,%esp
}
80100b53:	90                   	nop
80100b54:	c9                   	leave  
80100b55:	c3                   	ret    

80100b56 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b56:	55                   	push   %ebp
80100b57:	89 e5                	mov    %esp,%ebp
80100b59:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b5f:	e8 50 29 00 00       	call   801034b4 <begin_op>
  if((ip = namei(path)) == 0){
80100b64:	83 ec 0c             	sub    $0xc,%esp
80100b67:	ff 75 08             	pushl  0x8(%ebp)
80100b6a:	e8 54 19 00 00       	call   801024c3 <namei>
80100b6f:	83 c4 10             	add    $0x10,%esp
80100b72:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b75:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b79:	75 0f                	jne    80100b8a <exec+0x34>
    end_op();
80100b7b:	e8 c0 29 00 00       	call   80103540 <end_op>
    return -1;
80100b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b85:	e9 ce 03 00 00       	jmp    80100f58 <exec+0x402>
  }
  ilock(ip);
80100b8a:	83 ec 0c             	sub    $0xc,%esp
80100b8d:	ff 75 d8             	pushl  -0x28(%ebp)
80100b90:	e8 76 0d 00 00       	call   8010190b <ilock>
80100b95:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100b98:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b9f:	6a 34                	push   $0x34
80100ba1:	6a 00                	push   $0x0
80100ba3:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100ba9:	50                   	push   %eax
80100baa:	ff 75 d8             	pushl  -0x28(%ebp)
80100bad:	e8 c1 12 00 00       	call   80101e73 <readi>
80100bb2:	83 c4 10             	add    $0x10,%esp
80100bb5:	83 f8 33             	cmp    $0x33,%eax
80100bb8:	0f 86 49 03 00 00    	jbe    80100f07 <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100bbe:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bc4:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100bc9:	0f 85 3b 03 00 00    	jne    80100f0a <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100bcf:	e8 2b 77 00 00       	call   801082ff <setupkvm>
80100bd4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bd7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bdb:	0f 84 2c 03 00 00    	je     80100f0d <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100be1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bef:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bf5:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100bf8:	e9 ab 00 00 00       	jmp    80100ca8 <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c00:	6a 20                	push   $0x20
80100c02:	50                   	push   %eax
80100c03:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c09:	50                   	push   %eax
80100c0a:	ff 75 d8             	pushl  -0x28(%ebp)
80100c0d:	e8 61 12 00 00       	call   80101e73 <readi>
80100c12:	83 c4 10             	add    $0x10,%esp
80100c15:	83 f8 20             	cmp    $0x20,%eax
80100c18:	0f 85 f2 02 00 00    	jne    80100f10 <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c1e:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c24:	83 f8 01             	cmp    $0x1,%eax
80100c27:	75 71                	jne    80100c9a <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100c29:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c2f:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c35:	39 c2                	cmp    %eax,%edx
80100c37:	0f 82 d6 02 00 00    	jb     80100f13 <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c3d:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c43:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c49:	01 d0                	add    %edx,%eax
80100c4b:	83 ec 04             	sub    $0x4,%esp
80100c4e:	50                   	push   %eax
80100c4f:	ff 75 e0             	pushl  -0x20(%ebp)
80100c52:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c55:	e8 4c 7a 00 00       	call   801086a6 <allocuvm>
80100c5a:	83 c4 10             	add    $0x10,%esp
80100c5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c64:	0f 84 ac 02 00 00    	je     80100f16 <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c6a:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c70:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c7c:	83 ec 0c             	sub    $0xc,%esp
80100c7f:	52                   	push   %edx
80100c80:	50                   	push   %eax
80100c81:	ff 75 d8             	pushl  -0x28(%ebp)
80100c84:	51                   	push   %ecx
80100c85:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c88:	e8 42 79 00 00       	call   801085cf <loaduvm>
80100c8d:	83 c4 20             	add    $0x20,%esp
80100c90:	85 c0                	test   %eax,%eax
80100c92:	0f 88 81 02 00 00    	js     80100f19 <exec+0x3c3>
80100c98:	eb 01                	jmp    80100c9b <exec+0x145>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c9a:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c9b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ca2:	83 c0 20             	add    $0x20,%eax
80100ca5:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ca8:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100caf:	0f b7 c0             	movzwl %ax,%eax
80100cb2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cb5:	0f 8f 42 ff ff ff    	jg     80100bfd <exec+0xa7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cbb:	83 ec 0c             	sub    $0xc,%esp
80100cbe:	ff 75 d8             	pushl  -0x28(%ebp)
80100cc1:	e8 ff 0e 00 00       	call   80101bc5 <iunlockput>
80100cc6:	83 c4 10             	add    $0x10,%esp
  end_op();
80100cc9:	e8 72 28 00 00       	call   80103540 <end_op>
  ip = 0;
80100cce:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd8:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cdd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ce2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce8:	05 00 20 00 00       	add    $0x2000,%eax
80100ced:	83 ec 04             	sub    $0x4,%esp
80100cf0:	50                   	push   %eax
80100cf1:	ff 75 e0             	pushl  -0x20(%ebp)
80100cf4:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cf7:	e8 aa 79 00 00       	call   801086a6 <allocuvm>
80100cfc:	83 c4 10             	add    $0x10,%esp
80100cff:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d06:	0f 84 10 02 00 00    	je     80100f1c <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0f:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d14:	83 ec 08             	sub    $0x8,%esp
80100d17:	50                   	push   %eax
80100d18:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d1b:	e8 ac 7b 00 00       	call   801088cc <clearpteu>
80100d20:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d23:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d26:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d29:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d30:	e9 96 00 00 00       	jmp    80100dcb <exec+0x275>
    if(argc >= MAXARG)
80100d35:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d39:	0f 87 e0 01 00 00    	ja     80100f1f <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d42:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d4c:	01 d0                	add    %edx,%eax
80100d4e:	8b 00                	mov    (%eax),%eax
80100d50:	83 ec 0c             	sub    $0xc,%esp
80100d53:	50                   	push   %eax
80100d54:	e8 7a 4b 00 00       	call   801058d3 <strlen>
80100d59:	83 c4 10             	add    $0x10,%esp
80100d5c:	89 c2                	mov    %eax,%edx
80100d5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d61:	29 d0                	sub    %edx,%eax
80100d63:	83 e8 01             	sub    $0x1,%eax
80100d66:	83 e0 fc             	and    $0xfffffffc,%eax
80100d69:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d6f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d76:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d79:	01 d0                	add    %edx,%eax
80100d7b:	8b 00                	mov    (%eax),%eax
80100d7d:	83 ec 0c             	sub    $0xc,%esp
80100d80:	50                   	push   %eax
80100d81:	e8 4d 4b 00 00       	call   801058d3 <strlen>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	83 c0 01             	add    $0x1,%eax
80100d8c:	89 c1                	mov    %eax,%ecx
80100d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d91:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d98:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d9b:	01 d0                	add    %edx,%eax
80100d9d:	8b 00                	mov    (%eax),%eax
80100d9f:	51                   	push   %ecx
80100da0:	50                   	push   %eax
80100da1:	ff 75 dc             	pushl  -0x24(%ebp)
80100da4:	ff 75 d4             	pushl  -0x2c(%ebp)
80100da7:	e8 d7 7c 00 00       	call   80108a83 <copyout>
80100dac:	83 c4 10             	add    $0x10,%esp
80100daf:	85 c0                	test   %eax,%eax
80100db1:	0f 88 6b 01 00 00    	js     80100f22 <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dba:	8d 50 03             	lea    0x3(%eax),%edx
80100dbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dc0:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dc7:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dd8:	01 d0                	add    %edx,%eax
80100dda:	8b 00                	mov    (%eax),%eax
80100ddc:	85 c0                	test   %eax,%eax
80100dde:	0f 85 51 ff ff ff    	jne    80100d35 <exec+0x1df>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100de4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de7:	83 c0 03             	add    $0x3,%eax
80100dea:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100df1:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100df5:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dfc:	ff ff ff 
  ustack[1] = argc;
80100dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e02:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0b:	83 c0 01             	add    $0x1,%eax
80100e0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e15:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e18:	29 d0                	sub    %edx,%eax
80100e1a:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e23:	83 c0 04             	add    $0x4,%eax
80100e26:	c1 e0 02             	shl    $0x2,%eax
80100e29:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e2f:	83 c0 04             	add    $0x4,%eax
80100e32:	c1 e0 02             	shl    $0x2,%eax
80100e35:	50                   	push   %eax
80100e36:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e3c:	50                   	push   %eax
80100e3d:	ff 75 dc             	pushl  -0x24(%ebp)
80100e40:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e43:	e8 3b 7c 00 00       	call   80108a83 <copyout>
80100e48:	83 c4 10             	add    $0x10,%esp
80100e4b:	85 c0                	test   %eax,%eax
80100e4d:	0f 88 d2 00 00 00    	js     80100f25 <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e53:	8b 45 08             	mov    0x8(%ebp),%eax
80100e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e5f:	eb 17                	jmp    80100e78 <exec+0x322>
    if(*s == '/')
80100e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e64:	0f b6 00             	movzbl (%eax),%eax
80100e67:	3c 2f                	cmp    $0x2f,%al
80100e69:	75 09                	jne    80100e74 <exec+0x31e>
      last = s+1;
80100e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e6e:	83 c0 01             	add    $0x1,%eax
80100e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e74:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e7b:	0f b6 00             	movzbl (%eax),%eax
80100e7e:	84 c0                	test   %al,%al
80100e80:	75 df                	jne    80100e61 <exec+0x30b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e88:	83 c0 6c             	add    $0x6c,%eax
80100e8b:	83 ec 04             	sub    $0x4,%esp
80100e8e:	6a 10                	push   $0x10
80100e90:	ff 75 f0             	pushl  -0x10(%ebp)
80100e93:	50                   	push   %eax
80100e94:	e8 f0 49 00 00       	call   80105889 <safestrcpy>
80100e99:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea2:	8b 40 04             	mov    0x4(%eax),%eax
80100ea5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ea8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100eb1:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100eb4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eba:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ebd:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ebf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec5:	8b 40 18             	mov    0x18(%eax),%eax
80100ec8:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ece:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ed1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed7:	8b 40 18             	mov    0x18(%eax),%eax
80100eda:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100edd:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ee0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee6:	83 ec 0c             	sub    $0xc,%esp
80100ee9:	50                   	push   %eax
80100eea:	e8 f7 74 00 00       	call   801083e6 <switchuvm>
80100eef:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100ef2:	83 ec 0c             	sub    $0xc,%esp
80100ef5:	ff 75 d0             	pushl  -0x30(%ebp)
80100ef8:	e8 2f 79 00 00       	call   8010882c <freevm>
80100efd:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f00:	b8 00 00 00 00       	mov    $0x0,%eax
80100f05:	eb 51                	jmp    80100f58 <exec+0x402>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100f07:	90                   	nop
80100f08:	eb 1c                	jmp    80100f26 <exec+0x3d0>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100f0a:	90                   	nop
80100f0b:	eb 19                	jmp    80100f26 <exec+0x3d0>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100f0d:	90                   	nop
80100f0e:	eb 16                	jmp    80100f26 <exec+0x3d0>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100f10:	90                   	nop
80100f11:	eb 13                	jmp    80100f26 <exec+0x3d0>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100f13:	90                   	nop
80100f14:	eb 10                	jmp    80100f26 <exec+0x3d0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100f16:	90                   	nop
80100f17:	eb 0d                	jmp    80100f26 <exec+0x3d0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100f19:	90                   	nop
80100f1a:	eb 0a                	jmp    80100f26 <exec+0x3d0>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100f1c:	90                   	nop
80100f1d:	eb 07                	jmp    80100f26 <exec+0x3d0>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100f1f:	90                   	nop
80100f20:	eb 04                	jmp    80100f26 <exec+0x3d0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100f22:	90                   	nop
80100f23:	eb 01                	jmp    80100f26 <exec+0x3d0>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100f25:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100f26:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f2a:	74 0e                	je     80100f3a <exec+0x3e4>
    freevm(pgdir);
80100f2c:	83 ec 0c             	sub    $0xc,%esp
80100f2f:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f32:	e8 f5 78 00 00       	call   8010882c <freevm>
80100f37:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f3a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f3e:	74 13                	je     80100f53 <exec+0x3fd>
    iunlockput(ip);
80100f40:	83 ec 0c             	sub    $0xc,%esp
80100f43:	ff 75 d8             	pushl  -0x28(%ebp)
80100f46:	e8 7a 0c 00 00       	call   80101bc5 <iunlockput>
80100f4b:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f4e:	e8 ed 25 00 00       	call   80103540 <end_op>
  }
  return -1;
80100f53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f58:	c9                   	leave  
80100f59:	c3                   	ret    

80100f5a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f5a:	55                   	push   %ebp
80100f5b:	89 e5                	mov    %esp,%ebp
80100f5d:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f60:	83 ec 08             	sub    $0x8,%esp
80100f63:	68 f5 90 10 80       	push   $0x801090f5
80100f68:	68 60 18 11 80       	push   $0x80111860
80100f6d:	e8 8f 44 00 00       	call   80105401 <initlock>
80100f72:	83 c4 10             	add    $0x10,%esp
}
80100f75:	90                   	nop
80100f76:	c9                   	leave  
80100f77:	c3                   	ret    

80100f78 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f78:	55                   	push   %ebp
80100f79:	89 e5                	mov    %esp,%ebp
80100f7b:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f7e:	83 ec 0c             	sub    $0xc,%esp
80100f81:	68 60 18 11 80       	push   $0x80111860
80100f86:	e8 98 44 00 00       	call   80105423 <acquire>
80100f8b:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f8e:	c7 45 f4 94 18 11 80 	movl   $0x80111894,-0xc(%ebp)
80100f95:	eb 2d                	jmp    80100fc4 <filealloc+0x4c>
    if(f->ref == 0){
80100f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f9a:	8b 40 04             	mov    0x4(%eax),%eax
80100f9d:	85 c0                	test   %eax,%eax
80100f9f:	75 1f                	jne    80100fc0 <filealloc+0x48>
      f->ref = 1;
80100fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa4:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fab:	83 ec 0c             	sub    $0xc,%esp
80100fae:	68 60 18 11 80       	push   $0x80111860
80100fb3:	e8 d2 44 00 00       	call   8010548a <release>
80100fb8:	83 c4 10             	add    $0x10,%esp
      return f;
80100fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fbe:	eb 23                	jmp    80100fe3 <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fc0:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fc4:	b8 f4 21 11 80       	mov    $0x801121f4,%eax
80100fc9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100fcc:	72 c9                	jb     80100f97 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fce:	83 ec 0c             	sub    $0xc,%esp
80100fd1:	68 60 18 11 80       	push   $0x80111860
80100fd6:	e8 af 44 00 00       	call   8010548a <release>
80100fdb:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fde:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fe3:	c9                   	leave  
80100fe4:	c3                   	ret    

80100fe5 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fe5:	55                   	push   %ebp
80100fe6:	89 e5                	mov    %esp,%ebp
80100fe8:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80100feb:	83 ec 0c             	sub    $0xc,%esp
80100fee:	68 60 18 11 80       	push   $0x80111860
80100ff3:	e8 2b 44 00 00       	call   80105423 <acquire>
80100ff8:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffe:	8b 40 04             	mov    0x4(%eax),%eax
80101001:	85 c0                	test   %eax,%eax
80101003:	7f 0d                	jg     80101012 <filedup+0x2d>
    panic("filedup");
80101005:	83 ec 0c             	sub    $0xc,%esp
80101008:	68 fc 90 10 80       	push   $0x801090fc
8010100d:	e8 54 f5 ff ff       	call   80100566 <panic>
  f->ref++;
80101012:	8b 45 08             	mov    0x8(%ebp),%eax
80101015:	8b 40 04             	mov    0x4(%eax),%eax
80101018:	8d 50 01             	lea    0x1(%eax),%edx
8010101b:	8b 45 08             	mov    0x8(%ebp),%eax
8010101e:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101021:	83 ec 0c             	sub    $0xc,%esp
80101024:	68 60 18 11 80       	push   $0x80111860
80101029:	e8 5c 44 00 00       	call   8010548a <release>
8010102e:	83 c4 10             	add    $0x10,%esp
  return f;
80101031:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101034:	c9                   	leave  
80101035:	c3                   	ret    

80101036 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101036:	55                   	push   %ebp
80101037:	89 e5                	mov    %esp,%ebp
80101039:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	68 60 18 11 80       	push   $0x80111860
80101044:	e8 da 43 00 00       	call   80105423 <acquire>
80101049:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010104c:	8b 45 08             	mov    0x8(%ebp),%eax
8010104f:	8b 40 04             	mov    0x4(%eax),%eax
80101052:	85 c0                	test   %eax,%eax
80101054:	7f 0d                	jg     80101063 <fileclose+0x2d>
    panic("fileclose");
80101056:	83 ec 0c             	sub    $0xc,%esp
80101059:	68 04 91 10 80       	push   $0x80109104
8010105e:	e8 03 f5 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
80101063:	8b 45 08             	mov    0x8(%ebp),%eax
80101066:	8b 40 04             	mov    0x4(%eax),%eax
80101069:	8d 50 ff             	lea    -0x1(%eax),%edx
8010106c:	8b 45 08             	mov    0x8(%ebp),%eax
8010106f:	89 50 04             	mov    %edx,0x4(%eax)
80101072:	8b 45 08             	mov    0x8(%ebp),%eax
80101075:	8b 40 04             	mov    0x4(%eax),%eax
80101078:	85 c0                	test   %eax,%eax
8010107a:	7e 15                	jle    80101091 <fileclose+0x5b>
    release(&ftable.lock);
8010107c:	83 ec 0c             	sub    $0xc,%esp
8010107f:	68 60 18 11 80       	push   $0x80111860
80101084:	e8 01 44 00 00       	call   8010548a <release>
80101089:	83 c4 10             	add    $0x10,%esp
8010108c:	e9 8b 00 00 00       	jmp    8010111c <fileclose+0xe6>
    return;
  }
  ff = *f;
80101091:	8b 45 08             	mov    0x8(%ebp),%eax
80101094:	8b 10                	mov    (%eax),%edx
80101096:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101099:	8b 50 04             	mov    0x4(%eax),%edx
8010109c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010109f:	8b 50 08             	mov    0x8(%eax),%edx
801010a2:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010a5:	8b 50 0c             	mov    0xc(%eax),%edx
801010a8:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010ab:	8b 50 10             	mov    0x10(%eax),%edx
801010ae:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010b1:	8b 40 14             	mov    0x14(%eax),%eax
801010b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010b7:	8b 45 08             	mov    0x8(%ebp),%eax
801010ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010c1:	8b 45 08             	mov    0x8(%ebp),%eax
801010c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010ca:	83 ec 0c             	sub    $0xc,%esp
801010cd:	68 60 18 11 80       	push   $0x80111860
801010d2:	e8 b3 43 00 00       	call   8010548a <release>
801010d7:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801010da:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010dd:	83 f8 01             	cmp    $0x1,%eax
801010e0:	75 19                	jne    801010fb <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801010e2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010e6:	0f be d0             	movsbl %al,%edx
801010e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010ec:	83 ec 08             	sub    $0x8,%esp
801010ef:	52                   	push   %edx
801010f0:	50                   	push   %eax
801010f1:	e8 ef 2f 00 00       	call   801040e5 <pipeclose>
801010f6:	83 c4 10             	add    $0x10,%esp
801010f9:	eb 21                	jmp    8010111c <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801010fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010fe:	83 f8 02             	cmp    $0x2,%eax
80101101:	75 19                	jne    8010111c <fileclose+0xe6>
    begin_op();
80101103:	e8 ac 23 00 00       	call   801034b4 <begin_op>
    iput(ff.ip);
80101108:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010110b:	83 ec 0c             	sub    $0xc,%esp
8010110e:	50                   	push   %eax
8010110f:	e8 c1 09 00 00       	call   80101ad5 <iput>
80101114:	83 c4 10             	add    $0x10,%esp
    end_op();
80101117:	e8 24 24 00 00       	call   80103540 <end_op>
  }
}
8010111c:	c9                   	leave  
8010111d:	c3                   	ret    

8010111e <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010111e:	55                   	push   %ebp
8010111f:	89 e5                	mov    %esp,%ebp
80101121:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101124:	8b 45 08             	mov    0x8(%ebp),%eax
80101127:	8b 00                	mov    (%eax),%eax
80101129:	83 f8 02             	cmp    $0x2,%eax
8010112c:	75 40                	jne    8010116e <filestat+0x50>
    ilock(f->ip);
8010112e:	8b 45 08             	mov    0x8(%ebp),%eax
80101131:	8b 40 10             	mov    0x10(%eax),%eax
80101134:	83 ec 0c             	sub    $0xc,%esp
80101137:	50                   	push   %eax
80101138:	e8 ce 07 00 00       	call   8010190b <ilock>
8010113d:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101140:	8b 45 08             	mov    0x8(%ebp),%eax
80101143:	8b 40 10             	mov    0x10(%eax),%eax
80101146:	83 ec 08             	sub    $0x8,%esp
80101149:	ff 75 0c             	pushl  0xc(%ebp)
8010114c:	50                   	push   %eax
8010114d:	e8 db 0c 00 00       	call   80101e2d <stati>
80101152:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101155:	8b 45 08             	mov    0x8(%ebp),%eax
80101158:	8b 40 10             	mov    0x10(%eax),%eax
8010115b:	83 ec 0c             	sub    $0xc,%esp
8010115e:	50                   	push   %eax
8010115f:	e8 ff 08 00 00       	call   80101a63 <iunlock>
80101164:	83 c4 10             	add    $0x10,%esp
    return 0;
80101167:	b8 00 00 00 00       	mov    $0x0,%eax
8010116c:	eb 05                	jmp    80101173 <filestat+0x55>
  }
  return -1;
8010116e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101173:	c9                   	leave  
80101174:	c3                   	ret    

80101175 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101175:	55                   	push   %ebp
80101176:	89 e5                	mov    %esp,%ebp
80101178:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
8010117b:	8b 45 08             	mov    0x8(%ebp),%eax
8010117e:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101182:	84 c0                	test   %al,%al
80101184:	75 0a                	jne    80101190 <fileread+0x1b>
    return -1;
80101186:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010118b:	e9 9b 00 00 00       	jmp    8010122b <fileread+0xb6>
  if(f->type == FD_PIPE)
80101190:	8b 45 08             	mov    0x8(%ebp),%eax
80101193:	8b 00                	mov    (%eax),%eax
80101195:	83 f8 01             	cmp    $0x1,%eax
80101198:	75 1a                	jne    801011b4 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
8010119a:	8b 45 08             	mov    0x8(%ebp),%eax
8010119d:	8b 40 0c             	mov    0xc(%eax),%eax
801011a0:	83 ec 04             	sub    $0x4,%esp
801011a3:	ff 75 10             	pushl  0x10(%ebp)
801011a6:	ff 75 0c             	pushl  0xc(%ebp)
801011a9:	50                   	push   %eax
801011aa:	e8 de 30 00 00       	call   8010428d <piperead>
801011af:	83 c4 10             	add    $0x10,%esp
801011b2:	eb 77                	jmp    8010122b <fileread+0xb6>
  if(f->type == FD_INODE){
801011b4:	8b 45 08             	mov    0x8(%ebp),%eax
801011b7:	8b 00                	mov    (%eax),%eax
801011b9:	83 f8 02             	cmp    $0x2,%eax
801011bc:	75 60                	jne    8010121e <fileread+0xa9>
    ilock(f->ip);
801011be:	8b 45 08             	mov    0x8(%ebp),%eax
801011c1:	8b 40 10             	mov    0x10(%eax),%eax
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	50                   	push   %eax
801011c8:	e8 3e 07 00 00       	call   8010190b <ilock>
801011cd:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011d3:	8b 45 08             	mov    0x8(%ebp),%eax
801011d6:	8b 50 14             	mov    0x14(%eax),%edx
801011d9:	8b 45 08             	mov    0x8(%ebp),%eax
801011dc:	8b 40 10             	mov    0x10(%eax),%eax
801011df:	51                   	push   %ecx
801011e0:	52                   	push   %edx
801011e1:	ff 75 0c             	pushl  0xc(%ebp)
801011e4:	50                   	push   %eax
801011e5:	e8 89 0c 00 00       	call   80101e73 <readi>
801011ea:	83 c4 10             	add    $0x10,%esp
801011ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011f4:	7e 11                	jle    80101207 <fileread+0x92>
      f->off += r;
801011f6:	8b 45 08             	mov    0x8(%ebp),%eax
801011f9:	8b 50 14             	mov    0x14(%eax),%edx
801011fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011ff:	01 c2                	add    %eax,%edx
80101201:	8b 45 08             	mov    0x8(%ebp),%eax
80101204:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101207:	8b 45 08             	mov    0x8(%ebp),%eax
8010120a:	8b 40 10             	mov    0x10(%eax),%eax
8010120d:	83 ec 0c             	sub    $0xc,%esp
80101210:	50                   	push   %eax
80101211:	e8 4d 08 00 00       	call   80101a63 <iunlock>
80101216:	83 c4 10             	add    $0x10,%esp
    return r;
80101219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010121c:	eb 0d                	jmp    8010122b <fileread+0xb6>
  }
  panic("fileread");
8010121e:	83 ec 0c             	sub    $0xc,%esp
80101221:	68 0e 91 10 80       	push   $0x8010910e
80101226:	e8 3b f3 ff ff       	call   80100566 <panic>
}
8010122b:	c9                   	leave  
8010122c:	c3                   	ret    

8010122d <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010122d:	55                   	push   %ebp
8010122e:	89 e5                	mov    %esp,%ebp
80101230:	53                   	push   %ebx
80101231:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101234:	8b 45 08             	mov    0x8(%ebp),%eax
80101237:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010123b:	84 c0                	test   %al,%al
8010123d:	75 0a                	jne    80101249 <filewrite+0x1c>
    return -1;
8010123f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101244:	e9 1b 01 00 00       	jmp    80101364 <filewrite+0x137>
  if(f->type == FD_PIPE)
80101249:	8b 45 08             	mov    0x8(%ebp),%eax
8010124c:	8b 00                	mov    (%eax),%eax
8010124e:	83 f8 01             	cmp    $0x1,%eax
80101251:	75 1d                	jne    80101270 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
80101253:	8b 45 08             	mov    0x8(%ebp),%eax
80101256:	8b 40 0c             	mov    0xc(%eax),%eax
80101259:	83 ec 04             	sub    $0x4,%esp
8010125c:	ff 75 10             	pushl  0x10(%ebp)
8010125f:	ff 75 0c             	pushl  0xc(%ebp)
80101262:	50                   	push   %eax
80101263:	e8 27 2f 00 00       	call   8010418f <pipewrite>
80101268:	83 c4 10             	add    $0x10,%esp
8010126b:	e9 f4 00 00 00       	jmp    80101364 <filewrite+0x137>
  if(f->type == FD_INODE){
80101270:	8b 45 08             	mov    0x8(%ebp),%eax
80101273:	8b 00                	mov    (%eax),%eax
80101275:	83 f8 02             	cmp    $0x2,%eax
80101278:	0f 85 d9 00 00 00    	jne    80101357 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010127e:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101285:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010128c:	e9 a3 00 00 00       	jmp    80101334 <filewrite+0x107>
      int n1 = n - i;
80101291:	8b 45 10             	mov    0x10(%ebp),%eax
80101294:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101297:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010129a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010129d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012a0:	7e 06                	jle    801012a8 <filewrite+0x7b>
        n1 = max;
801012a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012a5:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012a8:	e8 07 22 00 00       	call   801034b4 <begin_op>
      ilock(f->ip);
801012ad:	8b 45 08             	mov    0x8(%ebp),%eax
801012b0:	8b 40 10             	mov    0x10(%eax),%eax
801012b3:	83 ec 0c             	sub    $0xc,%esp
801012b6:	50                   	push   %eax
801012b7:	e8 4f 06 00 00       	call   8010190b <ilock>
801012bc:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012bf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012c2:	8b 45 08             	mov    0x8(%ebp),%eax
801012c5:	8b 50 14             	mov    0x14(%eax),%edx
801012c8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801012ce:	01 c3                	add    %eax,%ebx
801012d0:	8b 45 08             	mov    0x8(%ebp),%eax
801012d3:	8b 40 10             	mov    0x10(%eax),%eax
801012d6:	51                   	push   %ecx
801012d7:	52                   	push   %edx
801012d8:	53                   	push   %ebx
801012d9:	50                   	push   %eax
801012da:	e8 eb 0c 00 00       	call   80101fca <writei>
801012df:	83 c4 10             	add    $0x10,%esp
801012e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012e9:	7e 11                	jle    801012fc <filewrite+0xcf>
        f->off += r;
801012eb:	8b 45 08             	mov    0x8(%ebp),%eax
801012ee:	8b 50 14             	mov    0x14(%eax),%edx
801012f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012f4:	01 c2                	add    %eax,%edx
801012f6:	8b 45 08             	mov    0x8(%ebp),%eax
801012f9:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012fc:	8b 45 08             	mov    0x8(%ebp),%eax
801012ff:	8b 40 10             	mov    0x10(%eax),%eax
80101302:	83 ec 0c             	sub    $0xc,%esp
80101305:	50                   	push   %eax
80101306:	e8 58 07 00 00       	call   80101a63 <iunlock>
8010130b:	83 c4 10             	add    $0x10,%esp
      end_op();
8010130e:	e8 2d 22 00 00       	call   80103540 <end_op>

      if(r < 0)
80101313:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101317:	78 29                	js     80101342 <filewrite+0x115>
        break;
      if(r != n1)
80101319:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010131c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010131f:	74 0d                	je     8010132e <filewrite+0x101>
        panic("short filewrite");
80101321:	83 ec 0c             	sub    $0xc,%esp
80101324:	68 17 91 10 80       	push   $0x80109117
80101329:	e8 38 f2 ff ff       	call   80100566 <panic>
      i += r;
8010132e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101331:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101337:	3b 45 10             	cmp    0x10(%ebp),%eax
8010133a:	0f 8c 51 ff ff ff    	jl     80101291 <filewrite+0x64>
80101340:	eb 01                	jmp    80101343 <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
80101342:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101343:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101346:	3b 45 10             	cmp    0x10(%ebp),%eax
80101349:	75 05                	jne    80101350 <filewrite+0x123>
8010134b:	8b 45 10             	mov    0x10(%ebp),%eax
8010134e:	eb 14                	jmp    80101364 <filewrite+0x137>
80101350:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101355:	eb 0d                	jmp    80101364 <filewrite+0x137>
  }
  panic("filewrite");
80101357:	83 ec 0c             	sub    $0xc,%esp
8010135a:	68 27 91 10 80       	push   $0x80109127
8010135f:	e8 02 f2 ff ff       	call   80100566 <panic>
}
80101364:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101367:	c9                   	leave  
80101368:	c3                   	ret    

80101369 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101369:	55                   	push   %ebp
8010136a:	89 e5                	mov    %esp,%ebp
8010136c:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010136f:	8b 45 08             	mov    0x8(%ebp),%eax
80101372:	83 ec 08             	sub    $0x8,%esp
80101375:	6a 01                	push   $0x1
80101377:	50                   	push   %eax
80101378:	e8 39 ee ff ff       	call   801001b6 <bread>
8010137d:	83 c4 10             	add    $0x10,%esp
80101380:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101383:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101386:	83 c0 18             	add    $0x18,%eax
80101389:	83 ec 04             	sub    $0x4,%esp
8010138c:	6a 10                	push   $0x10
8010138e:	50                   	push   %eax
8010138f:	ff 75 0c             	pushl  0xc(%ebp)
80101392:	e8 ae 43 00 00       	call   80105745 <memmove>
80101397:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010139a:	83 ec 0c             	sub    $0xc,%esp
8010139d:	ff 75 f4             	pushl  -0xc(%ebp)
801013a0:	e8 89 ee ff ff       	call   8010022e <brelse>
801013a5:	83 c4 10             	add    $0x10,%esp
}
801013a8:	90                   	nop
801013a9:	c9                   	leave  
801013aa:	c3                   	ret    

801013ab <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013ab:	55                   	push   %ebp
801013ac:	89 e5                	mov    %esp,%ebp
801013ae:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801013b1:	8b 55 0c             	mov    0xc(%ebp),%edx
801013b4:	8b 45 08             	mov    0x8(%ebp),%eax
801013b7:	83 ec 08             	sub    $0x8,%esp
801013ba:	52                   	push   %edx
801013bb:	50                   	push   %eax
801013bc:	e8 f5 ed ff ff       	call   801001b6 <bread>
801013c1:	83 c4 10             	add    $0x10,%esp
801013c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ca:	83 c0 18             	add    $0x18,%eax
801013cd:	83 ec 04             	sub    $0x4,%esp
801013d0:	68 00 02 00 00       	push   $0x200
801013d5:	6a 00                	push   $0x0
801013d7:	50                   	push   %eax
801013d8:	e8 a9 42 00 00       	call   80105686 <memset>
801013dd:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801013e0:	83 ec 0c             	sub    $0xc,%esp
801013e3:	ff 75 f4             	pushl  -0xc(%ebp)
801013e6:	e8 01 23 00 00       	call   801036ec <log_write>
801013eb:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013ee:	83 ec 0c             	sub    $0xc,%esp
801013f1:	ff 75 f4             	pushl  -0xc(%ebp)
801013f4:	e8 35 ee ff ff       	call   8010022e <brelse>
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	90                   	nop
801013fd:	c9                   	leave  
801013fe:	c3                   	ret    

801013ff <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013ff:	55                   	push   %ebp
80101400:	89 e5                	mov    %esp,%ebp
80101402:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
80101405:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
8010140c:	8b 45 08             	mov    0x8(%ebp),%eax
8010140f:	83 ec 08             	sub    $0x8,%esp
80101412:	8d 55 d8             	lea    -0x28(%ebp),%edx
80101415:	52                   	push   %edx
80101416:	50                   	push   %eax
80101417:	e8 4d ff ff ff       	call   80101369 <readsb>
8010141c:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
8010141f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101426:	e9 15 01 00 00       	jmp    80101540 <balloc+0x141>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
8010142b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010142e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101434:	85 c0                	test   %eax,%eax
80101436:	0f 48 c2             	cmovs  %edx,%eax
80101439:	c1 f8 0c             	sar    $0xc,%eax
8010143c:	89 c2                	mov    %eax,%edx
8010143e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101441:	c1 e8 03             	shr    $0x3,%eax
80101444:	01 d0                	add    %edx,%eax
80101446:	83 c0 03             	add    $0x3,%eax
80101449:	83 ec 08             	sub    $0x8,%esp
8010144c:	50                   	push   %eax
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 61 ed ff ff       	call   801001b6 <bread>
80101455:	83 c4 10             	add    $0x10,%esp
80101458:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010145b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101462:	e9 a6 00 00 00       	jmp    8010150d <balloc+0x10e>
      m = 1 << (bi % 8);
80101467:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146a:	99                   	cltd   
8010146b:	c1 ea 1d             	shr    $0x1d,%edx
8010146e:	01 d0                	add    %edx,%eax
80101470:	83 e0 07             	and    $0x7,%eax
80101473:	29 d0                	sub    %edx,%eax
80101475:	ba 01 00 00 00       	mov    $0x1,%edx
8010147a:	89 c1                	mov    %eax,%ecx
8010147c:	d3 e2                	shl    %cl,%edx
8010147e:	89 d0                	mov    %edx,%eax
80101480:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101483:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101486:	8d 50 07             	lea    0x7(%eax),%edx
80101489:	85 c0                	test   %eax,%eax
8010148b:	0f 48 c2             	cmovs  %edx,%eax
8010148e:	c1 f8 03             	sar    $0x3,%eax
80101491:	89 c2                	mov    %eax,%edx
80101493:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101496:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010149b:	0f b6 c0             	movzbl %al,%eax
8010149e:	23 45 e8             	and    -0x18(%ebp),%eax
801014a1:	85 c0                	test   %eax,%eax
801014a3:	75 64                	jne    80101509 <balloc+0x10a>
        bp->data[bi/8] |= m;  // Mark block in use.
801014a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014a8:	8d 50 07             	lea    0x7(%eax),%edx
801014ab:	85 c0                	test   %eax,%eax
801014ad:	0f 48 c2             	cmovs  %edx,%eax
801014b0:	c1 f8 03             	sar    $0x3,%eax
801014b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014b6:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801014bb:	89 d1                	mov    %edx,%ecx
801014bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014c0:	09 ca                	or     %ecx,%edx
801014c2:	89 d1                	mov    %edx,%ecx
801014c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014c7:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014cb:	83 ec 0c             	sub    $0xc,%esp
801014ce:	ff 75 ec             	pushl  -0x14(%ebp)
801014d1:	e8 16 22 00 00       	call   801036ec <log_write>
801014d6:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801014d9:	83 ec 0c             	sub    $0xc,%esp
801014dc:	ff 75 ec             	pushl  -0x14(%ebp)
801014df:	e8 4a ed ff ff       	call   8010022e <brelse>
801014e4:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ed:	01 c2                	add    %eax,%edx
801014ef:	8b 45 08             	mov    0x8(%ebp),%eax
801014f2:	83 ec 08             	sub    $0x8,%esp
801014f5:	52                   	push   %edx
801014f6:	50                   	push   %eax
801014f7:	e8 af fe ff ff       	call   801013ab <bzero>
801014fc:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801014ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101502:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101505:	01 d0                	add    %edx,%eax
80101507:	eb 52                	jmp    8010155b <balloc+0x15c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101509:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010150d:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101514:	7f 15                	jg     8010152b <balloc+0x12c>
80101516:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101519:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010151c:	01 d0                	add    %edx,%eax
8010151e:	89 c2                	mov    %eax,%edx
80101520:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101523:	39 c2                	cmp    %eax,%edx
80101525:	0f 82 3c ff ff ff    	jb     80101467 <balloc+0x68>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010152b:	83 ec 0c             	sub    $0xc,%esp
8010152e:	ff 75 ec             	pushl  -0x14(%ebp)
80101531:	e8 f8 ec ff ff       	call   8010022e <brelse>
80101536:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
80101539:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101540:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101546:	39 c2                	cmp    %eax,%edx
80101548:	0f 87 dd fe ff ff    	ja     8010142b <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010154e:	83 ec 0c             	sub    $0xc,%esp
80101551:	68 31 91 10 80       	push   $0x80109131
80101556:	e8 0b f0 ff ff       	call   80100566 <panic>
}
8010155b:	c9                   	leave  
8010155c:	c3                   	ret    

8010155d <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010155d:	55                   	push   %ebp
8010155e:	89 e5                	mov    %esp,%ebp
80101560:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101563:	83 ec 08             	sub    $0x8,%esp
80101566:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101569:	50                   	push   %eax
8010156a:	ff 75 08             	pushl  0x8(%ebp)
8010156d:	e8 f7 fd ff ff       	call   80101369 <readsb>
80101572:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101575:	8b 45 0c             	mov    0xc(%ebp),%eax
80101578:	c1 e8 0c             	shr    $0xc,%eax
8010157b:	89 c2                	mov    %eax,%edx
8010157d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101580:	c1 e8 03             	shr    $0x3,%eax
80101583:	01 d0                	add    %edx,%eax
80101585:	8d 50 03             	lea    0x3(%eax),%edx
80101588:	8b 45 08             	mov    0x8(%ebp),%eax
8010158b:	83 ec 08             	sub    $0x8,%esp
8010158e:	52                   	push   %edx
8010158f:	50                   	push   %eax
80101590:	e8 21 ec ff ff       	call   801001b6 <bread>
80101595:	83 c4 10             	add    $0x10,%esp
80101598:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010159b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010159e:	25 ff 0f 00 00       	and    $0xfff,%eax
801015a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015a9:	99                   	cltd   
801015aa:	c1 ea 1d             	shr    $0x1d,%edx
801015ad:	01 d0                	add    %edx,%eax
801015af:	83 e0 07             	and    $0x7,%eax
801015b2:	29 d0                	sub    %edx,%eax
801015b4:	ba 01 00 00 00       	mov    $0x1,%edx
801015b9:	89 c1                	mov    %eax,%ecx
801015bb:	d3 e2                	shl    %cl,%edx
801015bd:	89 d0                	mov    %edx,%eax
801015bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015c5:	8d 50 07             	lea    0x7(%eax),%edx
801015c8:	85 c0                	test   %eax,%eax
801015ca:	0f 48 c2             	cmovs  %edx,%eax
801015cd:	c1 f8 03             	sar    $0x3,%eax
801015d0:	89 c2                	mov    %eax,%edx
801015d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015d5:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015da:	0f b6 c0             	movzbl %al,%eax
801015dd:	23 45 ec             	and    -0x14(%ebp),%eax
801015e0:	85 c0                	test   %eax,%eax
801015e2:	75 0d                	jne    801015f1 <bfree+0x94>
    panic("freeing free block");
801015e4:	83 ec 0c             	sub    $0xc,%esp
801015e7:	68 47 91 10 80       	push   $0x80109147
801015ec:	e8 75 ef ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
801015f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015f4:	8d 50 07             	lea    0x7(%eax),%edx
801015f7:	85 c0                	test   %eax,%eax
801015f9:	0f 48 c2             	cmovs  %edx,%eax
801015fc:	c1 f8 03             	sar    $0x3,%eax
801015ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101602:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101607:	89 d1                	mov    %edx,%ecx
80101609:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010160c:	f7 d2                	not    %edx
8010160e:	21 ca                	and    %ecx,%edx
80101610:	89 d1                	mov    %edx,%ecx
80101612:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101615:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101619:	83 ec 0c             	sub    $0xc,%esp
8010161c:	ff 75 f4             	pushl  -0xc(%ebp)
8010161f:	e8 c8 20 00 00       	call   801036ec <log_write>
80101624:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101627:	83 ec 0c             	sub    $0xc,%esp
8010162a:	ff 75 f4             	pushl  -0xc(%ebp)
8010162d:	e8 fc eb ff ff       	call   8010022e <brelse>
80101632:	83 c4 10             	add    $0x10,%esp
}
80101635:	90                   	nop
80101636:	c9                   	leave  
80101637:	c3                   	ret    

80101638 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
80101638:	55                   	push   %ebp
80101639:	89 e5                	mov    %esp,%ebp
8010163b:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache");
8010163e:	83 ec 08             	sub    $0x8,%esp
80101641:	68 5a 91 10 80       	push   $0x8010915a
80101646:	68 60 22 11 80       	push   $0x80112260
8010164b:	e8 b1 3d 00 00       	call   80105401 <initlock>
80101650:	83 c4 10             	add    $0x10,%esp
}
80101653:	90                   	nop
80101654:	c9                   	leave  
80101655:	c3                   	ret    

80101656 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101656:	55                   	push   %ebp
80101657:	89 e5                	mov    %esp,%ebp
80101659:	83 ec 38             	sub    $0x38,%esp
8010165c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010165f:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101663:	8b 45 08             	mov    0x8(%ebp),%eax
80101666:	83 ec 08             	sub    $0x8,%esp
80101669:	8d 55 dc             	lea    -0x24(%ebp),%edx
8010166c:	52                   	push   %edx
8010166d:	50                   	push   %eax
8010166e:	e8 f6 fc ff ff       	call   80101369 <readsb>
80101673:	83 c4 10             	add    $0x10,%esp

  for(inum = 1; inum < sb.ninodes; inum++){
80101676:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010167d:	e9 98 00 00 00       	jmp    8010171a <ialloc+0xc4>
    bp = bread(dev, IBLOCK(inum));
80101682:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101685:	c1 e8 03             	shr    $0x3,%eax
80101688:	83 c0 02             	add    $0x2,%eax
8010168b:	83 ec 08             	sub    $0x8,%esp
8010168e:	50                   	push   %eax
8010168f:	ff 75 08             	pushl  0x8(%ebp)
80101692:	e8 1f eb ff ff       	call   801001b6 <bread>
80101697:	83 c4 10             	add    $0x10,%esp
8010169a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010169d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016a0:	8d 50 18             	lea    0x18(%eax),%edx
801016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016a6:	83 e0 07             	and    $0x7,%eax
801016a9:	c1 e0 06             	shl    $0x6,%eax
801016ac:	01 d0                	add    %edx,%eax
801016ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801016b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016b4:	0f b7 00             	movzwl (%eax),%eax
801016b7:	66 85 c0             	test   %ax,%ax
801016ba:	75 4c                	jne    80101708 <ialloc+0xb2>
      memset(dip, 0, sizeof(*dip));
801016bc:	83 ec 04             	sub    $0x4,%esp
801016bf:	6a 40                	push   $0x40
801016c1:	6a 00                	push   $0x0
801016c3:	ff 75 ec             	pushl  -0x14(%ebp)
801016c6:	e8 bb 3f 00 00       	call   80105686 <memset>
801016cb:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801016ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016d1:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
801016d5:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801016d8:	83 ec 0c             	sub    $0xc,%esp
801016db:	ff 75 f0             	pushl  -0x10(%ebp)
801016de:	e8 09 20 00 00       	call   801036ec <log_write>
801016e3:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801016e6:	83 ec 0c             	sub    $0xc,%esp
801016e9:	ff 75 f0             	pushl  -0x10(%ebp)
801016ec:	e8 3d eb ff ff       	call   8010022e <brelse>
801016f1:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801016f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016f7:	83 ec 08             	sub    $0x8,%esp
801016fa:	50                   	push   %eax
801016fb:	ff 75 08             	pushl  0x8(%ebp)
801016fe:	e8 ef 00 00 00       	call   801017f2 <iget>
80101703:	83 c4 10             	add    $0x10,%esp
80101706:	eb 2d                	jmp    80101735 <ialloc+0xdf>
    }
    brelse(bp);
80101708:	83 ec 0c             	sub    $0xc,%esp
8010170b:	ff 75 f0             	pushl  -0x10(%ebp)
8010170e:	e8 1b eb ff ff       	call   8010022e <brelse>
80101713:	83 c4 10             	add    $0x10,%esp
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
80101716:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010171a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101720:	39 c2                	cmp    %eax,%edx
80101722:	0f 87 5a ff ff ff    	ja     80101682 <ialloc+0x2c>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101728:	83 ec 0c             	sub    $0xc,%esp
8010172b:	68 61 91 10 80       	push   $0x80109161
80101730:	e8 31 ee ff ff       	call   80100566 <panic>
}
80101735:	c9                   	leave  
80101736:	c3                   	ret    

80101737 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101737:	55                   	push   %ebp
80101738:	89 e5                	mov    %esp,%ebp
8010173a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
8010173d:	8b 45 08             	mov    0x8(%ebp),%eax
80101740:	8b 40 04             	mov    0x4(%eax),%eax
80101743:	c1 e8 03             	shr    $0x3,%eax
80101746:	8d 50 02             	lea    0x2(%eax),%edx
80101749:	8b 45 08             	mov    0x8(%ebp),%eax
8010174c:	8b 00                	mov    (%eax),%eax
8010174e:	83 ec 08             	sub    $0x8,%esp
80101751:	52                   	push   %edx
80101752:	50                   	push   %eax
80101753:	e8 5e ea ff ff       	call   801001b6 <bread>
80101758:	83 c4 10             	add    $0x10,%esp
8010175b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010175e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101761:	8d 50 18             	lea    0x18(%eax),%edx
80101764:	8b 45 08             	mov    0x8(%ebp),%eax
80101767:	8b 40 04             	mov    0x4(%eax),%eax
8010176a:	83 e0 07             	and    $0x7,%eax
8010176d:	c1 e0 06             	shl    $0x6,%eax
80101770:	01 d0                	add    %edx,%eax
80101772:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101775:	8b 45 08             	mov    0x8(%ebp),%eax
80101778:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010177c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010177f:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101782:	8b 45 08             	mov    0x8(%ebp),%eax
80101785:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101789:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010178c:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101790:	8b 45 08             	mov    0x8(%ebp),%eax
80101793:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101797:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010179a:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010179e:	8b 45 08             	mov    0x8(%ebp),%eax
801017a1:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801017a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a8:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801017ac:	8b 45 08             	mov    0x8(%ebp),%eax
801017af:	8b 50 18             	mov    0x18(%eax),%edx
801017b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017b5:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017b8:	8b 45 08             	mov    0x8(%ebp),%eax
801017bb:	8d 50 1c             	lea    0x1c(%eax),%edx
801017be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c1:	83 c0 0c             	add    $0xc,%eax
801017c4:	83 ec 04             	sub    $0x4,%esp
801017c7:	6a 34                	push   $0x34
801017c9:	52                   	push   %edx
801017ca:	50                   	push   %eax
801017cb:	e8 75 3f 00 00       	call   80105745 <memmove>
801017d0:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801017d3:	83 ec 0c             	sub    $0xc,%esp
801017d6:	ff 75 f4             	pushl  -0xc(%ebp)
801017d9:	e8 0e 1f 00 00       	call   801036ec <log_write>
801017de:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801017e1:	83 ec 0c             	sub    $0xc,%esp
801017e4:	ff 75 f4             	pushl  -0xc(%ebp)
801017e7:	e8 42 ea ff ff       	call   8010022e <brelse>
801017ec:	83 c4 10             	add    $0x10,%esp
}
801017ef:	90                   	nop
801017f0:	c9                   	leave  
801017f1:	c3                   	ret    

801017f2 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017f2:	55                   	push   %ebp
801017f3:	89 e5                	mov    %esp,%ebp
801017f5:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801017f8:	83 ec 0c             	sub    $0xc,%esp
801017fb:	68 60 22 11 80       	push   $0x80112260
80101800:	e8 1e 3c 00 00       	call   80105423 <acquire>
80101805:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101808:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010180f:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
80101816:	eb 5d                	jmp    80101875 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010181b:	8b 40 08             	mov    0x8(%eax),%eax
8010181e:	85 c0                	test   %eax,%eax
80101820:	7e 39                	jle    8010185b <iget+0x69>
80101822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101825:	8b 00                	mov    (%eax),%eax
80101827:	3b 45 08             	cmp    0x8(%ebp),%eax
8010182a:	75 2f                	jne    8010185b <iget+0x69>
8010182c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010182f:	8b 40 04             	mov    0x4(%eax),%eax
80101832:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101835:	75 24                	jne    8010185b <iget+0x69>
      ip->ref++;
80101837:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183a:	8b 40 08             	mov    0x8(%eax),%eax
8010183d:	8d 50 01             	lea    0x1(%eax),%edx
80101840:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101843:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101846:	83 ec 0c             	sub    $0xc,%esp
80101849:	68 60 22 11 80       	push   $0x80112260
8010184e:	e8 37 3c 00 00       	call   8010548a <release>
80101853:	83 c4 10             	add    $0x10,%esp
      return ip;
80101856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101859:	eb 74                	jmp    801018cf <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010185b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010185f:	75 10                	jne    80101871 <iget+0x7f>
80101861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101864:	8b 40 08             	mov    0x8(%eax),%eax
80101867:	85 c0                	test   %eax,%eax
80101869:	75 06                	jne    80101871 <iget+0x7f>
      empty = ip;
8010186b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101871:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101875:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
8010187c:	72 9a                	jb     80101818 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010187e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101882:	75 0d                	jne    80101891 <iget+0x9f>
    panic("iget: no inodes");
80101884:	83 ec 0c             	sub    $0xc,%esp
80101887:	68 73 91 10 80       	push   $0x80109173
8010188c:	e8 d5 ec ff ff       	call   80100566 <panic>

  ip = empty;
80101891:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101894:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101897:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010189a:	8b 55 08             	mov    0x8(%ebp),%edx
8010189d:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010189f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a2:	8b 55 0c             	mov    0xc(%ebp),%edx
801018a5:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801018a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ab:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801018b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801018bc:	83 ec 0c             	sub    $0xc,%esp
801018bf:	68 60 22 11 80       	push   $0x80112260
801018c4:	e8 c1 3b 00 00       	call   8010548a <release>
801018c9:	83 c4 10             	add    $0x10,%esp

  return ip;
801018cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801018cf:	c9                   	leave  
801018d0:	c3                   	ret    

801018d1 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018d1:	55                   	push   %ebp
801018d2:	89 e5                	mov    %esp,%ebp
801018d4:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801018d7:	83 ec 0c             	sub    $0xc,%esp
801018da:	68 60 22 11 80       	push   $0x80112260
801018df:	e8 3f 3b 00 00       	call   80105423 <acquire>
801018e4:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801018e7:	8b 45 08             	mov    0x8(%ebp),%eax
801018ea:	8b 40 08             	mov    0x8(%eax),%eax
801018ed:	8d 50 01             	lea    0x1(%eax),%edx
801018f0:	8b 45 08             	mov    0x8(%ebp),%eax
801018f3:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	68 60 22 11 80       	push   $0x80112260
801018fe:	e8 87 3b 00 00       	call   8010548a <release>
80101903:	83 c4 10             	add    $0x10,%esp
  return ip;
80101906:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101909:	c9                   	leave  
8010190a:	c3                   	ret    

8010190b <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010190b:	55                   	push   %ebp
8010190c:	89 e5                	mov    %esp,%ebp
8010190e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101911:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101915:	74 0a                	je     80101921 <ilock+0x16>
80101917:	8b 45 08             	mov    0x8(%ebp),%eax
8010191a:	8b 40 08             	mov    0x8(%eax),%eax
8010191d:	85 c0                	test   %eax,%eax
8010191f:	7f 0d                	jg     8010192e <ilock+0x23>
    panic("ilock");
80101921:	83 ec 0c             	sub    $0xc,%esp
80101924:	68 83 91 10 80       	push   $0x80109183
80101929:	e8 38 ec ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
8010192e:	83 ec 0c             	sub    $0xc,%esp
80101931:	68 60 22 11 80       	push   $0x80112260
80101936:	e8 e8 3a 00 00       	call   80105423 <acquire>
8010193b:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
8010193e:	eb 13                	jmp    80101953 <ilock+0x48>
    sleep(ip, &icache.lock);
80101940:	83 ec 08             	sub    $0x8,%esp
80101943:	68 60 22 11 80       	push   $0x80112260
80101948:	ff 75 08             	pushl  0x8(%ebp)
8010194b:	e8 2f 33 00 00       	call   80104c7f <sleep>
80101950:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101953:	8b 45 08             	mov    0x8(%ebp),%eax
80101956:	8b 40 0c             	mov    0xc(%eax),%eax
80101959:	83 e0 01             	and    $0x1,%eax
8010195c:	85 c0                	test   %eax,%eax
8010195e:	75 e0                	jne    80101940 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101960:	8b 45 08             	mov    0x8(%ebp),%eax
80101963:	8b 40 0c             	mov    0xc(%eax),%eax
80101966:	83 c8 01             	or     $0x1,%eax
80101969:	89 c2                	mov    %eax,%edx
8010196b:	8b 45 08             	mov    0x8(%ebp),%eax
8010196e:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101971:	83 ec 0c             	sub    $0xc,%esp
80101974:	68 60 22 11 80       	push   $0x80112260
80101979:	e8 0c 3b 00 00       	call   8010548a <release>
8010197e:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101981:	8b 45 08             	mov    0x8(%ebp),%eax
80101984:	8b 40 0c             	mov    0xc(%eax),%eax
80101987:	83 e0 02             	and    $0x2,%eax
8010198a:	85 c0                	test   %eax,%eax
8010198c:	0f 85 ce 00 00 00    	jne    80101a60 <ilock+0x155>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101992:	8b 45 08             	mov    0x8(%ebp),%eax
80101995:	8b 40 04             	mov    0x4(%eax),%eax
80101998:	c1 e8 03             	shr    $0x3,%eax
8010199b:	8d 50 02             	lea    0x2(%eax),%edx
8010199e:	8b 45 08             	mov    0x8(%ebp),%eax
801019a1:	8b 00                	mov    (%eax),%eax
801019a3:	83 ec 08             	sub    $0x8,%esp
801019a6:	52                   	push   %edx
801019a7:	50                   	push   %eax
801019a8:	e8 09 e8 ff ff       	call   801001b6 <bread>
801019ad:	83 c4 10             	add    $0x10,%esp
801019b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b6:	8d 50 18             	lea    0x18(%eax),%edx
801019b9:	8b 45 08             	mov    0x8(%ebp),%eax
801019bc:	8b 40 04             	mov    0x4(%eax),%eax
801019bf:	83 e0 07             	and    $0x7,%eax
801019c2:	c1 e0 06             	shl    $0x6,%eax
801019c5:	01 d0                	add    %edx,%eax
801019c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019cd:	0f b7 10             	movzwl (%eax),%edx
801019d0:	8b 45 08             	mov    0x8(%ebp),%eax
801019d3:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
801019d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019da:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801019de:	8b 45 08             	mov    0x8(%ebp),%eax
801019e1:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
801019e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019e8:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801019ec:	8b 45 08             	mov    0x8(%ebp),%eax
801019ef:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
801019f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f6:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801019fa:	8b 45 08             	mov    0x8(%ebp),%eax
801019fd:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a04:	8b 50 08             	mov    0x8(%eax),%edx
80101a07:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0a:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a10:	8d 50 0c             	lea    0xc(%eax),%edx
80101a13:	8b 45 08             	mov    0x8(%ebp),%eax
80101a16:	83 c0 1c             	add    $0x1c,%eax
80101a19:	83 ec 04             	sub    $0x4,%esp
80101a1c:	6a 34                	push   $0x34
80101a1e:	52                   	push   %edx
80101a1f:	50                   	push   %eax
80101a20:	e8 20 3d 00 00       	call   80105745 <memmove>
80101a25:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101a28:	83 ec 0c             	sub    $0xc,%esp
80101a2b:	ff 75 f4             	pushl  -0xc(%ebp)
80101a2e:	e8 fb e7 ff ff       	call   8010022e <brelse>
80101a33:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101a36:	8b 45 08             	mov    0x8(%ebp),%eax
80101a39:	8b 40 0c             	mov    0xc(%eax),%eax
80101a3c:	83 c8 02             	or     $0x2,%eax
80101a3f:	89 c2                	mov    %eax,%edx
80101a41:	8b 45 08             	mov    0x8(%ebp),%eax
80101a44:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a47:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a4e:	66 85 c0             	test   %ax,%ax
80101a51:	75 0d                	jne    80101a60 <ilock+0x155>
      panic("ilock: no type");
80101a53:	83 ec 0c             	sub    $0xc,%esp
80101a56:	68 89 91 10 80       	push   $0x80109189
80101a5b:	e8 06 eb ff ff       	call   80100566 <panic>
  }
}
80101a60:	90                   	nop
80101a61:	c9                   	leave  
80101a62:	c3                   	ret    

80101a63 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a63:	55                   	push   %ebp
80101a64:	89 e5                	mov    %esp,%ebp
80101a66:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a6d:	74 17                	je     80101a86 <iunlock+0x23>
80101a6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a72:	8b 40 0c             	mov    0xc(%eax),%eax
80101a75:	83 e0 01             	and    $0x1,%eax
80101a78:	85 c0                	test   %eax,%eax
80101a7a:	74 0a                	je     80101a86 <iunlock+0x23>
80101a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7f:	8b 40 08             	mov    0x8(%eax),%eax
80101a82:	85 c0                	test   %eax,%eax
80101a84:	7f 0d                	jg     80101a93 <iunlock+0x30>
    panic("iunlock");
80101a86:	83 ec 0c             	sub    $0xc,%esp
80101a89:	68 98 91 10 80       	push   $0x80109198
80101a8e:	e8 d3 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a93:	83 ec 0c             	sub    $0xc,%esp
80101a96:	68 60 22 11 80       	push   $0x80112260
80101a9b:	e8 83 39 00 00       	call   80105423 <acquire>
80101aa0:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	8b 40 0c             	mov    0xc(%eax),%eax
80101aa9:	83 e0 fe             	and    $0xfffffffe,%eax
80101aac:	89 c2                	mov    %eax,%edx
80101aae:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab1:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101ab4:	83 ec 0c             	sub    $0xc,%esp
80101ab7:	ff 75 08             	pushl  0x8(%ebp)
80101aba:	e8 ae 32 00 00       	call   80104d6d <wakeup>
80101abf:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ac2:	83 ec 0c             	sub    $0xc,%esp
80101ac5:	68 60 22 11 80       	push   $0x80112260
80101aca:	e8 bb 39 00 00       	call   8010548a <release>
80101acf:	83 c4 10             	add    $0x10,%esp
}
80101ad2:	90                   	nop
80101ad3:	c9                   	leave  
80101ad4:	c3                   	ret    

80101ad5 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101ad5:	55                   	push   %ebp
80101ad6:	89 e5                	mov    %esp,%ebp
80101ad8:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101adb:	83 ec 0c             	sub    $0xc,%esp
80101ade:	68 60 22 11 80       	push   $0x80112260
80101ae3:	e8 3b 39 00 00       	call   80105423 <acquire>
80101ae8:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101aeb:	8b 45 08             	mov    0x8(%ebp),%eax
80101aee:	8b 40 08             	mov    0x8(%eax),%eax
80101af1:	83 f8 01             	cmp    $0x1,%eax
80101af4:	0f 85 a9 00 00 00    	jne    80101ba3 <iput+0xce>
80101afa:	8b 45 08             	mov    0x8(%ebp),%eax
80101afd:	8b 40 0c             	mov    0xc(%eax),%eax
80101b00:	83 e0 02             	and    $0x2,%eax
80101b03:	85 c0                	test   %eax,%eax
80101b05:	0f 84 98 00 00 00    	je     80101ba3 <iput+0xce>
80101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101b12:	66 85 c0             	test   %ax,%ax
80101b15:	0f 85 88 00 00 00    	jne    80101ba3 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1e:	8b 40 0c             	mov    0xc(%eax),%eax
80101b21:	83 e0 01             	and    $0x1,%eax
80101b24:	85 c0                	test   %eax,%eax
80101b26:	74 0d                	je     80101b35 <iput+0x60>
      panic("iput busy");
80101b28:	83 ec 0c             	sub    $0xc,%esp
80101b2b:	68 a0 91 10 80       	push   $0x801091a0
80101b30:	e8 31 ea ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101b35:	8b 45 08             	mov    0x8(%ebp),%eax
80101b38:	8b 40 0c             	mov    0xc(%eax),%eax
80101b3b:	83 c8 01             	or     $0x1,%eax
80101b3e:	89 c2                	mov    %eax,%edx
80101b40:	8b 45 08             	mov    0x8(%ebp),%eax
80101b43:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b46:	83 ec 0c             	sub    $0xc,%esp
80101b49:	68 60 22 11 80       	push   $0x80112260
80101b4e:	e8 37 39 00 00       	call   8010548a <release>
80101b53:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101b56:	83 ec 0c             	sub    $0xc,%esp
80101b59:	ff 75 08             	pushl  0x8(%ebp)
80101b5c:	e8 a8 01 00 00       	call   80101d09 <itrunc>
80101b61:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101b64:	8b 45 08             	mov    0x8(%ebp),%eax
80101b67:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b6d:	83 ec 0c             	sub    $0xc,%esp
80101b70:	ff 75 08             	pushl  0x8(%ebp)
80101b73:	e8 bf fb ff ff       	call   80101737 <iupdate>
80101b78:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
80101b7e:	68 60 22 11 80       	push   $0x80112260
80101b83:	e8 9b 38 00 00       	call   80105423 <acquire>
80101b88:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b95:	83 ec 0c             	sub    $0xc,%esp
80101b98:	ff 75 08             	pushl  0x8(%ebp)
80101b9b:	e8 cd 31 00 00       	call   80104d6d <wakeup>
80101ba0:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101ba3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba6:	8b 40 08             	mov    0x8(%eax),%eax
80101ba9:	8d 50 ff             	lea    -0x1(%eax),%edx
80101bac:	8b 45 08             	mov    0x8(%ebp),%eax
80101baf:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bb2:	83 ec 0c             	sub    $0xc,%esp
80101bb5:	68 60 22 11 80       	push   $0x80112260
80101bba:	e8 cb 38 00 00       	call   8010548a <release>
80101bbf:	83 c4 10             	add    $0x10,%esp
}
80101bc2:	90                   	nop
80101bc3:	c9                   	leave  
80101bc4:	c3                   	ret    

80101bc5 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101bc5:	55                   	push   %ebp
80101bc6:	89 e5                	mov    %esp,%ebp
80101bc8:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101bcb:	83 ec 0c             	sub    $0xc,%esp
80101bce:	ff 75 08             	pushl  0x8(%ebp)
80101bd1:	e8 8d fe ff ff       	call   80101a63 <iunlock>
80101bd6:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101bd9:	83 ec 0c             	sub    $0xc,%esp
80101bdc:	ff 75 08             	pushl  0x8(%ebp)
80101bdf:	e8 f1 fe ff ff       	call   80101ad5 <iput>
80101be4:	83 c4 10             	add    $0x10,%esp
}
80101be7:	90                   	nop
80101be8:	c9                   	leave  
80101be9:	c3                   	ret    

80101bea <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101bea:	55                   	push   %ebp
80101beb:	89 e5                	mov    %esp,%ebp
80101bed:	53                   	push   %ebx
80101bee:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101bf1:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101bf5:	77 42                	ja     80101c39 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bfd:	83 c2 04             	add    $0x4,%edx
80101c00:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c04:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c0b:	75 24                	jne    80101c31 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c10:	8b 00                	mov    (%eax),%eax
80101c12:	83 ec 0c             	sub    $0xc,%esp
80101c15:	50                   	push   %eax
80101c16:	e8 e4 f7 ff ff       	call   801013ff <balloc>
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c21:	8b 45 08             	mov    0x8(%ebp),%eax
80101c24:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c27:	8d 4a 04             	lea    0x4(%edx),%ecx
80101c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c2d:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c34:	e9 cb 00 00 00       	jmp    80101d04 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101c39:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c3d:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c41:	0f 87 b0 00 00 00    	ja     80101cf7 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c47:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4a:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c54:	75 1d                	jne    80101c73 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c56:	8b 45 08             	mov    0x8(%ebp),%eax
80101c59:	8b 00                	mov    (%eax),%eax
80101c5b:	83 ec 0c             	sub    $0xc,%esp
80101c5e:	50                   	push   %eax
80101c5f:	e8 9b f7 ff ff       	call   801013ff <balloc>
80101c64:	83 c4 10             	add    $0x10,%esp
80101c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c70:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c73:	8b 45 08             	mov    0x8(%ebp),%eax
80101c76:	8b 00                	mov    (%eax),%eax
80101c78:	83 ec 08             	sub    $0x8,%esp
80101c7b:	ff 75 f4             	pushl  -0xc(%ebp)
80101c7e:	50                   	push   %eax
80101c7f:	e8 32 e5 ff ff       	call   801001b6 <bread>
80101c84:	83 c4 10             	add    $0x10,%esp
80101c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c8d:	83 c0 18             	add    $0x18,%eax
80101c90:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c93:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ca0:	01 d0                	add    %edx,%eax
80101ca2:	8b 00                	mov    (%eax),%eax
80101ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cab:	75 37                	jne    80101ce4 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101cad:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cb0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cba:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc0:	8b 00                	mov    (%eax),%eax
80101cc2:	83 ec 0c             	sub    $0xc,%esp
80101cc5:	50                   	push   %eax
80101cc6:	e8 34 f7 ff ff       	call   801013ff <balloc>
80101ccb:	83 c4 10             	add    $0x10,%esp
80101cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cd4:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101cd6:	83 ec 0c             	sub    $0xc,%esp
80101cd9:	ff 75 f0             	pushl  -0x10(%ebp)
80101cdc:	e8 0b 1a 00 00       	call   801036ec <log_write>
80101ce1:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101ce4:	83 ec 0c             	sub    $0xc,%esp
80101ce7:	ff 75 f0             	pushl  -0x10(%ebp)
80101cea:	e8 3f e5 ff ff       	call   8010022e <brelse>
80101cef:	83 c4 10             	add    $0x10,%esp
    return addr;
80101cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cf5:	eb 0d                	jmp    80101d04 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101cf7:	83 ec 0c             	sub    $0xc,%esp
80101cfa:	68 aa 91 10 80       	push   $0x801091aa
80101cff:	e8 62 e8 ff ff       	call   80100566 <panic>
}
80101d04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d07:	c9                   	leave  
80101d08:	c3                   	ret    

80101d09 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d09:	55                   	push   %ebp
80101d0a:	89 e5                	mov    %esp,%ebp
80101d0c:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d16:	eb 45                	jmp    80101d5d <itrunc+0x54>
    if(ip->addrs[i]){
80101d18:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d1e:	83 c2 04             	add    $0x4,%edx
80101d21:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d25:	85 c0                	test   %eax,%eax
80101d27:	74 30                	je     80101d59 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d29:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d2f:	83 c2 04             	add    $0x4,%edx
80101d32:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d36:	8b 55 08             	mov    0x8(%ebp),%edx
80101d39:	8b 12                	mov    (%edx),%edx
80101d3b:	83 ec 08             	sub    $0x8,%esp
80101d3e:	50                   	push   %eax
80101d3f:	52                   	push   %edx
80101d40:	e8 18 f8 ff ff       	call   8010155d <bfree>
80101d45:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d48:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d4e:	83 c2 04             	add    $0x4,%edx
80101d51:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d58:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d5d:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d61:	7e b5                	jle    80101d18 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d63:	8b 45 08             	mov    0x8(%ebp),%eax
80101d66:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d69:	85 c0                	test   %eax,%eax
80101d6b:	0f 84 a1 00 00 00    	je     80101e12 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d71:	8b 45 08             	mov    0x8(%ebp),%eax
80101d74:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d77:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7a:	8b 00                	mov    (%eax),%eax
80101d7c:	83 ec 08             	sub    $0x8,%esp
80101d7f:	52                   	push   %edx
80101d80:	50                   	push   %eax
80101d81:	e8 30 e4 ff ff       	call   801001b6 <bread>
80101d86:	83 c4 10             	add    $0x10,%esp
80101d89:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d8f:	83 c0 18             	add    $0x18,%eax
80101d92:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d9c:	eb 3c                	jmp    80101dda <itrunc+0xd1>
      if(a[j])
80101d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101da1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101da8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dab:	01 d0                	add    %edx,%eax
80101dad:	8b 00                	mov    (%eax),%eax
80101daf:	85 c0                	test   %eax,%eax
80101db1:	74 23                	je     80101dd6 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101db6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dc0:	01 d0                	add    %edx,%eax
80101dc2:	8b 00                	mov    (%eax),%eax
80101dc4:	8b 55 08             	mov    0x8(%ebp),%edx
80101dc7:	8b 12                	mov    (%edx),%edx
80101dc9:	83 ec 08             	sub    $0x8,%esp
80101dcc:	50                   	push   %eax
80101dcd:	52                   	push   %edx
80101dce:	e8 8a f7 ff ff       	call   8010155d <bfree>
80101dd3:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101dd6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ddd:	83 f8 7f             	cmp    $0x7f,%eax
80101de0:	76 bc                	jbe    80101d9e <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101de2:	83 ec 0c             	sub    $0xc,%esp
80101de5:	ff 75 ec             	pushl  -0x14(%ebp)
80101de8:	e8 41 e4 ff ff       	call   8010022e <brelse>
80101ded:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101df0:	8b 45 08             	mov    0x8(%ebp),%eax
80101df3:	8b 40 4c             	mov    0x4c(%eax),%eax
80101df6:	8b 55 08             	mov    0x8(%ebp),%edx
80101df9:	8b 12                	mov    (%edx),%edx
80101dfb:	83 ec 08             	sub    $0x8,%esp
80101dfe:	50                   	push   %eax
80101dff:	52                   	push   %edx
80101e00:	e8 58 f7 ff ff       	call   8010155d <bfree>
80101e05:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e08:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0b:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101e12:	8b 45 08             	mov    0x8(%ebp),%eax
80101e15:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	ff 75 08             	pushl  0x8(%ebp)
80101e22:	e8 10 f9 ff ff       	call   80101737 <iupdate>
80101e27:	83 c4 10             	add    $0x10,%esp
}
80101e2a:	90                   	nop
80101e2b:	c9                   	leave  
80101e2c:	c3                   	ret    

80101e2d <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101e2d:	55                   	push   %ebp
80101e2e:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e30:	8b 45 08             	mov    0x8(%ebp),%eax
80101e33:	8b 00                	mov    (%eax),%eax
80101e35:	89 c2                	mov    %eax,%edx
80101e37:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e3a:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e40:	8b 50 04             	mov    0x4(%eax),%edx
80101e43:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e46:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e49:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4c:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101e50:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e53:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101e56:	8b 45 08             	mov    0x8(%ebp),%eax
80101e59:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e60:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101e64:	8b 45 08             	mov    0x8(%ebp),%eax
80101e67:	8b 50 18             	mov    0x18(%eax),%edx
80101e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e6d:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e70:	90                   	nop
80101e71:	5d                   	pop    %ebp
80101e72:	c3                   	ret    

80101e73 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e73:	55                   	push   %ebp
80101e74:	89 e5                	mov    %esp,%ebp
80101e76:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e79:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e80:	66 83 f8 03          	cmp    $0x3,%ax
80101e84:	75 5c                	jne    80101ee2 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e86:	8b 45 08             	mov    0x8(%ebp),%eax
80101e89:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e8d:	66 85 c0             	test   %ax,%ax
80101e90:	78 20                	js     80101eb2 <readi+0x3f>
80101e92:	8b 45 08             	mov    0x8(%ebp),%eax
80101e95:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e99:	66 83 f8 09          	cmp    $0x9,%ax
80101e9d:	7f 13                	jg     80101eb2 <readi+0x3f>
80101e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea2:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ea6:	98                   	cwtl   
80101ea7:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
80101eae:	85 c0                	test   %eax,%eax
80101eb0:	75 0a                	jne    80101ebc <readi+0x49>
      return -1;
80101eb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb7:	e9 0c 01 00 00       	jmp    80101fc8 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebf:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ec3:	98                   	cwtl   
80101ec4:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
80101ecb:	8b 55 14             	mov    0x14(%ebp),%edx
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	52                   	push   %edx
80101ed2:	ff 75 0c             	pushl  0xc(%ebp)
80101ed5:	ff 75 08             	pushl  0x8(%ebp)
80101ed8:	ff d0                	call   *%eax
80101eda:	83 c4 10             	add    $0x10,%esp
80101edd:	e9 e6 00 00 00       	jmp    80101fc8 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee5:	8b 40 18             	mov    0x18(%eax),%eax
80101ee8:	3b 45 10             	cmp    0x10(%ebp),%eax
80101eeb:	72 0d                	jb     80101efa <readi+0x87>
80101eed:	8b 55 10             	mov    0x10(%ebp),%edx
80101ef0:	8b 45 14             	mov    0x14(%ebp),%eax
80101ef3:	01 d0                	add    %edx,%eax
80101ef5:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ef8:	73 0a                	jae    80101f04 <readi+0x91>
    return -1;
80101efa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eff:	e9 c4 00 00 00       	jmp    80101fc8 <readi+0x155>
  if(off + n > ip->size)
80101f04:	8b 55 10             	mov    0x10(%ebp),%edx
80101f07:	8b 45 14             	mov    0x14(%ebp),%eax
80101f0a:	01 c2                	add    %eax,%edx
80101f0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0f:	8b 40 18             	mov    0x18(%eax),%eax
80101f12:	39 c2                	cmp    %eax,%edx
80101f14:	76 0c                	jbe    80101f22 <readi+0xaf>
    n = ip->size - off;
80101f16:	8b 45 08             	mov    0x8(%ebp),%eax
80101f19:	8b 40 18             	mov    0x18(%eax),%eax
80101f1c:	2b 45 10             	sub    0x10(%ebp),%eax
80101f1f:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f29:	e9 8b 00 00 00       	jmp    80101fb9 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f2e:	8b 45 10             	mov    0x10(%ebp),%eax
80101f31:	c1 e8 09             	shr    $0x9,%eax
80101f34:	83 ec 08             	sub    $0x8,%esp
80101f37:	50                   	push   %eax
80101f38:	ff 75 08             	pushl  0x8(%ebp)
80101f3b:	e8 aa fc ff ff       	call   80101bea <bmap>
80101f40:	83 c4 10             	add    $0x10,%esp
80101f43:	89 c2                	mov    %eax,%edx
80101f45:	8b 45 08             	mov    0x8(%ebp),%eax
80101f48:	8b 00                	mov    (%eax),%eax
80101f4a:	83 ec 08             	sub    $0x8,%esp
80101f4d:	52                   	push   %edx
80101f4e:	50                   	push   %eax
80101f4f:	e8 62 e2 ff ff       	call   801001b6 <bread>
80101f54:	83 c4 10             	add    $0x10,%esp
80101f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f5a:	8b 45 10             	mov    0x10(%ebp),%eax
80101f5d:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f62:	ba 00 02 00 00       	mov    $0x200,%edx
80101f67:	29 c2                	sub    %eax,%edx
80101f69:	8b 45 14             	mov    0x14(%ebp),%eax
80101f6c:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101f6f:	39 c2                	cmp    %eax,%edx
80101f71:	0f 46 c2             	cmovbe %edx,%eax
80101f74:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f7a:	8d 50 18             	lea    0x18(%eax),%edx
80101f7d:	8b 45 10             	mov    0x10(%ebp),%eax
80101f80:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f85:	01 d0                	add    %edx,%eax
80101f87:	83 ec 04             	sub    $0x4,%esp
80101f8a:	ff 75 ec             	pushl  -0x14(%ebp)
80101f8d:	50                   	push   %eax
80101f8e:	ff 75 0c             	pushl  0xc(%ebp)
80101f91:	e8 af 37 00 00       	call   80105745 <memmove>
80101f96:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101f99:	83 ec 0c             	sub    $0xc,%esp
80101f9c:	ff 75 f0             	pushl  -0x10(%ebp)
80101f9f:	e8 8a e2 ff ff       	call   8010022e <brelse>
80101fa4:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101faa:	01 45 f4             	add    %eax,-0xc(%ebp)
80101fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fb0:	01 45 10             	add    %eax,0x10(%ebp)
80101fb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fb6:	01 45 0c             	add    %eax,0xc(%ebp)
80101fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fbc:	3b 45 14             	cmp    0x14(%ebp),%eax
80101fbf:	0f 82 69 ff ff ff    	jb     80101f2e <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101fc5:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101fc8:	c9                   	leave  
80101fc9:	c3                   	ret    

80101fca <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101fca:	55                   	push   %ebp
80101fcb:	89 e5                	mov    %esp,%ebp
80101fcd:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fd0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101fd7:	66 83 f8 03          	cmp    $0x3,%ax
80101fdb:	75 5c                	jne    80102039 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101fdd:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fe4:	66 85 c0             	test   %ax,%ax
80101fe7:	78 20                	js     80102009 <writei+0x3f>
80101fe9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fec:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ff0:	66 83 f8 09          	cmp    $0x9,%ax
80101ff4:	7f 13                	jg     80102009 <writei+0x3f>
80101ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ffd:	98                   	cwtl   
80101ffe:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
80102005:	85 c0                	test   %eax,%eax
80102007:	75 0a                	jne    80102013 <writei+0x49>
      return -1;
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	e9 3d 01 00 00       	jmp    80102150 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
80102013:	8b 45 08             	mov    0x8(%ebp),%eax
80102016:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010201a:	98                   	cwtl   
8010201b:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
80102022:	8b 55 14             	mov    0x14(%ebp),%edx
80102025:	83 ec 04             	sub    $0x4,%esp
80102028:	52                   	push   %edx
80102029:	ff 75 0c             	pushl  0xc(%ebp)
8010202c:	ff 75 08             	pushl  0x8(%ebp)
8010202f:	ff d0                	call   *%eax
80102031:	83 c4 10             	add    $0x10,%esp
80102034:	e9 17 01 00 00       	jmp    80102150 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
80102039:	8b 45 08             	mov    0x8(%ebp),%eax
8010203c:	8b 40 18             	mov    0x18(%eax),%eax
8010203f:	3b 45 10             	cmp    0x10(%ebp),%eax
80102042:	72 0d                	jb     80102051 <writei+0x87>
80102044:	8b 55 10             	mov    0x10(%ebp),%edx
80102047:	8b 45 14             	mov    0x14(%ebp),%eax
8010204a:	01 d0                	add    %edx,%eax
8010204c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010204f:	73 0a                	jae    8010205b <writei+0x91>
    return -1;
80102051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102056:	e9 f5 00 00 00       	jmp    80102150 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
8010205b:	8b 55 10             	mov    0x10(%ebp),%edx
8010205e:	8b 45 14             	mov    0x14(%ebp),%eax
80102061:	01 d0                	add    %edx,%eax
80102063:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102068:	76 0a                	jbe    80102074 <writei+0xaa>
    return -1;
8010206a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010206f:	e9 dc 00 00 00       	jmp    80102150 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102074:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010207b:	e9 99 00 00 00       	jmp    80102119 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102080:	8b 45 10             	mov    0x10(%ebp),%eax
80102083:	c1 e8 09             	shr    $0x9,%eax
80102086:	83 ec 08             	sub    $0x8,%esp
80102089:	50                   	push   %eax
8010208a:	ff 75 08             	pushl  0x8(%ebp)
8010208d:	e8 58 fb ff ff       	call   80101bea <bmap>
80102092:	83 c4 10             	add    $0x10,%esp
80102095:	89 c2                	mov    %eax,%edx
80102097:	8b 45 08             	mov    0x8(%ebp),%eax
8010209a:	8b 00                	mov    (%eax),%eax
8010209c:	83 ec 08             	sub    $0x8,%esp
8010209f:	52                   	push   %edx
801020a0:	50                   	push   %eax
801020a1:	e8 10 e1 ff ff       	call   801001b6 <bread>
801020a6:	83 c4 10             	add    $0x10,%esp
801020a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020ac:	8b 45 10             	mov    0x10(%ebp),%eax
801020af:	25 ff 01 00 00       	and    $0x1ff,%eax
801020b4:	ba 00 02 00 00       	mov    $0x200,%edx
801020b9:	29 c2                	sub    %eax,%edx
801020bb:	8b 45 14             	mov    0x14(%ebp),%eax
801020be:	2b 45 f4             	sub    -0xc(%ebp),%eax
801020c1:	39 c2                	cmp    %eax,%edx
801020c3:	0f 46 c2             	cmovbe %edx,%eax
801020c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801020c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020cc:	8d 50 18             	lea    0x18(%eax),%edx
801020cf:	8b 45 10             	mov    0x10(%ebp),%eax
801020d2:	25 ff 01 00 00       	and    $0x1ff,%eax
801020d7:	01 d0                	add    %edx,%eax
801020d9:	83 ec 04             	sub    $0x4,%esp
801020dc:	ff 75 ec             	pushl  -0x14(%ebp)
801020df:	ff 75 0c             	pushl  0xc(%ebp)
801020e2:	50                   	push   %eax
801020e3:	e8 5d 36 00 00       	call   80105745 <memmove>
801020e8:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801020eb:	83 ec 0c             	sub    $0xc,%esp
801020ee:	ff 75 f0             	pushl  -0x10(%ebp)
801020f1:	e8 f6 15 00 00       	call   801036ec <log_write>
801020f6:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801020f9:	83 ec 0c             	sub    $0xc,%esp
801020fc:	ff 75 f0             	pushl  -0x10(%ebp)
801020ff:	e8 2a e1 ff ff       	call   8010022e <brelse>
80102104:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102107:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010210a:	01 45 f4             	add    %eax,-0xc(%ebp)
8010210d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102110:	01 45 10             	add    %eax,0x10(%ebp)
80102113:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102116:	01 45 0c             	add    %eax,0xc(%ebp)
80102119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010211c:	3b 45 14             	cmp    0x14(%ebp),%eax
8010211f:	0f 82 5b ff ff ff    	jb     80102080 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102125:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102129:	74 22                	je     8010214d <writei+0x183>
8010212b:	8b 45 08             	mov    0x8(%ebp),%eax
8010212e:	8b 40 18             	mov    0x18(%eax),%eax
80102131:	3b 45 10             	cmp    0x10(%ebp),%eax
80102134:	73 17                	jae    8010214d <writei+0x183>
    ip->size = off;
80102136:	8b 45 08             	mov    0x8(%ebp),%eax
80102139:	8b 55 10             	mov    0x10(%ebp),%edx
8010213c:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010213f:	83 ec 0c             	sub    $0xc,%esp
80102142:	ff 75 08             	pushl  0x8(%ebp)
80102145:	e8 ed f5 ff ff       	call   80101737 <iupdate>
8010214a:	83 c4 10             	add    $0x10,%esp
  }
  return n;
8010214d:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102150:	c9                   	leave  
80102151:	c3                   	ret    

80102152 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102152:	55                   	push   %ebp
80102153:	89 e5                	mov    %esp,%ebp
80102155:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102158:	83 ec 04             	sub    $0x4,%esp
8010215b:	6a 0e                	push   $0xe
8010215d:	ff 75 0c             	pushl  0xc(%ebp)
80102160:	ff 75 08             	pushl  0x8(%ebp)
80102163:	e8 73 36 00 00       	call   801057db <strncmp>
80102168:	83 c4 10             	add    $0x10,%esp
}
8010216b:	c9                   	leave  
8010216c:	c3                   	ret    

8010216d <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010216d:	55                   	push   %ebp
8010216e:	89 e5                	mov    %esp,%ebp
80102170:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102173:	8b 45 08             	mov    0x8(%ebp),%eax
80102176:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010217a:	66 83 f8 01          	cmp    $0x1,%ax
8010217e:	74 0d                	je     8010218d <dirlookup+0x20>
    panic("dirlookup not DIR");
80102180:	83 ec 0c             	sub    $0xc,%esp
80102183:	68 bd 91 10 80       	push   $0x801091bd
80102188:	e8 d9 e3 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010218d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102194:	eb 7b                	jmp    80102211 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102196:	6a 10                	push   $0x10
80102198:	ff 75 f4             	pushl  -0xc(%ebp)
8010219b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010219e:	50                   	push   %eax
8010219f:	ff 75 08             	pushl  0x8(%ebp)
801021a2:	e8 cc fc ff ff       	call   80101e73 <readi>
801021a7:	83 c4 10             	add    $0x10,%esp
801021aa:	83 f8 10             	cmp    $0x10,%eax
801021ad:	74 0d                	je     801021bc <dirlookup+0x4f>
      panic("dirlink read");
801021af:	83 ec 0c             	sub    $0xc,%esp
801021b2:	68 cf 91 10 80       	push   $0x801091cf
801021b7:	e8 aa e3 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801021bc:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021c0:	66 85 c0             	test   %ax,%ax
801021c3:	74 47                	je     8010220c <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801021c5:	83 ec 08             	sub    $0x8,%esp
801021c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021cb:	83 c0 02             	add    $0x2,%eax
801021ce:	50                   	push   %eax
801021cf:	ff 75 0c             	pushl  0xc(%ebp)
801021d2:	e8 7b ff ff ff       	call   80102152 <namecmp>
801021d7:	83 c4 10             	add    $0x10,%esp
801021da:	85 c0                	test   %eax,%eax
801021dc:	75 2f                	jne    8010220d <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801021de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021e2:	74 08                	je     801021ec <dirlookup+0x7f>
        *poff = off;
801021e4:	8b 45 10             	mov    0x10(%ebp),%eax
801021e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021ea:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801021ec:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021f0:	0f b7 c0             	movzwl %ax,%eax
801021f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801021f6:	8b 45 08             	mov    0x8(%ebp),%eax
801021f9:	8b 00                	mov    (%eax),%eax
801021fb:	83 ec 08             	sub    $0x8,%esp
801021fe:	ff 75 f0             	pushl  -0x10(%ebp)
80102201:	50                   	push   %eax
80102202:	e8 eb f5 ff ff       	call   801017f2 <iget>
80102207:	83 c4 10             	add    $0x10,%esp
8010220a:	eb 19                	jmp    80102225 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010220c:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010220d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102211:	8b 45 08             	mov    0x8(%ebp),%eax
80102214:	8b 40 18             	mov    0x18(%eax),%eax
80102217:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010221a:	0f 87 76 ff ff ff    	ja     80102196 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102220:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102225:	c9                   	leave  
80102226:	c3                   	ret    

80102227 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102227:	55                   	push   %ebp
80102228:	89 e5                	mov    %esp,%ebp
8010222a:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010222d:	83 ec 04             	sub    $0x4,%esp
80102230:	6a 00                	push   $0x0
80102232:	ff 75 0c             	pushl  0xc(%ebp)
80102235:	ff 75 08             	pushl  0x8(%ebp)
80102238:	e8 30 ff ff ff       	call   8010216d <dirlookup>
8010223d:	83 c4 10             	add    $0x10,%esp
80102240:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102243:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102247:	74 18                	je     80102261 <dirlink+0x3a>
    iput(ip);
80102249:	83 ec 0c             	sub    $0xc,%esp
8010224c:	ff 75 f0             	pushl  -0x10(%ebp)
8010224f:	e8 81 f8 ff ff       	call   80101ad5 <iput>
80102254:	83 c4 10             	add    $0x10,%esp
    return -1;
80102257:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010225c:	e9 9c 00 00 00       	jmp    801022fd <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102268:	eb 39                	jmp    801022a3 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010226d:	6a 10                	push   $0x10
8010226f:	50                   	push   %eax
80102270:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102273:	50                   	push   %eax
80102274:	ff 75 08             	pushl  0x8(%ebp)
80102277:	e8 f7 fb ff ff       	call   80101e73 <readi>
8010227c:	83 c4 10             	add    $0x10,%esp
8010227f:	83 f8 10             	cmp    $0x10,%eax
80102282:	74 0d                	je     80102291 <dirlink+0x6a>
      panic("dirlink read");
80102284:	83 ec 0c             	sub    $0xc,%esp
80102287:	68 cf 91 10 80       	push   $0x801091cf
8010228c:	e8 d5 e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102291:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102295:	66 85 c0             	test   %ax,%ax
80102298:	74 18                	je     801022b2 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010229d:	83 c0 10             	add    $0x10,%eax
801022a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022a3:	8b 45 08             	mov    0x8(%ebp),%eax
801022a6:	8b 50 18             	mov    0x18(%eax),%edx
801022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022ac:	39 c2                	cmp    %eax,%edx
801022ae:	77 ba                	ja     8010226a <dirlink+0x43>
801022b0:	eb 01                	jmp    801022b3 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801022b2:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801022b3:	83 ec 04             	sub    $0x4,%esp
801022b6:	6a 0e                	push   $0xe
801022b8:	ff 75 0c             	pushl  0xc(%ebp)
801022bb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022be:	83 c0 02             	add    $0x2,%eax
801022c1:	50                   	push   %eax
801022c2:	e8 6a 35 00 00       	call   80105831 <strncpy>
801022c7:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801022ca:	8b 45 10             	mov    0x10(%ebp),%eax
801022cd:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022d4:	6a 10                	push   $0x10
801022d6:	50                   	push   %eax
801022d7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022da:	50                   	push   %eax
801022db:	ff 75 08             	pushl  0x8(%ebp)
801022de:	e8 e7 fc ff ff       	call   80101fca <writei>
801022e3:	83 c4 10             	add    $0x10,%esp
801022e6:	83 f8 10             	cmp    $0x10,%eax
801022e9:	74 0d                	je     801022f8 <dirlink+0xd1>
    panic("dirlink");
801022eb:	83 ec 0c             	sub    $0xc,%esp
801022ee:	68 dc 91 10 80       	push   $0x801091dc
801022f3:	e8 6e e2 ff ff       	call   80100566 <panic>
  
  return 0;
801022f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022fd:	c9                   	leave  
801022fe:	c3                   	ret    

801022ff <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022ff:	55                   	push   %ebp
80102300:	89 e5                	mov    %esp,%ebp
80102302:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102305:	eb 04                	jmp    8010230b <skipelem+0xc>
    path++;
80102307:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010230b:	8b 45 08             	mov    0x8(%ebp),%eax
8010230e:	0f b6 00             	movzbl (%eax),%eax
80102311:	3c 2f                	cmp    $0x2f,%al
80102313:	74 f2                	je     80102307 <skipelem+0x8>
    path++;
  if(*path == 0)
80102315:	8b 45 08             	mov    0x8(%ebp),%eax
80102318:	0f b6 00             	movzbl (%eax),%eax
8010231b:	84 c0                	test   %al,%al
8010231d:	75 07                	jne    80102326 <skipelem+0x27>
    return 0;
8010231f:	b8 00 00 00 00       	mov    $0x0,%eax
80102324:	eb 7b                	jmp    801023a1 <skipelem+0xa2>
  s = path;
80102326:	8b 45 08             	mov    0x8(%ebp),%eax
80102329:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010232c:	eb 04                	jmp    80102332 <skipelem+0x33>
    path++;
8010232e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102332:	8b 45 08             	mov    0x8(%ebp),%eax
80102335:	0f b6 00             	movzbl (%eax),%eax
80102338:	3c 2f                	cmp    $0x2f,%al
8010233a:	74 0a                	je     80102346 <skipelem+0x47>
8010233c:	8b 45 08             	mov    0x8(%ebp),%eax
8010233f:	0f b6 00             	movzbl (%eax),%eax
80102342:	84 c0                	test   %al,%al
80102344:	75 e8                	jne    8010232e <skipelem+0x2f>
    path++;
  len = path - s;
80102346:	8b 55 08             	mov    0x8(%ebp),%edx
80102349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010234c:	29 c2                	sub    %eax,%edx
8010234e:	89 d0                	mov    %edx,%eax
80102350:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102353:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102357:	7e 15                	jle    8010236e <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102359:	83 ec 04             	sub    $0x4,%esp
8010235c:	6a 0e                	push   $0xe
8010235e:	ff 75 f4             	pushl  -0xc(%ebp)
80102361:	ff 75 0c             	pushl  0xc(%ebp)
80102364:	e8 dc 33 00 00       	call   80105745 <memmove>
80102369:	83 c4 10             	add    $0x10,%esp
8010236c:	eb 26                	jmp    80102394 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010236e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102371:	83 ec 04             	sub    $0x4,%esp
80102374:	50                   	push   %eax
80102375:	ff 75 f4             	pushl  -0xc(%ebp)
80102378:	ff 75 0c             	pushl  0xc(%ebp)
8010237b:	e8 c5 33 00 00       	call   80105745 <memmove>
80102380:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102383:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102386:	8b 45 0c             	mov    0xc(%ebp),%eax
80102389:	01 d0                	add    %edx,%eax
8010238b:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010238e:	eb 04                	jmp    80102394 <skipelem+0x95>
    path++;
80102390:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102394:	8b 45 08             	mov    0x8(%ebp),%eax
80102397:	0f b6 00             	movzbl (%eax),%eax
8010239a:	3c 2f                	cmp    $0x2f,%al
8010239c:	74 f2                	je     80102390 <skipelem+0x91>
    path++;
  return path;
8010239e:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023a1:	c9                   	leave  
801023a2:	c3                   	ret    

801023a3 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023a3:	55                   	push   %ebp
801023a4:	89 e5                	mov    %esp,%ebp
801023a6:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023a9:	8b 45 08             	mov    0x8(%ebp),%eax
801023ac:	0f b6 00             	movzbl (%eax),%eax
801023af:	3c 2f                	cmp    $0x2f,%al
801023b1:	75 17                	jne    801023ca <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801023b3:	83 ec 08             	sub    $0x8,%esp
801023b6:	6a 01                	push   $0x1
801023b8:	6a 01                	push   $0x1
801023ba:	e8 33 f4 ff ff       	call   801017f2 <iget>
801023bf:	83 c4 10             	add    $0x10,%esp
801023c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023c5:	e9 bb 00 00 00       	jmp    80102485 <namex+0xe2>
  else
    ip = idup(proc->cwd);
801023ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023d0:	8b 40 68             	mov    0x68(%eax),%eax
801023d3:	83 ec 0c             	sub    $0xc,%esp
801023d6:	50                   	push   %eax
801023d7:	e8 f5 f4 ff ff       	call   801018d1 <idup>
801023dc:	83 c4 10             	add    $0x10,%esp
801023df:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801023e2:	e9 9e 00 00 00       	jmp    80102485 <namex+0xe2>
    ilock(ip);
801023e7:	83 ec 0c             	sub    $0xc,%esp
801023ea:	ff 75 f4             	pushl  -0xc(%ebp)
801023ed:	e8 19 f5 ff ff       	call   8010190b <ilock>
801023f2:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023fc:	66 83 f8 01          	cmp    $0x1,%ax
80102400:	74 18                	je     8010241a <namex+0x77>
      iunlockput(ip);
80102402:	83 ec 0c             	sub    $0xc,%esp
80102405:	ff 75 f4             	pushl  -0xc(%ebp)
80102408:	e8 b8 f7 ff ff       	call   80101bc5 <iunlockput>
8010240d:	83 c4 10             	add    $0x10,%esp
      return 0;
80102410:	b8 00 00 00 00       	mov    $0x0,%eax
80102415:	e9 a7 00 00 00       	jmp    801024c1 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
8010241a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010241e:	74 20                	je     80102440 <namex+0x9d>
80102420:	8b 45 08             	mov    0x8(%ebp),%eax
80102423:	0f b6 00             	movzbl (%eax),%eax
80102426:	84 c0                	test   %al,%al
80102428:	75 16                	jne    80102440 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
8010242a:	83 ec 0c             	sub    $0xc,%esp
8010242d:	ff 75 f4             	pushl  -0xc(%ebp)
80102430:	e8 2e f6 ff ff       	call   80101a63 <iunlock>
80102435:	83 c4 10             	add    $0x10,%esp
      return ip;
80102438:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010243b:	e9 81 00 00 00       	jmp    801024c1 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102440:	83 ec 04             	sub    $0x4,%esp
80102443:	6a 00                	push   $0x0
80102445:	ff 75 10             	pushl  0x10(%ebp)
80102448:	ff 75 f4             	pushl  -0xc(%ebp)
8010244b:	e8 1d fd ff ff       	call   8010216d <dirlookup>
80102450:	83 c4 10             	add    $0x10,%esp
80102453:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102456:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010245a:	75 15                	jne    80102471 <namex+0xce>
      iunlockput(ip);
8010245c:	83 ec 0c             	sub    $0xc,%esp
8010245f:	ff 75 f4             	pushl  -0xc(%ebp)
80102462:	e8 5e f7 ff ff       	call   80101bc5 <iunlockput>
80102467:	83 c4 10             	add    $0x10,%esp
      return 0;
8010246a:	b8 00 00 00 00       	mov    $0x0,%eax
8010246f:	eb 50                	jmp    801024c1 <namex+0x11e>
    }
    iunlockput(ip);
80102471:	83 ec 0c             	sub    $0xc,%esp
80102474:	ff 75 f4             	pushl  -0xc(%ebp)
80102477:	e8 49 f7 ff ff       	call   80101bc5 <iunlockput>
8010247c:	83 c4 10             	add    $0x10,%esp
    ip = next;
8010247f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102482:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102485:	83 ec 08             	sub    $0x8,%esp
80102488:	ff 75 10             	pushl  0x10(%ebp)
8010248b:	ff 75 08             	pushl  0x8(%ebp)
8010248e:	e8 6c fe ff ff       	call   801022ff <skipelem>
80102493:	83 c4 10             	add    $0x10,%esp
80102496:	89 45 08             	mov    %eax,0x8(%ebp)
80102499:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010249d:	0f 85 44 ff ff ff    	jne    801023e7 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801024a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024a7:	74 15                	je     801024be <namex+0x11b>
    iput(ip);
801024a9:	83 ec 0c             	sub    $0xc,%esp
801024ac:	ff 75 f4             	pushl  -0xc(%ebp)
801024af:	e8 21 f6 ff ff       	call   80101ad5 <iput>
801024b4:	83 c4 10             	add    $0x10,%esp
    return 0;
801024b7:	b8 00 00 00 00       	mov    $0x0,%eax
801024bc:	eb 03                	jmp    801024c1 <namex+0x11e>
  }
  return ip;
801024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801024c1:	c9                   	leave  
801024c2:	c3                   	ret    

801024c3 <namei>:

struct inode*
namei(char *path)
{
801024c3:	55                   	push   %ebp
801024c4:	89 e5                	mov    %esp,%ebp
801024c6:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024c9:	83 ec 04             	sub    $0x4,%esp
801024cc:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024cf:	50                   	push   %eax
801024d0:	6a 00                	push   $0x0
801024d2:	ff 75 08             	pushl  0x8(%ebp)
801024d5:	e8 c9 fe ff ff       	call   801023a3 <namex>
801024da:	83 c4 10             	add    $0x10,%esp
}
801024dd:	c9                   	leave  
801024de:	c3                   	ret    

801024df <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024df:	55                   	push   %ebp
801024e0:	89 e5                	mov    %esp,%ebp
801024e2:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801024e5:	83 ec 04             	sub    $0x4,%esp
801024e8:	ff 75 0c             	pushl  0xc(%ebp)
801024eb:	6a 01                	push   $0x1
801024ed:	ff 75 08             	pushl  0x8(%ebp)
801024f0:	e8 ae fe ff ff       	call   801023a3 <namex>
801024f5:	83 c4 10             	add    $0x10,%esp
}
801024f8:	c9                   	leave  
801024f9:	c3                   	ret    

801024fa <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801024fa:	55                   	push   %ebp
801024fb:	89 e5                	mov    %esp,%ebp
801024fd:	83 ec 14             	sub    $0x14,%esp
80102500:	8b 45 08             	mov    0x8(%ebp),%eax
80102503:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102507:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010250b:	89 c2                	mov    %eax,%edx
8010250d:	ec                   	in     (%dx),%al
8010250e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102511:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102515:	c9                   	leave  
80102516:	c3                   	ret    

80102517 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102517:	55                   	push   %ebp
80102518:	89 e5                	mov    %esp,%ebp
8010251a:	57                   	push   %edi
8010251b:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010251c:	8b 55 08             	mov    0x8(%ebp),%edx
8010251f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102522:	8b 45 10             	mov    0x10(%ebp),%eax
80102525:	89 cb                	mov    %ecx,%ebx
80102527:	89 df                	mov    %ebx,%edi
80102529:	89 c1                	mov    %eax,%ecx
8010252b:	fc                   	cld    
8010252c:	f3 6d                	rep insl (%dx),%es:(%edi)
8010252e:	89 c8                	mov    %ecx,%eax
80102530:	89 fb                	mov    %edi,%ebx
80102532:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102535:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102538:	90                   	nop
80102539:	5b                   	pop    %ebx
8010253a:	5f                   	pop    %edi
8010253b:	5d                   	pop    %ebp
8010253c:	c3                   	ret    

8010253d <outb>:

static inline void
outb(ushort port, uchar data)
{
8010253d:	55                   	push   %ebp
8010253e:	89 e5                	mov    %esp,%ebp
80102540:	83 ec 08             	sub    $0x8,%esp
80102543:	8b 55 08             	mov    0x8(%ebp),%edx
80102546:	8b 45 0c             	mov    0xc(%ebp),%eax
80102549:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010254d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102550:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102554:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102558:	ee                   	out    %al,(%dx)
}
80102559:	90                   	nop
8010255a:	c9                   	leave  
8010255b:	c3                   	ret    

8010255c <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010255c:	55                   	push   %ebp
8010255d:	89 e5                	mov    %esp,%ebp
8010255f:	56                   	push   %esi
80102560:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102561:	8b 55 08             	mov    0x8(%ebp),%edx
80102564:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102567:	8b 45 10             	mov    0x10(%ebp),%eax
8010256a:	89 cb                	mov    %ecx,%ebx
8010256c:	89 de                	mov    %ebx,%esi
8010256e:	89 c1                	mov    %eax,%ecx
80102570:	fc                   	cld    
80102571:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102573:	89 c8                	mov    %ecx,%eax
80102575:	89 f3                	mov    %esi,%ebx
80102577:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010257a:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010257d:	90                   	nop
8010257e:	5b                   	pop    %ebx
8010257f:	5e                   	pop    %esi
80102580:	5d                   	pop    %ebp
80102581:	c3                   	ret    

80102582 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102582:	55                   	push   %ebp
80102583:	89 e5                	mov    %esp,%ebp
80102585:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102588:	90                   	nop
80102589:	68 f7 01 00 00       	push   $0x1f7
8010258e:	e8 67 ff ff ff       	call   801024fa <inb>
80102593:	83 c4 04             	add    $0x4,%esp
80102596:	0f b6 c0             	movzbl %al,%eax
80102599:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010259c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010259f:	25 c0 00 00 00       	and    $0xc0,%eax
801025a4:	83 f8 40             	cmp    $0x40,%eax
801025a7:	75 e0                	jne    80102589 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025ad:	74 11                	je     801025c0 <idewait+0x3e>
801025af:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025b2:	83 e0 21             	and    $0x21,%eax
801025b5:	85 c0                	test   %eax,%eax
801025b7:	74 07                	je     801025c0 <idewait+0x3e>
    return -1;
801025b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025be:	eb 05                	jmp    801025c5 <idewait+0x43>
  return 0;
801025c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025c5:	c9                   	leave  
801025c6:	c3                   	ret    

801025c7 <ideinit>:

void
ideinit(void)
{
801025c7:	55                   	push   %ebp
801025c8:	89 e5                	mov    %esp,%ebp
801025ca:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
801025cd:	83 ec 08             	sub    $0x8,%esp
801025d0:	68 e4 91 10 80       	push   $0x801091e4
801025d5:	68 20 c6 10 80       	push   $0x8010c620
801025da:	e8 22 2e 00 00       	call   80105401 <initlock>
801025df:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801025e2:	83 ec 0c             	sub    $0xc,%esp
801025e5:	6a 0e                	push   $0xe
801025e7:	e8 90 18 00 00       	call   80103e7c <picenable>
801025ec:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801025ef:	a1 60 39 11 80       	mov    0x80113960,%eax
801025f4:	83 e8 01             	sub    $0x1,%eax
801025f7:	83 ec 08             	sub    $0x8,%esp
801025fa:	50                   	push   %eax
801025fb:	6a 0e                	push   $0xe
801025fd:	e8 37 04 00 00       	call   80102a39 <ioapicenable>
80102602:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102605:	83 ec 0c             	sub    $0xc,%esp
80102608:	6a 00                	push   $0x0
8010260a:	e8 73 ff ff ff       	call   80102582 <idewait>
8010260f:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102612:	83 ec 08             	sub    $0x8,%esp
80102615:	68 f0 00 00 00       	push   $0xf0
8010261a:	68 f6 01 00 00       	push   $0x1f6
8010261f:	e8 19 ff ff ff       	call   8010253d <outb>
80102624:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102627:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010262e:	eb 24                	jmp    80102654 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	68 f7 01 00 00       	push   $0x1f7
80102638:	e8 bd fe ff ff       	call   801024fa <inb>
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	84 c0                	test   %al,%al
80102642:	74 0c                	je     80102650 <ideinit+0x89>
      havedisk1 = 1;
80102644:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
8010264b:	00 00 00 
      break;
8010264e:	eb 0d                	jmp    8010265d <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102650:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102654:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010265b:	7e d3                	jle    80102630 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010265d:	83 ec 08             	sub    $0x8,%esp
80102660:	68 e0 00 00 00       	push   $0xe0
80102665:	68 f6 01 00 00       	push   $0x1f6
8010266a:	e8 ce fe ff ff       	call   8010253d <outb>
8010266f:	83 c4 10             	add    $0x10,%esp
}
80102672:	90                   	nop
80102673:	c9                   	leave  
80102674:	c3                   	ret    

80102675 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
80102678:	83 ec 08             	sub    $0x8,%esp
  if(b == 0)
8010267b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010267f:	75 0d                	jne    8010268e <idestart+0x19>
    panic("idestart");
80102681:	83 ec 0c             	sub    $0xc,%esp
80102684:	68 e8 91 10 80       	push   $0x801091e8
80102689:	e8 d8 de ff ff       	call   80100566 <panic>

  idewait(0);
8010268e:	83 ec 0c             	sub    $0xc,%esp
80102691:	6a 00                	push   $0x0
80102693:	e8 ea fe ff ff       	call   80102582 <idewait>
80102698:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
8010269b:	83 ec 08             	sub    $0x8,%esp
8010269e:	6a 00                	push   $0x0
801026a0:	68 f6 03 00 00       	push   $0x3f6
801026a5:	e8 93 fe ff ff       	call   8010253d <outb>
801026aa:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, 1);  // number of sectors
801026ad:	83 ec 08             	sub    $0x8,%esp
801026b0:	6a 01                	push   $0x1
801026b2:	68 f2 01 00 00       	push   $0x1f2
801026b7:	e8 81 fe ff ff       	call   8010253d <outb>
801026bc:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, b->sector & 0xff);
801026bf:	8b 45 08             	mov    0x8(%ebp),%eax
801026c2:	8b 40 08             	mov    0x8(%eax),%eax
801026c5:	0f b6 c0             	movzbl %al,%eax
801026c8:	83 ec 08             	sub    $0x8,%esp
801026cb:	50                   	push   %eax
801026cc:	68 f3 01 00 00       	push   $0x1f3
801026d1:	e8 67 fe ff ff       	call   8010253d <outb>
801026d6:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (b->sector >> 8) & 0xff);
801026d9:	8b 45 08             	mov    0x8(%ebp),%eax
801026dc:	8b 40 08             	mov    0x8(%eax),%eax
801026df:	c1 e8 08             	shr    $0x8,%eax
801026e2:	0f b6 c0             	movzbl %al,%eax
801026e5:	83 ec 08             	sub    $0x8,%esp
801026e8:	50                   	push   %eax
801026e9:	68 f4 01 00 00       	push   $0x1f4
801026ee:	e8 4a fe ff ff       	call   8010253d <outb>
801026f3:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (b->sector >> 16) & 0xff);
801026f6:	8b 45 08             	mov    0x8(%ebp),%eax
801026f9:	8b 40 08             	mov    0x8(%eax),%eax
801026fc:	c1 e8 10             	shr    $0x10,%eax
801026ff:	0f b6 c0             	movzbl %al,%eax
80102702:	83 ec 08             	sub    $0x8,%esp
80102705:	50                   	push   %eax
80102706:	68 f5 01 00 00       	push   $0x1f5
8010270b:	e8 2d fe ff ff       	call   8010253d <outb>
80102710:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102713:	8b 45 08             	mov    0x8(%ebp),%eax
80102716:	8b 40 04             	mov    0x4(%eax),%eax
80102719:	83 e0 01             	and    $0x1,%eax
8010271c:	c1 e0 04             	shl    $0x4,%eax
8010271f:	89 c2                	mov    %eax,%edx
80102721:	8b 45 08             	mov    0x8(%ebp),%eax
80102724:	8b 40 08             	mov    0x8(%eax),%eax
80102727:	c1 e8 18             	shr    $0x18,%eax
8010272a:	83 e0 0f             	and    $0xf,%eax
8010272d:	09 d0                	or     %edx,%eax
8010272f:	83 c8 e0             	or     $0xffffffe0,%eax
80102732:	0f b6 c0             	movzbl %al,%eax
80102735:	83 ec 08             	sub    $0x8,%esp
80102738:	50                   	push   %eax
80102739:	68 f6 01 00 00       	push   $0x1f6
8010273e:	e8 fa fd ff ff       	call   8010253d <outb>
80102743:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102746:	8b 45 08             	mov    0x8(%ebp),%eax
80102749:	8b 00                	mov    (%eax),%eax
8010274b:	83 e0 04             	and    $0x4,%eax
8010274e:	85 c0                	test   %eax,%eax
80102750:	74 30                	je     80102782 <idestart+0x10d>
    outb(0x1f7, IDE_CMD_WRITE);
80102752:	83 ec 08             	sub    $0x8,%esp
80102755:	6a 30                	push   $0x30
80102757:	68 f7 01 00 00       	push   $0x1f7
8010275c:	e8 dc fd ff ff       	call   8010253d <outb>
80102761:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, 512/4);
80102764:	8b 45 08             	mov    0x8(%ebp),%eax
80102767:	83 c0 18             	add    $0x18,%eax
8010276a:	83 ec 04             	sub    $0x4,%esp
8010276d:	68 80 00 00 00       	push   $0x80
80102772:	50                   	push   %eax
80102773:	68 f0 01 00 00       	push   $0x1f0
80102778:	e8 df fd ff ff       	call   8010255c <outsl>
8010277d:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102780:	eb 12                	jmp    80102794 <idestart+0x11f>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102782:	83 ec 08             	sub    $0x8,%esp
80102785:	6a 20                	push   $0x20
80102787:	68 f7 01 00 00       	push   $0x1f7
8010278c:	e8 ac fd ff ff       	call   8010253d <outb>
80102791:	83 c4 10             	add    $0x10,%esp
  }
}
80102794:	90                   	nop
80102795:	c9                   	leave  
80102796:	c3                   	ret    

80102797 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102797:	55                   	push   %ebp
80102798:	89 e5                	mov    %esp,%ebp
8010279a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010279d:	83 ec 0c             	sub    $0xc,%esp
801027a0:	68 20 c6 10 80       	push   $0x8010c620
801027a5:	e8 79 2c 00 00       	call   80105423 <acquire>
801027aa:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801027ad:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027b9:	75 15                	jne    801027d0 <ideintr+0x39>
    release(&idelock);
801027bb:	83 ec 0c             	sub    $0xc,%esp
801027be:	68 20 c6 10 80       	push   $0x8010c620
801027c3:	e8 c2 2c 00 00       	call   8010548a <release>
801027c8:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
801027cb:	e9 9a 00 00 00       	jmp    8010286a <ideintr+0xd3>
  }
  idequeue = b->qnext;
801027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d3:	8b 40 14             	mov    0x14(%eax),%eax
801027d6:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027de:	8b 00                	mov    (%eax),%eax
801027e0:	83 e0 04             	and    $0x4,%eax
801027e3:	85 c0                	test   %eax,%eax
801027e5:	75 2d                	jne    80102814 <ideintr+0x7d>
801027e7:	83 ec 0c             	sub    $0xc,%esp
801027ea:	6a 01                	push   $0x1
801027ec:	e8 91 fd ff ff       	call   80102582 <idewait>
801027f1:	83 c4 10             	add    $0x10,%esp
801027f4:	85 c0                	test   %eax,%eax
801027f6:	78 1c                	js     80102814 <ideintr+0x7d>
    insl(0x1f0, b->data, 512/4);
801027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fb:	83 c0 18             	add    $0x18,%eax
801027fe:	83 ec 04             	sub    $0x4,%esp
80102801:	68 80 00 00 00       	push   $0x80
80102806:	50                   	push   %eax
80102807:	68 f0 01 00 00       	push   $0x1f0
8010280c:	e8 06 fd ff ff       	call   80102517 <insl>
80102811:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102817:	8b 00                	mov    (%eax),%eax
80102819:	83 c8 02             	or     $0x2,%eax
8010281c:	89 c2                	mov    %eax,%edx
8010281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102821:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102823:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102826:	8b 00                	mov    (%eax),%eax
80102828:	83 e0 fb             	and    $0xfffffffb,%eax
8010282b:	89 c2                	mov    %eax,%edx
8010282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102830:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102832:	83 ec 0c             	sub    $0xc,%esp
80102835:	ff 75 f4             	pushl  -0xc(%ebp)
80102838:	e8 30 25 00 00       	call   80104d6d <wakeup>
8010283d:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102840:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102845:	85 c0                	test   %eax,%eax
80102847:	74 11                	je     8010285a <ideintr+0xc3>
    idestart(idequeue);
80102849:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010284e:	83 ec 0c             	sub    $0xc,%esp
80102851:	50                   	push   %eax
80102852:	e8 1e fe ff ff       	call   80102675 <idestart>
80102857:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
8010285a:	83 ec 0c             	sub    $0xc,%esp
8010285d:	68 20 c6 10 80       	push   $0x8010c620
80102862:	e8 23 2c 00 00       	call   8010548a <release>
80102867:	83 c4 10             	add    $0x10,%esp
}
8010286a:	c9                   	leave  
8010286b:	c3                   	ret    

8010286c <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010286c:	55                   	push   %ebp
8010286d:	89 e5                	mov    %esp,%ebp
8010286f:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102872:	8b 45 08             	mov    0x8(%ebp),%eax
80102875:	8b 00                	mov    (%eax),%eax
80102877:	83 e0 01             	and    $0x1,%eax
8010287a:	85 c0                	test   %eax,%eax
8010287c:	75 0d                	jne    8010288b <iderw+0x1f>
    panic("iderw: buf not busy");
8010287e:	83 ec 0c             	sub    $0xc,%esp
80102881:	68 f1 91 10 80       	push   $0x801091f1
80102886:	e8 db dc ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010288b:	8b 45 08             	mov    0x8(%ebp),%eax
8010288e:	8b 00                	mov    (%eax),%eax
80102890:	83 e0 06             	and    $0x6,%eax
80102893:	83 f8 02             	cmp    $0x2,%eax
80102896:	75 0d                	jne    801028a5 <iderw+0x39>
    panic("iderw: nothing to do");
80102898:	83 ec 0c             	sub    $0xc,%esp
8010289b:	68 05 92 10 80       	push   $0x80109205
801028a0:	e8 c1 dc ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
801028a5:	8b 45 08             	mov    0x8(%ebp),%eax
801028a8:	8b 40 04             	mov    0x4(%eax),%eax
801028ab:	85 c0                	test   %eax,%eax
801028ad:	74 16                	je     801028c5 <iderw+0x59>
801028af:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801028b4:	85 c0                	test   %eax,%eax
801028b6:	75 0d                	jne    801028c5 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801028b8:	83 ec 0c             	sub    $0xc,%esp
801028bb:	68 1a 92 10 80       	push   $0x8010921a
801028c0:	e8 a1 dc ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028c5:	83 ec 0c             	sub    $0xc,%esp
801028c8:	68 20 c6 10 80       	push   $0x8010c620
801028cd:	e8 51 2b 00 00       	call   80105423 <acquire>
801028d2:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801028d5:	8b 45 08             	mov    0x8(%ebp),%eax
801028d8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028df:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
801028e6:	eb 0b                	jmp    801028f3 <iderw+0x87>
801028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028eb:	8b 00                	mov    (%eax),%eax
801028ed:	83 c0 14             	add    $0x14,%eax
801028f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f6:	8b 00                	mov    (%eax),%eax
801028f8:	85 c0                	test   %eax,%eax
801028fa:	75 ec                	jne    801028e8 <iderw+0x7c>
    ;
  *pp = b;
801028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ff:	8b 55 08             	mov    0x8(%ebp),%edx
80102902:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102904:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102909:	3b 45 08             	cmp    0x8(%ebp),%eax
8010290c:	75 23                	jne    80102931 <iderw+0xc5>
    idestart(b);
8010290e:	83 ec 0c             	sub    $0xc,%esp
80102911:	ff 75 08             	pushl  0x8(%ebp)
80102914:	e8 5c fd ff ff       	call   80102675 <idestart>
80102919:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010291c:	eb 13                	jmp    80102931 <iderw+0xc5>
    sleep(b, &idelock);
8010291e:	83 ec 08             	sub    $0x8,%esp
80102921:	68 20 c6 10 80       	push   $0x8010c620
80102926:	ff 75 08             	pushl  0x8(%ebp)
80102929:	e8 51 23 00 00       	call   80104c7f <sleep>
8010292e:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102931:	8b 45 08             	mov    0x8(%ebp),%eax
80102934:	8b 00                	mov    (%eax),%eax
80102936:	83 e0 06             	and    $0x6,%eax
80102939:	83 f8 02             	cmp    $0x2,%eax
8010293c:	75 e0                	jne    8010291e <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
8010293e:	83 ec 0c             	sub    $0xc,%esp
80102941:	68 20 c6 10 80       	push   $0x8010c620
80102946:	e8 3f 2b 00 00       	call   8010548a <release>
8010294b:	83 c4 10             	add    $0x10,%esp
}
8010294e:	90                   	nop
8010294f:	c9                   	leave  
80102950:	c3                   	ret    

80102951 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102951:	55                   	push   %ebp
80102952:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102954:	a1 34 32 11 80       	mov    0x80113234,%eax
80102959:	8b 55 08             	mov    0x8(%ebp),%edx
8010295c:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
8010295e:	a1 34 32 11 80       	mov    0x80113234,%eax
80102963:	8b 40 10             	mov    0x10(%eax),%eax
}
80102966:	5d                   	pop    %ebp
80102967:	c3                   	ret    

80102968 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102968:	55                   	push   %ebp
80102969:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010296b:	a1 34 32 11 80       	mov    0x80113234,%eax
80102970:	8b 55 08             	mov    0x8(%ebp),%edx
80102973:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102975:	a1 34 32 11 80       	mov    0x80113234,%eax
8010297a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010297d:	89 50 10             	mov    %edx,0x10(%eax)
}
80102980:	90                   	nop
80102981:	5d                   	pop    %ebp
80102982:	c3                   	ret    

80102983 <ioapicinit>:

void
ioapicinit(void)
{
80102983:	55                   	push   %ebp
80102984:	89 e5                	mov    %esp,%ebp
80102986:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102989:	a1 64 33 11 80       	mov    0x80113364,%eax
8010298e:	85 c0                	test   %eax,%eax
80102990:	0f 84 a0 00 00 00    	je     80102a36 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102996:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
8010299d:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029a0:	6a 01                	push   $0x1
801029a2:	e8 aa ff ff ff       	call   80102951 <ioapicread>
801029a7:	83 c4 04             	add    $0x4,%esp
801029aa:	c1 e8 10             	shr    $0x10,%eax
801029ad:	25 ff 00 00 00       	and    $0xff,%eax
801029b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801029b5:	6a 00                	push   $0x0
801029b7:	e8 95 ff ff ff       	call   80102951 <ioapicread>
801029bc:	83 c4 04             	add    $0x4,%esp
801029bf:	c1 e8 18             	shr    $0x18,%eax
801029c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801029c5:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
801029cc:	0f b6 c0             	movzbl %al,%eax
801029cf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801029d2:	74 10                	je     801029e4 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029d4:	83 ec 0c             	sub    $0xc,%esp
801029d7:	68 38 92 10 80       	push   $0x80109238
801029dc:	e8 e5 d9 ff ff       	call   801003c6 <cprintf>
801029e1:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029eb:	eb 3f                	jmp    80102a2c <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f0:	83 c0 20             	add    $0x20,%eax
801029f3:	0d 00 00 01 00       	or     $0x10000,%eax
801029f8:	89 c2                	mov    %eax,%edx
801029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029fd:	83 c0 08             	add    $0x8,%eax
80102a00:	01 c0                	add    %eax,%eax
80102a02:	83 ec 08             	sub    $0x8,%esp
80102a05:	52                   	push   %edx
80102a06:	50                   	push   %eax
80102a07:	e8 5c ff ff ff       	call   80102968 <ioapicwrite>
80102a0c:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a12:	83 c0 08             	add    $0x8,%eax
80102a15:	01 c0                	add    %eax,%eax
80102a17:	83 c0 01             	add    $0x1,%eax
80102a1a:	83 ec 08             	sub    $0x8,%esp
80102a1d:	6a 00                	push   $0x0
80102a1f:	50                   	push   %eax
80102a20:	e8 43 ff ff ff       	call   80102968 <ioapicwrite>
80102a25:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a28:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a2f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a32:	7e b9                	jle    801029ed <ioapicinit+0x6a>
80102a34:	eb 01                	jmp    80102a37 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102a36:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a37:	c9                   	leave  
80102a38:	c3                   	ret    

80102a39 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a39:	55                   	push   %ebp
80102a3a:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102a3c:	a1 64 33 11 80       	mov    0x80113364,%eax
80102a41:	85 c0                	test   %eax,%eax
80102a43:	74 39                	je     80102a7e <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a45:	8b 45 08             	mov    0x8(%ebp),%eax
80102a48:	83 c0 20             	add    $0x20,%eax
80102a4b:	89 c2                	mov    %eax,%edx
80102a4d:	8b 45 08             	mov    0x8(%ebp),%eax
80102a50:	83 c0 08             	add    $0x8,%eax
80102a53:	01 c0                	add    %eax,%eax
80102a55:	52                   	push   %edx
80102a56:	50                   	push   %eax
80102a57:	e8 0c ff ff ff       	call   80102968 <ioapicwrite>
80102a5c:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a62:	c1 e0 18             	shl    $0x18,%eax
80102a65:	89 c2                	mov    %eax,%edx
80102a67:	8b 45 08             	mov    0x8(%ebp),%eax
80102a6a:	83 c0 08             	add    $0x8,%eax
80102a6d:	01 c0                	add    %eax,%eax
80102a6f:	83 c0 01             	add    $0x1,%eax
80102a72:	52                   	push   %edx
80102a73:	50                   	push   %eax
80102a74:	e8 ef fe ff ff       	call   80102968 <ioapicwrite>
80102a79:	83 c4 08             	add    $0x8,%esp
80102a7c:	eb 01                	jmp    80102a7f <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102a7e:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102a7f:	c9                   	leave  
80102a80:	c3                   	ret    

80102a81 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a81:	55                   	push   %ebp
80102a82:	89 e5                	mov    %esp,%ebp
80102a84:	8b 45 08             	mov    0x8(%ebp),%eax
80102a87:	05 00 00 00 80       	add    $0x80000000,%eax
80102a8c:	5d                   	pop    %ebp
80102a8d:	c3                   	ret    

80102a8e <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a8e:	55                   	push   %ebp
80102a8f:	89 e5                	mov    %esp,%ebp
80102a91:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102a94:	83 ec 08             	sub    $0x8,%esp
80102a97:	68 6a 92 10 80       	push   $0x8010926a
80102a9c:	68 40 32 11 80       	push   $0x80113240
80102aa1:	e8 5b 29 00 00       	call   80105401 <initlock>
80102aa6:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102aa9:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
80102ab0:	00 00 00 
  freerange(vstart, vend);
80102ab3:	83 ec 08             	sub    $0x8,%esp
80102ab6:	ff 75 0c             	pushl  0xc(%ebp)
80102ab9:	ff 75 08             	pushl  0x8(%ebp)
80102abc:	e8 2a 00 00 00       	call   80102aeb <freerange>
80102ac1:	83 c4 10             	add    $0x10,%esp
}
80102ac4:	90                   	nop
80102ac5:	c9                   	leave  
80102ac6:	c3                   	ret    

80102ac7 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102ac7:	55                   	push   %ebp
80102ac8:	89 e5                	mov    %esp,%ebp
80102aca:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102acd:	83 ec 08             	sub    $0x8,%esp
80102ad0:	ff 75 0c             	pushl  0xc(%ebp)
80102ad3:	ff 75 08             	pushl  0x8(%ebp)
80102ad6:	e8 10 00 00 00       	call   80102aeb <freerange>
80102adb:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102ade:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
80102ae5:	00 00 00 
}
80102ae8:	90                   	nop
80102ae9:	c9                   	leave  
80102aea:	c3                   	ret    

80102aeb <freerange>:

void
freerange(void *vstart, void *vend)
{
80102aeb:	55                   	push   %ebp
80102aec:	89 e5                	mov    %esp,%ebp
80102aee:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102af1:	8b 45 08             	mov    0x8(%ebp),%eax
80102af4:	05 ff 0f 00 00       	add    $0xfff,%eax
80102af9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b01:	eb 15                	jmp    80102b18 <freerange+0x2d>
    kfree(p);
80102b03:	83 ec 0c             	sub    $0xc,%esp
80102b06:	ff 75 f4             	pushl  -0xc(%ebp)
80102b09:	e8 1a 00 00 00       	call   80102b28 <kfree>
80102b0e:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b11:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b1b:	05 00 10 00 00       	add    $0x1000,%eax
80102b20:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102b23:	76 de                	jbe    80102b03 <freerange+0x18>
    kfree(p);
}
80102b25:	90                   	nop
80102b26:	c9                   	leave  
80102b27:	c3                   	ret    

80102b28 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b28:	55                   	push   %ebp
80102b29:	89 e5                	mov    %esp,%ebp
80102b2b:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102b2e:	8b 45 08             	mov    0x8(%ebp),%eax
80102b31:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b36:	85 c0                	test   %eax,%eax
80102b38:	75 1b                	jne    80102b55 <kfree+0x2d>
80102b3a:	81 7d 08 e0 8a 11 80 	cmpl   $0x80118ae0,0x8(%ebp)
80102b41:	72 12                	jb     80102b55 <kfree+0x2d>
80102b43:	ff 75 08             	pushl  0x8(%ebp)
80102b46:	e8 36 ff ff ff       	call   80102a81 <v2p>
80102b4b:	83 c4 04             	add    $0x4,%esp
80102b4e:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b53:	76 0d                	jbe    80102b62 <kfree+0x3a>
    panic("kfree");
80102b55:	83 ec 0c             	sub    $0xc,%esp
80102b58:	68 6f 92 10 80       	push   $0x8010926f
80102b5d:	e8 04 da ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b62:	83 ec 04             	sub    $0x4,%esp
80102b65:	68 00 10 00 00       	push   $0x1000
80102b6a:	6a 01                	push   $0x1
80102b6c:	ff 75 08             	pushl  0x8(%ebp)
80102b6f:	e8 12 2b 00 00       	call   80105686 <memset>
80102b74:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102b77:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b7c:	85 c0                	test   %eax,%eax
80102b7e:	74 10                	je     80102b90 <kfree+0x68>
    acquire(&kmem.lock);
80102b80:	83 ec 0c             	sub    $0xc,%esp
80102b83:	68 40 32 11 80       	push   $0x80113240
80102b88:	e8 96 28 00 00       	call   80105423 <acquire>
80102b8d:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102b90:	8b 45 08             	mov    0x8(%ebp),%eax
80102b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b96:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b9f:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba4:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102ba9:	a1 74 32 11 80       	mov    0x80113274,%eax
80102bae:	85 c0                	test   %eax,%eax
80102bb0:	74 10                	je     80102bc2 <kfree+0x9a>
    release(&kmem.lock);
80102bb2:	83 ec 0c             	sub    $0xc,%esp
80102bb5:	68 40 32 11 80       	push   $0x80113240
80102bba:	e8 cb 28 00 00       	call   8010548a <release>
80102bbf:	83 c4 10             	add    $0x10,%esp
}
80102bc2:	90                   	nop
80102bc3:	c9                   	leave  
80102bc4:	c3                   	ret    

80102bc5 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102bc5:	55                   	push   %ebp
80102bc6:	89 e5                	mov    %esp,%ebp
80102bc8:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102bcb:	a1 74 32 11 80       	mov    0x80113274,%eax
80102bd0:	85 c0                	test   %eax,%eax
80102bd2:	74 10                	je     80102be4 <kalloc+0x1f>
    acquire(&kmem.lock);
80102bd4:	83 ec 0c             	sub    $0xc,%esp
80102bd7:	68 40 32 11 80       	push   $0x80113240
80102bdc:	e8 42 28 00 00       	call   80105423 <acquire>
80102be1:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102be4:	a1 78 32 11 80       	mov    0x80113278,%eax
80102be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102bf0:	74 0a                	je     80102bfc <kalloc+0x37>
    kmem.freelist = r->next;
80102bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bf5:	8b 00                	mov    (%eax),%eax
80102bf7:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102bfc:	a1 74 32 11 80       	mov    0x80113274,%eax
80102c01:	85 c0                	test   %eax,%eax
80102c03:	74 10                	je     80102c15 <kalloc+0x50>
    release(&kmem.lock);
80102c05:	83 ec 0c             	sub    $0xc,%esp
80102c08:	68 40 32 11 80       	push   $0x80113240
80102c0d:	e8 78 28 00 00       	call   8010548a <release>
80102c12:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c18:	c9                   	leave  
80102c19:	c3                   	ret    

80102c1a <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c1a:	55                   	push   %ebp
80102c1b:	89 e5                	mov    %esp,%ebp
80102c1d:	83 ec 14             	sub    $0x14,%esp
80102c20:	8b 45 08             	mov    0x8(%ebp),%eax
80102c23:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c27:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c2b:	89 c2                	mov    %eax,%edx
80102c2d:	ec                   	in     (%dx),%al
80102c2e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c31:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c35:	c9                   	leave  
80102c36:	c3                   	ret    

80102c37 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c37:	55                   	push   %ebp
80102c38:	89 e5                	mov    %esp,%ebp
80102c3a:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c3d:	6a 64                	push   $0x64
80102c3f:	e8 d6 ff ff ff       	call   80102c1a <inb>
80102c44:	83 c4 04             	add    $0x4,%esp
80102c47:	0f b6 c0             	movzbl %al,%eax
80102c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c50:	83 e0 01             	and    $0x1,%eax
80102c53:	85 c0                	test   %eax,%eax
80102c55:	75 0a                	jne    80102c61 <kbdgetc+0x2a>
    return -1;
80102c57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c5c:	e9 23 01 00 00       	jmp    80102d84 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102c61:	6a 60                	push   $0x60
80102c63:	e8 b2 ff ff ff       	call   80102c1a <inb>
80102c68:	83 c4 04             	add    $0x4,%esp
80102c6b:	0f b6 c0             	movzbl %al,%eax
80102c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c71:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c78:	75 17                	jne    80102c91 <kbdgetc+0x5a>
    shift |= E0ESC;
80102c7a:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c7f:	83 c8 40             	or     $0x40,%eax
80102c82:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102c87:	b8 00 00 00 00       	mov    $0x0,%eax
80102c8c:	e9 f3 00 00 00       	jmp    80102d84 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c94:	25 80 00 00 00       	and    $0x80,%eax
80102c99:	85 c0                	test   %eax,%eax
80102c9b:	74 45                	je     80102ce2 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c9d:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102ca2:	83 e0 40             	and    $0x40,%eax
80102ca5:	85 c0                	test   %eax,%eax
80102ca7:	75 08                	jne    80102cb1 <kbdgetc+0x7a>
80102ca9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cac:	83 e0 7f             	and    $0x7f,%eax
80102caf:	eb 03                	jmp    80102cb4 <kbdgetc+0x7d>
80102cb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102cb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cba:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102cbf:	0f b6 00             	movzbl (%eax),%eax
80102cc2:	83 c8 40             	or     $0x40,%eax
80102cc5:	0f b6 c0             	movzbl %al,%eax
80102cc8:	f7 d0                	not    %eax
80102cca:	89 c2                	mov    %eax,%edx
80102ccc:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cd1:	21 d0                	and    %edx,%eax
80102cd3:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102cd8:	b8 00 00 00 00       	mov    $0x0,%eax
80102cdd:	e9 a2 00 00 00       	jmp    80102d84 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102ce2:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102ce7:	83 e0 40             	and    $0x40,%eax
80102cea:	85 c0                	test   %eax,%eax
80102cec:	74 14                	je     80102d02 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102cee:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102cf5:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cfa:	83 e0 bf             	and    $0xffffffbf,%eax
80102cfd:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d05:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102d0a:	0f b6 00             	movzbl (%eax),%eax
80102d0d:	0f b6 d0             	movzbl %al,%edx
80102d10:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d15:	09 d0                	or     %edx,%eax
80102d17:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d1f:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102d24:	0f b6 00             	movzbl (%eax),%eax
80102d27:	0f b6 d0             	movzbl %al,%edx
80102d2a:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d2f:	31 d0                	xor    %edx,%eax
80102d31:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d36:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d3b:	83 e0 03             	and    $0x3,%eax
80102d3e:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d48:	01 d0                	add    %edx,%eax
80102d4a:	0f b6 00             	movzbl (%eax),%eax
80102d4d:	0f b6 c0             	movzbl %al,%eax
80102d50:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d53:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d58:	83 e0 08             	and    $0x8,%eax
80102d5b:	85 c0                	test   %eax,%eax
80102d5d:	74 22                	je     80102d81 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102d5f:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d63:	76 0c                	jbe    80102d71 <kbdgetc+0x13a>
80102d65:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d69:	77 06                	ja     80102d71 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102d6b:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d6f:	eb 10                	jmp    80102d81 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102d71:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d75:	76 0a                	jbe    80102d81 <kbdgetc+0x14a>
80102d77:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d7b:	77 04                	ja     80102d81 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102d7d:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d84:	c9                   	leave  
80102d85:	c3                   	ret    

80102d86 <kbdintr>:

void
kbdintr(void)
{
80102d86:	55                   	push   %ebp
80102d87:	89 e5                	mov    %esp,%ebp
80102d89:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102d8c:	83 ec 0c             	sub    $0xc,%esp
80102d8f:	68 37 2c 10 80       	push   $0x80102c37
80102d94:	e8 44 da ff ff       	call   801007dd <consoleintr>
80102d99:	83 c4 10             	add    $0x10,%esp
}
80102d9c:	90                   	nop
80102d9d:	c9                   	leave  
80102d9e:	c3                   	ret    

80102d9f <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102d9f:	55                   	push   %ebp
80102da0:	89 e5                	mov    %esp,%ebp
80102da2:	83 ec 14             	sub    $0x14,%esp
80102da5:	8b 45 08             	mov    0x8(%ebp),%eax
80102da8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dac:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102db0:	89 c2                	mov    %eax,%edx
80102db2:	ec                   	in     (%dx),%al
80102db3:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102db6:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102dba:	c9                   	leave  
80102dbb:	c3                   	ret    

80102dbc <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102dbc:	55                   	push   %ebp
80102dbd:	89 e5                	mov    %esp,%ebp
80102dbf:	83 ec 08             	sub    $0x8,%esp
80102dc2:	8b 55 08             	mov    0x8(%ebp),%edx
80102dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dc8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102dcc:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dcf:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102dd3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102dd7:	ee                   	out    %al,(%dx)
}
80102dd8:	90                   	nop
80102dd9:	c9                   	leave  
80102dda:	c3                   	ret    

80102ddb <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102ddb:	55                   	push   %ebp
80102ddc:	89 e5                	mov    %esp,%ebp
80102dde:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102de1:	9c                   	pushf  
80102de2:	58                   	pop    %eax
80102de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102de6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102de9:	c9                   	leave  
80102dea:	c3                   	ret    

80102deb <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102deb:	55                   	push   %ebp
80102dec:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102dee:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102df3:	8b 55 08             	mov    0x8(%ebp),%edx
80102df6:	c1 e2 02             	shl    $0x2,%edx
80102df9:	01 c2                	add    %eax,%edx
80102dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dfe:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e00:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e05:	83 c0 20             	add    $0x20,%eax
80102e08:	8b 00                	mov    (%eax),%eax
}
80102e0a:	90                   	nop
80102e0b:	5d                   	pop    %ebp
80102e0c:	c3                   	ret    

80102e0d <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102e0d:	55                   	push   %ebp
80102e0e:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102e10:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e15:	85 c0                	test   %eax,%eax
80102e17:	0f 84 0b 01 00 00    	je     80102f28 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e1d:	68 3f 01 00 00       	push   $0x13f
80102e22:	6a 3c                	push   $0x3c
80102e24:	e8 c2 ff ff ff       	call   80102deb <lapicw>
80102e29:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e2c:	6a 0b                	push   $0xb
80102e2e:	68 f8 00 00 00       	push   $0xf8
80102e33:	e8 b3 ff ff ff       	call   80102deb <lapicw>
80102e38:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e3b:	68 20 00 02 00       	push   $0x20020
80102e40:	68 c8 00 00 00       	push   $0xc8
80102e45:	e8 a1 ff ff ff       	call   80102deb <lapicw>
80102e4a:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102e4d:	68 80 96 98 00       	push   $0x989680
80102e52:	68 e0 00 00 00       	push   $0xe0
80102e57:	e8 8f ff ff ff       	call   80102deb <lapicw>
80102e5c:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e5f:	68 00 00 01 00       	push   $0x10000
80102e64:	68 d4 00 00 00       	push   $0xd4
80102e69:	e8 7d ff ff ff       	call   80102deb <lapicw>
80102e6e:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102e71:	68 00 00 01 00       	push   $0x10000
80102e76:	68 d8 00 00 00       	push   $0xd8
80102e7b:	e8 6b ff ff ff       	call   80102deb <lapicw>
80102e80:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e83:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e88:	83 c0 30             	add    $0x30,%eax
80102e8b:	8b 00                	mov    (%eax),%eax
80102e8d:	c1 e8 10             	shr    $0x10,%eax
80102e90:	0f b6 c0             	movzbl %al,%eax
80102e93:	83 f8 03             	cmp    $0x3,%eax
80102e96:	76 12                	jbe    80102eaa <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102e98:	68 00 00 01 00       	push   $0x10000
80102e9d:	68 d0 00 00 00       	push   $0xd0
80102ea2:	e8 44 ff ff ff       	call   80102deb <lapicw>
80102ea7:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102eaa:	6a 33                	push   $0x33
80102eac:	68 dc 00 00 00       	push   $0xdc
80102eb1:	e8 35 ff ff ff       	call   80102deb <lapicw>
80102eb6:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102eb9:	6a 00                	push   $0x0
80102ebb:	68 a0 00 00 00       	push   $0xa0
80102ec0:	e8 26 ff ff ff       	call   80102deb <lapicw>
80102ec5:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102ec8:	6a 00                	push   $0x0
80102eca:	68 a0 00 00 00       	push   $0xa0
80102ecf:	e8 17 ff ff ff       	call   80102deb <lapicw>
80102ed4:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102ed7:	6a 00                	push   $0x0
80102ed9:	6a 2c                	push   $0x2c
80102edb:	e8 0b ff ff ff       	call   80102deb <lapicw>
80102ee0:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ee3:	6a 00                	push   $0x0
80102ee5:	68 c4 00 00 00       	push   $0xc4
80102eea:	e8 fc fe ff ff       	call   80102deb <lapicw>
80102eef:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102ef2:	68 00 85 08 00       	push   $0x88500
80102ef7:	68 c0 00 00 00       	push   $0xc0
80102efc:	e8 ea fe ff ff       	call   80102deb <lapicw>
80102f01:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102f04:	90                   	nop
80102f05:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f0a:	05 00 03 00 00       	add    $0x300,%eax
80102f0f:	8b 00                	mov    (%eax),%eax
80102f11:	25 00 10 00 00       	and    $0x1000,%eax
80102f16:	85 c0                	test   %eax,%eax
80102f18:	75 eb                	jne    80102f05 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f1a:	6a 00                	push   $0x0
80102f1c:	6a 20                	push   $0x20
80102f1e:	e8 c8 fe ff ff       	call   80102deb <lapicw>
80102f23:	83 c4 08             	add    $0x8,%esp
80102f26:	eb 01                	jmp    80102f29 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102f28:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f29:	c9                   	leave  
80102f2a:	c3                   	ret    

80102f2b <cpunum>:

int
cpunum(void)
{
80102f2b:	55                   	push   %ebp
80102f2c:	89 e5                	mov    %esp,%ebp
80102f2e:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f31:	e8 a5 fe ff ff       	call   80102ddb <readeflags>
80102f36:	25 00 02 00 00       	and    $0x200,%eax
80102f3b:	85 c0                	test   %eax,%eax
80102f3d:	74 26                	je     80102f65 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102f3f:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102f44:	8d 50 01             	lea    0x1(%eax),%edx
80102f47:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80102f4d:	85 c0                	test   %eax,%eax
80102f4f:	75 14                	jne    80102f65 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f51:	8b 45 04             	mov    0x4(%ebp),%eax
80102f54:	83 ec 08             	sub    $0x8,%esp
80102f57:	50                   	push   %eax
80102f58:	68 78 92 10 80       	push   $0x80109278
80102f5d:	e8 64 d4 ff ff       	call   801003c6 <cprintf>
80102f62:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102f65:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	74 0f                	je     80102f7d <cpunum+0x52>
    return lapic[ID]>>24;
80102f6e:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f73:	83 c0 20             	add    $0x20,%eax
80102f76:	8b 00                	mov    (%eax),%eax
80102f78:	c1 e8 18             	shr    $0x18,%eax
80102f7b:	eb 05                	jmp    80102f82 <cpunum+0x57>
  return 0;
80102f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f82:	c9                   	leave  
80102f83:	c3                   	ret    

80102f84 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f84:	55                   	push   %ebp
80102f85:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102f87:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f8c:	85 c0                	test   %eax,%eax
80102f8e:	74 0c                	je     80102f9c <lapiceoi+0x18>
    lapicw(EOI, 0);
80102f90:	6a 00                	push   $0x0
80102f92:	6a 2c                	push   $0x2c
80102f94:	e8 52 fe ff ff       	call   80102deb <lapicw>
80102f99:	83 c4 08             	add    $0x8,%esp
}
80102f9c:	90                   	nop
80102f9d:	c9                   	leave  
80102f9e:	c3                   	ret    

80102f9f <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f9f:	55                   	push   %ebp
80102fa0:	89 e5                	mov    %esp,%ebp
}
80102fa2:	90                   	nop
80102fa3:	5d                   	pop    %ebp
80102fa4:	c3                   	ret    

80102fa5 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fa5:	55                   	push   %ebp
80102fa6:	89 e5                	mov    %esp,%ebp
80102fa8:	83 ec 14             	sub    $0x14,%esp
80102fab:	8b 45 08             	mov    0x8(%ebp),%eax
80102fae:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102fb1:	6a 0f                	push   $0xf
80102fb3:	6a 70                	push   $0x70
80102fb5:	e8 02 fe ff ff       	call   80102dbc <outb>
80102fba:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80102fbd:	6a 0a                	push   $0xa
80102fbf:	6a 71                	push   $0x71
80102fc1:	e8 f6 fd ff ff       	call   80102dbc <outb>
80102fc6:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102fc9:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fd3:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fdb:	83 c0 02             	add    $0x2,%eax
80102fde:	8b 55 0c             	mov    0xc(%ebp),%edx
80102fe1:	c1 ea 04             	shr    $0x4,%edx
80102fe4:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fe7:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102feb:	c1 e0 18             	shl    $0x18,%eax
80102fee:	50                   	push   %eax
80102fef:	68 c4 00 00 00       	push   $0xc4
80102ff4:	e8 f2 fd ff ff       	call   80102deb <lapicw>
80102ff9:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102ffc:	68 00 c5 00 00       	push   $0xc500
80103001:	68 c0 00 00 00       	push   $0xc0
80103006:	e8 e0 fd ff ff       	call   80102deb <lapicw>
8010300b:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010300e:	68 c8 00 00 00       	push   $0xc8
80103013:	e8 87 ff ff ff       	call   80102f9f <microdelay>
80103018:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010301b:	68 00 85 00 00       	push   $0x8500
80103020:	68 c0 00 00 00       	push   $0xc0
80103025:	e8 c1 fd ff ff       	call   80102deb <lapicw>
8010302a:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010302d:	6a 64                	push   $0x64
8010302f:	e8 6b ff ff ff       	call   80102f9f <microdelay>
80103034:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103037:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010303e:	eb 3d                	jmp    8010307d <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103040:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103044:	c1 e0 18             	shl    $0x18,%eax
80103047:	50                   	push   %eax
80103048:	68 c4 00 00 00       	push   $0xc4
8010304d:	e8 99 fd ff ff       	call   80102deb <lapicw>
80103052:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103055:	8b 45 0c             	mov    0xc(%ebp),%eax
80103058:	c1 e8 0c             	shr    $0xc,%eax
8010305b:	80 cc 06             	or     $0x6,%ah
8010305e:	50                   	push   %eax
8010305f:	68 c0 00 00 00       	push   $0xc0
80103064:	e8 82 fd ff ff       	call   80102deb <lapicw>
80103069:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
8010306c:	68 c8 00 00 00       	push   $0xc8
80103071:	e8 29 ff ff ff       	call   80102f9f <microdelay>
80103076:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103079:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010307d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103081:	7e bd                	jle    80103040 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103083:	90                   	nop
80103084:	c9                   	leave  
80103085:	c3                   	ret    

80103086 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103086:	55                   	push   %ebp
80103087:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103089:	8b 45 08             	mov    0x8(%ebp),%eax
8010308c:	0f b6 c0             	movzbl %al,%eax
8010308f:	50                   	push   %eax
80103090:	6a 70                	push   $0x70
80103092:	e8 25 fd ff ff       	call   80102dbc <outb>
80103097:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010309a:	68 c8 00 00 00       	push   $0xc8
8010309f:	e8 fb fe ff ff       	call   80102f9f <microdelay>
801030a4:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801030a7:	6a 71                	push   $0x71
801030a9:	e8 f1 fc ff ff       	call   80102d9f <inb>
801030ae:	83 c4 04             	add    $0x4,%esp
801030b1:	0f b6 c0             	movzbl %al,%eax
}
801030b4:	c9                   	leave  
801030b5:	c3                   	ret    

801030b6 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801030b6:	55                   	push   %ebp
801030b7:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801030b9:	6a 00                	push   $0x0
801030bb:	e8 c6 ff ff ff       	call   80103086 <cmos_read>
801030c0:	83 c4 04             	add    $0x4,%esp
801030c3:	89 c2                	mov    %eax,%edx
801030c5:	8b 45 08             	mov    0x8(%ebp),%eax
801030c8:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
801030ca:	6a 02                	push   $0x2
801030cc:	e8 b5 ff ff ff       	call   80103086 <cmos_read>
801030d1:	83 c4 04             	add    $0x4,%esp
801030d4:	89 c2                	mov    %eax,%edx
801030d6:	8b 45 08             	mov    0x8(%ebp),%eax
801030d9:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801030dc:	6a 04                	push   $0x4
801030de:	e8 a3 ff ff ff       	call   80103086 <cmos_read>
801030e3:	83 c4 04             	add    $0x4,%esp
801030e6:	89 c2                	mov    %eax,%edx
801030e8:	8b 45 08             	mov    0x8(%ebp),%eax
801030eb:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801030ee:	6a 07                	push   $0x7
801030f0:	e8 91 ff ff ff       	call   80103086 <cmos_read>
801030f5:	83 c4 04             	add    $0x4,%esp
801030f8:	89 c2                	mov    %eax,%edx
801030fa:	8b 45 08             	mov    0x8(%ebp),%eax
801030fd:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
80103100:	6a 08                	push   $0x8
80103102:	e8 7f ff ff ff       	call   80103086 <cmos_read>
80103107:	83 c4 04             	add    $0x4,%esp
8010310a:	89 c2                	mov    %eax,%edx
8010310c:	8b 45 08             	mov    0x8(%ebp),%eax
8010310f:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103112:	6a 09                	push   $0x9
80103114:	e8 6d ff ff ff       	call   80103086 <cmos_read>
80103119:	83 c4 04             	add    $0x4,%esp
8010311c:	89 c2                	mov    %eax,%edx
8010311e:	8b 45 08             	mov    0x8(%ebp),%eax
80103121:	89 50 14             	mov    %edx,0x14(%eax)
}
80103124:	90                   	nop
80103125:	c9                   	leave  
80103126:	c3                   	ret    

80103127 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103127:	55                   	push   %ebp
80103128:	89 e5                	mov    %esp,%ebp
8010312a:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010312d:	6a 0b                	push   $0xb
8010312f:	e8 52 ff ff ff       	call   80103086 <cmos_read>
80103134:	83 c4 04             	add    $0x4,%esp
80103137:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
8010313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010313d:	83 e0 04             	and    $0x4,%eax
80103140:	85 c0                	test   %eax,%eax
80103142:	0f 94 c0             	sete   %al
80103145:	0f b6 c0             	movzbl %al,%eax
80103148:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
8010314b:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010314e:	50                   	push   %eax
8010314f:	e8 62 ff ff ff       	call   801030b6 <fill_rtcdate>
80103154:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103157:	6a 0a                	push   $0xa
80103159:	e8 28 ff ff ff       	call   80103086 <cmos_read>
8010315e:	83 c4 04             	add    $0x4,%esp
80103161:	25 80 00 00 00       	and    $0x80,%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	75 27                	jne    80103191 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
8010316a:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010316d:	50                   	push   %eax
8010316e:	e8 43 ff ff ff       	call   801030b6 <fill_rtcdate>
80103173:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103176:	83 ec 04             	sub    $0x4,%esp
80103179:	6a 18                	push   $0x18
8010317b:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010317e:	50                   	push   %eax
8010317f:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103182:	50                   	push   %eax
80103183:	e8 65 25 00 00       	call   801056ed <memcmp>
80103188:	83 c4 10             	add    $0x10,%esp
8010318b:	85 c0                	test   %eax,%eax
8010318d:	74 05                	je     80103194 <cmostime+0x6d>
8010318f:	eb ba                	jmp    8010314b <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
80103191:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103192:	eb b7                	jmp    8010314b <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
80103194:	90                   	nop
  }

  // convert
  if (bcd) {
80103195:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103199:	0f 84 b4 00 00 00    	je     80103253 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010319f:	8b 45 d8             	mov    -0x28(%ebp),%eax
801031a2:	c1 e8 04             	shr    $0x4,%eax
801031a5:	89 c2                	mov    %eax,%edx
801031a7:	89 d0                	mov    %edx,%eax
801031a9:	c1 e0 02             	shl    $0x2,%eax
801031ac:	01 d0                	add    %edx,%eax
801031ae:	01 c0                	add    %eax,%eax
801031b0:	89 c2                	mov    %eax,%edx
801031b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801031b5:	83 e0 0f             	and    $0xf,%eax
801031b8:	01 d0                	add    %edx,%eax
801031ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801031bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031c0:	c1 e8 04             	shr    $0x4,%eax
801031c3:	89 c2                	mov    %eax,%edx
801031c5:	89 d0                	mov    %edx,%eax
801031c7:	c1 e0 02             	shl    $0x2,%eax
801031ca:	01 d0                	add    %edx,%eax
801031cc:	01 c0                	add    %eax,%eax
801031ce:	89 c2                	mov    %eax,%edx
801031d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031d3:	83 e0 0f             	and    $0xf,%eax
801031d6:	01 d0                	add    %edx,%eax
801031d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801031db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801031de:	c1 e8 04             	shr    $0x4,%eax
801031e1:	89 c2                	mov    %eax,%edx
801031e3:	89 d0                	mov    %edx,%eax
801031e5:	c1 e0 02             	shl    $0x2,%eax
801031e8:	01 d0                	add    %edx,%eax
801031ea:	01 c0                	add    %eax,%eax
801031ec:	89 c2                	mov    %eax,%edx
801031ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801031f1:	83 e0 0f             	and    $0xf,%eax
801031f4:	01 d0                	add    %edx,%eax
801031f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801031f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031fc:	c1 e8 04             	shr    $0x4,%eax
801031ff:	89 c2                	mov    %eax,%edx
80103201:	89 d0                	mov    %edx,%eax
80103203:	c1 e0 02             	shl    $0x2,%eax
80103206:	01 d0                	add    %edx,%eax
80103208:	01 c0                	add    %eax,%eax
8010320a:	89 c2                	mov    %eax,%edx
8010320c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010320f:	83 e0 0f             	and    $0xf,%eax
80103212:	01 d0                	add    %edx,%eax
80103214:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103217:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010321a:	c1 e8 04             	shr    $0x4,%eax
8010321d:	89 c2                	mov    %eax,%edx
8010321f:	89 d0                	mov    %edx,%eax
80103221:	c1 e0 02             	shl    $0x2,%eax
80103224:	01 d0                	add    %edx,%eax
80103226:	01 c0                	add    %eax,%eax
80103228:	89 c2                	mov    %eax,%edx
8010322a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010322d:	83 e0 0f             	and    $0xf,%eax
80103230:	01 d0                	add    %edx,%eax
80103232:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103235:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103238:	c1 e8 04             	shr    $0x4,%eax
8010323b:	89 c2                	mov    %eax,%edx
8010323d:	89 d0                	mov    %edx,%eax
8010323f:	c1 e0 02             	shl    $0x2,%eax
80103242:	01 d0                	add    %edx,%eax
80103244:	01 c0                	add    %eax,%eax
80103246:	89 c2                	mov    %eax,%edx
80103248:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010324b:	83 e0 0f             	and    $0xf,%eax
8010324e:	01 d0                	add    %edx,%eax
80103250:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103253:	8b 45 08             	mov    0x8(%ebp),%eax
80103256:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103259:	89 10                	mov    %edx,(%eax)
8010325b:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010325e:	89 50 04             	mov    %edx,0x4(%eax)
80103261:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103264:	89 50 08             	mov    %edx,0x8(%eax)
80103267:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010326a:	89 50 0c             	mov    %edx,0xc(%eax)
8010326d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103270:	89 50 10             	mov    %edx,0x10(%eax)
80103273:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103276:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103279:	8b 45 08             	mov    0x8(%ebp),%eax
8010327c:	8b 40 14             	mov    0x14(%eax),%eax
8010327f:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103285:	8b 45 08             	mov    0x8(%ebp),%eax
80103288:	89 50 14             	mov    %edx,0x14(%eax)
}
8010328b:	90                   	nop
8010328c:	c9                   	leave  
8010328d:	c3                   	ret    

8010328e <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
8010328e:	55                   	push   %ebp
8010328f:	89 e5                	mov    %esp,%ebp
80103291:	83 ec 18             	sub    $0x18,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103294:	83 ec 08             	sub    $0x8,%esp
80103297:	68 a4 92 10 80       	push   $0x801092a4
8010329c:	68 80 32 11 80       	push   $0x80113280
801032a1:	e8 5b 21 00 00       	call   80105401 <initlock>
801032a6:	83 c4 10             	add    $0x10,%esp
  readsb(ROOTDEV, &sb);
801032a9:	83 ec 08             	sub    $0x8,%esp
801032ac:	8d 45 e8             	lea    -0x18(%ebp),%eax
801032af:	50                   	push   %eax
801032b0:	6a 01                	push   $0x1
801032b2:	e8 b2 e0 ff ff       	call   80101369 <readsb>
801032b7:	83 c4 10             	add    $0x10,%esp
  log.start = sb.size - sb.nlog;
801032ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032c0:	29 c2                	sub    %eax,%edx
801032c2:	89 d0                	mov    %edx,%eax
801032c4:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
801032c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032cc:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = ROOTDEV;
801032d1:	c7 05 c4 32 11 80 01 	movl   $0x1,0x801132c4
801032d8:	00 00 00 
  recover_from_log();
801032db:	e8 b2 01 00 00       	call   80103492 <recover_from_log>
}
801032e0:	90                   	nop
801032e1:	c9                   	leave  
801032e2:	c3                   	ret    

801032e3 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801032e3:	55                   	push   %ebp
801032e4:	89 e5                	mov    %esp,%ebp
801032e6:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032f0:	e9 95 00 00 00       	jmp    8010338a <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032f5:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
801032fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032fe:	01 d0                	add    %edx,%eax
80103300:	83 c0 01             	add    $0x1,%eax
80103303:	89 c2                	mov    %eax,%edx
80103305:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010330a:	83 ec 08             	sub    $0x8,%esp
8010330d:	52                   	push   %edx
8010330e:	50                   	push   %eax
8010330f:	e8 a2 ce ff ff       	call   801001b6 <bread>
80103314:	83 c4 10             	add    $0x10,%esp
80103317:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
8010331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010331d:	83 c0 10             	add    $0x10,%eax
80103320:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103327:	89 c2                	mov    %eax,%edx
80103329:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010332e:	83 ec 08             	sub    $0x8,%esp
80103331:	52                   	push   %edx
80103332:	50                   	push   %eax
80103333:	e8 7e ce ff ff       	call   801001b6 <bread>
80103338:	83 c4 10             	add    $0x10,%esp
8010333b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010333e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103341:	8d 50 18             	lea    0x18(%eax),%edx
80103344:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103347:	83 c0 18             	add    $0x18,%eax
8010334a:	83 ec 04             	sub    $0x4,%esp
8010334d:	68 00 02 00 00       	push   $0x200
80103352:	52                   	push   %edx
80103353:	50                   	push   %eax
80103354:	e8 ec 23 00 00       	call   80105745 <memmove>
80103359:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010335c:	83 ec 0c             	sub    $0xc,%esp
8010335f:	ff 75 ec             	pushl  -0x14(%ebp)
80103362:	e8 88 ce ff ff       	call   801001ef <bwrite>
80103367:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010336a:	83 ec 0c             	sub    $0xc,%esp
8010336d:	ff 75 f0             	pushl  -0x10(%ebp)
80103370:	e8 b9 ce ff ff       	call   8010022e <brelse>
80103375:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103378:	83 ec 0c             	sub    $0xc,%esp
8010337b:	ff 75 ec             	pushl  -0x14(%ebp)
8010337e:	e8 ab ce ff ff       	call   8010022e <brelse>
80103383:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103386:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010338a:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010338f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103392:	0f 8f 5d ff ff ff    	jg     801032f5 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103398:	90                   	nop
80103399:	c9                   	leave  
8010339a:	c3                   	ret    

8010339b <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010339b:	55                   	push   %ebp
8010339c:	89 e5                	mov    %esp,%ebp
8010339e:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801033a1:	a1 b4 32 11 80       	mov    0x801132b4,%eax
801033a6:	89 c2                	mov    %eax,%edx
801033a8:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801033ad:	83 ec 08             	sub    $0x8,%esp
801033b0:	52                   	push   %edx
801033b1:	50                   	push   %eax
801033b2:	e8 ff cd ff ff       	call   801001b6 <bread>
801033b7:	83 c4 10             	add    $0x10,%esp
801033ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801033bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033c0:	83 c0 18             	add    $0x18,%eax
801033c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801033c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033c9:	8b 00                	mov    (%eax),%eax
801033cb:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
801033d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033d7:	eb 1b                	jmp    801033f4 <read_head+0x59>
    log.lh.sector[i] = lh->sector[i];
801033d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033df:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801033e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033e6:	83 c2 10             	add    $0x10,%edx
801033e9:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801033f0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033f4:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801033f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033fc:	7f db                	jg     801033d9 <read_head+0x3e>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
801033fe:	83 ec 0c             	sub    $0xc,%esp
80103401:	ff 75 f0             	pushl  -0x10(%ebp)
80103404:	e8 25 ce ff ff       	call   8010022e <brelse>
80103409:	83 c4 10             	add    $0x10,%esp
}
8010340c:	90                   	nop
8010340d:	c9                   	leave  
8010340e:	c3                   	ret    

8010340f <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010340f:	55                   	push   %ebp
80103410:	89 e5                	mov    %esp,%ebp
80103412:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103415:	a1 b4 32 11 80       	mov    0x801132b4,%eax
8010341a:	89 c2                	mov    %eax,%edx
8010341c:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103421:	83 ec 08             	sub    $0x8,%esp
80103424:	52                   	push   %edx
80103425:	50                   	push   %eax
80103426:	e8 8b cd ff ff       	call   801001b6 <bread>
8010342b:	83 c4 10             	add    $0x10,%esp
8010342e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103431:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103434:	83 c0 18             	add    $0x18,%eax
80103437:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010343a:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
80103440:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103443:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103445:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010344c:	eb 1b                	jmp    80103469 <write_head+0x5a>
    hb->sector[i] = log.lh.sector[i];
8010344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103451:	83 c0 10             	add    $0x10,%eax
80103454:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
8010345b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010345e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103461:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103465:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103469:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010346e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103471:	7f db                	jg     8010344e <write_head+0x3f>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
80103473:	83 ec 0c             	sub    $0xc,%esp
80103476:	ff 75 f0             	pushl  -0x10(%ebp)
80103479:	e8 71 cd ff ff       	call   801001ef <bwrite>
8010347e:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103481:	83 ec 0c             	sub    $0xc,%esp
80103484:	ff 75 f0             	pushl  -0x10(%ebp)
80103487:	e8 a2 cd ff ff       	call   8010022e <brelse>
8010348c:	83 c4 10             	add    $0x10,%esp
}
8010348f:	90                   	nop
80103490:	c9                   	leave  
80103491:	c3                   	ret    

80103492 <recover_from_log>:

static void
recover_from_log(void)
{
80103492:	55                   	push   %ebp
80103493:	89 e5                	mov    %esp,%ebp
80103495:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103498:	e8 fe fe ff ff       	call   8010339b <read_head>
  install_trans(); // if committed, copy from log to disk
8010349d:	e8 41 fe ff ff       	call   801032e3 <install_trans>
  log.lh.n = 0;
801034a2:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
801034a9:	00 00 00 
  write_head(); // clear the log
801034ac:	e8 5e ff ff ff       	call   8010340f <write_head>
}
801034b1:	90                   	nop
801034b2:	c9                   	leave  
801034b3:	c3                   	ret    

801034b4 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801034b4:	55                   	push   %ebp
801034b5:	89 e5                	mov    %esp,%ebp
801034b7:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801034ba:	83 ec 0c             	sub    $0xc,%esp
801034bd:	68 80 32 11 80       	push   $0x80113280
801034c2:	e8 5c 1f 00 00       	call   80105423 <acquire>
801034c7:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801034ca:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801034cf:	85 c0                	test   %eax,%eax
801034d1:	74 17                	je     801034ea <begin_op+0x36>
      sleep(&log, &log.lock);
801034d3:	83 ec 08             	sub    $0x8,%esp
801034d6:	68 80 32 11 80       	push   $0x80113280
801034db:	68 80 32 11 80       	push   $0x80113280
801034e0:	e8 9a 17 00 00       	call   80104c7f <sleep>
801034e5:	83 c4 10             	add    $0x10,%esp
801034e8:	eb e0                	jmp    801034ca <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801034ea:	8b 0d c8 32 11 80    	mov    0x801132c8,%ecx
801034f0:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801034f5:	8d 50 01             	lea    0x1(%eax),%edx
801034f8:	89 d0                	mov    %edx,%eax
801034fa:	c1 e0 02             	shl    $0x2,%eax
801034fd:	01 d0                	add    %edx,%eax
801034ff:	01 c0                	add    %eax,%eax
80103501:	01 c8                	add    %ecx,%eax
80103503:	83 f8 1e             	cmp    $0x1e,%eax
80103506:	7e 17                	jle    8010351f <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103508:	83 ec 08             	sub    $0x8,%esp
8010350b:	68 80 32 11 80       	push   $0x80113280
80103510:	68 80 32 11 80       	push   $0x80113280
80103515:	e8 65 17 00 00       	call   80104c7f <sleep>
8010351a:	83 c4 10             	add    $0x10,%esp
8010351d:	eb ab                	jmp    801034ca <begin_op+0x16>
    } else {
      log.outstanding += 1;
8010351f:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103524:	83 c0 01             	add    $0x1,%eax
80103527:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
8010352c:	83 ec 0c             	sub    $0xc,%esp
8010352f:	68 80 32 11 80       	push   $0x80113280
80103534:	e8 51 1f 00 00       	call   8010548a <release>
80103539:	83 c4 10             	add    $0x10,%esp
      break;
8010353c:	90                   	nop
    }
  }
}
8010353d:	90                   	nop
8010353e:	c9                   	leave  
8010353f:	c3                   	ret    

80103540 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103546:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010354d:	83 ec 0c             	sub    $0xc,%esp
80103550:	68 80 32 11 80       	push   $0x80113280
80103555:	e8 c9 1e 00 00       	call   80105423 <acquire>
8010355a:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010355d:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103562:	83 e8 01             	sub    $0x1,%eax
80103565:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
8010356a:	a1 c0 32 11 80       	mov    0x801132c0,%eax
8010356f:	85 c0                	test   %eax,%eax
80103571:	74 0d                	je     80103580 <end_op+0x40>
    panic("log.committing");
80103573:	83 ec 0c             	sub    $0xc,%esp
80103576:	68 a8 92 10 80       	push   $0x801092a8
8010357b:	e8 e6 cf ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
80103580:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103585:	85 c0                	test   %eax,%eax
80103587:	75 13                	jne    8010359c <end_op+0x5c>
    do_commit = 1;
80103589:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103590:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
80103597:	00 00 00 
8010359a:	eb 10                	jmp    801035ac <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010359c:	83 ec 0c             	sub    $0xc,%esp
8010359f:	68 80 32 11 80       	push   $0x80113280
801035a4:	e8 c4 17 00 00       	call   80104d6d <wakeup>
801035a9:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801035ac:	83 ec 0c             	sub    $0xc,%esp
801035af:	68 80 32 11 80       	push   $0x80113280
801035b4:	e8 d1 1e 00 00       	call   8010548a <release>
801035b9:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801035bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035c0:	74 3f                	je     80103601 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801035c2:	e8 f5 00 00 00       	call   801036bc <commit>
    acquire(&log.lock);
801035c7:	83 ec 0c             	sub    $0xc,%esp
801035ca:	68 80 32 11 80       	push   $0x80113280
801035cf:	e8 4f 1e 00 00       	call   80105423 <acquire>
801035d4:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801035d7:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
801035de:	00 00 00 
    wakeup(&log);
801035e1:	83 ec 0c             	sub    $0xc,%esp
801035e4:	68 80 32 11 80       	push   $0x80113280
801035e9:	e8 7f 17 00 00       	call   80104d6d <wakeup>
801035ee:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801035f1:	83 ec 0c             	sub    $0xc,%esp
801035f4:	68 80 32 11 80       	push   $0x80113280
801035f9:	e8 8c 1e 00 00       	call   8010548a <release>
801035fe:	83 c4 10             	add    $0x10,%esp
  }
}
80103601:	90                   	nop
80103602:	c9                   	leave  
80103603:	c3                   	ret    

80103604 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103604:	55                   	push   %ebp
80103605:	89 e5                	mov    %esp,%ebp
80103607:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010360a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103611:	e9 95 00 00 00       	jmp    801036ab <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103616:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
8010361c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010361f:	01 d0                	add    %edx,%eax
80103621:	83 c0 01             	add    $0x1,%eax
80103624:	89 c2                	mov    %eax,%edx
80103626:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010362b:	83 ec 08             	sub    $0x8,%esp
8010362e:	52                   	push   %edx
8010362f:	50                   	push   %eax
80103630:	e8 81 cb ff ff       	call   801001b6 <bread>
80103635:	83 c4 10             	add    $0x10,%esp
80103638:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
8010363b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010363e:	83 c0 10             	add    $0x10,%eax
80103641:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103648:	89 c2                	mov    %eax,%edx
8010364a:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010364f:	83 ec 08             	sub    $0x8,%esp
80103652:	52                   	push   %edx
80103653:	50                   	push   %eax
80103654:	e8 5d cb ff ff       	call   801001b6 <bread>
80103659:	83 c4 10             	add    $0x10,%esp
8010365c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010365f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103662:	8d 50 18             	lea    0x18(%eax),%edx
80103665:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103668:	83 c0 18             	add    $0x18,%eax
8010366b:	83 ec 04             	sub    $0x4,%esp
8010366e:	68 00 02 00 00       	push   $0x200
80103673:	52                   	push   %edx
80103674:	50                   	push   %eax
80103675:	e8 cb 20 00 00       	call   80105745 <memmove>
8010367a:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
8010367d:	83 ec 0c             	sub    $0xc,%esp
80103680:	ff 75 f0             	pushl  -0x10(%ebp)
80103683:	e8 67 cb ff ff       	call   801001ef <bwrite>
80103688:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
8010368b:	83 ec 0c             	sub    $0xc,%esp
8010368e:	ff 75 ec             	pushl  -0x14(%ebp)
80103691:	e8 98 cb ff ff       	call   8010022e <brelse>
80103696:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103699:	83 ec 0c             	sub    $0xc,%esp
8010369c:	ff 75 f0             	pushl  -0x10(%ebp)
8010369f:	e8 8a cb ff ff       	call   8010022e <brelse>
801036a4:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036ab:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036b3:	0f 8f 5d ff ff ff    	jg     80103616 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801036b9:	90                   	nop
801036ba:	c9                   	leave  
801036bb:	c3                   	ret    

801036bc <commit>:

static void
commit()
{
801036bc:	55                   	push   %ebp
801036bd:	89 e5                	mov    %esp,%ebp
801036bf:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801036c2:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036c7:	85 c0                	test   %eax,%eax
801036c9:	7e 1e                	jle    801036e9 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801036cb:	e8 34 ff ff ff       	call   80103604 <write_log>
    write_head();    // Write header to disk -- the real commit
801036d0:	e8 3a fd ff ff       	call   8010340f <write_head>
    install_trans(); // Now install writes to home locations
801036d5:	e8 09 fc ff ff       	call   801032e3 <install_trans>
    log.lh.n = 0; 
801036da:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
801036e1:	00 00 00 
    write_head();    // Erase the transaction from the log
801036e4:	e8 26 fd ff ff       	call   8010340f <write_head>
  }
}
801036e9:	90                   	nop
801036ea:	c9                   	leave  
801036eb:	c3                   	ret    

801036ec <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801036ec:	55                   	push   %ebp
801036ed:	89 e5                	mov    %esp,%ebp
801036ef:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801036f2:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036f7:	83 f8 1d             	cmp    $0x1d,%eax
801036fa:	7f 12                	jg     8010370e <log_write+0x22>
801036fc:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103701:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
80103707:	83 ea 01             	sub    $0x1,%edx
8010370a:	39 d0                	cmp    %edx,%eax
8010370c:	7c 0d                	jl     8010371b <log_write+0x2f>
    panic("too big a transaction");
8010370e:	83 ec 0c             	sub    $0xc,%esp
80103711:	68 b7 92 10 80       	push   $0x801092b7
80103716:	e8 4b ce ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
8010371b:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103720:	85 c0                	test   %eax,%eax
80103722:	7f 0d                	jg     80103731 <log_write+0x45>
    panic("log_write outside of trans");
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	68 cd 92 10 80       	push   $0x801092cd
8010372c:	e8 35 ce ff ff       	call   80100566 <panic>

  for (i = 0; i < log.lh.n; i++) {
80103731:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103738:	eb 1d                	jmp    80103757 <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
8010373a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010373d:	83 c0 10             	add    $0x10,%eax
80103740:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103747:	89 c2                	mov    %eax,%edx
80103749:	8b 45 08             	mov    0x8(%ebp),%eax
8010374c:	8b 40 08             	mov    0x8(%eax),%eax
8010374f:	39 c2                	cmp    %eax,%edx
80103751:	74 10                	je     80103763 <log_write+0x77>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80103753:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103757:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010375c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010375f:	7f d9                	jg     8010373a <log_write+0x4e>
80103761:	eb 01                	jmp    80103764 <log_write+0x78>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
      break;
80103763:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
80103764:	8b 45 08             	mov    0x8(%ebp),%eax
80103767:	8b 40 08             	mov    0x8(%eax),%eax
8010376a:	89 c2                	mov    %eax,%edx
8010376c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010376f:	83 c0 10             	add    $0x10,%eax
80103772:	89 14 85 8c 32 11 80 	mov    %edx,-0x7feecd74(,%eax,4)
  if (i == log.lh.n)
80103779:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010377e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103781:	75 0d                	jne    80103790 <log_write+0xa4>
    log.lh.n++;
80103783:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103788:	83 c0 01             	add    $0x1,%eax
8010378b:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  b->flags |= B_DIRTY; // prevent eviction
80103790:	8b 45 08             	mov    0x8(%ebp),%eax
80103793:	8b 00                	mov    (%eax),%eax
80103795:	83 c8 04             	or     $0x4,%eax
80103798:	89 c2                	mov    %eax,%edx
8010379a:	8b 45 08             	mov    0x8(%ebp),%eax
8010379d:	89 10                	mov    %edx,(%eax)
}
8010379f:	90                   	nop
801037a0:	c9                   	leave  
801037a1:	c3                   	ret    

801037a2 <v2p>:
801037a2:	55                   	push   %ebp
801037a3:	89 e5                	mov    %esp,%ebp
801037a5:	8b 45 08             	mov    0x8(%ebp),%eax
801037a8:	05 00 00 00 80       	add    $0x80000000,%eax
801037ad:	5d                   	pop    %ebp
801037ae:	c3                   	ret    

801037af <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801037af:	55                   	push   %ebp
801037b0:	89 e5                	mov    %esp,%ebp
801037b2:	8b 45 08             	mov    0x8(%ebp),%eax
801037b5:	05 00 00 00 80       	add    $0x80000000,%eax
801037ba:	5d                   	pop    %ebp
801037bb:	c3                   	ret    

801037bc <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801037bc:	55                   	push   %ebp
801037bd:	89 e5                	mov    %esp,%ebp
801037bf:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801037c2:	8b 55 08             	mov    0x8(%ebp),%edx
801037c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801037c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801037cb:	f0 87 02             	lock xchg %eax,(%edx)
801037ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801037d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801037d4:	c9                   	leave  
801037d5:	c3                   	ret    

801037d6 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801037d6:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801037da:	83 e4 f0             	and    $0xfffffff0,%esp
801037dd:	ff 71 fc             	pushl  -0x4(%ecx)
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	51                   	push   %ecx
801037e4:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801037e7:	83 ec 08             	sub    $0x8,%esp
801037ea:	68 00 00 40 80       	push   $0x80400000
801037ef:	68 e0 8a 11 80       	push   $0x80118ae0
801037f4:	e8 95 f2 ff ff       	call   80102a8e <kinit1>
801037f9:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801037fc:	e8 b0 4b 00 00       	call   801083b1 <kvmalloc>
  mpinit();        // collect info about this machine
80103801:	e8 4d 04 00 00       	call   80103c53 <mpinit>
  lapicinit();
80103806:	e8 02 f6 ff ff       	call   80102e0d <lapicinit>
  seginit();       // set up segments
8010380b:	e8 4a 45 00 00       	call   80107d5a <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103810:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103816:	0f b6 00             	movzbl (%eax),%eax
80103819:	0f b6 c0             	movzbl %al,%eax
8010381c:	83 ec 08             	sub    $0x8,%esp
8010381f:	50                   	push   %eax
80103820:	68 e8 92 10 80       	push   $0x801092e8
80103825:	e8 9c cb ff ff       	call   801003c6 <cprintf>
8010382a:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
8010382d:	e8 77 06 00 00       	call   80103ea9 <picinit>
  ioapicinit();    // another interrupt controller
80103832:	e8 4c f1 ff ff       	call   80102983 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103837:	e8 ad d2 ff ff       	call   80100ae9 <consoleinit>
  uartinit();      // serial port
8010383c:	e8 75 38 00 00       	call   801070b6 <uartinit>
  pinit();         // process table
80103841:	e8 60 0b 00 00       	call   801043a6 <pinit>
  seminit();       // semaphore table
80103846:	e8 d6 52 00 00       	call   80108b21 <seminit>
  tvinit();        // trap vectors
8010384b:	e8 30 34 00 00       	call   80106c80 <tvinit>
  binit();         // buffer cache
80103850:	e8 df c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103855:	e8 00 d7 ff ff       	call   80100f5a <fileinit>
  iinit();         // inode cache
8010385a:	e8 d9 dd ff ff       	call   80101638 <iinit>
  ideinit();       // disk
8010385f:	e8 63 ed ff ff       	call   801025c7 <ideinit>
  if(!ismp)
80103864:	a1 64 33 11 80       	mov    0x80113364,%eax
80103869:	85 c0                	test   %eax,%eax
8010386b:	75 05                	jne    80103872 <main+0x9c>
    timerinit();   // uniprocessor timer
8010386d:	e8 6b 33 00 00       	call   80106bdd <timerinit>
  startothers();   // start other processors
80103872:	e8 7f 00 00 00       	call   801038f6 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103877:	83 ec 08             	sub    $0x8,%esp
8010387a:	68 00 00 00 8e       	push   $0x8e000000
8010387f:	68 00 00 40 80       	push   $0x80400000
80103884:	e8 3e f2 ff ff       	call   80102ac7 <kinit2>
80103889:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
8010388c:	e8 3c 0c 00 00       	call   801044cd <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103891:	e8 1a 00 00 00       	call   801038b0 <mpmain>

80103896 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103896:	55                   	push   %ebp
80103897:	89 e5                	mov    %esp,%ebp
80103899:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
8010389c:	e8 28 4b 00 00       	call   801083c9 <switchkvm>
  seginit();
801038a1:	e8 b4 44 00 00       	call   80107d5a <seginit>
  lapicinit();
801038a6:	e8 62 f5 ff ff       	call   80102e0d <lapicinit>
  mpmain();
801038ab:	e8 00 00 00 00       	call   801038b0 <mpmain>

801038b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801038b6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038bc:	0f b6 00             	movzbl (%eax),%eax
801038bf:	0f b6 c0             	movzbl %al,%eax
801038c2:	83 ec 08             	sub    $0x8,%esp
801038c5:	50                   	push   %eax
801038c6:	68 ff 92 10 80       	push   $0x801092ff
801038cb:	e8 f6 ca ff ff       	call   801003c6 <cprintf>
801038d0:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801038d3:	e8 1e 35 00 00       	call   80106df6 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801038d8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038de:	05 a8 00 00 00       	add    $0xa8,%eax
801038e3:	83 ec 08             	sub    $0x8,%esp
801038e6:	6a 01                	push   $0x1
801038e8:	50                   	push   %eax
801038e9:	e8 ce fe ff ff       	call   801037bc <xchg>
801038ee:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801038f1:	e8 b9 11 00 00       	call   80104aaf <scheduler>

801038f6 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801038f6:	55                   	push   %ebp
801038f7:	89 e5                	mov    %esp,%ebp
801038f9:	53                   	push   %ebx
801038fa:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801038fd:	68 00 70 00 00       	push   $0x7000
80103902:	e8 a8 fe ff ff       	call   801037af <p2v>
80103907:	83 c4 04             	add    $0x4,%esp
8010390a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010390d:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103912:	83 ec 04             	sub    $0x4,%esp
80103915:	50                   	push   %eax
80103916:	68 2c c5 10 80       	push   $0x8010c52c
8010391b:	ff 75 f0             	pushl  -0x10(%ebp)
8010391e:	e8 22 1e 00 00       	call   80105745 <memmove>
80103923:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103926:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
8010392d:	e9 90 00 00 00       	jmp    801039c2 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103932:	e8 f4 f5 ff ff       	call   80102f2b <cpunum>
80103937:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010393d:	05 80 33 11 80       	add    $0x80113380,%eax
80103942:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103945:	74 73                	je     801039ba <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103947:	e8 79 f2 ff ff       	call   80102bc5 <kalloc>
8010394c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010394f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103952:	83 e8 04             	sub    $0x4,%eax
80103955:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103958:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010395e:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103960:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103963:	83 e8 08             	sub    $0x8,%eax
80103966:	c7 00 96 38 10 80    	movl   $0x80103896,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
8010396c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010396f:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103972:	83 ec 0c             	sub    $0xc,%esp
80103975:	68 00 b0 10 80       	push   $0x8010b000
8010397a:	e8 23 fe ff ff       	call   801037a2 <v2p>
8010397f:	83 c4 10             	add    $0x10,%esp
80103982:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103984:	83 ec 0c             	sub    $0xc,%esp
80103987:	ff 75 f0             	pushl  -0x10(%ebp)
8010398a:	e8 13 fe ff ff       	call   801037a2 <v2p>
8010398f:	83 c4 10             	add    $0x10,%esp
80103992:	89 c2                	mov    %eax,%edx
80103994:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103997:	0f b6 00             	movzbl (%eax),%eax
8010399a:	0f b6 c0             	movzbl %al,%eax
8010399d:	83 ec 08             	sub    $0x8,%esp
801039a0:	52                   	push   %edx
801039a1:	50                   	push   %eax
801039a2:	e8 fe f5 ff ff       	call   80102fa5 <lapicstartap>
801039a7:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039aa:	90                   	nop
801039ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ae:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801039b4:	85 c0                	test   %eax,%eax
801039b6:	74 f3                	je     801039ab <startothers+0xb5>
801039b8:	eb 01                	jmp    801039bb <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
801039ba:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801039bb:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801039c2:	a1 60 39 11 80       	mov    0x80113960,%eax
801039c7:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039cd:	05 80 33 11 80       	add    $0x80113380,%eax
801039d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039d5:	0f 87 57 ff ff ff    	ja     80103932 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801039db:	90                   	nop
801039dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039df:	c9                   	leave  
801039e0:	c3                   	ret    

801039e1 <p2v>:
801039e1:	55                   	push   %ebp
801039e2:	89 e5                	mov    %esp,%ebp
801039e4:	8b 45 08             	mov    0x8(%ebp),%eax
801039e7:	05 00 00 00 80       	add    $0x80000000,%eax
801039ec:	5d                   	pop    %ebp
801039ed:	c3                   	ret    

801039ee <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801039ee:	55                   	push   %ebp
801039ef:	89 e5                	mov    %esp,%ebp
801039f1:	83 ec 14             	sub    $0x14,%esp
801039f4:	8b 45 08             	mov    0x8(%ebp),%eax
801039f7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039fb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801039ff:	89 c2                	mov    %eax,%edx
80103a01:	ec                   	in     (%dx),%al
80103a02:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a05:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a09:	c9                   	leave  
80103a0a:	c3                   	ret    

80103a0b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a0b:	55                   	push   %ebp
80103a0c:	89 e5                	mov    %esp,%ebp
80103a0e:	83 ec 08             	sub    $0x8,%esp
80103a11:	8b 55 08             	mov    0x8(%ebp),%edx
80103a14:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a17:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a1b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a1e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a22:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a26:	ee                   	out    %al,(%dx)
}
80103a27:	90                   	nop
80103a28:	c9                   	leave  
80103a29:	c3                   	ret    

80103a2a <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103a2a:	55                   	push   %ebp
80103a2b:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103a2d:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103a32:	89 c2                	mov    %eax,%edx
80103a34:	b8 80 33 11 80       	mov    $0x80113380,%eax
80103a39:	29 c2                	sub    %eax,%edx
80103a3b:	89 d0                	mov    %edx,%eax
80103a3d:	c1 f8 02             	sar    $0x2,%eax
80103a40:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103a46:	5d                   	pop    %ebp
80103a47:	c3                   	ret    

80103a48 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103a48:	55                   	push   %ebp
80103a49:	89 e5                	mov    %esp,%ebp
80103a4b:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a4e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a5c:	eb 15                	jmp    80103a73 <sum+0x2b>
    sum += addr[i];
80103a5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a61:	8b 45 08             	mov    0x8(%ebp),%eax
80103a64:	01 d0                	add    %edx,%eax
80103a66:	0f b6 00             	movzbl (%eax),%eax
80103a69:	0f b6 c0             	movzbl %al,%eax
80103a6c:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103a6f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103a73:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a76:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a79:	7c e3                	jl     80103a5e <sum+0x16>
    sum += addr[i];
  return sum;
80103a7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103a7e:	c9                   	leave  
80103a7f:	c3                   	ret    

80103a80 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103a86:	ff 75 08             	pushl  0x8(%ebp)
80103a89:	e8 53 ff ff ff       	call   801039e1 <p2v>
80103a8e:	83 c4 04             	add    $0x4,%esp
80103a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103a94:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a9a:	01 d0                	add    %edx,%eax
80103a9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103aa5:	eb 36                	jmp    80103add <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103aa7:	83 ec 04             	sub    $0x4,%esp
80103aaa:	6a 04                	push   $0x4
80103aac:	68 10 93 10 80       	push   $0x80109310
80103ab1:	ff 75 f4             	pushl  -0xc(%ebp)
80103ab4:	e8 34 1c 00 00       	call   801056ed <memcmp>
80103ab9:	83 c4 10             	add    $0x10,%esp
80103abc:	85 c0                	test   %eax,%eax
80103abe:	75 19                	jne    80103ad9 <mpsearch1+0x59>
80103ac0:	83 ec 08             	sub    $0x8,%esp
80103ac3:	6a 10                	push   $0x10
80103ac5:	ff 75 f4             	pushl  -0xc(%ebp)
80103ac8:	e8 7b ff ff ff       	call   80103a48 <sum>
80103acd:	83 c4 10             	add    $0x10,%esp
80103ad0:	84 c0                	test   %al,%al
80103ad2:	75 05                	jne    80103ad9 <mpsearch1+0x59>
      return (struct mp*)p;
80103ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ad7:	eb 11                	jmp    80103aea <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103ad9:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103add:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ae3:	72 c2                	jb     80103aa7 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103ae5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103aea:	c9                   	leave  
80103aeb:	c3                   	ret    

80103aec <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103aec:	55                   	push   %ebp
80103aed:	89 e5                	mov    %esp,%ebp
80103aef:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103af2:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103afc:	83 c0 0f             	add    $0xf,%eax
80103aff:	0f b6 00             	movzbl (%eax),%eax
80103b02:	0f b6 c0             	movzbl %al,%eax
80103b05:	c1 e0 08             	shl    $0x8,%eax
80103b08:	89 c2                	mov    %eax,%edx
80103b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b0d:	83 c0 0e             	add    $0xe,%eax
80103b10:	0f b6 00             	movzbl (%eax),%eax
80103b13:	0f b6 c0             	movzbl %al,%eax
80103b16:	09 d0                	or     %edx,%eax
80103b18:	c1 e0 04             	shl    $0x4,%eax
80103b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b22:	74 21                	je     80103b45 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b24:	83 ec 08             	sub    $0x8,%esp
80103b27:	68 00 04 00 00       	push   $0x400
80103b2c:	ff 75 f0             	pushl  -0x10(%ebp)
80103b2f:	e8 4c ff ff ff       	call   80103a80 <mpsearch1>
80103b34:	83 c4 10             	add    $0x10,%esp
80103b37:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b3a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b3e:	74 51                	je     80103b91 <mpsearch+0xa5>
      return mp;
80103b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b43:	eb 61                	jmp    80103ba6 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b48:	83 c0 14             	add    $0x14,%eax
80103b4b:	0f b6 00             	movzbl (%eax),%eax
80103b4e:	0f b6 c0             	movzbl %al,%eax
80103b51:	c1 e0 08             	shl    $0x8,%eax
80103b54:	89 c2                	mov    %eax,%edx
80103b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b59:	83 c0 13             	add    $0x13,%eax
80103b5c:	0f b6 00             	movzbl (%eax),%eax
80103b5f:	0f b6 c0             	movzbl %al,%eax
80103b62:	09 d0                	or     %edx,%eax
80103b64:	c1 e0 0a             	shl    $0xa,%eax
80103b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b6d:	2d 00 04 00 00       	sub    $0x400,%eax
80103b72:	83 ec 08             	sub    $0x8,%esp
80103b75:	68 00 04 00 00       	push   $0x400
80103b7a:	50                   	push   %eax
80103b7b:	e8 00 ff ff ff       	call   80103a80 <mpsearch1>
80103b80:	83 c4 10             	add    $0x10,%esp
80103b83:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b86:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b8a:	74 05                	je     80103b91 <mpsearch+0xa5>
      return mp;
80103b8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b8f:	eb 15                	jmp    80103ba6 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103b91:	83 ec 08             	sub    $0x8,%esp
80103b94:	68 00 00 01 00       	push   $0x10000
80103b99:	68 00 00 0f 00       	push   $0xf0000
80103b9e:	e8 dd fe ff ff       	call   80103a80 <mpsearch1>
80103ba3:	83 c4 10             	add    $0x10,%esp
}
80103ba6:	c9                   	leave  
80103ba7:	c3                   	ret    

80103ba8 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103ba8:	55                   	push   %ebp
80103ba9:	89 e5                	mov    %esp,%ebp
80103bab:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103bae:	e8 39 ff ff ff       	call   80103aec <mpsearch>
80103bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103bba:	74 0a                	je     80103bc6 <mpconfig+0x1e>
80103bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bbf:	8b 40 04             	mov    0x4(%eax),%eax
80103bc2:	85 c0                	test   %eax,%eax
80103bc4:	75 0a                	jne    80103bd0 <mpconfig+0x28>
    return 0;
80103bc6:	b8 00 00 00 00       	mov    $0x0,%eax
80103bcb:	e9 81 00 00 00       	jmp    80103c51 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd3:	8b 40 04             	mov    0x4(%eax),%eax
80103bd6:	83 ec 0c             	sub    $0xc,%esp
80103bd9:	50                   	push   %eax
80103bda:	e8 02 fe ff ff       	call   801039e1 <p2v>
80103bdf:	83 c4 10             	add    $0x10,%esp
80103be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103be5:	83 ec 04             	sub    $0x4,%esp
80103be8:	6a 04                	push   $0x4
80103bea:	68 15 93 10 80       	push   $0x80109315
80103bef:	ff 75 f0             	pushl  -0x10(%ebp)
80103bf2:	e8 f6 1a 00 00       	call   801056ed <memcmp>
80103bf7:	83 c4 10             	add    $0x10,%esp
80103bfa:	85 c0                	test   %eax,%eax
80103bfc:	74 07                	je     80103c05 <mpconfig+0x5d>
    return 0;
80103bfe:	b8 00 00 00 00       	mov    $0x0,%eax
80103c03:	eb 4c                	jmp    80103c51 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c08:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c0c:	3c 01                	cmp    $0x1,%al
80103c0e:	74 12                	je     80103c22 <mpconfig+0x7a>
80103c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c13:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c17:	3c 04                	cmp    $0x4,%al
80103c19:	74 07                	je     80103c22 <mpconfig+0x7a>
    return 0;
80103c1b:	b8 00 00 00 00       	mov    $0x0,%eax
80103c20:	eb 2f                	jmp    80103c51 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c25:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c29:	0f b7 c0             	movzwl %ax,%eax
80103c2c:	83 ec 08             	sub    $0x8,%esp
80103c2f:	50                   	push   %eax
80103c30:	ff 75 f0             	pushl  -0x10(%ebp)
80103c33:	e8 10 fe ff ff       	call   80103a48 <sum>
80103c38:	83 c4 10             	add    $0x10,%esp
80103c3b:	84 c0                	test   %al,%al
80103c3d:	74 07                	je     80103c46 <mpconfig+0x9e>
    return 0;
80103c3f:	b8 00 00 00 00       	mov    $0x0,%eax
80103c44:	eb 0b                	jmp    80103c51 <mpconfig+0xa9>
  *pmp = mp;
80103c46:	8b 45 08             	mov    0x8(%ebp),%eax
80103c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c4c:	89 10                	mov    %edx,(%eax)
  return conf;
80103c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c51:	c9                   	leave  
80103c52:	c3                   	ret    

80103c53 <mpinit>:

void
mpinit(void)
{
80103c53:	55                   	push   %ebp
80103c54:	89 e5                	mov    %esp,%ebp
80103c56:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103c59:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103c60:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103c63:	83 ec 0c             	sub    $0xc,%esp
80103c66:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103c69:	50                   	push   %eax
80103c6a:	e8 39 ff ff ff       	call   80103ba8 <mpconfig>
80103c6f:	83 c4 10             	add    $0x10,%esp
80103c72:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c79:	0f 84 96 01 00 00    	je     80103e15 <mpinit+0x1c2>
    return;
  ismp = 1;
80103c7f:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103c86:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c8c:	8b 40 24             	mov    0x24(%eax),%eax
80103c8f:	a3 7c 32 11 80       	mov    %eax,0x8011327c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c97:	83 c0 2c             	add    $0x2c,%eax
80103c9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ca0:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103ca4:	0f b7 d0             	movzwl %ax,%edx
80103ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103caa:	01 d0                	add    %edx,%eax
80103cac:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103caf:	e9 f2 00 00 00       	jmp    80103da6 <mpinit+0x153>
    switch(*p){
80103cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb7:	0f b6 00             	movzbl (%eax),%eax
80103cba:	0f b6 c0             	movzbl %al,%eax
80103cbd:	83 f8 04             	cmp    $0x4,%eax
80103cc0:	0f 87 bc 00 00 00    	ja     80103d82 <mpinit+0x12f>
80103cc6:	8b 04 85 58 93 10 80 	mov    -0x7fef6ca8(,%eax,4),%eax
80103ccd:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd2:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103cd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cd8:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cdc:	0f b6 d0             	movzbl %al,%edx
80103cdf:	a1 60 39 11 80       	mov    0x80113960,%eax
80103ce4:	39 c2                	cmp    %eax,%edx
80103ce6:	74 2b                	je     80103d13 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103ce8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103ceb:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cef:	0f b6 d0             	movzbl %al,%edx
80103cf2:	a1 60 39 11 80       	mov    0x80113960,%eax
80103cf7:	83 ec 04             	sub    $0x4,%esp
80103cfa:	52                   	push   %edx
80103cfb:	50                   	push   %eax
80103cfc:	68 1a 93 10 80       	push   $0x8010931a
80103d01:	e8 c0 c6 ff ff       	call   801003c6 <cprintf>
80103d06:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103d09:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103d10:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103d13:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d16:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103d1a:	0f b6 c0             	movzbl %al,%eax
80103d1d:	83 e0 02             	and    $0x2,%eax
80103d20:	85 c0                	test   %eax,%eax
80103d22:	74 15                	je     80103d39 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103d24:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d29:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d2f:	05 80 33 11 80       	add    $0x80113380,%eax
80103d34:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103d39:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d3e:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103d44:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d4a:	05 80 33 11 80       	add    $0x80113380,%eax
80103d4f:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103d51:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d56:	83 c0 01             	add    $0x1,%eax
80103d59:	a3 60 39 11 80       	mov    %eax,0x80113960
      p += sizeof(struct mpproc);
80103d5e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103d62:	eb 42                	jmp    80103da6 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103d6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d6d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d71:	a2 60 33 11 80       	mov    %al,0x80113360
      p += sizeof(struct mpioapic);
80103d76:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d7a:	eb 2a                	jmp    80103da6 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d7c:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d80:	eb 24                	jmp    80103da6 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d85:	0f b6 00             	movzbl (%eax),%eax
80103d88:	0f b6 c0             	movzbl %al,%eax
80103d8b:	83 ec 08             	sub    $0x8,%esp
80103d8e:	50                   	push   %eax
80103d8f:	68 38 93 10 80       	push   $0x80109338
80103d94:	e8 2d c6 ff ff       	call   801003c6 <cprintf>
80103d99:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103d9c:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103da3:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103da9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103dac:	0f 82 02 ff ff ff    	jb     80103cb4 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103db2:	a1 64 33 11 80       	mov    0x80113364,%eax
80103db7:	85 c0                	test   %eax,%eax
80103db9:	75 1d                	jne    80103dd8 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103dbb:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103dc2:	00 00 00 
    lapic = 0;
80103dc5:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103dcc:	00 00 00 
    ioapicid = 0;
80103dcf:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
    return;
80103dd6:	eb 3e                	jmp    80103e16 <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ddb:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103ddf:	84 c0                	test   %al,%al
80103de1:	74 33                	je     80103e16 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103de3:	83 ec 08             	sub    $0x8,%esp
80103de6:	6a 70                	push   $0x70
80103de8:	6a 22                	push   $0x22
80103dea:	e8 1c fc ff ff       	call   80103a0b <outb>
80103def:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103df2:	83 ec 0c             	sub    $0xc,%esp
80103df5:	6a 23                	push   $0x23
80103df7:	e8 f2 fb ff ff       	call   801039ee <inb>
80103dfc:	83 c4 10             	add    $0x10,%esp
80103dff:	83 c8 01             	or     $0x1,%eax
80103e02:	0f b6 c0             	movzbl %al,%eax
80103e05:	83 ec 08             	sub    $0x8,%esp
80103e08:	50                   	push   %eax
80103e09:	6a 23                	push   $0x23
80103e0b:	e8 fb fb ff ff       	call   80103a0b <outb>
80103e10:	83 c4 10             	add    $0x10,%esp
80103e13:	eb 01                	jmp    80103e16 <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103e15:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103e16:	c9                   	leave  
80103e17:	c3                   	ret    

80103e18 <outb>:
80103e18:	55                   	push   %ebp
80103e19:	89 e5                	mov    %esp,%ebp
80103e1b:	83 ec 08             	sub    $0x8,%esp
80103e1e:	8b 55 08             	mov    0x8(%ebp),%edx
80103e21:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e24:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e28:	88 45 f8             	mov    %al,-0x8(%ebp)
80103e2b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e2f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e33:	ee                   	out    %al,(%dx)
80103e34:	90                   	nop
80103e35:	c9                   	leave  
80103e36:	c3                   	ret    

80103e37 <picsetmask>:
80103e37:	55                   	push   %ebp
80103e38:	89 e5                	mov    %esp,%ebp
80103e3a:	83 ec 04             	sub    $0x4,%esp
80103e3d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e40:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103e44:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e48:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
80103e4e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e52:	0f b6 c0             	movzbl %al,%eax
80103e55:	50                   	push   %eax
80103e56:	6a 21                	push   $0x21
80103e58:	e8 bb ff ff ff       	call   80103e18 <outb>
80103e5d:	83 c4 08             	add    $0x8,%esp
80103e60:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e64:	66 c1 e8 08          	shr    $0x8,%ax
80103e68:	0f b6 c0             	movzbl %al,%eax
80103e6b:	50                   	push   %eax
80103e6c:	68 a1 00 00 00       	push   $0xa1
80103e71:	e8 a2 ff ff ff       	call   80103e18 <outb>
80103e76:	83 c4 08             	add    $0x8,%esp
80103e79:	90                   	nop
80103e7a:	c9                   	leave  
80103e7b:	c3                   	ret    

80103e7c <picenable>:
80103e7c:	55                   	push   %ebp
80103e7d:	89 e5                	mov    %esp,%ebp
80103e7f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e82:	ba 01 00 00 00       	mov    $0x1,%edx
80103e87:	89 c1                	mov    %eax,%ecx
80103e89:	d3 e2                	shl    %cl,%edx
80103e8b:	89 d0                	mov    %edx,%eax
80103e8d:	f7 d0                	not    %eax
80103e8f:	89 c2                	mov    %eax,%edx
80103e91:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103e98:	21 d0                	and    %edx,%eax
80103e9a:	0f b7 c0             	movzwl %ax,%eax
80103e9d:	50                   	push   %eax
80103e9e:	e8 94 ff ff ff       	call   80103e37 <picsetmask>
80103ea3:	83 c4 04             	add    $0x4,%esp
80103ea6:	90                   	nop
80103ea7:	c9                   	leave  
80103ea8:	c3                   	ret    

80103ea9 <picinit>:
80103ea9:	55                   	push   %ebp
80103eaa:	89 e5                	mov    %esp,%ebp
80103eac:	68 ff 00 00 00       	push   $0xff
80103eb1:	6a 21                	push   $0x21
80103eb3:	e8 60 ff ff ff       	call   80103e18 <outb>
80103eb8:	83 c4 08             	add    $0x8,%esp
80103ebb:	68 ff 00 00 00       	push   $0xff
80103ec0:	68 a1 00 00 00       	push   $0xa1
80103ec5:	e8 4e ff ff ff       	call   80103e18 <outb>
80103eca:	83 c4 08             	add    $0x8,%esp
80103ecd:	6a 11                	push   $0x11
80103ecf:	6a 20                	push   $0x20
80103ed1:	e8 42 ff ff ff       	call   80103e18 <outb>
80103ed6:	83 c4 08             	add    $0x8,%esp
80103ed9:	6a 20                	push   $0x20
80103edb:	6a 21                	push   $0x21
80103edd:	e8 36 ff ff ff       	call   80103e18 <outb>
80103ee2:	83 c4 08             	add    $0x8,%esp
80103ee5:	6a 04                	push   $0x4
80103ee7:	6a 21                	push   $0x21
80103ee9:	e8 2a ff ff ff       	call   80103e18 <outb>
80103eee:	83 c4 08             	add    $0x8,%esp
80103ef1:	6a 03                	push   $0x3
80103ef3:	6a 21                	push   $0x21
80103ef5:	e8 1e ff ff ff       	call   80103e18 <outb>
80103efa:	83 c4 08             	add    $0x8,%esp
80103efd:	6a 11                	push   $0x11
80103eff:	68 a0 00 00 00       	push   $0xa0
80103f04:	e8 0f ff ff ff       	call   80103e18 <outb>
80103f09:	83 c4 08             	add    $0x8,%esp
80103f0c:	6a 28                	push   $0x28
80103f0e:	68 a1 00 00 00       	push   $0xa1
80103f13:	e8 00 ff ff ff       	call   80103e18 <outb>
80103f18:	83 c4 08             	add    $0x8,%esp
80103f1b:	6a 02                	push   $0x2
80103f1d:	68 a1 00 00 00       	push   $0xa1
80103f22:	e8 f1 fe ff ff       	call   80103e18 <outb>
80103f27:	83 c4 08             	add    $0x8,%esp
80103f2a:	6a 03                	push   $0x3
80103f2c:	68 a1 00 00 00       	push   $0xa1
80103f31:	e8 e2 fe ff ff       	call   80103e18 <outb>
80103f36:	83 c4 08             	add    $0x8,%esp
80103f39:	6a 68                	push   $0x68
80103f3b:	6a 20                	push   $0x20
80103f3d:	e8 d6 fe ff ff       	call   80103e18 <outb>
80103f42:	83 c4 08             	add    $0x8,%esp
80103f45:	6a 0a                	push   $0xa
80103f47:	6a 20                	push   $0x20
80103f49:	e8 ca fe ff ff       	call   80103e18 <outb>
80103f4e:	83 c4 08             	add    $0x8,%esp
80103f51:	6a 68                	push   $0x68
80103f53:	68 a0 00 00 00       	push   $0xa0
80103f58:	e8 bb fe ff ff       	call   80103e18 <outb>
80103f5d:	83 c4 08             	add    $0x8,%esp
80103f60:	6a 0a                	push   $0xa
80103f62:	68 a0 00 00 00       	push   $0xa0
80103f67:	e8 ac fe ff ff       	call   80103e18 <outb>
80103f6c:	83 c4 08             	add    $0x8,%esp
80103f6f:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f76:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f7a:	74 13                	je     80103f8f <picinit+0xe6>
80103f7c:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f83:	0f b7 c0             	movzwl %ax,%eax
80103f86:	50                   	push   %eax
80103f87:	e8 ab fe ff ff       	call   80103e37 <picsetmask>
80103f8c:	83 c4 04             	add    $0x4,%esp
80103f8f:	90                   	nop
80103f90:	c9                   	leave  
80103f91:	c3                   	ret    

80103f92 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f92:	55                   	push   %ebp
80103f93:	89 e5                	mov    %esp,%ebp
80103f95:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103f98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fa2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fab:	8b 10                	mov    (%eax),%edx
80103fad:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb0:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103fb2:	e8 c1 cf ff ff       	call   80100f78 <filealloc>
80103fb7:	89 c2                	mov    %eax,%edx
80103fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80103fbc:	89 10                	mov    %edx,(%eax)
80103fbe:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc1:	8b 00                	mov    (%eax),%eax
80103fc3:	85 c0                	test   %eax,%eax
80103fc5:	0f 84 cb 00 00 00    	je     80104096 <pipealloc+0x104>
80103fcb:	e8 a8 cf ff ff       	call   80100f78 <filealloc>
80103fd0:	89 c2                	mov    %eax,%edx
80103fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fd5:	89 10                	mov    %edx,(%eax)
80103fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fda:	8b 00                	mov    (%eax),%eax
80103fdc:	85 c0                	test   %eax,%eax
80103fde:	0f 84 b2 00 00 00    	je     80104096 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103fe4:	e8 dc eb ff ff       	call   80102bc5 <kalloc>
80103fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103fec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ff0:	0f 84 9f 00 00 00    	je     80104095 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
80103ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ff9:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104000:	00 00 00 
  p->writeopen = 1;
80104003:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104006:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010400d:	00 00 00 
  p->nwrite = 0;
80104010:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104013:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010401a:	00 00 00 
  p->nread = 0;
8010401d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104020:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104027:	00 00 00 
  initlock(&p->lock, "pipe");
8010402a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010402d:	83 ec 08             	sub    $0x8,%esp
80104030:	68 6c 93 10 80       	push   $0x8010936c
80104035:	50                   	push   %eax
80104036:	e8 c6 13 00 00       	call   80105401 <initlock>
8010403b:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010403e:	8b 45 08             	mov    0x8(%ebp),%eax
80104041:	8b 00                	mov    (%eax),%eax
80104043:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104049:	8b 45 08             	mov    0x8(%ebp),%eax
8010404c:	8b 00                	mov    (%eax),%eax
8010404e:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104052:	8b 45 08             	mov    0x8(%ebp),%eax
80104055:	8b 00                	mov    (%eax),%eax
80104057:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010405b:	8b 45 08             	mov    0x8(%ebp),%eax
8010405e:	8b 00                	mov    (%eax),%eax
80104060:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104063:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104066:	8b 45 0c             	mov    0xc(%ebp),%eax
80104069:	8b 00                	mov    (%eax),%eax
8010406b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104071:	8b 45 0c             	mov    0xc(%ebp),%eax
80104074:	8b 00                	mov    (%eax),%eax
80104076:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010407a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010407d:	8b 00                	mov    (%eax),%eax
8010407f:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104083:	8b 45 0c             	mov    0xc(%ebp),%eax
80104086:	8b 00                	mov    (%eax),%eax
80104088:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010408b:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010408e:	b8 00 00 00 00       	mov    $0x0,%eax
80104093:	eb 4e                	jmp    801040e3 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80104095:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80104096:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010409a:	74 0e                	je     801040aa <pipealloc+0x118>
    kfree((char*)p);
8010409c:	83 ec 0c             	sub    $0xc,%esp
8010409f:	ff 75 f4             	pushl  -0xc(%ebp)
801040a2:	e8 81 ea ff ff       	call   80102b28 <kfree>
801040a7:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801040aa:	8b 45 08             	mov    0x8(%ebp),%eax
801040ad:	8b 00                	mov    (%eax),%eax
801040af:	85 c0                	test   %eax,%eax
801040b1:	74 11                	je     801040c4 <pipealloc+0x132>
    fileclose(*f0);
801040b3:	8b 45 08             	mov    0x8(%ebp),%eax
801040b6:	8b 00                	mov    (%eax),%eax
801040b8:	83 ec 0c             	sub    $0xc,%esp
801040bb:	50                   	push   %eax
801040bc:	e8 75 cf ff ff       	call   80101036 <fileclose>
801040c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801040c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c7:	8b 00                	mov    (%eax),%eax
801040c9:	85 c0                	test   %eax,%eax
801040cb:	74 11                	je     801040de <pipealloc+0x14c>
    fileclose(*f1);
801040cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801040d0:	8b 00                	mov    (%eax),%eax
801040d2:	83 ec 0c             	sub    $0xc,%esp
801040d5:	50                   	push   %eax
801040d6:	e8 5b cf ff ff       	call   80101036 <fileclose>
801040db:	83 c4 10             	add    $0x10,%esp
  return -1;
801040de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040e3:	c9                   	leave  
801040e4:	c3                   	ret    

801040e5 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801040e5:	55                   	push   %ebp
801040e6:	89 e5                	mov    %esp,%ebp
801040e8:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801040eb:	8b 45 08             	mov    0x8(%ebp),%eax
801040ee:	83 ec 0c             	sub    $0xc,%esp
801040f1:	50                   	push   %eax
801040f2:	e8 2c 13 00 00       	call   80105423 <acquire>
801040f7:	83 c4 10             	add    $0x10,%esp
  if(writable){
801040fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801040fe:	74 23                	je     80104123 <pipeclose+0x3e>
    p->writeopen = 0;
80104100:	8b 45 08             	mov    0x8(%ebp),%eax
80104103:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010410a:	00 00 00 
    wakeup(&p->nread);
8010410d:	8b 45 08             	mov    0x8(%ebp),%eax
80104110:	05 34 02 00 00       	add    $0x234,%eax
80104115:	83 ec 0c             	sub    $0xc,%esp
80104118:	50                   	push   %eax
80104119:	e8 4f 0c 00 00       	call   80104d6d <wakeup>
8010411e:	83 c4 10             	add    $0x10,%esp
80104121:	eb 21                	jmp    80104144 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104123:	8b 45 08             	mov    0x8(%ebp),%eax
80104126:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010412d:	00 00 00 
    wakeup(&p->nwrite);
80104130:	8b 45 08             	mov    0x8(%ebp),%eax
80104133:	05 38 02 00 00       	add    $0x238,%eax
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	50                   	push   %eax
8010413c:	e8 2c 0c 00 00       	call   80104d6d <wakeup>
80104141:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104144:	8b 45 08             	mov    0x8(%ebp),%eax
80104147:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010414d:	85 c0                	test   %eax,%eax
8010414f:	75 2c                	jne    8010417d <pipeclose+0x98>
80104151:	8b 45 08             	mov    0x8(%ebp),%eax
80104154:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010415a:	85 c0                	test   %eax,%eax
8010415c:	75 1f                	jne    8010417d <pipeclose+0x98>
    release(&p->lock);
8010415e:	8b 45 08             	mov    0x8(%ebp),%eax
80104161:	83 ec 0c             	sub    $0xc,%esp
80104164:	50                   	push   %eax
80104165:	e8 20 13 00 00       	call   8010548a <release>
8010416a:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
8010416d:	83 ec 0c             	sub    $0xc,%esp
80104170:	ff 75 08             	pushl  0x8(%ebp)
80104173:	e8 b0 e9 ff ff       	call   80102b28 <kfree>
80104178:	83 c4 10             	add    $0x10,%esp
8010417b:	eb 0f                	jmp    8010418c <pipeclose+0xa7>
  } else
    release(&p->lock);
8010417d:	8b 45 08             	mov    0x8(%ebp),%eax
80104180:	83 ec 0c             	sub    $0xc,%esp
80104183:	50                   	push   %eax
80104184:	e8 01 13 00 00       	call   8010548a <release>
80104189:	83 c4 10             	add    $0x10,%esp
}
8010418c:	90                   	nop
8010418d:	c9                   	leave  
8010418e:	c3                   	ret    

8010418f <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010418f:	55                   	push   %ebp
80104190:	89 e5                	mov    %esp,%ebp
80104192:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80104195:	8b 45 08             	mov    0x8(%ebp),%eax
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	50                   	push   %eax
8010419c:	e8 82 12 00 00       	call   80105423 <acquire>
801041a1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801041a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041ab:	e9 ad 00 00 00       	jmp    8010425d <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801041b0:	8b 45 08             	mov    0x8(%ebp),%eax
801041b3:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041b9:	85 c0                	test   %eax,%eax
801041bb:	74 0d                	je     801041ca <pipewrite+0x3b>
801041bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041c3:	8b 40 24             	mov    0x24(%eax),%eax
801041c6:	85 c0                	test   %eax,%eax
801041c8:	74 19                	je     801041e3 <pipewrite+0x54>
        release(&p->lock);
801041ca:	8b 45 08             	mov    0x8(%ebp),%eax
801041cd:	83 ec 0c             	sub    $0xc,%esp
801041d0:	50                   	push   %eax
801041d1:	e8 b4 12 00 00       	call   8010548a <release>
801041d6:	83 c4 10             	add    $0x10,%esp
        return -1;
801041d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041de:	e9 a8 00 00 00       	jmp    8010428b <pipewrite+0xfc>
      }
      wakeup(&p->nread);
801041e3:	8b 45 08             	mov    0x8(%ebp),%eax
801041e6:	05 34 02 00 00       	add    $0x234,%eax
801041eb:	83 ec 0c             	sub    $0xc,%esp
801041ee:	50                   	push   %eax
801041ef:	e8 79 0b 00 00       	call   80104d6d <wakeup>
801041f4:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801041f7:	8b 45 08             	mov    0x8(%ebp),%eax
801041fa:	8b 55 08             	mov    0x8(%ebp),%edx
801041fd:	81 c2 38 02 00 00    	add    $0x238,%edx
80104203:	83 ec 08             	sub    $0x8,%esp
80104206:	50                   	push   %eax
80104207:	52                   	push   %edx
80104208:	e8 72 0a 00 00       	call   80104c7f <sleep>
8010420d:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104210:	8b 45 08             	mov    0x8(%ebp),%eax
80104213:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104219:	8b 45 08             	mov    0x8(%ebp),%eax
8010421c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104222:	05 00 02 00 00       	add    $0x200,%eax
80104227:	39 c2                	cmp    %eax,%edx
80104229:	74 85                	je     801041b0 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010422b:	8b 45 08             	mov    0x8(%ebp),%eax
8010422e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104234:	8d 48 01             	lea    0x1(%eax),%ecx
80104237:	8b 55 08             	mov    0x8(%ebp),%edx
8010423a:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104240:	25 ff 01 00 00       	and    $0x1ff,%eax
80104245:	89 c1                	mov    %eax,%ecx
80104247:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010424a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010424d:	01 d0                	add    %edx,%eax
8010424f:	0f b6 10             	movzbl (%eax),%edx
80104252:	8b 45 08             	mov    0x8(%ebp),%eax
80104255:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104259:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010425d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104260:	3b 45 10             	cmp    0x10(%ebp),%eax
80104263:	7c ab                	jl     80104210 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104265:	8b 45 08             	mov    0x8(%ebp),%eax
80104268:	05 34 02 00 00       	add    $0x234,%eax
8010426d:	83 ec 0c             	sub    $0xc,%esp
80104270:	50                   	push   %eax
80104271:	e8 f7 0a 00 00       	call   80104d6d <wakeup>
80104276:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104279:	8b 45 08             	mov    0x8(%ebp),%eax
8010427c:	83 ec 0c             	sub    $0xc,%esp
8010427f:	50                   	push   %eax
80104280:	e8 05 12 00 00       	call   8010548a <release>
80104285:	83 c4 10             	add    $0x10,%esp
  return n;
80104288:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010428b:	c9                   	leave  
8010428c:	c3                   	ret    

8010428d <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010428d:	55                   	push   %ebp
8010428e:	89 e5                	mov    %esp,%ebp
80104290:	53                   	push   %ebx
80104291:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104294:	8b 45 08             	mov    0x8(%ebp),%eax
80104297:	83 ec 0c             	sub    $0xc,%esp
8010429a:	50                   	push   %eax
8010429b:	e8 83 11 00 00       	call   80105423 <acquire>
801042a0:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042a3:	eb 3f                	jmp    801042e4 <piperead+0x57>
    if(proc->killed){
801042a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042ab:	8b 40 24             	mov    0x24(%eax),%eax
801042ae:	85 c0                	test   %eax,%eax
801042b0:	74 19                	je     801042cb <piperead+0x3e>
      release(&p->lock);
801042b2:	8b 45 08             	mov    0x8(%ebp),%eax
801042b5:	83 ec 0c             	sub    $0xc,%esp
801042b8:	50                   	push   %eax
801042b9:	e8 cc 11 00 00       	call   8010548a <release>
801042be:	83 c4 10             	add    $0x10,%esp
      return -1;
801042c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042c6:	e9 bf 00 00 00       	jmp    8010438a <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801042cb:	8b 45 08             	mov    0x8(%ebp),%eax
801042ce:	8b 55 08             	mov    0x8(%ebp),%edx
801042d1:	81 c2 34 02 00 00    	add    $0x234,%edx
801042d7:	83 ec 08             	sub    $0x8,%esp
801042da:	50                   	push   %eax
801042db:	52                   	push   %edx
801042dc:	e8 9e 09 00 00       	call   80104c7f <sleep>
801042e1:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042e4:	8b 45 08             	mov    0x8(%ebp),%eax
801042e7:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801042ed:	8b 45 08             	mov    0x8(%ebp),%eax
801042f0:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042f6:	39 c2                	cmp    %eax,%edx
801042f8:	75 0d                	jne    80104307 <piperead+0x7a>
801042fa:	8b 45 08             	mov    0x8(%ebp),%eax
801042fd:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104303:	85 c0                	test   %eax,%eax
80104305:	75 9e                	jne    801042a5 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104307:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010430e:	eb 49                	jmp    80104359 <piperead+0xcc>
    if(p->nread == p->nwrite)
80104310:	8b 45 08             	mov    0x8(%ebp),%eax
80104313:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104319:	8b 45 08             	mov    0x8(%ebp),%eax
8010431c:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104322:	39 c2                	cmp    %eax,%edx
80104324:	74 3d                	je     80104363 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104326:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104329:	8b 45 0c             	mov    0xc(%ebp),%eax
8010432c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010432f:	8b 45 08             	mov    0x8(%ebp),%eax
80104332:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104338:	8d 48 01             	lea    0x1(%eax),%ecx
8010433b:	8b 55 08             	mov    0x8(%ebp),%edx
8010433e:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104344:	25 ff 01 00 00       	and    $0x1ff,%eax
80104349:	89 c2                	mov    %eax,%edx
8010434b:	8b 45 08             	mov    0x8(%ebp),%eax
8010434e:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104353:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104355:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104359:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010435c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010435f:	7c af                	jl     80104310 <piperead+0x83>
80104361:	eb 01                	jmp    80104364 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
80104363:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104364:	8b 45 08             	mov    0x8(%ebp),%eax
80104367:	05 38 02 00 00       	add    $0x238,%eax
8010436c:	83 ec 0c             	sub    $0xc,%esp
8010436f:	50                   	push   %eax
80104370:	e8 f8 09 00 00       	call   80104d6d <wakeup>
80104375:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104378:	8b 45 08             	mov    0x8(%ebp),%eax
8010437b:	83 ec 0c             	sub    $0xc,%esp
8010437e:	50                   	push   %eax
8010437f:	e8 06 11 00 00       	call   8010548a <release>
80104384:	83 c4 10             	add    $0x10,%esp
  return i;
80104387:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010438a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010438d:	c9                   	leave  
8010438e:	c3                   	ret    

8010438f <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010438f:	55                   	push   %ebp
80104390:	89 e5                	mov    %esp,%ebp
80104392:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104395:	9c                   	pushf  
80104396:	58                   	pop    %eax
80104397:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010439a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010439d:	c9                   	leave  
8010439e:	c3                   	ret    

8010439f <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010439f:	55                   	push   %ebp
801043a0:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801043a2:	fb                   	sti    
}
801043a3:	90                   	nop
801043a4:	5d                   	pop    %ebp
801043a5:	c3                   	ret    

801043a6 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801043a6:	55                   	push   %ebp
801043a7:	89 e5                	mov    %esp,%ebp
801043a9:	83 ec 08             	sub    $0x8,%esp
	initlock(&ptable.lock, "ptable");
801043ac:	83 ec 08             	sub    $0x8,%esp
801043af:	68 74 93 10 80       	push   $0x80109374
801043b4:	68 80 39 11 80       	push   $0x80113980
801043b9:	e8 43 10 00 00       	call   80105401 <initlock>
801043be:	83 c4 10             	add    $0x10,%esp
}
801043c1:	90                   	nop
801043c2:	c9                   	leave  
801043c3:	c3                   	ret    

801043c4 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801043c4:	55                   	push   %ebp
801043c5:	89 e5                	mov    %esp,%ebp
801043c7:	83 ec 18             	sub    $0x18,%esp
	struct proc *p;
	char *sp;

	acquire(&ptable.lock);
801043ca:	83 ec 0c             	sub    $0xc,%esp
801043cd:	68 80 39 11 80       	push   $0x80113980
801043d2:	e8 4c 10 00 00       	call   80105423 <acquire>
801043d7:	83 c4 10             	add    $0x10,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043da:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801043e1:	eb 11                	jmp    801043f4 <allocproc+0x30>
		if(p->state == UNUSED)
801043e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e6:	8b 40 0c             	mov    0xc(%eax),%eax
801043e9:	85 c0                	test   %eax,%eax
801043eb:	74 2a                	je     80104417 <allocproc+0x53>
{
	struct proc *p;
	char *sp;

	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ed:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801043f4:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
801043fb:	72 e6                	jb     801043e3 <allocproc+0x1f>
		if(p->state == UNUSED)
			goto found;
	release(&ptable.lock);
801043fd:	83 ec 0c             	sub    $0xc,%esp
80104400:	68 80 39 11 80       	push   $0x80113980
80104405:	e8 80 10 00 00       	call   8010548a <release>
8010440a:	83 c4 10             	add    $0x10,%esp
	return 0;
8010440d:	b8 00 00 00 00       	mov    $0x0,%eax
80104412:	e9 b4 00 00 00       	jmp    801044cb <allocproc+0x107>
	char *sp;

	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
		if(p->state == UNUSED)
			goto found;
80104417:	90                   	nop
	release(&ptable.lock);
	return 0;

found:
	p->state = EMBRYO;
80104418:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010441b:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
	p->pid = nextpid++;
80104422:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104427:	8d 50 01             	lea    0x1(%eax),%edx
8010442a:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
80104430:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104433:	89 42 10             	mov    %eax,0x10(%edx)
	release(&ptable.lock);
80104436:	83 ec 0c             	sub    $0xc,%esp
80104439:	68 80 39 11 80       	push   $0x80113980
8010443e:	e8 47 10 00 00       	call   8010548a <release>
80104443:	83 c4 10             	add    $0x10,%esp

	// Allocate kernel stack.
	if((p->kstack = kalloc()) == 0){
80104446:	e8 7a e7 ff ff       	call   80102bc5 <kalloc>
8010444b:	89 c2                	mov    %eax,%edx
8010444d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104450:	89 50 08             	mov    %edx,0x8(%eax)
80104453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104456:	8b 40 08             	mov    0x8(%eax),%eax
80104459:	85 c0                	test   %eax,%eax
8010445b:	75 11                	jne    8010446e <allocproc+0xaa>
		p->state = UNUSED;
8010445d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104460:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		return 0;
80104467:	b8 00 00 00 00       	mov    $0x0,%eax
8010446c:	eb 5d                	jmp    801044cb <allocproc+0x107>
	}
	sp = p->kstack + KSTACKSIZE;
8010446e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104471:	8b 40 08             	mov    0x8(%eax),%eax
80104474:	05 00 10 00 00       	add    $0x1000,%eax
80104479:	89 45 f0             	mov    %eax,-0x10(%ebp)

	// Leave room for trap frame.
	sp -= sizeof *p->tf;
8010447c:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
	p->tf = (struct trapframe*)sp;
80104480:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104483:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104486:	89 50 18             	mov    %edx,0x18(%eax)

	// Set up new context to start executing at forkret,
	// which returns to trapret.
	sp -= 4;
80104489:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
	*(uint*)sp = (uint)trapret;
8010448d:	ba 3a 6c 10 80       	mov    $0x80106c3a,%edx
80104492:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104495:	89 10                	mov    %edx,(%eax)

	sp -= sizeof *p->context;
80104497:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
	p->context = (struct context*)sp;
8010449b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010449e:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044a1:	89 50 1c             	mov    %edx,0x1c(%eax)
	memset(p->context, 0, sizeof *p->context);
801044a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a7:	8b 40 1c             	mov    0x1c(%eax),%eax
801044aa:	83 ec 04             	sub    $0x4,%esp
801044ad:	6a 14                	push   $0x14
801044af:	6a 00                	push   $0x0
801044b1:	50                   	push   %eax
801044b2:	e8 cf 11 00 00       	call   80105686 <memset>
801044b7:	83 c4 10             	add    $0x10,%esp
	p->context->eip = (uint)forkret;
801044ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044bd:	8b 40 1c             	mov    0x1c(%eax),%eax
801044c0:	ba 4e 4c 10 80       	mov    $0x80104c4e,%edx
801044c5:	89 50 10             	mov    %edx,0x10(%eax)

	return p;
801044c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044cb:	c9                   	leave  
801044cc:	c3                   	ret    

801044cd <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801044cd:	55                   	push   %ebp
801044ce:	89 e5                	mov    %esp,%ebp
801044d0:	83 ec 18             	sub    $0x18,%esp
	struct proc *p;
	extern char _binary_initcode_start[], _binary_initcode_size[];

	p = allocproc();
801044d3:	e8 ec fe ff ff       	call   801043c4 <allocproc>
801044d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	initproc = p;
801044db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044de:	a3 68 c6 10 80       	mov    %eax,0x8010c668
	if((p->pgdir = setupkvm()) == 0)
801044e3:	e8 17 3e 00 00       	call   801082ff <setupkvm>
801044e8:	89 c2                	mov    %eax,%edx
801044ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ed:	89 50 04             	mov    %edx,0x4(%eax)
801044f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f3:	8b 40 04             	mov    0x4(%eax),%eax
801044f6:	85 c0                	test   %eax,%eax
801044f8:	75 0d                	jne    80104507 <userinit+0x3a>
		panic("userinit: out of memory?");
801044fa:	83 ec 0c             	sub    $0xc,%esp
801044fd:	68 7b 93 10 80       	push   $0x8010937b
80104502:	e8 5f c0 ff ff       	call   80100566 <panic>
	inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104507:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010450c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010450f:	8b 40 04             	mov    0x4(%eax),%eax
80104512:	83 ec 04             	sub    $0x4,%esp
80104515:	52                   	push   %edx
80104516:	68 00 c5 10 80       	push   $0x8010c500
8010451b:	50                   	push   %eax
8010451c:	e8 38 40 00 00       	call   80108559 <inituvm>
80104521:	83 c4 10             	add    $0x10,%esp
	p->sz = PGSIZE;
80104524:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104527:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
	memset(p->tf, 0, sizeof(*p->tf));
8010452d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104530:	8b 40 18             	mov    0x18(%eax),%eax
80104533:	83 ec 04             	sub    $0x4,%esp
80104536:	6a 4c                	push   $0x4c
80104538:	6a 00                	push   $0x0
8010453a:	50                   	push   %eax
8010453b:	e8 46 11 00 00       	call   80105686 <memset>
80104540:	83 c4 10             	add    $0x10,%esp
	p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104546:	8b 40 18             	mov    0x18(%eax),%eax
80104549:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
	p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010454f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104552:	8b 40 18             	mov    0x18(%eax),%eax
80104555:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
	p->tf->es = p->tf->ds;
8010455b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455e:	8b 40 18             	mov    0x18(%eax),%eax
80104561:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104564:	8b 52 18             	mov    0x18(%edx),%edx
80104567:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010456b:	66 89 50 28          	mov    %dx,0x28(%eax)
	p->tf->ss = p->tf->ds;
8010456f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104572:	8b 40 18             	mov    0x18(%eax),%eax
80104575:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104578:	8b 52 18             	mov    0x18(%edx),%edx
8010457b:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010457f:	66 89 50 48          	mov    %dx,0x48(%eax)
	p->tf->eflags = FL_IF;
80104583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104586:	8b 40 18             	mov    0x18(%eax),%eax
80104589:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
	p->tf->esp = PGSIZE;
80104590:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104593:	8b 40 18             	mov    0x18(%eax),%eax
80104596:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
	p->tf->eip = 0;  // beginning of initcode.S
8010459d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a0:	8b 40 18             	mov    0x18(%eax),%eax
801045a3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

	safestrcpy(p->name, "initcode", sizeof(p->name));
801045aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ad:	83 c0 6c             	add    $0x6c,%eax
801045b0:	83 ec 04             	sub    $0x4,%esp
801045b3:	6a 10                	push   $0x10
801045b5:	68 94 93 10 80       	push   $0x80109394
801045ba:	50                   	push   %eax
801045bb:	e8 c9 12 00 00       	call   80105889 <safestrcpy>
801045c0:	83 c4 10             	add    $0x10,%esp
	p->cwd = namei("/");
801045c3:	83 ec 0c             	sub    $0xc,%esp
801045c6:	68 9d 93 10 80       	push   $0x8010939d
801045cb:	e8 f3 de ff ff       	call   801024c3 <namei>
801045d0:	83 c4 10             	add    $0x10,%esp
801045d3:	89 c2                	mov    %eax,%edx
801045d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d8:	89 50 68             	mov    %edx,0x68(%eax)

	p->state = RUNNABLE;
801045db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045de:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
801045e5:	90                   	nop
801045e6:	c9                   	leave  
801045e7:	c3                   	ret    

801045e8 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801045e8:	55                   	push   %ebp
801045e9:	89 e5                	mov    %esp,%ebp
801045eb:	83 ec 18             	sub    $0x18,%esp
	uint sz;

	sz = proc->sz;
801045ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045f4:	8b 00                	mov    (%eax),%eax
801045f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(n > 0){
801045f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801045fd:	7e 31                	jle    80104630 <growproc+0x48>
		if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801045ff:	8b 55 08             	mov    0x8(%ebp),%edx
80104602:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104605:	01 c2                	add    %eax,%edx
80104607:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010460d:	8b 40 04             	mov    0x4(%eax),%eax
80104610:	83 ec 04             	sub    $0x4,%esp
80104613:	52                   	push   %edx
80104614:	ff 75 f4             	pushl  -0xc(%ebp)
80104617:	50                   	push   %eax
80104618:	e8 89 40 00 00       	call   801086a6 <allocuvm>
8010461d:	83 c4 10             	add    $0x10,%esp
80104620:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104623:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104627:	75 3e                	jne    80104667 <growproc+0x7f>
			return -1;
80104629:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010462e:	eb 59                	jmp    80104689 <growproc+0xa1>
	} else if(n < 0){
80104630:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104634:	79 31                	jns    80104667 <growproc+0x7f>
		if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104636:	8b 55 08             	mov    0x8(%ebp),%edx
80104639:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463c:	01 c2                	add    %eax,%edx
8010463e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104644:	8b 40 04             	mov    0x4(%eax),%eax
80104647:	83 ec 04             	sub    $0x4,%esp
8010464a:	52                   	push   %edx
8010464b:	ff 75 f4             	pushl  -0xc(%ebp)
8010464e:	50                   	push   %eax
8010464f:	e8 1b 41 00 00       	call   8010876f <deallocuvm>
80104654:	83 c4 10             	add    $0x10,%esp
80104657:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010465a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010465e:	75 07                	jne    80104667 <growproc+0x7f>
			return -1;
80104660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104665:	eb 22                	jmp    80104689 <growproc+0xa1>
	}
	proc->sz = sz;
80104667:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010466d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104670:	89 10                	mov    %edx,(%eax)
	switchuvm(proc);
80104672:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104678:	83 ec 0c             	sub    $0xc,%esp
8010467b:	50                   	push   %eax
8010467c:	e8 65 3d 00 00       	call   801083e6 <switchuvm>
80104681:	83 c4 10             	add    $0x10,%esp
	return 0;
80104684:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104689:	c9                   	leave  
8010468a:	c3                   	ret    

8010468b <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010468b:	55                   	push   %ebp
8010468c:	89 e5                	mov    %esp,%ebp
8010468e:	57                   	push   %edi
8010468f:	56                   	push   %esi
80104690:	53                   	push   %ebx
80104691:	83 ec 1c             	sub    $0x1c,%esp
	int i, pid;
	struct proc *np;

	// Allocate process.
	if((np = allocproc()) == 0)
80104694:	e8 2b fd ff ff       	call   801043c4 <allocproc>
80104699:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010469c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801046a0:	75 0a                	jne    801046ac <fork+0x21>
		return -1;
801046a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046a7:	e9 68 01 00 00       	jmp    80104814 <fork+0x189>

	// Copy process state from p.
	if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801046ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b2:	8b 10                	mov    (%eax),%edx
801046b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ba:	8b 40 04             	mov    0x4(%eax),%eax
801046bd:	83 ec 08             	sub    $0x8,%esp
801046c0:	52                   	push   %edx
801046c1:	50                   	push   %eax
801046c2:	e8 46 42 00 00       	call   8010890d <copyuvm>
801046c7:	83 c4 10             	add    $0x10,%esp
801046ca:	89 c2                	mov    %eax,%edx
801046cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046cf:	89 50 04             	mov    %edx,0x4(%eax)
801046d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046d5:	8b 40 04             	mov    0x4(%eax),%eax
801046d8:	85 c0                	test   %eax,%eax
801046da:	75 30                	jne    8010470c <fork+0x81>
		kfree(np->kstack);
801046dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046df:	8b 40 08             	mov    0x8(%eax),%eax
801046e2:	83 ec 0c             	sub    $0xc,%esp
801046e5:	50                   	push   %eax
801046e6:	e8 3d e4 ff ff       	call   80102b28 <kfree>
801046eb:	83 c4 10             	add    $0x10,%esp
		np->kstack = 0;
801046ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		np->state = UNUSED;
801046f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046fb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		return -1;
80104702:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104707:	e9 08 01 00 00       	jmp    80104814 <fork+0x189>
	}
	np->sz = proc->sz;
8010470c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104712:	8b 10                	mov    (%eax),%edx
80104714:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104717:	89 10                	mov    %edx,(%eax)
	np->parent = proc;
80104719:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104720:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104723:	89 50 14             	mov    %edx,0x14(%eax)
	*np->tf = *proc->tf;
80104726:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104729:	8b 50 18             	mov    0x18(%eax),%edx
8010472c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104732:	8b 40 18             	mov    0x18(%eax),%eax
80104735:	89 c3                	mov    %eax,%ebx
80104737:	b8 13 00 00 00       	mov    $0x13,%eax
8010473c:	89 d7                	mov    %edx,%edi
8010473e:	89 de                	mov    %ebx,%esi
80104740:	89 c1                	mov    %eax,%ecx
80104742:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	// Clear %eax so that fork returns 0 in the child.
	np->tf->eax = 0;
80104744:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104747:	8b 40 18             	mov    0x18(%eax),%eax
8010474a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	for(i = 0; i < NOFILE; i++)
80104751:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104758:	eb 43                	jmp    8010479d <fork+0x112>
		if(proc->ofile[i])
8010475a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104760:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104763:	83 c2 08             	add    $0x8,%edx
80104766:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010476a:	85 c0                	test   %eax,%eax
8010476c:	74 2b                	je     80104799 <fork+0x10e>
			np->ofile[i] = filedup(proc->ofile[i]);
8010476e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104774:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104777:	83 c2 08             	add    $0x8,%edx
8010477a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010477e:	83 ec 0c             	sub    $0xc,%esp
80104781:	50                   	push   %eax
80104782:	e8 5e c8 ff ff       	call   80100fe5 <filedup>
80104787:	83 c4 10             	add    $0x10,%esp
8010478a:	89 c1                	mov    %eax,%ecx
8010478c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010478f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104792:	83 c2 08             	add    $0x8,%edx
80104795:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
	*np->tf = *proc->tf;

	// Clear %eax so that fork returns 0 in the child.
	np->tf->eax = 0;

	for(i = 0; i < NOFILE; i++)
80104799:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010479d:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801047a1:	7e b7                	jle    8010475a <fork+0xcf>
		if(proc->ofile[i])
			np->ofile[i] = filedup(proc->ofile[i]);
	np->cwd = idup(proc->cwd);
801047a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a9:	8b 40 68             	mov    0x68(%eax),%eax
801047ac:	83 ec 0c             	sub    $0xc,%esp
801047af:	50                   	push   %eax
801047b0:	e8 1c d1 ff ff       	call   801018d1 <idup>
801047b5:	83 c4 10             	add    $0x10,%esp
801047b8:	89 c2                	mov    %eax,%edx
801047ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047bd:	89 50 68             	mov    %edx,0x68(%eax)

	safestrcpy(np->name, proc->name, sizeof(proc->name));
801047c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047c6:	8d 50 6c             	lea    0x6c(%eax),%edx
801047c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047cc:	83 c0 6c             	add    $0x6c,%eax
801047cf:	83 ec 04             	sub    $0x4,%esp
801047d2:	6a 10                	push   $0x10
801047d4:	52                   	push   %edx
801047d5:	50                   	push   %eax
801047d6:	e8 ae 10 00 00       	call   80105889 <safestrcpy>
801047db:	83 c4 10             	add    $0x10,%esp

	pid = np->pid;
801047de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047e1:	8b 40 10             	mov    0x10(%eax),%eax
801047e4:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// lock to force the compiler to emit the np->state write last.
	acquire(&ptable.lock);
801047e7:	83 ec 0c             	sub    $0xc,%esp
801047ea:	68 80 39 11 80       	push   $0x80113980
801047ef:	e8 2f 0c 00 00       	call   80105423 <acquire>
801047f4:	83 c4 10             	add    $0x10,%esp
	np->state = RUNNABLE;
801047f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047fa:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
	release(&ptable.lock);
80104801:	83 ec 0c             	sub    $0xc,%esp
80104804:	68 80 39 11 80       	push   $0x80113980
80104809:	e8 7c 0c 00 00       	call   8010548a <release>
8010480e:	83 c4 10             	add    $0x10,%esp

	return pid;
80104811:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104814:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104817:	5b                   	pop    %ebx
80104818:	5e                   	pop    %esi
80104819:	5f                   	pop    %edi
8010481a:	5d                   	pop    %ebp
8010481b:	c3                   	ret    

8010481c <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010481c:	55                   	push   %ebp
8010481d:	89 e5                	mov    %esp,%ebp
8010481f:	83 ec 18             	sub    $0x18,%esp
	struct proc *p;
	int fd;

	if(proc == initproc)
80104822:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104829:	a1 68 c6 10 80       	mov    0x8010c668,%eax
8010482e:	39 c2                	cmp    %eax,%edx
80104830:	75 0d                	jne    8010483f <exit+0x23>
		panic("init exiting");
80104832:	83 ec 0c             	sub    $0xc,%esp
80104835:	68 9f 93 10 80       	push   $0x8010939f
8010483a:	e8 27 bd ff ff       	call   80100566 <panic>

	// Close all open files.
	for(fd = 0; fd < NOFILE; fd++){
8010483f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104846:	eb 48                	jmp    80104890 <exit+0x74>
		if(proc->ofile[fd]){
80104848:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010484e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104851:	83 c2 08             	add    $0x8,%edx
80104854:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104858:	85 c0                	test   %eax,%eax
8010485a:	74 30                	je     8010488c <exit+0x70>
			fileclose(proc->ofile[fd]);
8010485c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104862:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104865:	83 c2 08             	add    $0x8,%edx
80104868:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010486c:	83 ec 0c             	sub    $0xc,%esp
8010486f:	50                   	push   %eax
80104870:	e8 c1 c7 ff ff       	call   80101036 <fileclose>
80104875:	83 c4 10             	add    $0x10,%esp
			proc->ofile[fd] = 0;
80104878:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010487e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104881:	83 c2 08             	add    $0x8,%edx
80104884:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010488b:	00 

	if(proc == initproc)
		panic("init exiting");

	// Close all open files.
	for(fd = 0; fd < NOFILE; fd++){
8010488c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104890:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104894:	7e b2                	jle    80104848 <exit+0x2c>
			fileclose(proc->ofile[fd]);
			proc->ofile[fd] = 0;
		}
	}

	begin_op();
80104896:	e8 19 ec ff ff       	call   801034b4 <begin_op>
	iput(proc->cwd);
8010489b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048a1:	8b 40 68             	mov    0x68(%eax),%eax
801048a4:	83 ec 0c             	sub    $0xc,%esp
801048a7:	50                   	push   %eax
801048a8:	e8 28 d2 ff ff       	call   80101ad5 <iput>
801048ad:	83 c4 10             	add    $0x10,%esp
	end_op();
801048b0:	e8 8b ec ff ff       	call   80103540 <end_op>
	proc->cwd = 0;
801048b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048bb:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

	acquire(&ptable.lock);
801048c2:	83 ec 0c             	sub    $0xc,%esp
801048c5:	68 80 39 11 80       	push   $0x80113980
801048ca:	e8 54 0b 00 00       	call   80105423 <acquire>
801048cf:	83 c4 10             	add    $0x10,%esp

	// Parent might be sleeping in wait().
	wakeup1(proc->parent);
801048d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d8:	8b 40 14             	mov    0x14(%eax),%eax
801048db:	83 ec 0c             	sub    $0xc,%esp
801048de:	50                   	push   %eax
801048df:	e8 47 04 00 00       	call   80104d2b <wakeup1>
801048e4:	83 c4 10             	add    $0x10,%esp

	// Pass abandoned children to init.
	// And kill the child threads and free their stacks
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048e7:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801048ee:	eb 70                	jmp    80104960 <exit+0x144>
		if(p->parent == proc){
801048f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f3:	8b 50 14             	mov    0x14(%eax),%edx
801048f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048fc:	39 c2                	cmp    %eax,%edx
801048fe:	75 59                	jne    80104959 <exit+0x13d>
			p->parent = initproc;
80104900:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104909:	89 50 14             	mov    %edx,0x14(%eax)
			// clean up the kernel stack of child threads
			if(p->isthread == 1){
8010490c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010490f:	8b 40 7c             	mov    0x7c(%eax),%eax
80104912:	83 f8 01             	cmp    $0x1,%eax
80104915:	75 26                	jne    8010493d <exit+0x121>
				p->state = UNUSED;
80104917:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				kfree(p->kstack);
80104921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104924:	8b 40 08             	mov    0x8(%eax),%eax
80104927:	83 ec 0c             	sub    $0xc,%esp
8010492a:	50                   	push   %eax
8010492b:	e8 f8 e1 ff ff       	call   80102b28 <kfree>
80104930:	83 c4 10             	add    $0x10,%esp
				p->kstack = 0;
80104933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104936:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			}
			if(p->state == ZOMBIE)
8010493d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104940:	8b 40 0c             	mov    0xc(%eax),%eax
80104943:	83 f8 05             	cmp    $0x5,%eax
80104946:	75 11                	jne    80104959 <exit+0x13d>
				wakeup1(initproc);
80104948:	a1 68 c6 10 80       	mov    0x8010c668,%eax
8010494d:	83 ec 0c             	sub    $0xc,%esp
80104950:	50                   	push   %eax
80104951:	e8 d5 03 00 00       	call   80104d2b <wakeup1>
80104956:	83 c4 10             	add    $0x10,%esp
	// Parent might be sleeping in wait().
	wakeup1(proc->parent);

	// Pass abandoned children to init.
	// And kill the child threads and free their stacks
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104959:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104960:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
80104967:	72 87                	jb     801048f0 <exit+0xd4>
				wakeup1(initproc);
		}
	}   

	// Jump into the scheduler, never to return.
	proc->state = ZOMBIE;
80104969:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010496f:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
	sched();
80104976:	e8 dc 01 00 00       	call   80104b57 <sched>
	panic("zombie exit");
8010497b:	83 ec 0c             	sub    $0xc,%esp
8010497e:	68 ac 93 10 80       	push   $0x801093ac
80104983:	e8 de bb ff ff       	call   80100566 <panic>

80104988 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104988:	55                   	push   %ebp
80104989:	89 e5                	mov    %esp,%ebp
8010498b:	83 ec 18             	sub    $0x18,%esp
	struct proc *p;
	int havekids, pid;

	acquire(&ptable.lock);
8010498e:	83 ec 0c             	sub    $0xc,%esp
80104991:	68 80 39 11 80       	push   $0x80113980
80104996:	e8 88 0a 00 00       	call   80105423 <acquire>
8010499b:	83 c4 10             	add    $0x10,%esp
	for(;;){
		// Scan through table looking for zombie children.
		havekids = 0;
8010499e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049a5:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801049ac:	e9 a9 00 00 00       	jmp    80104a5a <wait+0xd2>
			if(p->parent != proc)
801049b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b4:	8b 50 14             	mov    0x14(%eax),%edx
801049b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049bd:	39 c2                	cmp    %eax,%edx
801049bf:	0f 85 8d 00 00 00    	jne    80104a52 <wait+0xca>
				continue;
			havekids = 1;
801049c5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
			if(p->state == ZOMBIE){
801049cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049cf:	8b 40 0c             	mov    0xc(%eax),%eax
801049d2:	83 f8 05             	cmp    $0x5,%eax
801049d5:	75 7c                	jne    80104a53 <wait+0xcb>
				// Found one.
				pid = p->pid;
801049d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049da:	8b 40 10             	mov    0x10(%eax),%eax
801049dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
				kfree(p->kstack);
801049e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e3:	8b 40 08             	mov    0x8(%eax),%eax
801049e6:	83 ec 0c             	sub    $0xc,%esp
801049e9:	50                   	push   %eax
801049ea:	e8 39 e1 ff ff       	call   80102b28 <kfree>
801049ef:	83 c4 10             	add    $0x10,%esp
				p->kstack = 0;
801049f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				freevm(p->pgdir);
801049fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ff:	8b 40 04             	mov    0x4(%eax),%eax
80104a02:	83 ec 0c             	sub    $0xc,%esp
80104a05:	50                   	push   %eax
80104a06:	e8 21 3e 00 00       	call   8010882c <freevm>
80104a0b:	83 c4 10             	add    $0x10,%esp
				p->state = UNUSED;
80104a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a11:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				p->pid = 0;
80104a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a1b:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
				p->parent = 0;
80104a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a25:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
				p->name[0] = 0;
80104a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a2f:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
				p->killed = 0;
80104a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a36:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
				release(&ptable.lock);
80104a3d:	83 ec 0c             	sub    $0xc,%esp
80104a40:	68 80 39 11 80       	push   $0x80113980
80104a45:	e8 40 0a 00 00       	call   8010548a <release>
80104a4a:	83 c4 10             	add    $0x10,%esp
				return pid;
80104a4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a50:	eb 5b                	jmp    80104aad <wait+0x125>
	for(;;){
		// Scan through table looking for zombie children.
		havekids = 0;
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
			if(p->parent != proc)
				continue;
80104a52:	90                   	nop

	acquire(&ptable.lock);
	for(;;){
		// Scan through table looking for zombie children.
		havekids = 0;
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a53:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104a5a:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
80104a61:	0f 82 4a ff ff ff    	jb     801049b1 <wait+0x29>
				return pid;
			}
		}

		// No point waiting if we don't have any children.
		if(!havekids || proc->killed){
80104a67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a6b:	74 0d                	je     80104a7a <wait+0xf2>
80104a6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a73:	8b 40 24             	mov    0x24(%eax),%eax
80104a76:	85 c0                	test   %eax,%eax
80104a78:	74 17                	je     80104a91 <wait+0x109>
			release(&ptable.lock);
80104a7a:	83 ec 0c             	sub    $0xc,%esp
80104a7d:	68 80 39 11 80       	push   $0x80113980
80104a82:	e8 03 0a 00 00       	call   8010548a <release>
80104a87:	83 c4 10             	add    $0x10,%esp
			return -1;
80104a8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a8f:	eb 1c                	jmp    80104aad <wait+0x125>
		}

		// Wait for children to exit.  (See wakeup1 call in proc_exit.)
		sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104a91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a97:	83 ec 08             	sub    $0x8,%esp
80104a9a:	68 80 39 11 80       	push   $0x80113980
80104a9f:	50                   	push   %eax
80104aa0:	e8 da 01 00 00       	call   80104c7f <sleep>
80104aa5:	83 c4 10             	add    $0x10,%esp
	}
80104aa8:	e9 f1 fe ff ff       	jmp    8010499e <wait+0x16>
}
80104aad:	c9                   	leave  
80104aae:	c3                   	ret    

80104aaf <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104aaf:	55                   	push   %ebp
80104ab0:	89 e5                	mov    %esp,%ebp
80104ab2:	83 ec 18             	sub    $0x18,%esp
	struct proc *p;

	for(;;){
		// Enable interrupts on this processor.
		sti();
80104ab5:	e8 e5 f8 ff ff       	call   8010439f <sti>

		// Loop over process table looking for process to run.
		acquire(&ptable.lock);
80104aba:	83 ec 0c             	sub    $0xc,%esp
80104abd:	68 80 39 11 80       	push   $0x80113980
80104ac2:	e8 5c 09 00 00       	call   80105423 <acquire>
80104ac7:	83 c4 10             	add    $0x10,%esp
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104aca:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104ad1:	eb 66                	jmp    80104b39 <scheduler+0x8a>
			if(p->state != RUNNABLE)
80104ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad6:	8b 40 0c             	mov    0xc(%eax),%eax
80104ad9:	83 f8 03             	cmp    $0x3,%eax
80104adc:	75 53                	jne    80104b31 <scheduler+0x82>
				continue;

			// Switch to chosen process.  It is the process's job
			// to release ptable.lock and then reacquire it
			// before jumping back to us.
			proc = p;
80104ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae1:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
			switchuvm(p);
80104ae7:	83 ec 0c             	sub    $0xc,%esp
80104aea:	ff 75 f4             	pushl  -0xc(%ebp)
80104aed:	e8 f4 38 00 00       	call   801083e6 <switchuvm>
80104af2:	83 c4 10             	add    $0x10,%esp
			p->state = RUNNING;
80104af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af8:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
			swtch(&cpu->scheduler, proc->context);
80104aff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b05:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b08:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104b0f:	83 c2 04             	add    $0x4,%edx
80104b12:	83 ec 08             	sub    $0x8,%esp
80104b15:	50                   	push   %eax
80104b16:	52                   	push   %edx
80104b17:	e8 de 0d 00 00       	call   801058fa <swtch>
80104b1c:	83 c4 10             	add    $0x10,%esp
			switchkvm();
80104b1f:	e8 a5 38 00 00       	call   801083c9 <switchkvm>

			// Process is done running for now.
			// It should have changed its p->state before coming back.
			proc = 0;
80104b24:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104b2b:	00 00 00 00 
80104b2f:	eb 01                	jmp    80104b32 <scheduler+0x83>

		// Loop over process table looking for process to run.
		acquire(&ptable.lock);
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
			if(p->state != RUNNABLE)
				continue;
80104b31:	90                   	nop
		// Enable interrupts on this processor.
		sti();

		// Loop over process table looking for process to run.
		acquire(&ptable.lock);
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b32:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104b39:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
80104b40:	72 91                	jb     80104ad3 <scheduler+0x24>

			// Process is done running for now.
			// It should have changed its p->state before coming back.
			proc = 0;
		}
		release(&ptable.lock);
80104b42:	83 ec 0c             	sub    $0xc,%esp
80104b45:	68 80 39 11 80       	push   $0x80113980
80104b4a:	e8 3b 09 00 00       	call   8010548a <release>
80104b4f:	83 c4 10             	add    $0x10,%esp

	}
80104b52:	e9 5e ff ff ff       	jmp    80104ab5 <scheduler+0x6>

80104b57 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104b57:	55                   	push   %ebp
80104b58:	89 e5                	mov    %esp,%ebp
80104b5a:	83 ec 18             	sub    $0x18,%esp
	int intena;

	if(!holding(&ptable.lock))
80104b5d:	83 ec 0c             	sub    $0xc,%esp
80104b60:	68 80 39 11 80       	push   $0x80113980
80104b65:	e8 ec 09 00 00       	call   80105556 <holding>
80104b6a:	83 c4 10             	add    $0x10,%esp
80104b6d:	85 c0                	test   %eax,%eax
80104b6f:	75 0d                	jne    80104b7e <sched+0x27>
		panic("sched ptable.lock");
80104b71:	83 ec 0c             	sub    $0xc,%esp
80104b74:	68 b8 93 10 80       	push   $0x801093b8
80104b79:	e8 e8 b9 ff ff       	call   80100566 <panic>

	if(cpu->ncli != 1)
80104b7e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b84:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104b8a:	83 f8 01             	cmp    $0x1,%eax
80104b8d:	74 0d                	je     80104b9c <sched+0x45>
		panic("sched locks");
80104b8f:	83 ec 0c             	sub    $0xc,%esp
80104b92:	68 ca 93 10 80       	push   $0x801093ca
80104b97:	e8 ca b9 ff ff       	call   80100566 <panic>

	if(proc->state == RUNNING)
80104b9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ba2:	8b 40 0c             	mov    0xc(%eax),%eax
80104ba5:	83 f8 04             	cmp    $0x4,%eax
80104ba8:	75 0d                	jne    80104bb7 <sched+0x60>
		panic("sched running");
80104baa:	83 ec 0c             	sub    $0xc,%esp
80104bad:	68 d6 93 10 80       	push   $0x801093d6
80104bb2:	e8 af b9 ff ff       	call   80100566 <panic>
	if(readeflags()&FL_IF)
80104bb7:	e8 d3 f7 ff ff       	call   8010438f <readeflags>
80104bbc:	25 00 02 00 00       	and    $0x200,%eax
80104bc1:	85 c0                	test   %eax,%eax
80104bc3:	74 0d                	je     80104bd2 <sched+0x7b>
		panic("sched interruptible");
80104bc5:	83 ec 0c             	sub    $0xc,%esp
80104bc8:	68 e4 93 10 80       	push   $0x801093e4
80104bcd:	e8 94 b9 ff ff       	call   80100566 <panic>
	intena = cpu->intena;
80104bd2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bd8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104bde:	89 45 f4             	mov    %eax,-0xc(%ebp)
	swtch(&proc->context, cpu->scheduler);
80104be1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104be7:	8b 40 04             	mov    0x4(%eax),%eax
80104bea:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104bf1:	83 c2 1c             	add    $0x1c,%edx
80104bf4:	83 ec 08             	sub    $0x8,%esp
80104bf7:	50                   	push   %eax
80104bf8:	52                   	push   %edx
80104bf9:	e8 fc 0c 00 00       	call   801058fa <swtch>
80104bfe:	83 c4 10             	add    $0x10,%esp
	cpu->intena = intena;
80104c01:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c07:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c0a:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104c10:	90                   	nop
80104c11:	c9                   	leave  
80104c12:	c3                   	ret    

80104c13 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104c13:	55                   	push   %ebp
80104c14:	89 e5                	mov    %esp,%ebp
80104c16:	83 ec 08             	sub    $0x8,%esp
	acquire(&ptable.lock);  //DOC: yieldlock
80104c19:	83 ec 0c             	sub    $0xc,%esp
80104c1c:	68 80 39 11 80       	push   $0x80113980
80104c21:	e8 fd 07 00 00       	call   80105423 <acquire>
80104c26:	83 c4 10             	add    $0x10,%esp
	proc->state = RUNNABLE;
80104c29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c2f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
	sched();
80104c36:	e8 1c ff ff ff       	call   80104b57 <sched>
	release(&ptable.lock);
80104c3b:	83 ec 0c             	sub    $0xc,%esp
80104c3e:	68 80 39 11 80       	push   $0x80113980
80104c43:	e8 42 08 00 00       	call   8010548a <release>
80104c48:	83 c4 10             	add    $0x10,%esp
}
80104c4b:	90                   	nop
80104c4c:	c9                   	leave  
80104c4d:	c3                   	ret    

80104c4e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104c4e:	55                   	push   %ebp
80104c4f:	89 e5                	mov    %esp,%ebp
80104c51:	83 ec 08             	sub    $0x8,%esp
	static int first = 1;
	// Still holding ptable.lock from scheduler.
	release(&ptable.lock);
80104c54:	83 ec 0c             	sub    $0xc,%esp
80104c57:	68 80 39 11 80       	push   $0x80113980
80104c5c:	e8 29 08 00 00       	call   8010548a <release>
80104c61:	83 c4 10             	add    $0x10,%esp

	if (first) {
80104c64:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104c69:	85 c0                	test   %eax,%eax
80104c6b:	74 0f                	je     80104c7c <forkret+0x2e>
		// Some initialization functions must be run in the context
		// of a regular process (e.g., they call sleep), and thus cannot 
		// be run from main().
		first = 0;
80104c6d:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104c74:	00 00 00 
		initlog();
80104c77:	e8 12 e6 ff ff       	call   8010328e <initlog>
	}

	// Return to "caller", actually trapret (see allocproc).
}
80104c7c:	90                   	nop
80104c7d:	c9                   	leave  
80104c7e:	c3                   	ret    

80104c7f <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104c7f:	55                   	push   %ebp
80104c80:	89 e5                	mov    %esp,%ebp
80104c82:	83 ec 08             	sub    $0x8,%esp
	if(proc == 0)
80104c85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c8b:	85 c0                	test   %eax,%eax
80104c8d:	75 0d                	jne    80104c9c <sleep+0x1d>
		panic("sleep");
80104c8f:	83 ec 0c             	sub    $0xc,%esp
80104c92:	68 f8 93 10 80       	push   $0x801093f8
80104c97:	e8 ca b8 ff ff       	call   80100566 <panic>

	if(lk == 0)
80104c9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104ca0:	75 0d                	jne    80104caf <sleep+0x30>
		panic("sleep without lk");
80104ca2:	83 ec 0c             	sub    $0xc,%esp
80104ca5:	68 fe 93 10 80       	push   $0x801093fe
80104caa:	e8 b7 b8 ff ff       	call   80100566 <panic>
	// change p->state and then call sched.
	// Once we hold ptable.lock, we can be
	// guaranteed that we won't miss any wakeup
	// (wakeup runs with ptable.lock locked),
	// so it's okay to release lk.
	if(lk != &ptable.lock){  //DOC: sleeplock0
80104caf:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104cb6:	74 1e                	je     80104cd6 <sleep+0x57>
		acquire(&ptable.lock);  //DOC: sleeplock1
80104cb8:	83 ec 0c             	sub    $0xc,%esp
80104cbb:	68 80 39 11 80       	push   $0x80113980
80104cc0:	e8 5e 07 00 00       	call   80105423 <acquire>
80104cc5:	83 c4 10             	add    $0x10,%esp
		release(lk);
80104cc8:	83 ec 0c             	sub    $0xc,%esp
80104ccb:	ff 75 0c             	pushl  0xc(%ebp)
80104cce:	e8 b7 07 00 00       	call   8010548a <release>
80104cd3:	83 c4 10             	add    $0x10,%esp
	}

	// Go to sleep.
	proc->chan = chan;
80104cd6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cdc:	8b 55 08             	mov    0x8(%ebp),%edx
80104cdf:	89 50 20             	mov    %edx,0x20(%eax)
	proc->state = SLEEPING;
80104ce2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ce8:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
	sched();
80104cef:	e8 63 fe ff ff       	call   80104b57 <sched>

	// Tidy up.
	proc->chan = 0;
80104cf4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cfa:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

	// Reacquire original lock.
	if(lk != &ptable.lock){  //DOC: sleeplock2
80104d01:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104d08:	74 1e                	je     80104d28 <sleep+0xa9>
		release(&ptable.lock);
80104d0a:	83 ec 0c             	sub    $0xc,%esp
80104d0d:	68 80 39 11 80       	push   $0x80113980
80104d12:	e8 73 07 00 00       	call   8010548a <release>
80104d17:	83 c4 10             	add    $0x10,%esp
		acquire(lk);
80104d1a:	83 ec 0c             	sub    $0xc,%esp
80104d1d:	ff 75 0c             	pushl  0xc(%ebp)
80104d20:	e8 fe 06 00 00       	call   80105423 <acquire>
80104d25:	83 c4 10             	add    $0x10,%esp
	}
}
80104d28:	90                   	nop
80104d29:	c9                   	leave  
80104d2a:	c3                   	ret    

80104d2b <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104d2b:	55                   	push   %ebp
80104d2c:	89 e5                	mov    %esp,%ebp
80104d2e:	83 ec 10             	sub    $0x10,%esp
	struct proc *p;

	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d31:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80104d38:	eb 27                	jmp    80104d61 <wakeup1+0x36>
		if(p->state == SLEEPING && p->chan == chan)
80104d3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d3d:	8b 40 0c             	mov    0xc(%eax),%eax
80104d40:	83 f8 02             	cmp    $0x2,%eax
80104d43:	75 15                	jne    80104d5a <wakeup1+0x2f>
80104d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d48:	8b 40 20             	mov    0x20(%eax),%eax
80104d4b:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d4e:	75 0a                	jne    80104d5a <wakeup1+0x2f>
			p->state = RUNNABLE;
80104d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d53:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
	struct proc *p;

	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d5a:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104d61:	81 7d fc b4 5a 11 80 	cmpl   $0x80115ab4,-0x4(%ebp)
80104d68:	72 d0                	jb     80104d3a <wakeup1+0xf>
		if(p->state == SLEEPING && p->chan == chan)
			p->state = RUNNABLE;
}
80104d6a:	90                   	nop
80104d6b:	c9                   	leave  
80104d6c:	c3                   	ret    

80104d6d <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104d6d:	55                   	push   %ebp
80104d6e:	89 e5                	mov    %esp,%ebp
80104d70:	83 ec 08             	sub    $0x8,%esp
	acquire(&ptable.lock);
80104d73:	83 ec 0c             	sub    $0xc,%esp
80104d76:	68 80 39 11 80       	push   $0x80113980
80104d7b:	e8 a3 06 00 00       	call   80105423 <acquire>
80104d80:	83 c4 10             	add    $0x10,%esp
	wakeup1(chan);
80104d83:	83 ec 0c             	sub    $0xc,%esp
80104d86:	ff 75 08             	pushl  0x8(%ebp)
80104d89:	e8 9d ff ff ff       	call   80104d2b <wakeup1>
80104d8e:	83 c4 10             	add    $0x10,%esp
	release(&ptable.lock);
80104d91:	83 ec 0c             	sub    $0xc,%esp
80104d94:	68 80 39 11 80       	push   $0x80113980
80104d99:	e8 ec 06 00 00       	call   8010548a <release>
80104d9e:	83 c4 10             	add    $0x10,%esp
}
80104da1:	90                   	nop
80104da2:	c9                   	leave  
80104da3:	c3                   	ret    

80104da4 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104da4:	55                   	push   %ebp
80104da5:	89 e5                	mov    %esp,%ebp
80104da7:	83 ec 18             	sub    $0x18,%esp
	struct proc *p;

	acquire(&ptable.lock);
80104daa:	83 ec 0c             	sub    $0xc,%esp
80104dad:	68 80 39 11 80       	push   $0x80113980
80104db2:	e8 6c 06 00 00       	call   80105423 <acquire>
80104db7:	83 c4 10             	add    $0x10,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dba:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104dc1:	eb 48                	jmp    80104e0b <kill+0x67>
		if(p->pid == pid){
80104dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc6:	8b 40 10             	mov    0x10(%eax),%eax
80104dc9:	3b 45 08             	cmp    0x8(%ebp),%eax
80104dcc:	75 36                	jne    80104e04 <kill+0x60>
			p->killed = 1;
80104dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd1:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
			// Wake process from sleep if necessary.
			if(p->state == SLEEPING)
80104dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ddb:	8b 40 0c             	mov    0xc(%eax),%eax
80104dde:	83 f8 02             	cmp    $0x2,%eax
80104de1:	75 0a                	jne    80104ded <kill+0x49>
				p->state = RUNNABLE;
80104de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104de6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
			release(&ptable.lock);
80104ded:	83 ec 0c             	sub    $0xc,%esp
80104df0:	68 80 39 11 80       	push   $0x80113980
80104df5:	e8 90 06 00 00       	call   8010548a <release>
80104dfa:	83 c4 10             	add    $0x10,%esp
			return 0;
80104dfd:	b8 00 00 00 00       	mov    $0x0,%eax
80104e02:	eb 25                	jmp    80104e29 <kill+0x85>
kill(int pid)
{
	struct proc *p;

	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e04:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104e0b:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
80104e12:	72 af                	jb     80104dc3 <kill+0x1f>
				p->state = RUNNABLE;
			release(&ptable.lock);
			return 0;
		}
	}
	release(&ptable.lock);
80104e14:	83 ec 0c             	sub    $0xc,%esp
80104e17:	68 80 39 11 80       	push   $0x80113980
80104e1c:	e8 69 06 00 00       	call   8010548a <release>
80104e21:	83 c4 10             	add    $0x10,%esp
	return -1;
80104e24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e29:	c9                   	leave  
80104e2a:	c3                   	ret    

80104e2b <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104e2b:	55                   	push   %ebp
80104e2c:	89 e5                	mov    %esp,%ebp
80104e2e:	83 ec 48             	sub    $0x48,%esp
	int i;
	struct proc *p;
	char *state;
	uint pc[10];

	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e31:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
80104e38:	e9 da 00 00 00       	jmp    80104f17 <procdump+0xec>
		if(p->state == UNUSED)
80104e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e40:	8b 40 0c             	mov    0xc(%eax),%eax
80104e43:	85 c0                	test   %eax,%eax
80104e45:	0f 84 c4 00 00 00    	je     80104f0f <procdump+0xe4>
			continue;
		if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e4e:	8b 40 0c             	mov    0xc(%eax),%eax
80104e51:	83 f8 05             	cmp    $0x5,%eax
80104e54:	77 23                	ja     80104e79 <procdump+0x4e>
80104e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e59:	8b 40 0c             	mov    0xc(%eax),%eax
80104e5c:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104e63:	85 c0                	test   %eax,%eax
80104e65:	74 12                	je     80104e79 <procdump+0x4e>
			state = states[p->state];
80104e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e6a:	8b 40 0c             	mov    0xc(%eax),%eax
80104e6d:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104e74:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104e77:	eb 07                	jmp    80104e80 <procdump+0x55>
		else
			state = "???";
80104e79:	c7 45 ec 0f 94 10 80 	movl   $0x8010940f,-0x14(%ebp)
		cprintf("%d %s %s", p->pid, state, p->name);
80104e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e83:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e89:	8b 40 10             	mov    0x10(%eax),%eax
80104e8c:	52                   	push   %edx
80104e8d:	ff 75 ec             	pushl  -0x14(%ebp)
80104e90:	50                   	push   %eax
80104e91:	68 13 94 10 80       	push   $0x80109413
80104e96:	e8 2b b5 ff ff       	call   801003c6 <cprintf>
80104e9b:	83 c4 10             	add    $0x10,%esp
		if(p->state == SLEEPING){
80104e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ea1:	8b 40 0c             	mov    0xc(%eax),%eax
80104ea4:	83 f8 02             	cmp    $0x2,%eax
80104ea7:	75 54                	jne    80104efd <procdump+0xd2>
			getcallerpcs((uint*)p->context->ebp+2, pc);
80104ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eac:	8b 40 1c             	mov    0x1c(%eax),%eax
80104eaf:	8b 40 0c             	mov    0xc(%eax),%eax
80104eb2:	83 c0 08             	add    $0x8,%eax
80104eb5:	89 c2                	mov    %eax,%edx
80104eb7:	83 ec 08             	sub    $0x8,%esp
80104eba:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ebd:	50                   	push   %eax
80104ebe:	52                   	push   %edx
80104ebf:	e8 18 06 00 00       	call   801054dc <getcallerpcs>
80104ec4:	83 c4 10             	add    $0x10,%esp
			for(i=0; i<10 && pc[i] != 0; i++)
80104ec7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104ece:	eb 1c                	jmp    80104eec <procdump+0xc1>
				cprintf(" %p", pc[i]);
80104ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed3:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ed7:	83 ec 08             	sub    $0x8,%esp
80104eda:	50                   	push   %eax
80104edb:	68 1c 94 10 80       	push   $0x8010941c
80104ee0:	e8 e1 b4 ff ff       	call   801003c6 <cprintf>
80104ee5:	83 c4 10             	add    $0x10,%esp
		else
			state = "???";
		cprintf("%d %s %s", p->pid, state, p->name);
		if(p->state == SLEEPING){
			getcallerpcs((uint*)p->context->ebp+2, pc);
			for(i=0; i<10 && pc[i] != 0; i++)
80104ee8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104eec:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104ef0:	7f 0b                	jg     80104efd <procdump+0xd2>
80104ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ef5:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ef9:	85 c0                	test   %eax,%eax
80104efb:	75 d3                	jne    80104ed0 <procdump+0xa5>
				cprintf(" %p", pc[i]);
		}
		cprintf("\n");
80104efd:	83 ec 0c             	sub    $0xc,%esp
80104f00:	68 20 94 10 80       	push   $0x80109420
80104f05:	e8 bc b4 ff ff       	call   801003c6 <cprintf>
80104f0a:	83 c4 10             	add    $0x10,%esp
80104f0d:	eb 01                	jmp    80104f10 <procdump+0xe5>
	char *state;
	uint pc[10];

	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
		if(p->state == UNUSED)
			continue;
80104f0f:	90                   	nop
	int i;
	struct proc *p;
	char *state;
	uint pc[10];

	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f10:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104f17:	81 7d f0 b4 5a 11 80 	cmpl   $0x80115ab4,-0x10(%ebp)
80104f1e:	0f 82 19 ff ff ff    	jb     80104e3d <procdump+0x12>
			for(i=0; i<10 && pc[i] != 0; i++)
				cprintf(" %p", pc[i]);
		}
		cprintf("\n");
	}
}
80104f24:	90                   	nop
80104f25:	c9                   	leave  
80104f26:	c3                   	ret    

80104f27 <getnp>:

// return the number of current runnable processes
int 
getnp(void)
{
80104f27:	55                   	push   %ebp
80104f28:	89 e5                	mov    %esp,%ebp
80104f2a:	83 ec 18             	sub    $0x18,%esp
	struct proc *p; 
	int num=0;
80104f2d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)


	acquire(&ptable.lock);
80104f34:	83 ec 0c             	sub    $0xc,%esp
80104f37:	68 80 39 11 80       	push   $0x80113980
80104f3c:	e8 e2 04 00 00       	call   80105423 <acquire>
80104f41:	83 c4 10             	add    $0x10,%esp

	procdump();
80104f44:	e8 e2 fe ff ff       	call   80104e2b <procdump>

	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f49:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104f50:	eb 15                	jmp    80104f67 <getnp+0x40>
		if(p->state != UNUSED ) num++;
80104f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f55:	8b 40 0c             	mov    0xc(%eax),%eax
80104f58:	85 c0                	test   %eax,%eax
80104f5a:	74 04                	je     80104f60 <getnp+0x39>
80104f5c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)

	acquire(&ptable.lock);

	procdump();

	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f60:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104f67:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
80104f6e:	72 e2                	jb     80104f52 <getnp+0x2b>
		if(p->state != UNUSED ) num++;

	release(&ptable.lock);
80104f70:	83 ec 0c             	sub    $0xc,%esp
80104f73:	68 80 39 11 80       	push   $0x80113980
80104f78:	e8 0d 05 00 00       	call   8010548a <release>
80104f7d:	83 c4 10             	add    $0x10,%esp
	return num;
80104f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80104f83:	c9                   	leave  
80104f84:	c3                   	ret    

80104f85 <clone>:


int
clone(void* function, void *arg, void *stack)
{
80104f85:	55                   	push   %ebp
80104f86:	89 e5                	mov    %esp,%ebp
80104f88:	57                   	push   %edi
80104f89:	56                   	push   %esi
80104f8a:	53                   	push   %ebx
80104f8b:	83 ec 1c             	sub    $0x1c,%esp
	int i, pid;
	struct proc *np;

	// Allocate process.
	if((np = allocproc()) == 0)
80104f8e:	e8 31 f4 ff ff       	call   801043c4 <allocproc>
80104f93:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104f96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104f9a:	75 0a                	jne    80104fa6 <clone+0x21>
		return -1;
80104f9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fa1:	e9 a0 01 00 00       	jmp    80105146 <clone+0x1c1>

	np->sz = proc->sz;
80104fa6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fac:	8b 10                	mov    (%eax),%edx
80104fae:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fb1:	89 10                	mov    %edx,(%eax)
	// if the process calling clone is itself a thread,
	// copy its parent to the new thread
	if (proc->isthread == 0) {
80104fb3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fb9:	8b 40 7c             	mov    0x7c(%eax),%eax
80104fbc:	85 c0                	test   %eax,%eax
80104fbe:	75 0f                	jne    80104fcf <clone+0x4a>
		np->parent = proc;
80104fc0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104fc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fca:	89 50 14             	mov    %edx,0x14(%eax)
80104fcd:	eb 0f                	jmp    80104fde <clone+0x59>
	}
	else {
		np->parent = proc->parent;
80104fcf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fd5:	8b 50 14             	mov    0x14(%eax),%edx
80104fd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fdb:	89 50 14             	mov    %edx,0x14(%eax)
	}
	*np->tf = *proc->tf;
80104fde:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fe1:	8b 50 18             	mov    0x18(%eax),%edx
80104fe4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fea:	8b 40 18             	mov    0x18(%eax),%eax
80104fed:	89 c3                	mov    %eax,%ebx
80104fef:	b8 13 00 00 00       	mov    $0x13,%eax
80104ff4:	89 d7                	mov    %edx,%edi
80104ff6:	89 de                	mov    %ebx,%esi
80104ff8:	89 c1                	mov    %eax,%ecx
80104ffa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	// Clear %eax so that fork returns 0 in the child.
	np->tf->eax = 0;
80104ffc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fff:	8b 40 18             	mov    0x18(%eax),%eax
80105002:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	// reallocate old process's page table to new process
	np->pgdir = proc->pgdir;
80105009:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010500f:	8b 50 04             	mov    0x4(%eax),%edx
80105012:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105015:	89 50 04             	mov    %edx,0x4(%eax)
	// modified the return ip to thread function
	np->tf->eip = (int)function;
80105018:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010501b:	8b 40 18             	mov    0x18(%eax),%eax
8010501e:	8b 55 08             	mov    0x8(%ebp),%edx
80105021:	89 50 38             	mov    %edx,0x38(%eax)
	// modified the thread indicator's value
	np->isthread = 1;
80105024:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105027:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
	// modified the stack
	np->stack = (int)stack;
8010502e:	8b 55 10             	mov    0x10(%ebp),%edx
80105031:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105034:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	np->tf->esp = (int)stack + 4092; // move esp to the top of the new stack
8010503a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010503d:	8b 40 18             	mov    0x18(%eax),%eax
80105040:	8b 55 10             	mov    0x10(%ebp),%edx
80105043:	81 c2 fc 0f 00 00    	add    $0xffc,%edx
80105049:	89 50 44             	mov    %edx,0x44(%eax)
	*((int *)(np->tf->esp)) = (int)arg; // push the argument
8010504c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010504f:	8b 40 18             	mov    0x18(%eax),%eax
80105052:	8b 40 44             	mov    0x44(%eax),%eax
80105055:	89 c2                	mov    %eax,%edx
80105057:	8b 45 0c             	mov    0xc(%ebp),%eax
8010505a:	89 02                	mov    %eax,(%edx)
	*((int *)(np->tf->esp - 4)) = 0xFFFFFFFF; // push the return address
8010505c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010505f:	8b 40 18             	mov    0x18(%eax),%eax
80105062:	8b 40 44             	mov    0x44(%eax),%eax
80105065:	83 e8 04             	sub    $0x4,%eax
80105068:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
	np->tf->esp -= 4;
8010506e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105071:	8b 40 18             	mov    0x18(%eax),%eax
80105074:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105077:	8b 52 18             	mov    0x18(%edx),%edx
8010507a:	8b 52 44             	mov    0x44(%edx),%edx
8010507d:	83 ea 04             	sub    $0x4,%edx
80105080:	89 50 44             	mov    %edx,0x44(%eax)

	for(i = 0; i < NOFILE; i++)
80105083:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010508a:	eb 43                	jmp    801050cf <clone+0x14a>
		if(proc->ofile[i])
8010508c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105092:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105095:	83 c2 08             	add    $0x8,%edx
80105098:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010509c:	85 c0                	test   %eax,%eax
8010509e:	74 2b                	je     801050cb <clone+0x146>
			np->ofile[i] = filedup(proc->ofile[i]);
801050a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801050a9:	83 c2 08             	add    $0x8,%edx
801050ac:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801050b0:	83 ec 0c             	sub    $0xc,%esp
801050b3:	50                   	push   %eax
801050b4:	e8 2c bf ff ff       	call   80100fe5 <filedup>
801050b9:	83 c4 10             	add    $0x10,%esp
801050bc:	89 c1                	mov    %eax,%ecx
801050be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801050c4:	83 c2 08             	add    $0x8,%edx
801050c7:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
	np->tf->esp = (int)stack + 4092; // move esp to the top of the new stack
	*((int *)(np->tf->esp)) = (int)arg; // push the argument
	*((int *)(np->tf->esp - 4)) = 0xFFFFFFFF; // push the return address
	np->tf->esp -= 4;

	for(i = 0; i < NOFILE; i++)
801050cb:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801050cf:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801050d3:	7e b7                	jle    8010508c <clone+0x107>
		if(proc->ofile[i])
			np->ofile[i] = filedup(proc->ofile[i]);
	np->cwd = idup(proc->cwd);
801050d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050db:	8b 40 68             	mov    0x68(%eax),%eax
801050de:	83 ec 0c             	sub    $0xc,%esp
801050e1:	50                   	push   %eax
801050e2:	e8 ea c7 ff ff       	call   801018d1 <idup>
801050e7:	83 c4 10             	add    $0x10,%esp
801050ea:	89 c2                	mov    %eax,%edx
801050ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050ef:	89 50 68             	mov    %edx,0x68(%eax)

	safestrcpy(np->name, proc->name, sizeof(proc->name));
801050f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050f8:	8d 50 6c             	lea    0x6c(%eax),%edx
801050fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050fe:	83 c0 6c             	add    $0x6c,%eax
80105101:	83 ec 04             	sub    $0x4,%esp
80105104:	6a 10                	push   $0x10
80105106:	52                   	push   %edx
80105107:	50                   	push   %eax
80105108:	e8 7c 07 00 00       	call   80105889 <safestrcpy>
8010510d:	83 c4 10             	add    $0x10,%esp

	pid = np->pid;
80105110:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105113:	8b 40 10             	mov    0x10(%eax),%eax
80105116:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// lock to force the compiler to emit the np->state write last.
	acquire(&ptable.lock);
80105119:	83 ec 0c             	sub    $0xc,%esp
8010511c:	68 80 39 11 80       	push   $0x80113980
80105121:	e8 fd 02 00 00       	call   80105423 <acquire>
80105126:	83 c4 10             	add    $0x10,%esp
	np->state = RUNNABLE;
80105129:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010512c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
	release(&ptable.lock);
80105133:	83 ec 0c             	sub    $0xc,%esp
80105136:	68 80 39 11 80       	push   $0x80113980
8010513b:	e8 4a 03 00 00       	call   8010548a <release>
80105140:	83 c4 10             	add    $0x10,%esp

	// exit();
	return pid;
80105143:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80105146:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105149:	5b                   	pop    %ebx
8010514a:	5e                   	pop    %esi
8010514b:	5f                   	pop    %edi
8010514c:	5d                   	pop    %ebp
8010514d:	c3                   	ret    

8010514e <join>:

int
join(void **stack)
{
8010514e:	55                   	push   %ebp
8010514f:	89 e5                	mov    %esp,%ebp
80105151:	83 ec 18             	sub    $0x18,%esp
	struct proc *p;
	int havekids, pid;

	acquire(&ptable.lock);
80105154:	83 ec 0c             	sub    $0xc,%esp
80105157:	68 80 39 11 80       	push   $0x80113980
8010515c:	e8 c2 02 00 00       	call   80105423 <acquire>
80105161:	83 c4 10             	add    $0x10,%esp
	for(;;){
		// Scan through table looking for zombie children.
		havekids = 0;
80105164:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010516b:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80105172:	e9 a2 00 00 00       	jmp    80105219 <join+0xcb>
			// only wait for the child thread, but not the child process
			if(p->parent != proc || p->isthread != 1)
80105177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010517a:	8b 50 14             	mov    0x14(%eax),%edx
8010517d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105183:	39 c2                	cmp    %eax,%edx
80105185:	0f 85 86 00 00 00    	jne    80105211 <join+0xc3>
8010518b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010518e:	8b 40 7c             	mov    0x7c(%eax),%eax
80105191:	83 f8 01             	cmp    $0x1,%eax
80105194:	75 7b                	jne    80105211 <join+0xc3>
				continue;
			havekids = 1;
80105196:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
			if(p->state == ZOMBIE){
8010519d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051a0:	8b 40 0c             	mov    0xc(%eax),%eax
801051a3:	83 f8 05             	cmp    $0x5,%eax
801051a6:	75 6a                	jne    80105212 <join+0xc4>
				// Found one.
				pid = p->pid;
801051a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ab:	8b 40 10             	mov    0x10(%eax),%eax
801051ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
				kfree(p->kstack);
801051b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051b4:	8b 40 08             	mov    0x8(%eax),%eax
801051b7:	83 ec 0c             	sub    $0xc,%esp
801051ba:	50                   	push   %eax
801051bb:	e8 68 d9 ff ff       	call   80102b28 <kfree>
801051c0:	83 c4 10             	add    $0x10,%esp
				p->kstack = 0;
801051c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				p->state = UNUSED;
801051cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051d0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				p->pid = 0;
801051d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051da:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
				p->parent = 0;
801051e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051e4:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
				p->name[0] = 0;
801051eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ee:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
				p->killed = 0;
801051f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051f5:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
				release(&ptable.lock);
801051fc:	83 ec 0c             	sub    $0xc,%esp
801051ff:	68 80 39 11 80       	push   $0x80113980
80105204:	e8 81 02 00 00       	call   8010548a <release>
80105209:	83 c4 10             	add    $0x10,%esp
				return pid;
8010520c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010520f:	eb 6c                	jmp    8010527d <join+0x12f>
		// Scan through table looking for zombie children.
		havekids = 0;
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
			// only wait for the child thread, but not the child process
			if(p->parent != proc || p->isthread != 1)
				continue;
80105211:	90                   	nop

	acquire(&ptable.lock);
	for(;;){
		// Scan through table looking for zombie children.
		havekids = 0;
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105212:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80105219:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
80105220:	0f 82 51 ff ff ff    	jb     80105177 <join+0x29>
				return pid;
			}
		}

		// No point waiting if we don't have any children thread.
		if(!havekids || proc->killed){
80105226:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010522a:	74 0d                	je     80105239 <join+0xeb>
8010522c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105232:	8b 40 24             	mov    0x24(%eax),%eax
80105235:	85 c0                	test   %eax,%eax
80105237:	74 17                	je     80105250 <join+0x102>
			release(&ptable.lock);
80105239:	83 ec 0c             	sub    $0xc,%esp
8010523c:	68 80 39 11 80       	push   $0x80113980
80105241:	e8 44 02 00 00       	call   8010548a <release>
80105246:	83 c4 10             	add    $0x10,%esp
			return -1;
80105249:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010524e:	eb 2d                	jmp    8010527d <join+0x12f>
		}

		// Wait for children to exit.  (See wakeup1 call in proc_exit.)
		sleep(proc, &ptable.lock);  //DOC: wait-sleep
80105250:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105256:	83 ec 08             	sub    $0x8,%esp
80105259:	68 80 39 11 80       	push   $0x80113980
8010525e:	50                   	push   %eax
8010525f:	e8 1b fa ff ff       	call   80104c7f <sleep>
80105264:	83 c4 10             	add    $0x10,%esp
		*(int*)stack = proc->stack;
80105267:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010526d:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80105273:	8b 45 08             	mov    0x8(%ebp),%eax
80105276:	89 10                	mov    %edx,(%eax)
	}
80105278:	e9 e7 fe ff ff       	jmp    80105164 <join+0x16>
}
8010527d:	c9                   	leave  
8010527e:	c3                   	ret    

8010527f <block>:


// hufs "block" definition
void block(struct spinlock *lk)
{
8010527f:	55                   	push   %ebp
80105280:	89 e5                	mov    %esp,%ebp
80105282:	83 ec 08             	sub    $0x8,%esp
	if(proc == 0)
80105285:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010528b:	85 c0                	test   %eax,%eax
8010528d:	75 0d                	jne    8010529c <block+0x1d>
		panic("block");
8010528f:	83 ec 0c             	sub    $0xc,%esp
80105292:	68 22 94 10 80       	push   $0x80109422
80105297:	e8 ca b2 ff ff       	call   80100566 <panic>

	if (lk != &ptable.lock) {
8010529c:	81 7d 08 80 39 11 80 	cmpl   $0x80113980,0x8(%ebp)
801052a3:	74 1e                	je     801052c3 <block+0x44>
		acquire(&ptable.lock);
801052a5:	83 ec 0c             	sub    $0xc,%esp
801052a8:	68 80 39 11 80       	push   $0x80113980
801052ad:	e8 71 01 00 00       	call   80105423 <acquire>
801052b2:	83 c4 10             	add    $0x10,%esp
		release(lk);
801052b5:	83 ec 0c             	sub    $0xc,%esp
801052b8:	ff 75 08             	pushl  0x8(%ebp)
801052bb:	e8 ca 01 00 00       	call   8010548a <release>
801052c0:	83 c4 10             	add    $0x10,%esp
	}

	// Go to sleep.
	proc->state = SLEEPING;
801052c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052c9:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
	sched();
801052d0:	e8 82 f8 ff ff       	call   80104b57 <sched>

	if (lk != &ptable.lock) {
801052d5:	81 7d 08 80 39 11 80 	cmpl   $0x80113980,0x8(%ebp)
801052dc:	74 1e                	je     801052fc <block+0x7d>
		release(&ptable.lock);
801052de:	83 ec 0c             	sub    $0xc,%esp
801052e1:	68 80 39 11 80       	push   $0x80113980
801052e6:	e8 9f 01 00 00       	call   8010548a <release>
801052eb:	83 c4 10             	add    $0x10,%esp
		acquire(lk);
801052ee:	83 ec 0c             	sub    $0xc,%esp
801052f1:	ff 75 08             	pushl  0x8(%ebp)
801052f4:	e8 2a 01 00 00       	call   80105423 <acquire>
801052f9:	83 c4 10             	add    $0x10,%esp
	}
}
801052fc:	90                   	nop
801052fd:	c9                   	leave  
801052fe:	c3                   	ret    

801052ff <wakeup_pid>:


// hufs "wakeup_pid" definition
int 
wakeup_pid(int pid, struct spinlock *lk)
{
801052ff:	55                   	push   %ebp
80105300:	89 e5                	mov    %esp,%ebp
80105302:	83 ec 18             	sub    $0x18,%esp
	struct proc *p;

	if (lk != &ptable.lock) {
80105305:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
8010530c:	74 1e                	je     8010532c <wakeup_pid+0x2d>
		acquire(&ptable.lock);
8010530e:	83 ec 0c             	sub    $0xc,%esp
80105311:	68 80 39 11 80       	push   $0x80113980
80105316:	e8 08 01 00 00       	call   80105423 <acquire>
8010531b:	83 c4 10             	add    $0x10,%esp
		release(lk);
8010531e:	83 ec 0c             	sub    $0xc,%esp
80105321:	ff 75 0c             	pushl  0xc(%ebp)
80105324:	e8 61 01 00 00       	call   8010548a <release>
80105329:	83 c4 10             	add    $0x10,%esp
	}

	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010532c:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80105333:	eb 78                	jmp    801053ad <wakeup_pid+0xae>
		if(p->pid == pid && p->state == SLEEPING) {
80105335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105338:	8b 40 10             	mov    0x10(%eax),%eax
8010533b:	3b 45 08             	cmp    0x8(%ebp),%eax
8010533e:	75 43                	jne    80105383 <wakeup_pid+0x84>
80105340:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105343:	8b 40 0c             	mov    0xc(%eax),%eax
80105346:	83 f8 02             	cmp    $0x2,%eax
80105349:	75 38                	jne    80105383 <wakeup_pid+0x84>
			p->state = RUNNABLE;
8010534b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010534e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

			if (lk != &ptable.lock) {
80105355:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
8010535c:	74 1e                	je     8010537c <wakeup_pid+0x7d>
				release(&ptable.lock);
8010535e:	83 ec 0c             	sub    $0xc,%esp
80105361:	68 80 39 11 80       	push   $0x80113980
80105366:	e8 1f 01 00 00       	call   8010548a <release>
8010536b:	83 c4 10             	add    $0x10,%esp
				acquire(lk);
8010536e:	83 ec 0c             	sub    $0xc,%esp
80105371:	ff 75 0c             	pushl  0xc(%ebp)
80105374:	e8 aa 00 00 00       	call   80105423 <acquire>
80105379:	83 c4 10             	add    $0x10,%esp
			}

			return 0;
8010537c:	b8 00 00 00 00       	mov    $0x0,%eax
80105381:	eb 44                	jmp    801053c7 <wakeup_pid+0xc8>
		}
		else if (p->pid == pid && p->state != SLEEPING) {
80105383:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105386:	8b 40 10             	mov    0x10(%eax),%eax
80105389:	3b 45 08             	cmp    0x8(%ebp),%eax
8010538c:	75 18                	jne    801053a6 <wakeup_pid+0xa7>
8010538e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105391:	8b 40 0c             	mov    0xc(%eax),%eax
80105394:	83 f8 02             	cmp    $0x2,%eax
80105397:	74 0d                	je     801053a6 <wakeup_pid+0xa7>
			panic("wakeup_pid: the pid is NOT sleeping,...");
80105399:	83 ec 0c             	sub    $0xc,%esp
8010539c:	68 28 94 10 80       	push   $0x80109428
801053a1:	e8 c0 b1 ff ff       	call   80100566 <panic>
	if (lk != &ptable.lock) {
		acquire(&ptable.lock);
		release(lk);
	}

	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801053a6:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801053ad:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
801053b4:	0f 82 7b ff ff ff    	jb     80105335 <wakeup_pid+0x36>
		}
		else if (p->pid == pid && p->state != SLEEPING) {
			panic("wakeup_pid: the pid is NOT sleeping,...");
		}

	panic("wakeup_pid: invalid SLEEPING pid");
801053ba:	83 ec 0c             	sub    $0xc,%esp
801053bd:	68 50 94 10 80       	push   $0x80109450
801053c2:	e8 9f b1 ff ff       	call   80100566 <panic>

	return -1;
}
801053c7:	c9                   	leave  
801053c8:	c3                   	ret    

801053c9 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801053c9:	55                   	push   %ebp
801053ca:	89 e5                	mov    %esp,%ebp
801053cc:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801053cf:	9c                   	pushf  
801053d0:	58                   	pop    %eax
801053d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801053d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053d7:	c9                   	leave  
801053d8:	c3                   	ret    

801053d9 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801053d9:	55                   	push   %ebp
801053da:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801053dc:	fa                   	cli    
}
801053dd:	90                   	nop
801053de:	5d                   	pop    %ebp
801053df:	c3                   	ret    

801053e0 <sti>:

static inline void
sti(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801053e3:	fb                   	sti    
}
801053e4:	90                   	nop
801053e5:	5d                   	pop    %ebp
801053e6:	c3                   	ret    

801053e7 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801053e7:	55                   	push   %ebp
801053e8:	89 e5                	mov    %esp,%ebp
801053ea:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801053ed:	8b 55 08             	mov    0x8(%ebp),%edx
801053f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801053f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801053f6:	f0 87 02             	lock xchg %eax,(%edx)
801053f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801053fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053ff:	c9                   	leave  
80105400:	c3                   	ret    

80105401 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105401:	55                   	push   %ebp
80105402:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105404:	8b 45 08             	mov    0x8(%ebp),%eax
80105407:	8b 55 0c             	mov    0xc(%ebp),%edx
8010540a:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010540d:	8b 45 08             	mov    0x8(%ebp),%eax
80105410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105416:	8b 45 08             	mov    0x8(%ebp),%eax
80105419:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105420:	90                   	nop
80105421:	5d                   	pop    %ebp
80105422:	c3                   	ret    

80105423 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105423:	55                   	push   %ebp
80105424:	89 e5                	mov    %esp,%ebp
80105426:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105429:	e8 52 01 00 00       	call   80105580 <pushcli>
  if(holding(lk))
8010542e:	8b 45 08             	mov    0x8(%ebp),%eax
80105431:	83 ec 0c             	sub    $0xc,%esp
80105434:	50                   	push   %eax
80105435:	e8 1c 01 00 00       	call   80105556 <holding>
8010543a:	83 c4 10             	add    $0x10,%esp
8010543d:	85 c0                	test   %eax,%eax
8010543f:	74 0d                	je     8010544e <acquire+0x2b>
    panic("acquire");
80105441:	83 ec 0c             	sub    $0xc,%esp
80105444:	68 9b 94 10 80       	push   $0x8010949b
80105449:	e8 18 b1 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
8010544e:	90                   	nop
8010544f:	8b 45 08             	mov    0x8(%ebp),%eax
80105452:	83 ec 08             	sub    $0x8,%esp
80105455:	6a 01                	push   $0x1
80105457:	50                   	push   %eax
80105458:	e8 8a ff ff ff       	call   801053e7 <xchg>
8010545d:	83 c4 10             	add    $0x10,%esp
80105460:	85 c0                	test   %eax,%eax
80105462:	75 eb                	jne    8010544f <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105464:	8b 45 08             	mov    0x8(%ebp),%eax
80105467:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010546e:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105471:	8b 45 08             	mov    0x8(%ebp),%eax
80105474:	83 c0 0c             	add    $0xc,%eax
80105477:	83 ec 08             	sub    $0x8,%esp
8010547a:	50                   	push   %eax
8010547b:	8d 45 08             	lea    0x8(%ebp),%eax
8010547e:	50                   	push   %eax
8010547f:	e8 58 00 00 00       	call   801054dc <getcallerpcs>
80105484:	83 c4 10             	add    $0x10,%esp
}
80105487:	90                   	nop
80105488:	c9                   	leave  
80105489:	c3                   	ret    

8010548a <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
8010548a:	55                   	push   %ebp
8010548b:	89 e5                	mov    %esp,%ebp
8010548d:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	ff 75 08             	pushl  0x8(%ebp)
80105496:	e8 bb 00 00 00       	call   80105556 <holding>
8010549b:	83 c4 10             	add    $0x10,%esp
8010549e:	85 c0                	test   %eax,%eax
801054a0:	75 0d                	jne    801054af <release+0x25>
    panic("release");
801054a2:	83 ec 0c             	sub    $0xc,%esp
801054a5:	68 a3 94 10 80       	push   $0x801094a3
801054aa:	e8 b7 b0 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801054af:	8b 45 08             	mov    0x8(%ebp),%eax
801054b2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801054b9:	8b 45 08             	mov    0x8(%ebp),%eax
801054bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801054c3:	8b 45 08             	mov    0x8(%ebp),%eax
801054c6:	83 ec 08             	sub    $0x8,%esp
801054c9:	6a 00                	push   $0x0
801054cb:	50                   	push   %eax
801054cc:	e8 16 ff ff ff       	call   801053e7 <xchg>
801054d1:	83 c4 10             	add    $0x10,%esp

  popcli();
801054d4:	e8 ec 00 00 00       	call   801055c5 <popcli>
}
801054d9:	90                   	nop
801054da:	c9                   	leave  
801054db:	c3                   	ret    

801054dc <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801054dc:	55                   	push   %ebp
801054dd:	89 e5                	mov    %esp,%ebp
801054df:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801054e2:	8b 45 08             	mov    0x8(%ebp),%eax
801054e5:	83 e8 08             	sub    $0x8,%eax
801054e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801054eb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801054f2:	eb 38                	jmp    8010552c <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801054f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801054f8:	74 53                	je     8010554d <getcallerpcs+0x71>
801054fa:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105501:	76 4a                	jbe    8010554d <getcallerpcs+0x71>
80105503:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105507:	74 44                	je     8010554d <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105509:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010550c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105513:	8b 45 0c             	mov    0xc(%ebp),%eax
80105516:	01 c2                	add    %eax,%edx
80105518:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010551b:	8b 40 04             	mov    0x4(%eax),%eax
8010551e:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105520:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105523:	8b 00                	mov    (%eax),%eax
80105525:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105528:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010552c:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105530:	7e c2                	jle    801054f4 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105532:	eb 19                	jmp    8010554d <getcallerpcs+0x71>
    pcs[i] = 0;
80105534:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105537:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010553e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105541:	01 d0                	add    %edx,%eax
80105543:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105549:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010554d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105551:	7e e1                	jle    80105534 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105553:	90                   	nop
80105554:	c9                   	leave  
80105555:	c3                   	ret    

80105556 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105556:	55                   	push   %ebp
80105557:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105559:	8b 45 08             	mov    0x8(%ebp),%eax
8010555c:	8b 00                	mov    (%eax),%eax
8010555e:	85 c0                	test   %eax,%eax
80105560:	74 17                	je     80105579 <holding+0x23>
80105562:	8b 45 08             	mov    0x8(%ebp),%eax
80105565:	8b 50 08             	mov    0x8(%eax),%edx
80105568:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010556e:	39 c2                	cmp    %eax,%edx
80105570:	75 07                	jne    80105579 <holding+0x23>
80105572:	b8 01 00 00 00       	mov    $0x1,%eax
80105577:	eb 05                	jmp    8010557e <holding+0x28>
80105579:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010557e:	5d                   	pop    %ebp
8010557f:	c3                   	ret    

80105580 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105586:	e8 3e fe ff ff       	call   801053c9 <readeflags>
8010558b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010558e:	e8 46 fe ff ff       	call   801053d9 <cli>
  if(cpu->ncli++ == 0)
80105593:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010559a:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801055a0:	8d 48 01             	lea    0x1(%eax),%ecx
801055a3:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801055a9:	85 c0                	test   %eax,%eax
801055ab:	75 15                	jne    801055c2 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801055ad:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
801055b6:	81 e2 00 02 00 00    	and    $0x200,%edx
801055bc:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801055c2:	90                   	nop
801055c3:	c9                   	leave  
801055c4:	c3                   	ret    

801055c5 <popcli>:

void
popcli(void)
{
801055c5:	55                   	push   %ebp
801055c6:	89 e5                	mov    %esp,%ebp
801055c8:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801055cb:	e8 f9 fd ff ff       	call   801053c9 <readeflags>
801055d0:	25 00 02 00 00       	and    $0x200,%eax
801055d5:	85 c0                	test   %eax,%eax
801055d7:	74 0d                	je     801055e6 <popcli+0x21>
    panic("popcli - interruptible");
801055d9:	83 ec 0c             	sub    $0xc,%esp
801055dc:	68 ab 94 10 80       	push   $0x801094ab
801055e1:	e8 80 af ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
801055e6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055ec:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801055f2:	83 ea 01             	sub    $0x1,%edx
801055f5:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801055fb:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105601:	85 c0                	test   %eax,%eax
80105603:	79 0d                	jns    80105612 <popcli+0x4d>
    panic("popcli");
80105605:	83 ec 0c             	sub    $0xc,%esp
80105608:	68 c2 94 10 80       	push   $0x801094c2
8010560d:	e8 54 af ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105612:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105618:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010561e:	85 c0                	test   %eax,%eax
80105620:	75 15                	jne    80105637 <popcli+0x72>
80105622:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105628:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010562e:	85 c0                	test   %eax,%eax
80105630:	74 05                	je     80105637 <popcli+0x72>
    sti();
80105632:	e8 a9 fd ff ff       	call   801053e0 <sti>
}
80105637:	90                   	nop
80105638:	c9                   	leave  
80105639:	c3                   	ret    

8010563a <stosb>:
8010563a:	55                   	push   %ebp
8010563b:	89 e5                	mov    %esp,%ebp
8010563d:	57                   	push   %edi
8010563e:	53                   	push   %ebx
8010563f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105642:	8b 55 10             	mov    0x10(%ebp),%edx
80105645:	8b 45 0c             	mov    0xc(%ebp),%eax
80105648:	89 cb                	mov    %ecx,%ebx
8010564a:	89 df                	mov    %ebx,%edi
8010564c:	89 d1                	mov    %edx,%ecx
8010564e:	fc                   	cld    
8010564f:	f3 aa                	rep stos %al,%es:(%edi)
80105651:	89 ca                	mov    %ecx,%edx
80105653:	89 fb                	mov    %edi,%ebx
80105655:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105658:	89 55 10             	mov    %edx,0x10(%ebp)
8010565b:	90                   	nop
8010565c:	5b                   	pop    %ebx
8010565d:	5f                   	pop    %edi
8010565e:	5d                   	pop    %ebp
8010565f:	c3                   	ret    

80105660 <stosl>:
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	57                   	push   %edi
80105664:	53                   	push   %ebx
80105665:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105668:	8b 55 10             	mov    0x10(%ebp),%edx
8010566b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010566e:	89 cb                	mov    %ecx,%ebx
80105670:	89 df                	mov    %ebx,%edi
80105672:	89 d1                	mov    %edx,%ecx
80105674:	fc                   	cld    
80105675:	f3 ab                	rep stos %eax,%es:(%edi)
80105677:	89 ca                	mov    %ecx,%edx
80105679:	89 fb                	mov    %edi,%ebx
8010567b:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010567e:	89 55 10             	mov    %edx,0x10(%ebp)
80105681:	90                   	nop
80105682:	5b                   	pop    %ebx
80105683:	5f                   	pop    %edi
80105684:	5d                   	pop    %ebp
80105685:	c3                   	ret    

80105686 <memset>:
80105686:	55                   	push   %ebp
80105687:	89 e5                	mov    %esp,%ebp
80105689:	8b 45 08             	mov    0x8(%ebp),%eax
8010568c:	83 e0 03             	and    $0x3,%eax
8010568f:	85 c0                	test   %eax,%eax
80105691:	75 43                	jne    801056d6 <memset+0x50>
80105693:	8b 45 10             	mov    0x10(%ebp),%eax
80105696:	83 e0 03             	and    $0x3,%eax
80105699:	85 c0                	test   %eax,%eax
8010569b:	75 39                	jne    801056d6 <memset+0x50>
8010569d:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
801056a4:	8b 45 10             	mov    0x10(%ebp),%eax
801056a7:	c1 e8 02             	shr    $0x2,%eax
801056aa:	89 c1                	mov    %eax,%ecx
801056ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801056af:	c1 e0 18             	shl    $0x18,%eax
801056b2:	89 c2                	mov    %eax,%edx
801056b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801056b7:	c1 e0 10             	shl    $0x10,%eax
801056ba:	09 c2                	or     %eax,%edx
801056bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801056bf:	c1 e0 08             	shl    $0x8,%eax
801056c2:	09 d0                	or     %edx,%eax
801056c4:	0b 45 0c             	or     0xc(%ebp),%eax
801056c7:	51                   	push   %ecx
801056c8:	50                   	push   %eax
801056c9:	ff 75 08             	pushl  0x8(%ebp)
801056cc:	e8 8f ff ff ff       	call   80105660 <stosl>
801056d1:	83 c4 0c             	add    $0xc,%esp
801056d4:	eb 12                	jmp    801056e8 <memset+0x62>
801056d6:	8b 45 10             	mov    0x10(%ebp),%eax
801056d9:	50                   	push   %eax
801056da:	ff 75 0c             	pushl  0xc(%ebp)
801056dd:	ff 75 08             	pushl  0x8(%ebp)
801056e0:	e8 55 ff ff ff       	call   8010563a <stosb>
801056e5:	83 c4 0c             	add    $0xc,%esp
801056e8:	8b 45 08             	mov    0x8(%ebp),%eax
801056eb:	c9                   	leave  
801056ec:	c3                   	ret    

801056ed <memcmp>:
801056ed:	55                   	push   %ebp
801056ee:	89 e5                	mov    %esp,%ebp
801056f0:	83 ec 10             	sub    $0x10,%esp
801056f3:	8b 45 08             	mov    0x8(%ebp),%eax
801056f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
801056f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801056fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
801056ff:	eb 30                	jmp    80105731 <memcmp+0x44>
80105701:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105704:	0f b6 10             	movzbl (%eax),%edx
80105707:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010570a:	0f b6 00             	movzbl (%eax),%eax
8010570d:	38 c2                	cmp    %al,%dl
8010570f:	74 18                	je     80105729 <memcmp+0x3c>
80105711:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105714:	0f b6 00             	movzbl (%eax),%eax
80105717:	0f b6 d0             	movzbl %al,%edx
8010571a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010571d:	0f b6 00             	movzbl (%eax),%eax
80105720:	0f b6 c0             	movzbl %al,%eax
80105723:	29 c2                	sub    %eax,%edx
80105725:	89 d0                	mov    %edx,%eax
80105727:	eb 1a                	jmp    80105743 <memcmp+0x56>
80105729:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010572d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105731:	8b 45 10             	mov    0x10(%ebp),%eax
80105734:	8d 50 ff             	lea    -0x1(%eax),%edx
80105737:	89 55 10             	mov    %edx,0x10(%ebp)
8010573a:	85 c0                	test   %eax,%eax
8010573c:	75 c3                	jne    80105701 <memcmp+0x14>
8010573e:	b8 00 00 00 00       	mov    $0x0,%eax
80105743:	c9                   	leave  
80105744:	c3                   	ret    

80105745 <memmove>:
80105745:	55                   	push   %ebp
80105746:	89 e5                	mov    %esp,%ebp
80105748:	83 ec 10             	sub    $0x10,%esp
8010574b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010574e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105751:	8b 45 08             	mov    0x8(%ebp),%eax
80105754:	89 45 f8             	mov    %eax,-0x8(%ebp)
80105757:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010575a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010575d:	73 54                	jae    801057b3 <memmove+0x6e>
8010575f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105762:	8b 45 10             	mov    0x10(%ebp),%eax
80105765:	01 d0                	add    %edx,%eax
80105767:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010576a:	76 47                	jbe    801057b3 <memmove+0x6e>
8010576c:	8b 45 10             	mov    0x10(%ebp),%eax
8010576f:	01 45 fc             	add    %eax,-0x4(%ebp)
80105772:	8b 45 10             	mov    0x10(%ebp),%eax
80105775:	01 45 f8             	add    %eax,-0x8(%ebp)
80105778:	eb 13                	jmp    8010578d <memmove+0x48>
8010577a:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010577e:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105782:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105785:	0f b6 10             	movzbl (%eax),%edx
80105788:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010578b:	88 10                	mov    %dl,(%eax)
8010578d:	8b 45 10             	mov    0x10(%ebp),%eax
80105790:	8d 50 ff             	lea    -0x1(%eax),%edx
80105793:	89 55 10             	mov    %edx,0x10(%ebp)
80105796:	85 c0                	test   %eax,%eax
80105798:	75 e0                	jne    8010577a <memmove+0x35>
8010579a:	eb 24                	jmp    801057c0 <memmove+0x7b>
8010579c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010579f:	8d 50 01             	lea    0x1(%eax),%edx
801057a2:	89 55 f8             	mov    %edx,-0x8(%ebp)
801057a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057a8:	8d 4a 01             	lea    0x1(%edx),%ecx
801057ab:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801057ae:	0f b6 12             	movzbl (%edx),%edx
801057b1:	88 10                	mov    %dl,(%eax)
801057b3:	8b 45 10             	mov    0x10(%ebp),%eax
801057b6:	8d 50 ff             	lea    -0x1(%eax),%edx
801057b9:	89 55 10             	mov    %edx,0x10(%ebp)
801057bc:	85 c0                	test   %eax,%eax
801057be:	75 dc                	jne    8010579c <memmove+0x57>
801057c0:	8b 45 08             	mov    0x8(%ebp),%eax
801057c3:	c9                   	leave  
801057c4:	c3                   	ret    

801057c5 <memcpy>:
801057c5:	55                   	push   %ebp
801057c6:	89 e5                	mov    %esp,%ebp
801057c8:	ff 75 10             	pushl  0x10(%ebp)
801057cb:	ff 75 0c             	pushl  0xc(%ebp)
801057ce:	ff 75 08             	pushl  0x8(%ebp)
801057d1:	e8 6f ff ff ff       	call   80105745 <memmove>
801057d6:	83 c4 0c             	add    $0xc,%esp
801057d9:	c9                   	leave  
801057da:	c3                   	ret    

801057db <strncmp>:
801057db:	55                   	push   %ebp
801057dc:	89 e5                	mov    %esp,%ebp
801057de:	eb 0c                	jmp    801057ec <strncmp+0x11>
801057e0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801057e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801057e8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801057ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057f0:	74 1a                	je     8010580c <strncmp+0x31>
801057f2:	8b 45 08             	mov    0x8(%ebp),%eax
801057f5:	0f b6 00             	movzbl (%eax),%eax
801057f8:	84 c0                	test   %al,%al
801057fa:	74 10                	je     8010580c <strncmp+0x31>
801057fc:	8b 45 08             	mov    0x8(%ebp),%eax
801057ff:	0f b6 10             	movzbl (%eax),%edx
80105802:	8b 45 0c             	mov    0xc(%ebp),%eax
80105805:	0f b6 00             	movzbl (%eax),%eax
80105808:	38 c2                	cmp    %al,%dl
8010580a:	74 d4                	je     801057e0 <strncmp+0x5>
8010580c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105810:	75 07                	jne    80105819 <strncmp+0x3e>
80105812:	b8 00 00 00 00       	mov    $0x0,%eax
80105817:	eb 16                	jmp    8010582f <strncmp+0x54>
80105819:	8b 45 08             	mov    0x8(%ebp),%eax
8010581c:	0f b6 00             	movzbl (%eax),%eax
8010581f:	0f b6 d0             	movzbl %al,%edx
80105822:	8b 45 0c             	mov    0xc(%ebp),%eax
80105825:	0f b6 00             	movzbl (%eax),%eax
80105828:	0f b6 c0             	movzbl %al,%eax
8010582b:	29 c2                	sub    %eax,%edx
8010582d:	89 d0                	mov    %edx,%eax
8010582f:	5d                   	pop    %ebp
80105830:	c3                   	ret    

80105831 <strncpy>:
80105831:	55                   	push   %ebp
80105832:	89 e5                	mov    %esp,%ebp
80105834:	83 ec 10             	sub    $0x10,%esp
80105837:	8b 45 08             	mov    0x8(%ebp),%eax
8010583a:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010583d:	90                   	nop
8010583e:	8b 45 10             	mov    0x10(%ebp),%eax
80105841:	8d 50 ff             	lea    -0x1(%eax),%edx
80105844:	89 55 10             	mov    %edx,0x10(%ebp)
80105847:	85 c0                	test   %eax,%eax
80105849:	7e 2c                	jle    80105877 <strncpy+0x46>
8010584b:	8b 45 08             	mov    0x8(%ebp),%eax
8010584e:	8d 50 01             	lea    0x1(%eax),%edx
80105851:	89 55 08             	mov    %edx,0x8(%ebp)
80105854:	8b 55 0c             	mov    0xc(%ebp),%edx
80105857:	8d 4a 01             	lea    0x1(%edx),%ecx
8010585a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010585d:	0f b6 12             	movzbl (%edx),%edx
80105860:	88 10                	mov    %dl,(%eax)
80105862:	0f b6 00             	movzbl (%eax),%eax
80105865:	84 c0                	test   %al,%al
80105867:	75 d5                	jne    8010583e <strncpy+0xd>
80105869:	eb 0c                	jmp    80105877 <strncpy+0x46>
8010586b:	8b 45 08             	mov    0x8(%ebp),%eax
8010586e:	8d 50 01             	lea    0x1(%eax),%edx
80105871:	89 55 08             	mov    %edx,0x8(%ebp)
80105874:	c6 00 00             	movb   $0x0,(%eax)
80105877:	8b 45 10             	mov    0x10(%ebp),%eax
8010587a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010587d:	89 55 10             	mov    %edx,0x10(%ebp)
80105880:	85 c0                	test   %eax,%eax
80105882:	7f e7                	jg     8010586b <strncpy+0x3a>
80105884:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105887:	c9                   	leave  
80105888:	c3                   	ret    

80105889 <safestrcpy>:
80105889:	55                   	push   %ebp
8010588a:	89 e5                	mov    %esp,%ebp
8010588c:	83 ec 10             	sub    $0x10,%esp
8010588f:	8b 45 08             	mov    0x8(%ebp),%eax
80105892:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105895:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105899:	7f 05                	jg     801058a0 <safestrcpy+0x17>
8010589b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010589e:	eb 31                	jmp    801058d1 <safestrcpy+0x48>
801058a0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801058a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058a8:	7e 1e                	jle    801058c8 <safestrcpy+0x3f>
801058aa:	8b 45 08             	mov    0x8(%ebp),%eax
801058ad:	8d 50 01             	lea    0x1(%eax),%edx
801058b0:	89 55 08             	mov    %edx,0x8(%ebp)
801058b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801058b6:	8d 4a 01             	lea    0x1(%edx),%ecx
801058b9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801058bc:	0f b6 12             	movzbl (%edx),%edx
801058bf:	88 10                	mov    %dl,(%eax)
801058c1:	0f b6 00             	movzbl (%eax),%eax
801058c4:	84 c0                	test   %al,%al
801058c6:	75 d8                	jne    801058a0 <safestrcpy+0x17>
801058c8:	8b 45 08             	mov    0x8(%ebp),%eax
801058cb:	c6 00 00             	movb   $0x0,(%eax)
801058ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058d1:	c9                   	leave  
801058d2:	c3                   	ret    

801058d3 <strlen>:
801058d3:	55                   	push   %ebp
801058d4:	89 e5                	mov    %esp,%ebp
801058d6:	83 ec 10             	sub    $0x10,%esp
801058d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801058e0:	eb 04                	jmp    801058e6 <strlen+0x13>
801058e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801058e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058e9:	8b 45 08             	mov    0x8(%ebp),%eax
801058ec:	01 d0                	add    %edx,%eax
801058ee:	0f b6 00             	movzbl (%eax),%eax
801058f1:	84 c0                	test   %al,%al
801058f3:	75 ed                	jne    801058e2 <strlen+0xf>
801058f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058f8:	c9                   	leave  
801058f9:	c3                   	ret    

801058fa <swtch>:
801058fa:	8b 44 24 04          	mov    0x4(%esp),%eax
801058fe:	8b 54 24 08          	mov    0x8(%esp),%edx
80105902:	55                   	push   %ebp
80105903:	53                   	push   %ebx
80105904:	56                   	push   %esi
80105905:	57                   	push   %edi
80105906:	89 20                	mov    %esp,(%eax)
80105908:	89 d4                	mov    %edx,%esp
8010590a:	5f                   	pop    %edi
8010590b:	5e                   	pop    %esi
8010590c:	5b                   	pop    %ebx
8010590d:	5d                   	pop    %ebp
8010590e:	c3                   	ret    

8010590f <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010590f:	55                   	push   %ebp
80105910:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105912:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105918:	8b 00                	mov    (%eax),%eax
8010591a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010591d:	76 12                	jbe    80105931 <fetchint+0x22>
8010591f:	8b 45 08             	mov    0x8(%ebp),%eax
80105922:	8d 50 04             	lea    0x4(%eax),%edx
80105925:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010592b:	8b 00                	mov    (%eax),%eax
8010592d:	39 c2                	cmp    %eax,%edx
8010592f:	76 07                	jbe    80105938 <fetchint+0x29>
    return -1;
80105931:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105936:	eb 0f                	jmp    80105947 <fetchint+0x38>
  *ip = *(int*)(addr);
80105938:	8b 45 08             	mov    0x8(%ebp),%eax
8010593b:	8b 10                	mov    (%eax),%edx
8010593d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105940:	89 10                	mov    %edx,(%eax)
  return 0;
80105942:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105947:	5d                   	pop    %ebp
80105948:	c3                   	ret    

80105949 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105949:	55                   	push   %ebp
8010594a:	89 e5                	mov    %esp,%ebp
8010594c:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010594f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105955:	8b 00                	mov    (%eax),%eax
80105957:	3b 45 08             	cmp    0x8(%ebp),%eax
8010595a:	77 07                	ja     80105963 <fetchstr+0x1a>
    return -1;
8010595c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105961:	eb 46                	jmp    801059a9 <fetchstr+0x60>
  *pp = (char*)addr;
80105963:	8b 55 08             	mov    0x8(%ebp),%edx
80105966:	8b 45 0c             	mov    0xc(%ebp),%eax
80105969:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
8010596b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105971:	8b 00                	mov    (%eax),%eax
80105973:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105976:	8b 45 0c             	mov    0xc(%ebp),%eax
80105979:	8b 00                	mov    (%eax),%eax
8010597b:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010597e:	eb 1c                	jmp    8010599c <fetchstr+0x53>
    if(*s == 0)
80105980:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105983:	0f b6 00             	movzbl (%eax),%eax
80105986:	84 c0                	test   %al,%al
80105988:	75 0e                	jne    80105998 <fetchstr+0x4f>
      return s - *pp;
8010598a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010598d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105990:	8b 00                	mov    (%eax),%eax
80105992:	29 c2                	sub    %eax,%edx
80105994:	89 d0                	mov    %edx,%eax
80105996:	eb 11                	jmp    801059a9 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105998:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010599c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010599f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801059a2:	72 dc                	jb     80105980 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801059a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059a9:	c9                   	leave  
801059aa:	c3                   	ret    

801059ab <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801059ab:	55                   	push   %ebp
801059ac:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801059ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059b4:	8b 40 18             	mov    0x18(%eax),%eax
801059b7:	8b 40 44             	mov    0x44(%eax),%eax
801059ba:	8b 55 08             	mov    0x8(%ebp),%edx
801059bd:	c1 e2 02             	shl    $0x2,%edx
801059c0:	01 d0                	add    %edx,%eax
801059c2:	83 c0 04             	add    $0x4,%eax
801059c5:	ff 75 0c             	pushl  0xc(%ebp)
801059c8:	50                   	push   %eax
801059c9:	e8 41 ff ff ff       	call   8010590f <fetchint>
801059ce:	83 c4 08             	add    $0x8,%esp
}
801059d1:	c9                   	leave  
801059d2:	c3                   	ret    

801059d3 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801059d3:	55                   	push   %ebp
801059d4:	89 e5                	mov    %esp,%ebp
801059d6:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801059d9:	8d 45 fc             	lea    -0x4(%ebp),%eax
801059dc:	50                   	push   %eax
801059dd:	ff 75 08             	pushl  0x8(%ebp)
801059e0:	e8 c6 ff ff ff       	call   801059ab <argint>
801059e5:	83 c4 08             	add    $0x8,%esp
801059e8:	85 c0                	test   %eax,%eax
801059ea:	79 07                	jns    801059f3 <argptr+0x20>
    return -1;
801059ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f1:	eb 3b                	jmp    80105a2e <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801059f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059f9:	8b 00                	mov    (%eax),%eax
801059fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
801059fe:	39 d0                	cmp    %edx,%eax
80105a00:	76 16                	jbe    80105a18 <argptr+0x45>
80105a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a05:	89 c2                	mov    %eax,%edx
80105a07:	8b 45 10             	mov    0x10(%ebp),%eax
80105a0a:	01 c2                	add    %eax,%edx
80105a0c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a12:	8b 00                	mov    (%eax),%eax
80105a14:	39 c2                	cmp    %eax,%edx
80105a16:	76 07                	jbe    80105a1f <argptr+0x4c>
    return -1;
80105a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a1d:	eb 0f                	jmp    80105a2e <argptr+0x5b>
  *pp = (char*)i;
80105a1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a22:	89 c2                	mov    %eax,%edx
80105a24:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a27:	89 10                	mov    %edx,(%eax)
  return 0;
80105a29:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a2e:	c9                   	leave  
80105a2f:	c3                   	ret    

80105a30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105a36:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105a39:	50                   	push   %eax
80105a3a:	ff 75 08             	pushl  0x8(%ebp)
80105a3d:	e8 69 ff ff ff       	call   801059ab <argint>
80105a42:	83 c4 08             	add    $0x8,%esp
80105a45:	85 c0                	test   %eax,%eax
80105a47:	79 07                	jns    80105a50 <argstr+0x20>
    return -1;
80105a49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a4e:	eb 0f                	jmp    80105a5f <argstr+0x2f>
  return fetchstr(addr, pp);
80105a50:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a53:	ff 75 0c             	pushl  0xc(%ebp)
80105a56:	50                   	push   %eax
80105a57:	e8 ed fe ff ff       	call   80105949 <fetchstr>
80105a5c:	83 c4 08             	add    $0x8,%esp
}
80105a5f:	c9                   	leave  
80105a60:	c3                   	ret    

80105a61 <syscall>:
[SYS_join]    sys_join
};

void
syscall(void)
{
80105a61:	55                   	push   %ebp
80105a62:	89 e5                	mov    %esp,%ebp
80105a64:	53                   	push   %ebx
80105a65:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105a68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a6e:	8b 40 18             	mov    0x18(%eax),%eax
80105a71:	8b 40 1c             	mov    0x1c(%eax),%eax
80105a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105a77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a7b:	7e 30                	jle    80105aad <syscall+0x4c>
80105a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a80:	83 f8 1d             	cmp    $0x1d,%eax
80105a83:	77 28                	ja     80105aad <syscall+0x4c>
80105a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a88:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105a8f:	85 c0                	test   %eax,%eax
80105a91:	74 1a                	je     80105aad <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105a93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a99:	8b 58 18             	mov    0x18(%eax),%ebx
80105a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a9f:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105aa6:	ff d0                	call   *%eax
80105aa8:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105aab:	eb 34                	jmp    80105ae1 <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105aad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ab3:	8d 50 6c             	lea    0x6c(%eax),%edx
80105ab6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105abc:	8b 40 10             	mov    0x10(%eax),%eax
80105abf:	ff 75 f4             	pushl  -0xc(%ebp)
80105ac2:	52                   	push   %edx
80105ac3:	50                   	push   %eax
80105ac4:	68 c9 94 10 80       	push   $0x801094c9
80105ac9:	e8 f8 a8 ff ff       	call   801003c6 <cprintf>
80105ace:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105ad1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ad7:	8b 40 18             	mov    0x18(%eax),%eax
80105ada:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105ae1:	90                   	nop
80105ae2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ae5:	c9                   	leave  
80105ae6:	c3                   	ret    

80105ae7 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105ae7:	55                   	push   %ebp
80105ae8:	89 e5                	mov    %esp,%ebp
80105aea:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105aed:	83 ec 08             	sub    $0x8,%esp
80105af0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105af3:	50                   	push   %eax
80105af4:	ff 75 08             	pushl  0x8(%ebp)
80105af7:	e8 af fe ff ff       	call   801059ab <argint>
80105afc:	83 c4 10             	add    $0x10,%esp
80105aff:	85 c0                	test   %eax,%eax
80105b01:	79 07                	jns    80105b0a <argfd+0x23>
    return -1;
80105b03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b08:	eb 50                	jmp    80105b5a <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b0d:	85 c0                	test   %eax,%eax
80105b0f:	78 21                	js     80105b32 <argfd+0x4b>
80105b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b14:	83 f8 0f             	cmp    $0xf,%eax
80105b17:	7f 19                	jg     80105b32 <argfd+0x4b>
80105b19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b22:	83 c2 08             	add    $0x8,%edx
80105b25:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b30:	75 07                	jne    80105b39 <argfd+0x52>
    return -1;
80105b32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b37:	eb 21                	jmp    80105b5a <argfd+0x73>
  if(pfd)
80105b39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105b3d:	74 08                	je     80105b47 <argfd+0x60>
    *pfd = fd;
80105b3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b42:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b45:	89 10                	mov    %edx,(%eax)
  if(pf)
80105b47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105b4b:	74 08                	je     80105b55 <argfd+0x6e>
    *pf = f;
80105b4d:	8b 45 10             	mov    0x10(%ebp),%eax
80105b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b53:	89 10                	mov    %edx,(%eax)
  return 0;
80105b55:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b5a:	c9                   	leave  
80105b5b:	c3                   	ret    

80105b5c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105b5c:	55                   	push   %ebp
80105b5d:	89 e5                	mov    %esp,%ebp
80105b5f:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105b62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105b69:	eb 30                	jmp    80105b9b <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105b6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b71:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b74:	83 c2 08             	add    $0x8,%edx
80105b77:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105b7b:	85 c0                	test   %eax,%eax
80105b7d:	75 18                	jne    80105b97 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105b7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b85:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b88:	8d 4a 08             	lea    0x8(%edx),%ecx
80105b8b:	8b 55 08             	mov    0x8(%ebp),%edx
80105b8e:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105b92:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b95:	eb 0f                	jmp    80105ba6 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105b97:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105b9b:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105b9f:	7e ca                	jle    80105b6b <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ba6:	c9                   	leave  
80105ba7:	c3                   	ret    

80105ba8 <sys_dup>:

int
sys_dup(void)
{
80105ba8:	55                   	push   %ebp
80105ba9:	89 e5                	mov    %esp,%ebp
80105bab:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105bae:	83 ec 04             	sub    $0x4,%esp
80105bb1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bb4:	50                   	push   %eax
80105bb5:	6a 00                	push   $0x0
80105bb7:	6a 00                	push   $0x0
80105bb9:	e8 29 ff ff ff       	call   80105ae7 <argfd>
80105bbe:	83 c4 10             	add    $0x10,%esp
80105bc1:	85 c0                	test   %eax,%eax
80105bc3:	79 07                	jns    80105bcc <sys_dup+0x24>
    return -1;
80105bc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bca:	eb 31                	jmp    80105bfd <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bcf:	83 ec 0c             	sub    $0xc,%esp
80105bd2:	50                   	push   %eax
80105bd3:	e8 84 ff ff ff       	call   80105b5c <fdalloc>
80105bd8:	83 c4 10             	add    $0x10,%esp
80105bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105be2:	79 07                	jns    80105beb <sys_dup+0x43>
    return -1;
80105be4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be9:	eb 12                	jmp    80105bfd <sys_dup+0x55>
  filedup(f);
80105beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bee:	83 ec 0c             	sub    $0xc,%esp
80105bf1:	50                   	push   %eax
80105bf2:	e8 ee b3 ff ff       	call   80100fe5 <filedup>
80105bf7:	83 c4 10             	add    $0x10,%esp
  return fd;
80105bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105bfd:	c9                   	leave  
80105bfe:	c3                   	ret    

80105bff <sys_read>:

int
sys_read(void)
{
80105bff:	55                   	push   %ebp
80105c00:	89 e5                	mov    %esp,%ebp
80105c02:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c05:	83 ec 04             	sub    $0x4,%esp
80105c08:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c0b:	50                   	push   %eax
80105c0c:	6a 00                	push   $0x0
80105c0e:	6a 00                	push   $0x0
80105c10:	e8 d2 fe ff ff       	call   80105ae7 <argfd>
80105c15:	83 c4 10             	add    $0x10,%esp
80105c18:	85 c0                	test   %eax,%eax
80105c1a:	78 2e                	js     80105c4a <sys_read+0x4b>
80105c1c:	83 ec 08             	sub    $0x8,%esp
80105c1f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c22:	50                   	push   %eax
80105c23:	6a 02                	push   $0x2
80105c25:	e8 81 fd ff ff       	call   801059ab <argint>
80105c2a:	83 c4 10             	add    $0x10,%esp
80105c2d:	85 c0                	test   %eax,%eax
80105c2f:	78 19                	js     80105c4a <sys_read+0x4b>
80105c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c34:	83 ec 04             	sub    $0x4,%esp
80105c37:	50                   	push   %eax
80105c38:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c3b:	50                   	push   %eax
80105c3c:	6a 01                	push   $0x1
80105c3e:	e8 90 fd ff ff       	call   801059d3 <argptr>
80105c43:	83 c4 10             	add    $0x10,%esp
80105c46:	85 c0                	test   %eax,%eax
80105c48:	79 07                	jns    80105c51 <sys_read+0x52>
    return -1;
80105c4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c4f:	eb 17                	jmp    80105c68 <sys_read+0x69>
  return fileread(f, p, n);
80105c51:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105c54:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c5a:	83 ec 04             	sub    $0x4,%esp
80105c5d:	51                   	push   %ecx
80105c5e:	52                   	push   %edx
80105c5f:	50                   	push   %eax
80105c60:	e8 10 b5 ff ff       	call   80101175 <fileread>
80105c65:	83 c4 10             	add    $0x10,%esp
}
80105c68:	c9                   	leave  
80105c69:	c3                   	ret    

80105c6a <sys_write>:

int
sys_write(void)
{
80105c6a:	55                   	push   %ebp
80105c6b:	89 e5                	mov    %esp,%ebp
80105c6d:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c70:	83 ec 04             	sub    $0x4,%esp
80105c73:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c76:	50                   	push   %eax
80105c77:	6a 00                	push   $0x0
80105c79:	6a 00                	push   $0x0
80105c7b:	e8 67 fe ff ff       	call   80105ae7 <argfd>
80105c80:	83 c4 10             	add    $0x10,%esp
80105c83:	85 c0                	test   %eax,%eax
80105c85:	78 2e                	js     80105cb5 <sys_write+0x4b>
80105c87:	83 ec 08             	sub    $0x8,%esp
80105c8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c8d:	50                   	push   %eax
80105c8e:	6a 02                	push   $0x2
80105c90:	e8 16 fd ff ff       	call   801059ab <argint>
80105c95:	83 c4 10             	add    $0x10,%esp
80105c98:	85 c0                	test   %eax,%eax
80105c9a:	78 19                	js     80105cb5 <sys_write+0x4b>
80105c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c9f:	83 ec 04             	sub    $0x4,%esp
80105ca2:	50                   	push   %eax
80105ca3:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ca6:	50                   	push   %eax
80105ca7:	6a 01                	push   $0x1
80105ca9:	e8 25 fd ff ff       	call   801059d3 <argptr>
80105cae:	83 c4 10             	add    $0x10,%esp
80105cb1:	85 c0                	test   %eax,%eax
80105cb3:	79 07                	jns    80105cbc <sys_write+0x52>
    return -1;
80105cb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cba:	eb 17                	jmp    80105cd3 <sys_write+0x69>
  return filewrite(f, p, n);
80105cbc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105cbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc5:	83 ec 04             	sub    $0x4,%esp
80105cc8:	51                   	push   %ecx
80105cc9:	52                   	push   %edx
80105cca:	50                   	push   %eax
80105ccb:	e8 5d b5 ff ff       	call   8010122d <filewrite>
80105cd0:	83 c4 10             	add    $0x10,%esp
}
80105cd3:	c9                   	leave  
80105cd4:	c3                   	ret    

80105cd5 <sys_close>:

int
sys_close(void)
{
80105cd5:	55                   	push   %ebp
80105cd6:	89 e5                	mov    %esp,%ebp
80105cd8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105cdb:	83 ec 04             	sub    $0x4,%esp
80105cde:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ce1:	50                   	push   %eax
80105ce2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ce5:	50                   	push   %eax
80105ce6:	6a 00                	push   $0x0
80105ce8:	e8 fa fd ff ff       	call   80105ae7 <argfd>
80105ced:	83 c4 10             	add    $0x10,%esp
80105cf0:	85 c0                	test   %eax,%eax
80105cf2:	79 07                	jns    80105cfb <sys_close+0x26>
    return -1;
80105cf4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cf9:	eb 28                	jmp    80105d23 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105cfb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d04:	83 c2 08             	add    $0x8,%edx
80105d07:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105d0e:	00 
  fileclose(f);
80105d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d12:	83 ec 0c             	sub    $0xc,%esp
80105d15:	50                   	push   %eax
80105d16:	e8 1b b3 ff ff       	call   80101036 <fileclose>
80105d1b:	83 c4 10             	add    $0x10,%esp
  return 0;
80105d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d23:	c9                   	leave  
80105d24:	c3                   	ret    

80105d25 <sys_fstat>:

int
sys_fstat(void)
{
80105d25:	55                   	push   %ebp
80105d26:	89 e5                	mov    %esp,%ebp
80105d28:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105d2b:	83 ec 04             	sub    $0x4,%esp
80105d2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d31:	50                   	push   %eax
80105d32:	6a 00                	push   $0x0
80105d34:	6a 00                	push   $0x0
80105d36:	e8 ac fd ff ff       	call   80105ae7 <argfd>
80105d3b:	83 c4 10             	add    $0x10,%esp
80105d3e:	85 c0                	test   %eax,%eax
80105d40:	78 17                	js     80105d59 <sys_fstat+0x34>
80105d42:	83 ec 04             	sub    $0x4,%esp
80105d45:	6a 14                	push   $0x14
80105d47:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d4a:	50                   	push   %eax
80105d4b:	6a 01                	push   $0x1
80105d4d:	e8 81 fc ff ff       	call   801059d3 <argptr>
80105d52:	83 c4 10             	add    $0x10,%esp
80105d55:	85 c0                	test   %eax,%eax
80105d57:	79 07                	jns    80105d60 <sys_fstat+0x3b>
    return -1;
80105d59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d5e:	eb 13                	jmp    80105d73 <sys_fstat+0x4e>
  return filestat(f, st);
80105d60:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d66:	83 ec 08             	sub    $0x8,%esp
80105d69:	52                   	push   %edx
80105d6a:	50                   	push   %eax
80105d6b:	e8 ae b3 ff ff       	call   8010111e <filestat>
80105d70:	83 c4 10             	add    $0x10,%esp
}
80105d73:	c9                   	leave  
80105d74:	c3                   	ret    

80105d75 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105d75:	55                   	push   %ebp
80105d76:	89 e5                	mov    %esp,%ebp
80105d78:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105d7b:	83 ec 08             	sub    $0x8,%esp
80105d7e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105d81:	50                   	push   %eax
80105d82:	6a 00                	push   $0x0
80105d84:	e8 a7 fc ff ff       	call   80105a30 <argstr>
80105d89:	83 c4 10             	add    $0x10,%esp
80105d8c:	85 c0                	test   %eax,%eax
80105d8e:	78 15                	js     80105da5 <sys_link+0x30>
80105d90:	83 ec 08             	sub    $0x8,%esp
80105d93:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105d96:	50                   	push   %eax
80105d97:	6a 01                	push   $0x1
80105d99:	e8 92 fc ff ff       	call   80105a30 <argstr>
80105d9e:	83 c4 10             	add    $0x10,%esp
80105da1:	85 c0                	test   %eax,%eax
80105da3:	79 0a                	jns    80105daf <sys_link+0x3a>
    return -1;
80105da5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105daa:	e9 68 01 00 00       	jmp    80105f17 <sys_link+0x1a2>

  begin_op();
80105daf:	e8 00 d7 ff ff       	call   801034b4 <begin_op>
  if((ip = namei(old)) == 0){
80105db4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105db7:	83 ec 0c             	sub    $0xc,%esp
80105dba:	50                   	push   %eax
80105dbb:	e8 03 c7 ff ff       	call   801024c3 <namei>
80105dc0:	83 c4 10             	add    $0x10,%esp
80105dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dca:	75 0f                	jne    80105ddb <sys_link+0x66>
    end_op();
80105dcc:	e8 6f d7 ff ff       	call   80103540 <end_op>
    return -1;
80105dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd6:	e9 3c 01 00 00       	jmp    80105f17 <sys_link+0x1a2>
  }

  ilock(ip);
80105ddb:	83 ec 0c             	sub    $0xc,%esp
80105dde:	ff 75 f4             	pushl  -0xc(%ebp)
80105de1:	e8 25 bb ff ff       	call   8010190b <ilock>
80105de6:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dec:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105df0:	66 83 f8 01          	cmp    $0x1,%ax
80105df4:	75 1d                	jne    80105e13 <sys_link+0x9e>
    iunlockput(ip);
80105df6:	83 ec 0c             	sub    $0xc,%esp
80105df9:	ff 75 f4             	pushl  -0xc(%ebp)
80105dfc:	e8 c4 bd ff ff       	call   80101bc5 <iunlockput>
80105e01:	83 c4 10             	add    $0x10,%esp
    end_op();
80105e04:	e8 37 d7 ff ff       	call   80103540 <end_op>
    return -1;
80105e09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e0e:	e9 04 01 00 00       	jmp    80105f17 <sys_link+0x1a2>
  }

  ip->nlink++;
80105e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e16:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e1a:	83 c0 01             	add    $0x1,%eax
80105e1d:	89 c2                	mov    %eax,%edx
80105e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e22:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105e26:	83 ec 0c             	sub    $0xc,%esp
80105e29:	ff 75 f4             	pushl  -0xc(%ebp)
80105e2c:	e8 06 b9 ff ff       	call   80101737 <iupdate>
80105e31:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105e34:	83 ec 0c             	sub    $0xc,%esp
80105e37:	ff 75 f4             	pushl  -0xc(%ebp)
80105e3a:	e8 24 bc ff ff       	call   80101a63 <iunlock>
80105e3f:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105e42:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e45:	83 ec 08             	sub    $0x8,%esp
80105e48:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105e4b:	52                   	push   %edx
80105e4c:	50                   	push   %eax
80105e4d:	e8 8d c6 ff ff       	call   801024df <nameiparent>
80105e52:	83 c4 10             	add    $0x10,%esp
80105e55:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e5c:	74 71                	je     80105ecf <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105e5e:	83 ec 0c             	sub    $0xc,%esp
80105e61:	ff 75 f0             	pushl  -0x10(%ebp)
80105e64:	e8 a2 ba ff ff       	call   8010190b <ilock>
80105e69:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e6f:	8b 10                	mov    (%eax),%edx
80105e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e74:	8b 00                	mov    (%eax),%eax
80105e76:	39 c2                	cmp    %eax,%edx
80105e78:	75 1d                	jne    80105e97 <sys_link+0x122>
80105e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e7d:	8b 40 04             	mov    0x4(%eax),%eax
80105e80:	83 ec 04             	sub    $0x4,%esp
80105e83:	50                   	push   %eax
80105e84:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105e87:	50                   	push   %eax
80105e88:	ff 75 f0             	pushl  -0x10(%ebp)
80105e8b:	e8 97 c3 ff ff       	call   80102227 <dirlink>
80105e90:	83 c4 10             	add    $0x10,%esp
80105e93:	85 c0                	test   %eax,%eax
80105e95:	79 10                	jns    80105ea7 <sys_link+0x132>
    iunlockput(dp);
80105e97:	83 ec 0c             	sub    $0xc,%esp
80105e9a:	ff 75 f0             	pushl  -0x10(%ebp)
80105e9d:	e8 23 bd ff ff       	call   80101bc5 <iunlockput>
80105ea2:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105ea5:	eb 29                	jmp    80105ed0 <sys_link+0x15b>
  }
  iunlockput(dp);
80105ea7:	83 ec 0c             	sub    $0xc,%esp
80105eaa:	ff 75 f0             	pushl  -0x10(%ebp)
80105ead:	e8 13 bd ff ff       	call   80101bc5 <iunlockput>
80105eb2:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105eb5:	83 ec 0c             	sub    $0xc,%esp
80105eb8:	ff 75 f4             	pushl  -0xc(%ebp)
80105ebb:	e8 15 bc ff ff       	call   80101ad5 <iput>
80105ec0:	83 c4 10             	add    $0x10,%esp

  end_op();
80105ec3:	e8 78 d6 ff ff       	call   80103540 <end_op>

  return 0;
80105ec8:	b8 00 00 00 00       	mov    $0x0,%eax
80105ecd:	eb 48                	jmp    80105f17 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105ecf:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105ed0:	83 ec 0c             	sub    $0xc,%esp
80105ed3:	ff 75 f4             	pushl  -0xc(%ebp)
80105ed6:	e8 30 ba ff ff       	call   8010190b <ilock>
80105edb:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ee1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ee5:	83 e8 01             	sub    $0x1,%eax
80105ee8:	89 c2                	mov    %eax,%edx
80105eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eed:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105ef1:	83 ec 0c             	sub    $0xc,%esp
80105ef4:	ff 75 f4             	pushl  -0xc(%ebp)
80105ef7:	e8 3b b8 ff ff       	call   80101737 <iupdate>
80105efc:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105eff:	83 ec 0c             	sub    $0xc,%esp
80105f02:	ff 75 f4             	pushl  -0xc(%ebp)
80105f05:	e8 bb bc ff ff       	call   80101bc5 <iunlockput>
80105f0a:	83 c4 10             	add    $0x10,%esp
  end_op();
80105f0d:	e8 2e d6 ff ff       	call   80103540 <end_op>
  return -1;
80105f12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f17:	c9                   	leave  
80105f18:	c3                   	ret    

80105f19 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105f19:	55                   	push   %ebp
80105f1a:	89 e5                	mov    %esp,%ebp
80105f1c:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105f1f:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105f26:	eb 40                	jmp    80105f68 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f2b:	6a 10                	push   $0x10
80105f2d:	50                   	push   %eax
80105f2e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f31:	50                   	push   %eax
80105f32:	ff 75 08             	pushl  0x8(%ebp)
80105f35:	e8 39 bf ff ff       	call   80101e73 <readi>
80105f3a:	83 c4 10             	add    $0x10,%esp
80105f3d:	83 f8 10             	cmp    $0x10,%eax
80105f40:	74 0d                	je     80105f4f <isdirempty+0x36>
      panic("isdirempty: readi");
80105f42:	83 ec 0c             	sub    $0xc,%esp
80105f45:	68 e5 94 10 80       	push   $0x801094e5
80105f4a:	e8 17 a6 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80105f4f:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105f53:	66 85 c0             	test   %ax,%ax
80105f56:	74 07                	je     80105f5f <isdirempty+0x46>
      return 0;
80105f58:	b8 00 00 00 00       	mov    $0x0,%eax
80105f5d:	eb 1b                	jmp    80105f7a <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f62:	83 c0 10             	add    $0x10,%eax
80105f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f68:	8b 45 08             	mov    0x8(%ebp),%eax
80105f6b:	8b 50 18             	mov    0x18(%eax),%edx
80105f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f71:	39 c2                	cmp    %eax,%edx
80105f73:	77 b3                	ja     80105f28 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105f75:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105f7a:	c9                   	leave  
80105f7b:	c3                   	ret    

80105f7c <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105f7c:	55                   	push   %ebp
80105f7d:	89 e5                	mov    %esp,%ebp
80105f7f:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105f82:	83 ec 08             	sub    $0x8,%esp
80105f85:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105f88:	50                   	push   %eax
80105f89:	6a 00                	push   $0x0
80105f8b:	e8 a0 fa ff ff       	call   80105a30 <argstr>
80105f90:	83 c4 10             	add    $0x10,%esp
80105f93:	85 c0                	test   %eax,%eax
80105f95:	79 0a                	jns    80105fa1 <sys_unlink+0x25>
    return -1;
80105f97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f9c:	e9 bc 01 00 00       	jmp    8010615d <sys_unlink+0x1e1>

  begin_op();
80105fa1:	e8 0e d5 ff ff       	call   801034b4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105fa6:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105fa9:	83 ec 08             	sub    $0x8,%esp
80105fac:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105faf:	52                   	push   %edx
80105fb0:	50                   	push   %eax
80105fb1:	e8 29 c5 ff ff       	call   801024df <nameiparent>
80105fb6:	83 c4 10             	add    $0x10,%esp
80105fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fc0:	75 0f                	jne    80105fd1 <sys_unlink+0x55>
    end_op();
80105fc2:	e8 79 d5 ff ff       	call   80103540 <end_op>
    return -1;
80105fc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fcc:	e9 8c 01 00 00       	jmp    8010615d <sys_unlink+0x1e1>
  }

  ilock(dp);
80105fd1:	83 ec 0c             	sub    $0xc,%esp
80105fd4:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd7:	e8 2f b9 ff ff       	call   8010190b <ilock>
80105fdc:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105fdf:	83 ec 08             	sub    $0x8,%esp
80105fe2:	68 f7 94 10 80       	push   $0x801094f7
80105fe7:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105fea:	50                   	push   %eax
80105feb:	e8 62 c1 ff ff       	call   80102152 <namecmp>
80105ff0:	83 c4 10             	add    $0x10,%esp
80105ff3:	85 c0                	test   %eax,%eax
80105ff5:	0f 84 4a 01 00 00    	je     80106145 <sys_unlink+0x1c9>
80105ffb:	83 ec 08             	sub    $0x8,%esp
80105ffe:	68 f9 94 10 80       	push   $0x801094f9
80106003:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106006:	50                   	push   %eax
80106007:	e8 46 c1 ff ff       	call   80102152 <namecmp>
8010600c:	83 c4 10             	add    $0x10,%esp
8010600f:	85 c0                	test   %eax,%eax
80106011:	0f 84 2e 01 00 00    	je     80106145 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106017:	83 ec 04             	sub    $0x4,%esp
8010601a:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010601d:	50                   	push   %eax
8010601e:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106021:	50                   	push   %eax
80106022:	ff 75 f4             	pushl  -0xc(%ebp)
80106025:	e8 43 c1 ff ff       	call   8010216d <dirlookup>
8010602a:	83 c4 10             	add    $0x10,%esp
8010602d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106030:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106034:	0f 84 0a 01 00 00    	je     80106144 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
8010603a:	83 ec 0c             	sub    $0xc,%esp
8010603d:	ff 75 f0             	pushl  -0x10(%ebp)
80106040:	e8 c6 b8 ff ff       	call   8010190b <ilock>
80106045:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106048:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010604b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010604f:	66 85 c0             	test   %ax,%ax
80106052:	7f 0d                	jg     80106061 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106054:	83 ec 0c             	sub    $0xc,%esp
80106057:	68 fc 94 10 80       	push   $0x801094fc
8010605c:	e8 05 a5 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106061:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106064:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106068:	66 83 f8 01          	cmp    $0x1,%ax
8010606c:	75 25                	jne    80106093 <sys_unlink+0x117>
8010606e:	83 ec 0c             	sub    $0xc,%esp
80106071:	ff 75 f0             	pushl  -0x10(%ebp)
80106074:	e8 a0 fe ff ff       	call   80105f19 <isdirempty>
80106079:	83 c4 10             	add    $0x10,%esp
8010607c:	85 c0                	test   %eax,%eax
8010607e:	75 13                	jne    80106093 <sys_unlink+0x117>
    iunlockput(ip);
80106080:	83 ec 0c             	sub    $0xc,%esp
80106083:	ff 75 f0             	pushl  -0x10(%ebp)
80106086:	e8 3a bb ff ff       	call   80101bc5 <iunlockput>
8010608b:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010608e:	e9 b2 00 00 00       	jmp    80106145 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80106093:	83 ec 04             	sub    $0x4,%esp
80106096:	6a 10                	push   $0x10
80106098:	6a 00                	push   $0x0
8010609a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010609d:	50                   	push   %eax
8010609e:	e8 e3 f5 ff ff       	call   80105686 <memset>
801060a3:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801060a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
801060a9:	6a 10                	push   $0x10
801060ab:	50                   	push   %eax
801060ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
801060af:	50                   	push   %eax
801060b0:	ff 75 f4             	pushl  -0xc(%ebp)
801060b3:	e8 12 bf ff ff       	call   80101fca <writei>
801060b8:	83 c4 10             	add    $0x10,%esp
801060bb:	83 f8 10             	cmp    $0x10,%eax
801060be:	74 0d                	je     801060cd <sys_unlink+0x151>
    panic("unlink: writei");
801060c0:	83 ec 0c             	sub    $0xc,%esp
801060c3:	68 0e 95 10 80       	push   $0x8010950e
801060c8:	e8 99 a4 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
801060cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060d0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801060d4:	66 83 f8 01          	cmp    $0x1,%ax
801060d8:	75 21                	jne    801060fb <sys_unlink+0x17f>
    dp->nlink--;
801060da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060dd:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801060e1:	83 e8 01             	sub    $0x1,%eax
801060e4:	89 c2                	mov    %eax,%edx
801060e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e9:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801060ed:	83 ec 0c             	sub    $0xc,%esp
801060f0:	ff 75 f4             	pushl  -0xc(%ebp)
801060f3:	e8 3f b6 ff ff       	call   80101737 <iupdate>
801060f8:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801060fb:	83 ec 0c             	sub    $0xc,%esp
801060fe:	ff 75 f4             	pushl  -0xc(%ebp)
80106101:	e8 bf ba ff ff       	call   80101bc5 <iunlockput>
80106106:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106109:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010610c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106110:	83 e8 01             	sub    $0x1,%eax
80106113:	89 c2                	mov    %eax,%edx
80106115:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106118:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010611c:	83 ec 0c             	sub    $0xc,%esp
8010611f:	ff 75 f0             	pushl  -0x10(%ebp)
80106122:	e8 10 b6 ff ff       	call   80101737 <iupdate>
80106127:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010612a:	83 ec 0c             	sub    $0xc,%esp
8010612d:	ff 75 f0             	pushl  -0x10(%ebp)
80106130:	e8 90 ba ff ff       	call   80101bc5 <iunlockput>
80106135:	83 c4 10             	add    $0x10,%esp

  end_op();
80106138:	e8 03 d4 ff ff       	call   80103540 <end_op>

  return 0;
8010613d:	b8 00 00 00 00       	mov    $0x0,%eax
80106142:	eb 19                	jmp    8010615d <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106144:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106145:	83 ec 0c             	sub    $0xc,%esp
80106148:	ff 75 f4             	pushl  -0xc(%ebp)
8010614b:	e8 75 ba ff ff       	call   80101bc5 <iunlockput>
80106150:	83 c4 10             	add    $0x10,%esp
  end_op();
80106153:	e8 e8 d3 ff ff       	call   80103540 <end_op>
  return -1;
80106158:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010615d:	c9                   	leave  
8010615e:	c3                   	ret    

8010615f <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010615f:	55                   	push   %ebp
80106160:	89 e5                	mov    %esp,%ebp
80106162:	83 ec 38             	sub    $0x38,%esp
80106165:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106168:	8b 55 10             	mov    0x10(%ebp),%edx
8010616b:	8b 45 14             	mov    0x14(%ebp),%eax
8010616e:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106172:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106176:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010617a:	83 ec 08             	sub    $0x8,%esp
8010617d:	8d 45 de             	lea    -0x22(%ebp),%eax
80106180:	50                   	push   %eax
80106181:	ff 75 08             	pushl  0x8(%ebp)
80106184:	e8 56 c3 ff ff       	call   801024df <nameiparent>
80106189:	83 c4 10             	add    $0x10,%esp
8010618c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010618f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106193:	75 0a                	jne    8010619f <create+0x40>
    return 0;
80106195:	b8 00 00 00 00       	mov    $0x0,%eax
8010619a:	e9 90 01 00 00       	jmp    8010632f <create+0x1d0>
  ilock(dp);
8010619f:	83 ec 0c             	sub    $0xc,%esp
801061a2:	ff 75 f4             	pushl  -0xc(%ebp)
801061a5:	e8 61 b7 ff ff       	call   8010190b <ilock>
801061aa:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801061ad:	83 ec 04             	sub    $0x4,%esp
801061b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061b3:	50                   	push   %eax
801061b4:	8d 45 de             	lea    -0x22(%ebp),%eax
801061b7:	50                   	push   %eax
801061b8:	ff 75 f4             	pushl  -0xc(%ebp)
801061bb:	e8 ad bf ff ff       	call   8010216d <dirlookup>
801061c0:	83 c4 10             	add    $0x10,%esp
801061c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061ca:	74 50                	je     8010621c <create+0xbd>
    iunlockput(dp);
801061cc:	83 ec 0c             	sub    $0xc,%esp
801061cf:	ff 75 f4             	pushl  -0xc(%ebp)
801061d2:	e8 ee b9 ff ff       	call   80101bc5 <iunlockput>
801061d7:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801061da:	83 ec 0c             	sub    $0xc,%esp
801061dd:	ff 75 f0             	pushl  -0x10(%ebp)
801061e0:	e8 26 b7 ff ff       	call   8010190b <ilock>
801061e5:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801061e8:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801061ed:	75 15                	jne    80106204 <create+0xa5>
801061ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061f2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801061f6:	66 83 f8 02          	cmp    $0x2,%ax
801061fa:	75 08                	jne    80106204 <create+0xa5>
      return ip;
801061fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ff:	e9 2b 01 00 00       	jmp    8010632f <create+0x1d0>
    iunlockput(ip);
80106204:	83 ec 0c             	sub    $0xc,%esp
80106207:	ff 75 f0             	pushl  -0x10(%ebp)
8010620a:	e8 b6 b9 ff ff       	call   80101bc5 <iunlockput>
8010620f:	83 c4 10             	add    $0x10,%esp
    return 0;
80106212:	b8 00 00 00 00       	mov    $0x0,%eax
80106217:	e9 13 01 00 00       	jmp    8010632f <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010621c:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106220:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106223:	8b 00                	mov    (%eax),%eax
80106225:	83 ec 08             	sub    $0x8,%esp
80106228:	52                   	push   %edx
80106229:	50                   	push   %eax
8010622a:	e8 27 b4 ff ff       	call   80101656 <ialloc>
8010622f:	83 c4 10             	add    $0x10,%esp
80106232:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106235:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106239:	75 0d                	jne    80106248 <create+0xe9>
    panic("create: ialloc");
8010623b:	83 ec 0c             	sub    $0xc,%esp
8010623e:	68 1d 95 10 80       	push   $0x8010951d
80106243:	e8 1e a3 ff ff       	call   80100566 <panic>

  ilock(ip);
80106248:	83 ec 0c             	sub    $0xc,%esp
8010624b:	ff 75 f0             	pushl  -0x10(%ebp)
8010624e:	e8 b8 b6 ff ff       	call   8010190b <ilock>
80106253:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106256:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106259:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010625d:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106261:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106264:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106268:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
8010626c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010626f:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106275:	83 ec 0c             	sub    $0xc,%esp
80106278:	ff 75 f0             	pushl  -0x10(%ebp)
8010627b:	e8 b7 b4 ff ff       	call   80101737 <iupdate>
80106280:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106283:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106288:	75 6a                	jne    801062f4 <create+0x195>
    dp->nlink++;  // for ".."
8010628a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010628d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106291:	83 c0 01             	add    $0x1,%eax
80106294:	89 c2                	mov    %eax,%edx
80106296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106299:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010629d:	83 ec 0c             	sub    $0xc,%esp
801062a0:	ff 75 f4             	pushl  -0xc(%ebp)
801062a3:	e8 8f b4 ff ff       	call   80101737 <iupdate>
801062a8:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801062ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062ae:	8b 40 04             	mov    0x4(%eax),%eax
801062b1:	83 ec 04             	sub    $0x4,%esp
801062b4:	50                   	push   %eax
801062b5:	68 f7 94 10 80       	push   $0x801094f7
801062ba:	ff 75 f0             	pushl  -0x10(%ebp)
801062bd:	e8 65 bf ff ff       	call   80102227 <dirlink>
801062c2:	83 c4 10             	add    $0x10,%esp
801062c5:	85 c0                	test   %eax,%eax
801062c7:	78 1e                	js     801062e7 <create+0x188>
801062c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062cc:	8b 40 04             	mov    0x4(%eax),%eax
801062cf:	83 ec 04             	sub    $0x4,%esp
801062d2:	50                   	push   %eax
801062d3:	68 f9 94 10 80       	push   $0x801094f9
801062d8:	ff 75 f0             	pushl  -0x10(%ebp)
801062db:	e8 47 bf ff ff       	call   80102227 <dirlink>
801062e0:	83 c4 10             	add    $0x10,%esp
801062e3:	85 c0                	test   %eax,%eax
801062e5:	79 0d                	jns    801062f4 <create+0x195>
      panic("create dots");
801062e7:	83 ec 0c             	sub    $0xc,%esp
801062ea:	68 2c 95 10 80       	push   $0x8010952c
801062ef:	e8 72 a2 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801062f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062f7:	8b 40 04             	mov    0x4(%eax),%eax
801062fa:	83 ec 04             	sub    $0x4,%esp
801062fd:	50                   	push   %eax
801062fe:	8d 45 de             	lea    -0x22(%ebp),%eax
80106301:	50                   	push   %eax
80106302:	ff 75 f4             	pushl  -0xc(%ebp)
80106305:	e8 1d bf ff ff       	call   80102227 <dirlink>
8010630a:	83 c4 10             	add    $0x10,%esp
8010630d:	85 c0                	test   %eax,%eax
8010630f:	79 0d                	jns    8010631e <create+0x1bf>
    panic("create: dirlink");
80106311:	83 ec 0c             	sub    $0xc,%esp
80106314:	68 38 95 10 80       	push   $0x80109538
80106319:	e8 48 a2 ff ff       	call   80100566 <panic>

  iunlockput(dp);
8010631e:	83 ec 0c             	sub    $0xc,%esp
80106321:	ff 75 f4             	pushl  -0xc(%ebp)
80106324:	e8 9c b8 ff ff       	call   80101bc5 <iunlockput>
80106329:	83 c4 10             	add    $0x10,%esp

  return ip;
8010632c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010632f:	c9                   	leave  
80106330:	c3                   	ret    

80106331 <sys_open>:

int
sys_open(void)
{
80106331:	55                   	push   %ebp
80106332:	89 e5                	mov    %esp,%ebp
80106334:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106337:	83 ec 08             	sub    $0x8,%esp
8010633a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010633d:	50                   	push   %eax
8010633e:	6a 00                	push   $0x0
80106340:	e8 eb f6 ff ff       	call   80105a30 <argstr>
80106345:	83 c4 10             	add    $0x10,%esp
80106348:	85 c0                	test   %eax,%eax
8010634a:	78 15                	js     80106361 <sys_open+0x30>
8010634c:	83 ec 08             	sub    $0x8,%esp
8010634f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106352:	50                   	push   %eax
80106353:	6a 01                	push   $0x1
80106355:	e8 51 f6 ff ff       	call   801059ab <argint>
8010635a:	83 c4 10             	add    $0x10,%esp
8010635d:	85 c0                	test   %eax,%eax
8010635f:	79 0a                	jns    8010636b <sys_open+0x3a>
    return -1;
80106361:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106366:	e9 61 01 00 00       	jmp    801064cc <sys_open+0x19b>

  begin_op();
8010636b:	e8 44 d1 ff ff       	call   801034b4 <begin_op>

  if(omode & O_CREATE){
80106370:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106373:	25 00 02 00 00       	and    $0x200,%eax
80106378:	85 c0                	test   %eax,%eax
8010637a:	74 2a                	je     801063a6 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
8010637c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010637f:	6a 00                	push   $0x0
80106381:	6a 00                	push   $0x0
80106383:	6a 02                	push   $0x2
80106385:	50                   	push   %eax
80106386:	e8 d4 fd ff ff       	call   8010615f <create>
8010638b:	83 c4 10             	add    $0x10,%esp
8010638e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106391:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106395:	75 75                	jne    8010640c <sys_open+0xdb>
      end_op();
80106397:	e8 a4 d1 ff ff       	call   80103540 <end_op>
      return -1;
8010639c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a1:	e9 26 01 00 00       	jmp    801064cc <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801063a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063a9:	83 ec 0c             	sub    $0xc,%esp
801063ac:	50                   	push   %eax
801063ad:	e8 11 c1 ff ff       	call   801024c3 <namei>
801063b2:	83 c4 10             	add    $0x10,%esp
801063b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063bc:	75 0f                	jne    801063cd <sys_open+0x9c>
      end_op();
801063be:	e8 7d d1 ff ff       	call   80103540 <end_op>
      return -1;
801063c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063c8:	e9 ff 00 00 00       	jmp    801064cc <sys_open+0x19b>
    }
    ilock(ip);
801063cd:	83 ec 0c             	sub    $0xc,%esp
801063d0:	ff 75 f4             	pushl  -0xc(%ebp)
801063d3:	e8 33 b5 ff ff       	call   8010190b <ilock>
801063d8:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801063db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063de:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801063e2:	66 83 f8 01          	cmp    $0x1,%ax
801063e6:	75 24                	jne    8010640c <sys_open+0xdb>
801063e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063eb:	85 c0                	test   %eax,%eax
801063ed:	74 1d                	je     8010640c <sys_open+0xdb>
      iunlockput(ip);
801063ef:	83 ec 0c             	sub    $0xc,%esp
801063f2:	ff 75 f4             	pushl  -0xc(%ebp)
801063f5:	e8 cb b7 ff ff       	call   80101bc5 <iunlockput>
801063fa:	83 c4 10             	add    $0x10,%esp
      end_op();
801063fd:	e8 3e d1 ff ff       	call   80103540 <end_op>
      return -1;
80106402:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106407:	e9 c0 00 00 00       	jmp    801064cc <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010640c:	e8 67 ab ff ff       	call   80100f78 <filealloc>
80106411:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106414:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106418:	74 17                	je     80106431 <sys_open+0x100>
8010641a:	83 ec 0c             	sub    $0xc,%esp
8010641d:	ff 75 f0             	pushl  -0x10(%ebp)
80106420:	e8 37 f7 ff ff       	call   80105b5c <fdalloc>
80106425:	83 c4 10             	add    $0x10,%esp
80106428:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010642b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010642f:	79 2e                	jns    8010645f <sys_open+0x12e>
    if(f)
80106431:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106435:	74 0e                	je     80106445 <sys_open+0x114>
      fileclose(f);
80106437:	83 ec 0c             	sub    $0xc,%esp
8010643a:	ff 75 f0             	pushl  -0x10(%ebp)
8010643d:	e8 f4 ab ff ff       	call   80101036 <fileclose>
80106442:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106445:	83 ec 0c             	sub    $0xc,%esp
80106448:	ff 75 f4             	pushl  -0xc(%ebp)
8010644b:	e8 75 b7 ff ff       	call   80101bc5 <iunlockput>
80106450:	83 c4 10             	add    $0x10,%esp
    end_op();
80106453:	e8 e8 d0 ff ff       	call   80103540 <end_op>
    return -1;
80106458:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010645d:	eb 6d                	jmp    801064cc <sys_open+0x19b>
  }
  iunlock(ip);
8010645f:	83 ec 0c             	sub    $0xc,%esp
80106462:	ff 75 f4             	pushl  -0xc(%ebp)
80106465:	e8 f9 b5 ff ff       	call   80101a63 <iunlock>
8010646a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010646d:	e8 ce d0 ff ff       	call   80103540 <end_op>

  f->type = FD_INODE;
80106472:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106475:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010647b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010647e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106481:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106484:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106487:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010648e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106491:	83 e0 01             	and    $0x1,%eax
80106494:	85 c0                	test   %eax,%eax
80106496:	0f 94 c0             	sete   %al
80106499:	89 c2                	mov    %eax,%edx
8010649b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010649e:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801064a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064a4:	83 e0 01             	and    $0x1,%eax
801064a7:	85 c0                	test   %eax,%eax
801064a9:	75 0a                	jne    801064b5 <sys_open+0x184>
801064ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064ae:	83 e0 02             	and    $0x2,%eax
801064b1:	85 c0                	test   %eax,%eax
801064b3:	74 07                	je     801064bc <sys_open+0x18b>
801064b5:	b8 01 00 00 00       	mov    $0x1,%eax
801064ba:	eb 05                	jmp    801064c1 <sys_open+0x190>
801064bc:	b8 00 00 00 00       	mov    $0x0,%eax
801064c1:	89 c2                	mov    %eax,%edx
801064c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064c6:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801064c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801064cc:	c9                   	leave  
801064cd:	c3                   	ret    

801064ce <sys_mkdir>:

int
sys_mkdir(void)
{
801064ce:	55                   	push   %ebp
801064cf:	89 e5                	mov    %esp,%ebp
801064d1:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801064d4:	e8 db cf ff ff       	call   801034b4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801064d9:	83 ec 08             	sub    $0x8,%esp
801064dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064df:	50                   	push   %eax
801064e0:	6a 00                	push   $0x0
801064e2:	e8 49 f5 ff ff       	call   80105a30 <argstr>
801064e7:	83 c4 10             	add    $0x10,%esp
801064ea:	85 c0                	test   %eax,%eax
801064ec:	78 1b                	js     80106509 <sys_mkdir+0x3b>
801064ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064f1:	6a 00                	push   $0x0
801064f3:	6a 00                	push   $0x0
801064f5:	6a 01                	push   $0x1
801064f7:	50                   	push   %eax
801064f8:	e8 62 fc ff ff       	call   8010615f <create>
801064fd:	83 c4 10             	add    $0x10,%esp
80106500:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106503:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106507:	75 0c                	jne    80106515 <sys_mkdir+0x47>
    end_op();
80106509:	e8 32 d0 ff ff       	call   80103540 <end_op>
    return -1;
8010650e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106513:	eb 18                	jmp    8010652d <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106515:	83 ec 0c             	sub    $0xc,%esp
80106518:	ff 75 f4             	pushl  -0xc(%ebp)
8010651b:	e8 a5 b6 ff ff       	call   80101bc5 <iunlockput>
80106520:	83 c4 10             	add    $0x10,%esp
  end_op();
80106523:	e8 18 d0 ff ff       	call   80103540 <end_op>
  return 0;
80106528:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010652d:	c9                   	leave  
8010652e:	c3                   	ret    

8010652f <sys_mknod>:

int
sys_mknod(void)
{
8010652f:	55                   	push   %ebp
80106530:	89 e5                	mov    %esp,%ebp
80106532:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106535:	e8 7a cf ff ff       	call   801034b4 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010653a:	83 ec 08             	sub    $0x8,%esp
8010653d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106540:	50                   	push   %eax
80106541:	6a 00                	push   $0x0
80106543:	e8 e8 f4 ff ff       	call   80105a30 <argstr>
80106548:	83 c4 10             	add    $0x10,%esp
8010654b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010654e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106552:	78 4f                	js     801065a3 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80106554:	83 ec 08             	sub    $0x8,%esp
80106557:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010655a:	50                   	push   %eax
8010655b:	6a 01                	push   $0x1
8010655d:	e8 49 f4 ff ff       	call   801059ab <argint>
80106562:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106565:	85 c0                	test   %eax,%eax
80106567:	78 3a                	js     801065a3 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106569:	83 ec 08             	sub    $0x8,%esp
8010656c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010656f:	50                   	push   %eax
80106570:	6a 02                	push   $0x2
80106572:	e8 34 f4 ff ff       	call   801059ab <argint>
80106577:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010657a:	85 c0                	test   %eax,%eax
8010657c:	78 25                	js     801065a3 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010657e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106581:	0f bf c8             	movswl %ax,%ecx
80106584:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106587:	0f bf d0             	movswl %ax,%edx
8010658a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010658d:	51                   	push   %ecx
8010658e:	52                   	push   %edx
8010658f:	6a 03                	push   $0x3
80106591:	50                   	push   %eax
80106592:	e8 c8 fb ff ff       	call   8010615f <create>
80106597:	83 c4 10             	add    $0x10,%esp
8010659a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010659d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801065a1:	75 0c                	jne    801065af <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801065a3:	e8 98 cf ff ff       	call   80103540 <end_op>
    return -1;
801065a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ad:	eb 18                	jmp    801065c7 <sys_mknod+0x98>
  }
  iunlockput(ip);
801065af:	83 ec 0c             	sub    $0xc,%esp
801065b2:	ff 75 f0             	pushl  -0x10(%ebp)
801065b5:	e8 0b b6 ff ff       	call   80101bc5 <iunlockput>
801065ba:	83 c4 10             	add    $0x10,%esp
  end_op();
801065bd:	e8 7e cf ff ff       	call   80103540 <end_op>
  return 0;
801065c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065c7:	c9                   	leave  
801065c8:	c3                   	ret    

801065c9 <sys_chdir>:

int
sys_chdir(void)
{
801065c9:	55                   	push   %ebp
801065ca:	89 e5                	mov    %esp,%ebp
801065cc:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801065cf:	e8 e0 ce ff ff       	call   801034b4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801065d4:	83 ec 08             	sub    $0x8,%esp
801065d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065da:	50                   	push   %eax
801065db:	6a 00                	push   $0x0
801065dd:	e8 4e f4 ff ff       	call   80105a30 <argstr>
801065e2:	83 c4 10             	add    $0x10,%esp
801065e5:	85 c0                	test   %eax,%eax
801065e7:	78 18                	js     80106601 <sys_chdir+0x38>
801065e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065ec:	83 ec 0c             	sub    $0xc,%esp
801065ef:	50                   	push   %eax
801065f0:	e8 ce be ff ff       	call   801024c3 <namei>
801065f5:	83 c4 10             	add    $0x10,%esp
801065f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065ff:	75 0c                	jne    8010660d <sys_chdir+0x44>
    end_op();
80106601:	e8 3a cf ff ff       	call   80103540 <end_op>
    return -1;
80106606:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010660b:	eb 6e                	jmp    8010667b <sys_chdir+0xb2>
  }
  ilock(ip);
8010660d:	83 ec 0c             	sub    $0xc,%esp
80106610:	ff 75 f4             	pushl  -0xc(%ebp)
80106613:	e8 f3 b2 ff ff       	call   8010190b <ilock>
80106618:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010661b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010661e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106622:	66 83 f8 01          	cmp    $0x1,%ax
80106626:	74 1a                	je     80106642 <sys_chdir+0x79>
    iunlockput(ip);
80106628:	83 ec 0c             	sub    $0xc,%esp
8010662b:	ff 75 f4             	pushl  -0xc(%ebp)
8010662e:	e8 92 b5 ff ff       	call   80101bc5 <iunlockput>
80106633:	83 c4 10             	add    $0x10,%esp
    end_op();
80106636:	e8 05 cf ff ff       	call   80103540 <end_op>
    return -1;
8010663b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106640:	eb 39                	jmp    8010667b <sys_chdir+0xb2>
  }
  iunlock(ip);
80106642:	83 ec 0c             	sub    $0xc,%esp
80106645:	ff 75 f4             	pushl  -0xc(%ebp)
80106648:	e8 16 b4 ff ff       	call   80101a63 <iunlock>
8010664d:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80106650:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106656:	8b 40 68             	mov    0x68(%eax),%eax
80106659:	83 ec 0c             	sub    $0xc,%esp
8010665c:	50                   	push   %eax
8010665d:	e8 73 b4 ff ff       	call   80101ad5 <iput>
80106662:	83 c4 10             	add    $0x10,%esp
  end_op();
80106665:	e8 d6 ce ff ff       	call   80103540 <end_op>
  proc->cwd = ip;
8010666a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106670:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106673:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106676:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010667b:	c9                   	leave  
8010667c:	c3                   	ret    

8010667d <sys_exec>:

int
sys_exec(void)
{
8010667d:	55                   	push   %ebp
8010667e:	89 e5                	mov    %esp,%ebp
80106680:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106686:	83 ec 08             	sub    $0x8,%esp
80106689:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010668c:	50                   	push   %eax
8010668d:	6a 00                	push   $0x0
8010668f:	e8 9c f3 ff ff       	call   80105a30 <argstr>
80106694:	83 c4 10             	add    $0x10,%esp
80106697:	85 c0                	test   %eax,%eax
80106699:	78 18                	js     801066b3 <sys_exec+0x36>
8010669b:	83 ec 08             	sub    $0x8,%esp
8010669e:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801066a4:	50                   	push   %eax
801066a5:	6a 01                	push   $0x1
801066a7:	e8 ff f2 ff ff       	call   801059ab <argint>
801066ac:	83 c4 10             	add    $0x10,%esp
801066af:	85 c0                	test   %eax,%eax
801066b1:	79 0a                	jns    801066bd <sys_exec+0x40>
    return -1;
801066b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066b8:	e9 c6 00 00 00       	jmp    80106783 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801066bd:	83 ec 04             	sub    $0x4,%esp
801066c0:	68 80 00 00 00       	push   $0x80
801066c5:	6a 00                	push   $0x0
801066c7:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801066cd:	50                   	push   %eax
801066ce:	e8 b3 ef ff ff       	call   80105686 <memset>
801066d3:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801066d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801066dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066e0:	83 f8 1f             	cmp    $0x1f,%eax
801066e3:	76 0a                	jbe    801066ef <sys_exec+0x72>
      return -1;
801066e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ea:	e9 94 00 00 00       	jmp    80106783 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801066ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066f2:	c1 e0 02             	shl    $0x2,%eax
801066f5:	89 c2                	mov    %eax,%edx
801066f7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801066fd:	01 c2                	add    %eax,%edx
801066ff:	83 ec 08             	sub    $0x8,%esp
80106702:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106708:	50                   	push   %eax
80106709:	52                   	push   %edx
8010670a:	e8 00 f2 ff ff       	call   8010590f <fetchint>
8010670f:	83 c4 10             	add    $0x10,%esp
80106712:	85 c0                	test   %eax,%eax
80106714:	79 07                	jns    8010671d <sys_exec+0xa0>
      return -1;
80106716:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671b:	eb 66                	jmp    80106783 <sys_exec+0x106>
    if(uarg == 0){
8010671d:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106723:	85 c0                	test   %eax,%eax
80106725:	75 27                	jne    8010674e <sys_exec+0xd1>
      argv[i] = 0;
80106727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010672a:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106731:	00 00 00 00 
      break;
80106735:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106736:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106739:	83 ec 08             	sub    $0x8,%esp
8010673c:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106742:	52                   	push   %edx
80106743:	50                   	push   %eax
80106744:	e8 0d a4 ff ff       	call   80100b56 <exec>
80106749:	83 c4 10             	add    $0x10,%esp
8010674c:	eb 35                	jmp    80106783 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010674e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106754:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106757:	c1 e2 02             	shl    $0x2,%edx
8010675a:	01 c2                	add    %eax,%edx
8010675c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106762:	83 ec 08             	sub    $0x8,%esp
80106765:	52                   	push   %edx
80106766:	50                   	push   %eax
80106767:	e8 dd f1 ff ff       	call   80105949 <fetchstr>
8010676c:	83 c4 10             	add    $0x10,%esp
8010676f:	85 c0                	test   %eax,%eax
80106771:	79 07                	jns    8010677a <sys_exec+0xfd>
      return -1;
80106773:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106778:	eb 09                	jmp    80106783 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
8010677a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010677e:	e9 5a ff ff ff       	jmp    801066dd <sys_exec+0x60>
  return exec(path, argv);
}
80106783:	c9                   	leave  
80106784:	c3                   	ret    

80106785 <sys_pipe>:

int
sys_pipe(void)
{
80106785:	55                   	push   %ebp
80106786:	89 e5                	mov    %esp,%ebp
80106788:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010678b:	83 ec 04             	sub    $0x4,%esp
8010678e:	6a 08                	push   $0x8
80106790:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106793:	50                   	push   %eax
80106794:	6a 00                	push   $0x0
80106796:	e8 38 f2 ff ff       	call   801059d3 <argptr>
8010679b:	83 c4 10             	add    $0x10,%esp
8010679e:	85 c0                	test   %eax,%eax
801067a0:	79 0a                	jns    801067ac <sys_pipe+0x27>
    return -1;
801067a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067a7:	e9 af 00 00 00       	jmp    8010685b <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801067ac:	83 ec 08             	sub    $0x8,%esp
801067af:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801067b2:	50                   	push   %eax
801067b3:	8d 45 e8             	lea    -0x18(%ebp),%eax
801067b6:	50                   	push   %eax
801067b7:	e8 d6 d7 ff ff       	call   80103f92 <pipealloc>
801067bc:	83 c4 10             	add    $0x10,%esp
801067bf:	85 c0                	test   %eax,%eax
801067c1:	79 0a                	jns    801067cd <sys_pipe+0x48>
    return -1;
801067c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067c8:	e9 8e 00 00 00       	jmp    8010685b <sys_pipe+0xd6>
  fd0 = -1;
801067cd:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801067d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801067d7:	83 ec 0c             	sub    $0xc,%esp
801067da:	50                   	push   %eax
801067db:	e8 7c f3 ff ff       	call   80105b5c <fdalloc>
801067e0:	83 c4 10             	add    $0x10,%esp
801067e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801067e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067ea:	78 18                	js     80106804 <sys_pipe+0x7f>
801067ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067ef:	83 ec 0c             	sub    $0xc,%esp
801067f2:	50                   	push   %eax
801067f3:	e8 64 f3 ff ff       	call   80105b5c <fdalloc>
801067f8:	83 c4 10             	add    $0x10,%esp
801067fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801067fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106802:	79 3f                	jns    80106843 <sys_pipe+0xbe>
    if(fd0 >= 0)
80106804:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106808:	78 14                	js     8010681e <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
8010680a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106810:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106813:	83 c2 08             	add    $0x8,%edx
80106816:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010681d:	00 
    fileclose(rf);
8010681e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106821:	83 ec 0c             	sub    $0xc,%esp
80106824:	50                   	push   %eax
80106825:	e8 0c a8 ff ff       	call   80101036 <fileclose>
8010682a:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010682d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106830:	83 ec 0c             	sub    $0xc,%esp
80106833:	50                   	push   %eax
80106834:	e8 fd a7 ff ff       	call   80101036 <fileclose>
80106839:	83 c4 10             	add    $0x10,%esp
    return -1;
8010683c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106841:	eb 18                	jmp    8010685b <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80106843:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106846:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106849:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010684b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010684e:	8d 50 04             	lea    0x4(%eax),%edx
80106851:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106854:	89 02                	mov    %eax,(%edx)
  return 0;
80106856:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010685b:	c9                   	leave  
8010685c:	c3                   	ret    

8010685d <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
8010685d:	55                   	push   %ebp
8010685e:	89 e5                	mov    %esp,%ebp
80106860:	83 ec 08             	sub    $0x8,%esp
80106863:	8b 55 08             	mov    0x8(%ebp),%edx
80106866:	8b 45 0c             	mov    0xc(%ebp),%eax
80106869:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010686d:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106871:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80106875:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106879:	66 ef                	out    %ax,(%dx)
}
8010687b:	90                   	nop
8010687c:	c9                   	leave  
8010687d:	c3                   	ret    

8010687e <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010687e:	55                   	push   %ebp
8010687f:	89 e5                	mov    %esp,%ebp
80106881:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106884:	e8 02 de ff ff       	call   8010468b <fork>
}
80106889:	c9                   	leave  
8010688a:	c3                   	ret    

8010688b <sys_exit>:

int
sys_exit(void)
{
8010688b:	55                   	push   %ebp
8010688c:	89 e5                	mov    %esp,%ebp
8010688e:	83 ec 08             	sub    $0x8,%esp
  exit();
80106891:	e8 86 df ff ff       	call   8010481c <exit>
  return 0;  // not reached
80106896:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010689b:	c9                   	leave  
8010689c:	c3                   	ret    

8010689d <sys_wait>:

int
sys_wait(void)
{
8010689d:	55                   	push   %ebp
8010689e:	89 e5                	mov    %esp,%ebp
801068a0:	83 ec 08             	sub    $0x8,%esp
  return wait();
801068a3:	e8 e0 e0 ff ff       	call   80104988 <wait>
}
801068a8:	c9                   	leave  
801068a9:	c3                   	ret    

801068aa <sys_kill>:

int
sys_kill(void)
{
801068aa:	55                   	push   %ebp
801068ab:	89 e5                	mov    %esp,%ebp
801068ad:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801068b0:	83 ec 08             	sub    $0x8,%esp
801068b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068b6:	50                   	push   %eax
801068b7:	6a 00                	push   $0x0
801068b9:	e8 ed f0 ff ff       	call   801059ab <argint>
801068be:	83 c4 10             	add    $0x10,%esp
801068c1:	85 c0                	test   %eax,%eax
801068c3:	79 07                	jns    801068cc <sys_kill+0x22>
    return -1;
801068c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068ca:	eb 0f                	jmp    801068db <sys_kill+0x31>
  return kill(pid);
801068cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068cf:	83 ec 0c             	sub    $0xc,%esp
801068d2:	50                   	push   %eax
801068d3:	e8 cc e4 ff ff       	call   80104da4 <kill>
801068d8:	83 c4 10             	add    $0x10,%esp
}
801068db:	c9                   	leave  
801068dc:	c3                   	ret    

801068dd <sys_getpid>:

int
sys_getpid(void)
{
801068dd:	55                   	push   %ebp
801068de:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801068e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068e6:	8b 40 10             	mov    0x10(%eax),%eax
}
801068e9:	5d                   	pop    %ebp
801068ea:	c3                   	ret    

801068eb <sys_sbrk>:

int
sys_sbrk(void)
{
801068eb:	55                   	push   %ebp
801068ec:	89 e5                	mov    %esp,%ebp
801068ee:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801068f1:	83 ec 08             	sub    $0x8,%esp
801068f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068f7:	50                   	push   %eax
801068f8:	6a 00                	push   $0x0
801068fa:	e8 ac f0 ff ff       	call   801059ab <argint>
801068ff:	83 c4 10             	add    $0x10,%esp
80106902:	85 c0                	test   %eax,%eax
80106904:	79 07                	jns    8010690d <sys_sbrk+0x22>
    return -1;
80106906:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010690b:	eb 28                	jmp    80106935 <sys_sbrk+0x4a>
  addr = proc->sz;
8010690d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106913:	8b 00                	mov    (%eax),%eax
80106915:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106918:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010691b:	83 ec 0c             	sub    $0xc,%esp
8010691e:	50                   	push   %eax
8010691f:	e8 c4 dc ff ff       	call   801045e8 <growproc>
80106924:	83 c4 10             	add    $0x10,%esp
80106927:	85 c0                	test   %eax,%eax
80106929:	79 07                	jns    80106932 <sys_sbrk+0x47>
    return -1;
8010692b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106930:	eb 03                	jmp    80106935 <sys_sbrk+0x4a>
  return addr;
80106932:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106935:	c9                   	leave  
80106936:	c3                   	ret    

80106937 <sys_sleep>:

int
sys_sleep(void)
{
80106937:	55                   	push   %ebp
80106938:	89 e5                	mov    %esp,%ebp
8010693a:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010693d:	83 ec 08             	sub    $0x8,%esp
80106940:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106943:	50                   	push   %eax
80106944:	6a 00                	push   $0x0
80106946:	e8 60 f0 ff ff       	call   801059ab <argint>
8010694b:	83 c4 10             	add    $0x10,%esp
8010694e:	85 c0                	test   %eax,%eax
80106950:	79 07                	jns    80106959 <sys_sleep+0x22>
    return -1;
80106952:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106957:	eb 77                	jmp    801069d0 <sys_sleep+0x99>
  acquire(&tickslock);
80106959:	83 ec 0c             	sub    $0xc,%esp
8010695c:	68 c0 5a 11 80       	push   $0x80115ac0
80106961:	e8 bd ea ff ff       	call   80105423 <acquire>
80106966:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106969:	a1 00 63 11 80       	mov    0x80116300,%eax
8010696e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106971:	eb 39                	jmp    801069ac <sys_sleep+0x75>
    if(proc->killed){
80106973:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106979:	8b 40 24             	mov    0x24(%eax),%eax
8010697c:	85 c0                	test   %eax,%eax
8010697e:	74 17                	je     80106997 <sys_sleep+0x60>
      release(&tickslock);
80106980:	83 ec 0c             	sub    $0xc,%esp
80106983:	68 c0 5a 11 80       	push   $0x80115ac0
80106988:	e8 fd ea ff ff       	call   8010548a <release>
8010698d:	83 c4 10             	add    $0x10,%esp
      return -1;
80106990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106995:	eb 39                	jmp    801069d0 <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80106997:	83 ec 08             	sub    $0x8,%esp
8010699a:	68 c0 5a 11 80       	push   $0x80115ac0
8010699f:	68 00 63 11 80       	push   $0x80116300
801069a4:	e8 d6 e2 ff ff       	call   80104c7f <sleep>
801069a9:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801069ac:	a1 00 63 11 80       	mov    0x80116300,%eax
801069b1:	2b 45 f4             	sub    -0xc(%ebp),%eax
801069b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801069b7:	39 d0                	cmp    %edx,%eax
801069b9:	72 b8                	jb     80106973 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801069bb:	83 ec 0c             	sub    $0xc,%esp
801069be:	68 c0 5a 11 80       	push   $0x80115ac0
801069c3:	e8 c2 ea ff ff       	call   8010548a <release>
801069c8:	83 c4 10             	add    $0x10,%esp
  return 0;
801069cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069d0:	c9                   	leave  
801069d1:	c3                   	ret    

801069d2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801069d2:	55                   	push   %ebp
801069d3:	89 e5                	mov    %esp,%ebp
801069d5:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
801069d8:	83 ec 0c             	sub    $0xc,%esp
801069db:	68 c0 5a 11 80       	push   $0x80115ac0
801069e0:	e8 3e ea ff ff       	call   80105423 <acquire>
801069e5:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
801069e8:	a1 00 63 11 80       	mov    0x80116300,%eax
801069ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801069f0:	83 ec 0c             	sub    $0xc,%esp
801069f3:	68 c0 5a 11 80       	push   $0x80115ac0
801069f8:	e8 8d ea ff ff       	call   8010548a <release>
801069fd:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106a03:	c9                   	leave  
80106a04:	c3                   	ret    

80106a05 <sys_halt>:
// signal to QEMU.
// Based on: http://pdos.csail.mit.edu/6.828/2012/homework/xv6-syscall.html
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
80106a05:	55                   	push   %ebp
80106a06:	89 e5                	mov    %esp,%ebp
80106a08:	83 ec 10             	sub    $0x10,%esp
  char *p = "Shutdown";
80106a0b:	c7 45 fc 48 95 10 80 	movl   $0x80109548,-0x4(%ebp)
  for( ; *p; p++)
80106a12:	eb 16                	jmp    80106a2a <sys_halt+0x25>
    outw(0xB004, 0x2000);
80106a14:	68 00 20 00 00       	push   $0x2000
80106a19:	68 04 b0 00 00       	push   $0xb004
80106a1e:	e8 3a fe ff ff       	call   8010685d <outw>
80106a23:	83 c4 08             	add    $0x8,%esp
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
  char *p = "Shutdown";
  for( ; *p; p++)
80106a26:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106a2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106a2d:	0f b6 00             	movzbl (%eax),%eax
80106a30:	84 c0                	test   %al,%al
80106a32:	75 e0                	jne    80106a14 <sys_halt+0xf>
    outw(0xB004, 0x2000);
  return 0;
80106a34:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a39:	c9                   	leave  
80106a3a:	c3                   	ret    

80106a3b <sys_getnp>:

int 
sys_getnp(void)
{
80106a3b:	55                   	push   %ebp
80106a3c:	89 e5                	mov    %esp,%ebp
80106a3e:	83 ec 08             	sub    $0x8,%esp
	return getnp();
80106a41:	e8 e1 e4 ff ff       	call   80104f27 <getnp>
}
80106a46:	c9                   	leave  
80106a47:	c3                   	ret    

80106a48 <sys_sem_create>:

int
sys_sem_create(void)
{
80106a48:	55                   	push   %ebp
80106a49:	89 e5                	mov    %esp,%ebp
80106a4b:	83 ec 18             	sub    $0x18,%esp
  int num;
  if(argint(0, &num) < 0)
80106a4e:	83 ec 08             	sub    $0x8,%esp
80106a51:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a54:	50                   	push   %eax
80106a55:	6a 00                	push   $0x0
80106a57:	e8 4f ef ff ff       	call   801059ab <argint>
80106a5c:	83 c4 10             	add    $0x10,%esp
80106a5f:	85 c0                	test   %eax,%eax
80106a61:	79 07                	jns    80106a6a <sys_sem_create+0x22>
    return -1;
80106a63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a68:	eb 0f                	jmp    80106a79 <sys_sem_create+0x31>
  return sem_create(num);
80106a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a6d:	83 ec 0c             	sub    $0xc,%esp
80106a70:	50                   	push   %eax
80106a71:	e8 43 21 00 00       	call   80108bb9 <sem_create>
80106a76:	83 c4 10             	add    $0x10,%esp
}
80106a79:	c9                   	leave  
80106a7a:	c3                   	ret    

80106a7b <sys_sem_destroy>:

int
sys_sem_destroy(void)
{
80106a7b:	55                   	push   %ebp
80106a7c:	89 e5                	mov    %esp,%ebp
80106a7e:	83 ec 18             	sub    $0x18,%esp
  int num;
  if(argint(0, &num) < 0)
80106a81:	83 ec 08             	sub    $0x8,%esp
80106a84:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a87:	50                   	push   %eax
80106a88:	6a 00                	push   $0x0
80106a8a:	e8 1c ef ff ff       	call   801059ab <argint>
80106a8f:	83 c4 10             	add    $0x10,%esp
80106a92:	85 c0                	test   %eax,%eax
80106a94:	79 07                	jns    80106a9d <sys_sem_destroy+0x22>
    return -1;
80106a96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a9b:	eb 0f                	jmp    80106aac <sys_sem_destroy+0x31>
  return sem_destroy(num);
80106a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aa0:	83 ec 0c             	sub    $0xc,%esp
80106aa3:	50                   	push   %eax
80106aa4:	e8 de 21 00 00       	call   80108c87 <sem_destroy>
80106aa9:	83 c4 10             	add    $0x10,%esp
}
80106aac:	c9                   	leave  
80106aad:	c3                   	ret    

80106aae <sys_sem_wait>:

int
sys_sem_wait(void)
{
80106aae:	55                   	push   %ebp
80106aaf:	89 e5                	mov    %esp,%ebp
80106ab1:	83 ec 18             	sub    $0x18,%esp
  int num;
  if(argint(0, &num) < 0)
80106ab4:	83 ec 08             	sub    $0x8,%esp
80106ab7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106aba:	50                   	push   %eax
80106abb:	6a 00                	push   $0x0
80106abd:	e8 e9 ee ff ff       	call   801059ab <argint>
80106ac2:	83 c4 10             	add    $0x10,%esp
80106ac5:	85 c0                	test   %eax,%eax
80106ac7:	79 07                	jns    80106ad0 <sys_sem_wait+0x22>
    return -1;
80106ac9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ace:	eb 0f                	jmp    80106adf <sys_sem_wait+0x31>
  return sem_wait(num);
80106ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ad3:	83 ec 0c             	sub    $0xc,%esp
80106ad6:	50                   	push   %eax
80106ad7:	e8 c8 22 00 00       	call   80108da4 <sem_wait>
80106adc:	83 c4 10             	add    $0x10,%esp
}
80106adf:	c9                   	leave  
80106ae0:	c3                   	ret    

80106ae1 <sys_sem_signal>:

int
sys_sem_signal(void)
{
80106ae1:	55                   	push   %ebp
80106ae2:	89 e5                	mov    %esp,%ebp
80106ae4:	83 ec 18             	sub    $0x18,%esp
  int num;
  if(argint(0, &num) < 0)
80106ae7:	83 ec 08             	sub    $0x8,%esp
80106aea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106aed:	50                   	push   %eax
80106aee:	6a 00                	push   $0x0
80106af0:	e8 b6 ee ff ff       	call   801059ab <argint>
80106af5:	83 c4 10             	add    $0x10,%esp
80106af8:	85 c0                	test   %eax,%eax
80106afa:	79 07                	jns    80106b03 <sys_sem_signal+0x22>
    return -1;
80106afc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b01:	eb 0f                	jmp    80106b12 <sys_sem_signal+0x31>
  return sem_signal(num);
80106b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b06:	83 ec 0c             	sub    $0xc,%esp
80106b09:	50                   	push   %eax
80106b0a:	e8 11 24 00 00       	call   80108f20 <sem_signal>
80106b0f:	83 c4 10             	add    $0x10,%esp
}
80106b12:	c9                   	leave  
80106b13:	c3                   	ret    

80106b14 <sys_clone>:

int
sys_clone(void)
{
80106b14:	55                   	push   %ebp
80106b15:	89 e5                	mov    %esp,%ebp
80106b17:	83 ec 18             	sub    $0x18,%esp
  int function, arg, stack;
  if(argint(0, &function) < 0)
80106b1a:	83 ec 08             	sub    $0x8,%esp
80106b1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b20:	50                   	push   %eax
80106b21:	6a 00                	push   $0x0
80106b23:	e8 83 ee ff ff       	call   801059ab <argint>
80106b28:	83 c4 10             	add    $0x10,%esp
80106b2b:	85 c0                	test   %eax,%eax
80106b2d:	79 07                	jns    80106b36 <sys_clone+0x22>
    return -1;
80106b2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b34:	eb 53                	jmp    80106b89 <sys_clone+0x75>
  if(argint(1, &arg) < 0)
80106b36:	83 ec 08             	sub    $0x8,%esp
80106b39:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b3c:	50                   	push   %eax
80106b3d:	6a 01                	push   $0x1
80106b3f:	e8 67 ee ff ff       	call   801059ab <argint>
80106b44:	83 c4 10             	add    $0x10,%esp
80106b47:	85 c0                	test   %eax,%eax
80106b49:	79 07                	jns    80106b52 <sys_clone+0x3e>
    return -1;
80106b4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b50:	eb 37                	jmp    80106b89 <sys_clone+0x75>
  if(argint(2, &stack) < 0)
80106b52:	83 ec 08             	sub    $0x8,%esp
80106b55:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b58:	50                   	push   %eax
80106b59:	6a 02                	push   $0x2
80106b5b:	e8 4b ee ff ff       	call   801059ab <argint>
80106b60:	83 c4 10             	add    $0x10,%esp
80106b63:	85 c0                	test   %eax,%eax
80106b65:	79 07                	jns    80106b6e <sys_clone+0x5a>
    return -1;
80106b67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b6c:	eb 1b                	jmp    80106b89 <sys_clone+0x75>
  return clone((void*)function, (void*)arg, (void*)stack);
80106b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b71:	89 c1                	mov    %eax,%ecx
80106b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b76:	89 c2                	mov    %eax,%edx
80106b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b7b:	83 ec 04             	sub    $0x4,%esp
80106b7e:	51                   	push   %ecx
80106b7f:	52                   	push   %edx
80106b80:	50                   	push   %eax
80106b81:	e8 ff e3 ff ff       	call   80104f85 <clone>
80106b86:	83 c4 10             	add    $0x10,%esp
}
80106b89:	c9                   	leave  
80106b8a:	c3                   	ret    

80106b8b <sys_join>:

int
sys_join(void)
{
80106b8b:	55                   	push   %ebp
80106b8c:	89 e5                	mov    %esp,%ebp
80106b8e:	83 ec 18             	sub    $0x18,%esp
  int stack;
  if(argint(0, &stack) < 0)
80106b91:	83 ec 08             	sub    $0x8,%esp
80106b94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b97:	50                   	push   %eax
80106b98:	6a 00                	push   $0x0
80106b9a:	e8 0c ee ff ff       	call   801059ab <argint>
80106b9f:	83 c4 10             	add    $0x10,%esp
80106ba2:	85 c0                	test   %eax,%eax
80106ba4:	79 07                	jns    80106bad <sys_join+0x22>
    return -1;
80106ba6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bab:	eb 0f                	jmp    80106bbc <sys_join+0x31>
  return join((void**)stack);
80106bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bb0:	83 ec 0c             	sub    $0xc,%esp
80106bb3:	50                   	push   %eax
80106bb4:	e8 95 e5 ff ff       	call   8010514e <join>
80106bb9:	83 c4 10             	add    $0x10,%esp
}
80106bbc:	c9                   	leave  
80106bbd:	c3                   	ret    

80106bbe <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106bbe:	55                   	push   %ebp
80106bbf:	89 e5                	mov    %esp,%ebp
80106bc1:	83 ec 08             	sub    $0x8,%esp
80106bc4:	8b 55 08             	mov    0x8(%ebp),%edx
80106bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bca:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106bce:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106bd1:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106bd5:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106bd9:	ee                   	out    %al,(%dx)
}
80106bda:	90                   	nop
80106bdb:	c9                   	leave  
80106bdc:	c3                   	ret    

80106bdd <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106bdd:	55                   	push   %ebp
80106bde:	89 e5                	mov    %esp,%ebp
80106be0:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106be3:	6a 34                	push   $0x34
80106be5:	6a 43                	push   $0x43
80106be7:	e8 d2 ff ff ff       	call   80106bbe <outb>
80106bec:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106bef:	68 9c 00 00 00       	push   $0x9c
80106bf4:	6a 40                	push   $0x40
80106bf6:	e8 c3 ff ff ff       	call   80106bbe <outb>
80106bfb:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106bfe:	6a 2e                	push   $0x2e
80106c00:	6a 40                	push   $0x40
80106c02:	e8 b7 ff ff ff       	call   80106bbe <outb>
80106c07:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106c0a:	83 ec 0c             	sub    $0xc,%esp
80106c0d:	6a 00                	push   $0x0
80106c0f:	e8 68 d2 ff ff       	call   80103e7c <picenable>
80106c14:	83 c4 10             	add    $0x10,%esp
}
80106c17:	90                   	nop
80106c18:	c9                   	leave  
80106c19:	c3                   	ret    

80106c1a <alltraps>:
80106c1a:	1e                   	push   %ds
80106c1b:	06                   	push   %es
80106c1c:	0f a0                	push   %fs
80106c1e:	0f a8                	push   %gs
80106c20:	60                   	pusha  
80106c21:	66 b8 10 00          	mov    $0x10,%ax
80106c25:	8e d8                	mov    %eax,%ds
80106c27:	8e c0                	mov    %eax,%es
80106c29:	66 b8 18 00          	mov    $0x18,%ax
80106c2d:	8e e0                	mov    %eax,%fs
80106c2f:	8e e8                	mov    %eax,%gs
80106c31:	54                   	push   %esp
80106c32:	e8 d7 01 00 00       	call   80106e0e <trap>
80106c37:	83 c4 04             	add    $0x4,%esp

80106c3a <trapret>:
80106c3a:	61                   	popa   
80106c3b:	0f a9                	pop    %gs
80106c3d:	0f a1                	pop    %fs
80106c3f:	07                   	pop    %es
80106c40:	1f                   	pop    %ds
80106c41:	83 c4 08             	add    $0x8,%esp
80106c44:	cf                   	iret   

80106c45 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106c45:	55                   	push   %ebp
80106c46:	89 e5                	mov    %esp,%ebp
80106c48:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c4e:	83 e8 01             	sub    $0x1,%eax
80106c51:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106c55:	8b 45 08             	mov    0x8(%ebp),%eax
80106c58:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106c5c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c5f:	c1 e8 10             	shr    $0x10,%eax
80106c62:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106c66:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106c69:	0f 01 18             	lidtl  (%eax)
}
80106c6c:	90                   	nop
80106c6d:	c9                   	leave  
80106c6e:	c3                   	ret    

80106c6f <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106c6f:	55                   	push   %ebp
80106c70:	89 e5                	mov    %esp,%ebp
80106c72:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106c75:	0f 20 d0             	mov    %cr2,%eax
80106c78:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106c7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106c7e:	c9                   	leave  
80106c7f:	c3                   	ret    

80106c80 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106c86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106c8d:	e9 c3 00 00 00       	jmp    80106d55 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c95:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
80106c9c:	89 c2                	mov    %eax,%edx
80106c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ca1:	66 89 14 c5 00 5b 11 	mov    %dx,-0x7feea500(,%eax,8)
80106ca8:	80 
80106ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cac:	66 c7 04 c5 02 5b 11 	movw   $0x8,-0x7feea4fe(,%eax,8)
80106cb3:	80 08 00 
80106cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cb9:	0f b6 14 c5 04 5b 11 	movzbl -0x7feea4fc(,%eax,8),%edx
80106cc0:	80 
80106cc1:	83 e2 e0             	and    $0xffffffe0,%edx
80106cc4:	88 14 c5 04 5b 11 80 	mov    %dl,-0x7feea4fc(,%eax,8)
80106ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cce:	0f b6 14 c5 04 5b 11 	movzbl -0x7feea4fc(,%eax,8),%edx
80106cd5:	80 
80106cd6:	83 e2 1f             	and    $0x1f,%edx
80106cd9:	88 14 c5 04 5b 11 80 	mov    %dl,-0x7feea4fc(,%eax,8)
80106ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ce3:	0f b6 14 c5 05 5b 11 	movzbl -0x7feea4fb(,%eax,8),%edx
80106cea:	80 
80106ceb:	83 e2 f0             	and    $0xfffffff0,%edx
80106cee:	83 ca 0e             	or     $0xe,%edx
80106cf1:	88 14 c5 05 5b 11 80 	mov    %dl,-0x7feea4fb(,%eax,8)
80106cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cfb:	0f b6 14 c5 05 5b 11 	movzbl -0x7feea4fb(,%eax,8),%edx
80106d02:	80 
80106d03:	83 e2 ef             	and    $0xffffffef,%edx
80106d06:	88 14 c5 05 5b 11 80 	mov    %dl,-0x7feea4fb(,%eax,8)
80106d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d10:	0f b6 14 c5 05 5b 11 	movzbl -0x7feea4fb(,%eax,8),%edx
80106d17:	80 
80106d18:	83 e2 9f             	and    $0xffffff9f,%edx
80106d1b:	88 14 c5 05 5b 11 80 	mov    %dl,-0x7feea4fb(,%eax,8)
80106d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d25:	0f b6 14 c5 05 5b 11 	movzbl -0x7feea4fb(,%eax,8),%edx
80106d2c:	80 
80106d2d:	83 ca 80             	or     $0xffffff80,%edx
80106d30:	88 14 c5 05 5b 11 80 	mov    %dl,-0x7feea4fb(,%eax,8)
80106d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d3a:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
80106d41:	c1 e8 10             	shr    $0x10,%eax
80106d44:	89 c2                	mov    %eax,%edx
80106d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d49:	66 89 14 c5 06 5b 11 	mov    %dx,-0x7feea4fa(,%eax,8)
80106d50:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106d51:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106d55:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106d5c:	0f 8e 30 ff ff ff    	jle    80106c92 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106d62:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
80106d67:	66 a3 00 5d 11 80    	mov    %ax,0x80115d00
80106d6d:	66 c7 05 02 5d 11 80 	movw   $0x8,0x80115d02
80106d74:	08 00 
80106d76:	0f b6 05 04 5d 11 80 	movzbl 0x80115d04,%eax
80106d7d:	83 e0 e0             	and    $0xffffffe0,%eax
80106d80:	a2 04 5d 11 80       	mov    %al,0x80115d04
80106d85:	0f b6 05 04 5d 11 80 	movzbl 0x80115d04,%eax
80106d8c:	83 e0 1f             	and    $0x1f,%eax
80106d8f:	a2 04 5d 11 80       	mov    %al,0x80115d04
80106d94:	0f b6 05 05 5d 11 80 	movzbl 0x80115d05,%eax
80106d9b:	83 c8 0f             	or     $0xf,%eax
80106d9e:	a2 05 5d 11 80       	mov    %al,0x80115d05
80106da3:	0f b6 05 05 5d 11 80 	movzbl 0x80115d05,%eax
80106daa:	83 e0 ef             	and    $0xffffffef,%eax
80106dad:	a2 05 5d 11 80       	mov    %al,0x80115d05
80106db2:	0f b6 05 05 5d 11 80 	movzbl 0x80115d05,%eax
80106db9:	83 c8 60             	or     $0x60,%eax
80106dbc:	a2 05 5d 11 80       	mov    %al,0x80115d05
80106dc1:	0f b6 05 05 5d 11 80 	movzbl 0x80115d05,%eax
80106dc8:	83 c8 80             	or     $0xffffff80,%eax
80106dcb:	a2 05 5d 11 80       	mov    %al,0x80115d05
80106dd0:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
80106dd5:	c1 e8 10             	shr    $0x10,%eax
80106dd8:	66 a3 06 5d 11 80    	mov    %ax,0x80115d06
  
  initlock(&tickslock, "time");
80106dde:	83 ec 08             	sub    $0x8,%esp
80106de1:	68 54 95 10 80       	push   $0x80109554
80106de6:	68 c0 5a 11 80       	push   $0x80115ac0
80106deb:	e8 11 e6 ff ff       	call   80105401 <initlock>
80106df0:	83 c4 10             	add    $0x10,%esp
}
80106df3:	90                   	nop
80106df4:	c9                   	leave  
80106df5:	c3                   	ret    

80106df6 <idtinit>:

void
idtinit(void)
{
80106df6:	55                   	push   %ebp
80106df7:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106df9:	68 00 08 00 00       	push   $0x800
80106dfe:	68 00 5b 11 80       	push   $0x80115b00
80106e03:	e8 3d fe ff ff       	call   80106c45 <lidt>
80106e08:	83 c4 08             	add    $0x8,%esp
}
80106e0b:	90                   	nop
80106e0c:	c9                   	leave  
80106e0d:	c3                   	ret    

80106e0e <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106e0e:	55                   	push   %ebp
80106e0f:	89 e5                	mov    %esp,%ebp
80106e11:	57                   	push   %edi
80106e12:	56                   	push   %esi
80106e13:	53                   	push   %ebx
80106e14:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106e17:	8b 45 08             	mov    0x8(%ebp),%eax
80106e1a:	8b 40 30             	mov    0x30(%eax),%eax
80106e1d:	83 f8 40             	cmp    $0x40,%eax
80106e20:	75 3e                	jne    80106e60 <trap+0x52>
    if(proc->killed)
80106e22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e28:	8b 40 24             	mov    0x24(%eax),%eax
80106e2b:	85 c0                	test   %eax,%eax
80106e2d:	74 05                	je     80106e34 <trap+0x26>
      exit();
80106e2f:	e8 e8 d9 ff ff       	call   8010481c <exit>
    proc->tf = tf;
80106e34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e3a:	8b 55 08             	mov    0x8(%ebp),%edx
80106e3d:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106e40:	e8 1c ec ff ff       	call   80105a61 <syscall>
    if(proc->killed)
80106e45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e4b:	8b 40 24             	mov    0x24(%eax),%eax
80106e4e:	85 c0                	test   %eax,%eax
80106e50:	0f 84 1b 02 00 00    	je     80107071 <trap+0x263>
      exit();
80106e56:	e8 c1 d9 ff ff       	call   8010481c <exit>
    return;
80106e5b:	e9 11 02 00 00       	jmp    80107071 <trap+0x263>
  }

  switch(tf->trapno){
80106e60:	8b 45 08             	mov    0x8(%ebp),%eax
80106e63:	8b 40 30             	mov    0x30(%eax),%eax
80106e66:	83 e8 20             	sub    $0x20,%eax
80106e69:	83 f8 1f             	cmp    $0x1f,%eax
80106e6c:	0f 87 c0 00 00 00    	ja     80106f32 <trap+0x124>
80106e72:	8b 04 85 fc 95 10 80 	mov    -0x7fef6a04(,%eax,4),%eax
80106e79:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106e7b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e81:	0f b6 00             	movzbl (%eax),%eax
80106e84:	84 c0                	test   %al,%al
80106e86:	75 3d                	jne    80106ec5 <trap+0xb7>
      acquire(&tickslock);
80106e88:	83 ec 0c             	sub    $0xc,%esp
80106e8b:	68 c0 5a 11 80       	push   $0x80115ac0
80106e90:	e8 8e e5 ff ff       	call   80105423 <acquire>
80106e95:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106e98:	a1 00 63 11 80       	mov    0x80116300,%eax
80106e9d:	83 c0 01             	add    $0x1,%eax
80106ea0:	a3 00 63 11 80       	mov    %eax,0x80116300
      wakeup(&ticks);
80106ea5:	83 ec 0c             	sub    $0xc,%esp
80106ea8:	68 00 63 11 80       	push   $0x80116300
80106ead:	e8 bb de ff ff       	call   80104d6d <wakeup>
80106eb2:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106eb5:	83 ec 0c             	sub    $0xc,%esp
80106eb8:	68 c0 5a 11 80       	push   $0x80115ac0
80106ebd:	e8 c8 e5 ff ff       	call   8010548a <release>
80106ec2:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106ec5:	e8 ba c0 ff ff       	call   80102f84 <lapiceoi>
    break;
80106eca:	e9 1c 01 00 00       	jmp    80106feb <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106ecf:	e8 c3 b8 ff ff       	call   80102797 <ideintr>
    lapiceoi();
80106ed4:	e8 ab c0 ff ff       	call   80102f84 <lapiceoi>
    break;
80106ed9:	e9 0d 01 00 00       	jmp    80106feb <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106ede:	e8 a3 be ff ff       	call   80102d86 <kbdintr>
    lapiceoi();
80106ee3:	e8 9c c0 ff ff       	call   80102f84 <lapiceoi>
    break;
80106ee8:	e9 fe 00 00 00       	jmp    80106feb <trap+0x1dd>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106eed:	e8 60 03 00 00       	call   80107252 <uartintr>
    lapiceoi();
80106ef2:	e8 8d c0 ff ff       	call   80102f84 <lapiceoi>
    break;
80106ef7:	e9 ef 00 00 00       	jmp    80106feb <trap+0x1dd>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106efc:	8b 45 08             	mov    0x8(%ebp),%eax
80106eff:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106f02:	8b 45 08             	mov    0x8(%ebp),%eax
80106f05:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106f09:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106f0c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106f12:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106f15:	0f b6 c0             	movzbl %al,%eax
80106f18:	51                   	push   %ecx
80106f19:	52                   	push   %edx
80106f1a:	50                   	push   %eax
80106f1b:	68 5c 95 10 80       	push   $0x8010955c
80106f20:	e8 a1 94 ff ff       	call   801003c6 <cprintf>
80106f25:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106f28:	e8 57 c0 ff ff       	call   80102f84 <lapiceoi>
    break;
80106f2d:	e9 b9 00 00 00       	jmp    80106feb <trap+0x1dd>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106f32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f38:	85 c0                	test   %eax,%eax
80106f3a:	74 11                	je     80106f4d <trap+0x13f>
80106f3c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f3f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106f43:	0f b7 c0             	movzwl %ax,%eax
80106f46:	83 e0 03             	and    $0x3,%eax
80106f49:	85 c0                	test   %eax,%eax
80106f4b:	75 40                	jne    80106f8d <trap+0x17f>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106f4d:	e8 1d fd ff ff       	call   80106c6f <rcr2>
80106f52:	89 c3                	mov    %eax,%ebx
80106f54:	8b 45 08             	mov    0x8(%ebp),%eax
80106f57:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106f5a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106f60:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106f63:	0f b6 d0             	movzbl %al,%edx
80106f66:	8b 45 08             	mov    0x8(%ebp),%eax
80106f69:	8b 40 30             	mov    0x30(%eax),%eax
80106f6c:	83 ec 0c             	sub    $0xc,%esp
80106f6f:	53                   	push   %ebx
80106f70:	51                   	push   %ecx
80106f71:	52                   	push   %edx
80106f72:	50                   	push   %eax
80106f73:	68 80 95 10 80       	push   $0x80109580
80106f78:	e8 49 94 ff ff       	call   801003c6 <cprintf>
80106f7d:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106f80:	83 ec 0c             	sub    $0xc,%esp
80106f83:	68 b2 95 10 80       	push   $0x801095b2
80106f88:	e8 d9 95 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f8d:	e8 dd fc ff ff       	call   80106c6f <rcr2>
80106f92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f95:	8b 45 08             	mov    0x8(%ebp),%eax
80106f98:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106f9b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106fa1:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106fa4:	0f b6 d8             	movzbl %al,%ebx
80106fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80106faa:	8b 48 34             	mov    0x34(%eax),%ecx
80106fad:	8b 45 08             	mov    0x8(%ebp),%eax
80106fb0:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106fb3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fb9:	8d 78 6c             	lea    0x6c(%eax),%edi
80106fbc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106fc2:	8b 40 10             	mov    0x10(%eax),%eax
80106fc5:	ff 75 e4             	pushl  -0x1c(%ebp)
80106fc8:	56                   	push   %esi
80106fc9:	53                   	push   %ebx
80106fca:	51                   	push   %ecx
80106fcb:	52                   	push   %edx
80106fcc:	57                   	push   %edi
80106fcd:	50                   	push   %eax
80106fce:	68 b8 95 10 80       	push   $0x801095b8
80106fd3:	e8 ee 93 ff ff       	call   801003c6 <cprintf>
80106fd8:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106fdb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fe1:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106fe8:	eb 01                	jmp    80106feb <trap+0x1dd>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106fea:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106feb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ff1:	85 c0                	test   %eax,%eax
80106ff3:	74 24                	je     80107019 <trap+0x20b>
80106ff5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ffb:	8b 40 24             	mov    0x24(%eax),%eax
80106ffe:	85 c0                	test   %eax,%eax
80107000:	74 17                	je     80107019 <trap+0x20b>
80107002:	8b 45 08             	mov    0x8(%ebp),%eax
80107005:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107009:	0f b7 c0             	movzwl %ax,%eax
8010700c:	83 e0 03             	and    $0x3,%eax
8010700f:	83 f8 03             	cmp    $0x3,%eax
80107012:	75 05                	jne    80107019 <trap+0x20b>
    exit();
80107014:	e8 03 d8 ff ff       	call   8010481c <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80107019:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010701f:	85 c0                	test   %eax,%eax
80107021:	74 1e                	je     80107041 <trap+0x233>
80107023:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107029:	8b 40 0c             	mov    0xc(%eax),%eax
8010702c:	83 f8 04             	cmp    $0x4,%eax
8010702f:	75 10                	jne    80107041 <trap+0x233>
80107031:	8b 45 08             	mov    0x8(%ebp),%eax
80107034:	8b 40 30             	mov    0x30(%eax),%eax
80107037:	83 f8 20             	cmp    $0x20,%eax
8010703a:	75 05                	jne    80107041 <trap+0x233>
    yield();
8010703c:	e8 d2 db ff ff       	call   80104c13 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107041:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107047:	85 c0                	test   %eax,%eax
80107049:	74 27                	je     80107072 <trap+0x264>
8010704b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107051:	8b 40 24             	mov    0x24(%eax),%eax
80107054:	85 c0                	test   %eax,%eax
80107056:	74 1a                	je     80107072 <trap+0x264>
80107058:	8b 45 08             	mov    0x8(%ebp),%eax
8010705b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010705f:	0f b7 c0             	movzwl %ax,%eax
80107062:	83 e0 03             	and    $0x3,%eax
80107065:	83 f8 03             	cmp    $0x3,%eax
80107068:	75 08                	jne    80107072 <trap+0x264>
    exit();
8010706a:	e8 ad d7 ff ff       	call   8010481c <exit>
8010706f:	eb 01                	jmp    80107072 <trap+0x264>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80107071:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107072:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107075:	5b                   	pop    %ebx
80107076:	5e                   	pop    %esi
80107077:	5f                   	pop    %edi
80107078:	5d                   	pop    %ebp
80107079:	c3                   	ret    

8010707a <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010707a:	55                   	push   %ebp
8010707b:	89 e5                	mov    %esp,%ebp
8010707d:	83 ec 14             	sub    $0x14,%esp
80107080:	8b 45 08             	mov    0x8(%ebp),%eax
80107083:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107087:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010708b:	89 c2                	mov    %eax,%edx
8010708d:	ec                   	in     (%dx),%al
8010708e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107091:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107095:	c9                   	leave  
80107096:	c3                   	ret    

80107097 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107097:	55                   	push   %ebp
80107098:	89 e5                	mov    %esp,%ebp
8010709a:	83 ec 08             	sub    $0x8,%esp
8010709d:	8b 55 08             	mov    0x8(%ebp),%edx
801070a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801070a3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801070a7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801070aa:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801070ae:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801070b2:	ee                   	out    %al,(%dx)
}
801070b3:	90                   	nop
801070b4:	c9                   	leave  
801070b5:	c3                   	ret    

801070b6 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801070b6:	55                   	push   %ebp
801070b7:	89 e5                	mov    %esp,%ebp
801070b9:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801070bc:	6a 00                	push   $0x0
801070be:	68 fa 03 00 00       	push   $0x3fa
801070c3:	e8 cf ff ff ff       	call   80107097 <outb>
801070c8:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801070cb:	68 80 00 00 00       	push   $0x80
801070d0:	68 fb 03 00 00       	push   $0x3fb
801070d5:	e8 bd ff ff ff       	call   80107097 <outb>
801070da:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801070dd:	6a 0c                	push   $0xc
801070df:	68 f8 03 00 00       	push   $0x3f8
801070e4:	e8 ae ff ff ff       	call   80107097 <outb>
801070e9:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801070ec:	6a 00                	push   $0x0
801070ee:	68 f9 03 00 00       	push   $0x3f9
801070f3:	e8 9f ff ff ff       	call   80107097 <outb>
801070f8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801070fb:	6a 03                	push   $0x3
801070fd:	68 fb 03 00 00       	push   $0x3fb
80107102:	e8 90 ff ff ff       	call   80107097 <outb>
80107107:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
8010710a:	6a 00                	push   $0x0
8010710c:	68 fc 03 00 00       	push   $0x3fc
80107111:	e8 81 ff ff ff       	call   80107097 <outb>
80107116:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107119:	6a 01                	push   $0x1
8010711b:	68 f9 03 00 00       	push   $0x3f9
80107120:	e8 72 ff ff ff       	call   80107097 <outb>
80107125:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107128:	68 fd 03 00 00       	push   $0x3fd
8010712d:	e8 48 ff ff ff       	call   8010707a <inb>
80107132:	83 c4 04             	add    $0x4,%esp
80107135:	3c ff                	cmp    $0xff,%al
80107137:	74 6e                	je     801071a7 <uartinit+0xf1>
    return;
  uart = 1;
80107139:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80107140:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107143:	68 fa 03 00 00       	push   $0x3fa
80107148:	e8 2d ff ff ff       	call   8010707a <inb>
8010714d:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107150:	68 f8 03 00 00       	push   $0x3f8
80107155:	e8 20 ff ff ff       	call   8010707a <inb>
8010715a:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
8010715d:	83 ec 0c             	sub    $0xc,%esp
80107160:	6a 04                	push   $0x4
80107162:	e8 15 cd ff ff       	call   80103e7c <picenable>
80107167:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
8010716a:	83 ec 08             	sub    $0x8,%esp
8010716d:	6a 00                	push   $0x0
8010716f:	6a 04                	push   $0x4
80107171:	e8 c3 b8 ff ff       	call   80102a39 <ioapicenable>
80107176:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107179:	c7 45 f4 7c 96 10 80 	movl   $0x8010967c,-0xc(%ebp)
80107180:	eb 19                	jmp    8010719b <uartinit+0xe5>
    uartputc(*p);
80107182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107185:	0f b6 00             	movzbl (%eax),%eax
80107188:	0f be c0             	movsbl %al,%eax
8010718b:	83 ec 0c             	sub    $0xc,%esp
8010718e:	50                   	push   %eax
8010718f:	e8 16 00 00 00       	call   801071aa <uartputc>
80107194:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107197:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010719b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010719e:	0f b6 00             	movzbl (%eax),%eax
801071a1:	84 c0                	test   %al,%al
801071a3:	75 dd                	jne    80107182 <uartinit+0xcc>
801071a5:	eb 01                	jmp    801071a8 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
801071a7:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
801071a8:	c9                   	leave  
801071a9:	c3                   	ret    

801071aa <uartputc>:

void
uartputc(int c)
{
801071aa:	55                   	push   %ebp
801071ab:	89 e5                	mov    %esp,%ebp
801071ad:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801071b0:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801071b5:	85 c0                	test   %eax,%eax
801071b7:	74 53                	je     8010720c <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801071b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801071c0:	eb 11                	jmp    801071d3 <uartputc+0x29>
    microdelay(10);
801071c2:	83 ec 0c             	sub    $0xc,%esp
801071c5:	6a 0a                	push   $0xa
801071c7:	e8 d3 bd ff ff       	call   80102f9f <microdelay>
801071cc:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801071cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801071d3:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801071d7:	7f 1a                	jg     801071f3 <uartputc+0x49>
801071d9:	83 ec 0c             	sub    $0xc,%esp
801071dc:	68 fd 03 00 00       	push   $0x3fd
801071e1:	e8 94 fe ff ff       	call   8010707a <inb>
801071e6:	83 c4 10             	add    $0x10,%esp
801071e9:	0f b6 c0             	movzbl %al,%eax
801071ec:	83 e0 20             	and    $0x20,%eax
801071ef:	85 c0                	test   %eax,%eax
801071f1:	74 cf                	je     801071c2 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801071f3:	8b 45 08             	mov    0x8(%ebp),%eax
801071f6:	0f b6 c0             	movzbl %al,%eax
801071f9:	83 ec 08             	sub    $0x8,%esp
801071fc:	50                   	push   %eax
801071fd:	68 f8 03 00 00       	push   $0x3f8
80107202:	e8 90 fe ff ff       	call   80107097 <outb>
80107207:	83 c4 10             	add    $0x10,%esp
8010720a:	eb 01                	jmp    8010720d <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
8010720c:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
8010720d:	c9                   	leave  
8010720e:	c3                   	ret    

8010720f <uartgetc>:

static int
uartgetc(void)
{
8010720f:	55                   	push   %ebp
80107210:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107212:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107217:	85 c0                	test   %eax,%eax
80107219:	75 07                	jne    80107222 <uartgetc+0x13>
    return -1;
8010721b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107220:	eb 2e                	jmp    80107250 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80107222:	68 fd 03 00 00       	push   $0x3fd
80107227:	e8 4e fe ff ff       	call   8010707a <inb>
8010722c:	83 c4 04             	add    $0x4,%esp
8010722f:	0f b6 c0             	movzbl %al,%eax
80107232:	83 e0 01             	and    $0x1,%eax
80107235:	85 c0                	test   %eax,%eax
80107237:	75 07                	jne    80107240 <uartgetc+0x31>
    return -1;
80107239:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010723e:	eb 10                	jmp    80107250 <uartgetc+0x41>
  return inb(COM1+0);
80107240:	68 f8 03 00 00       	push   $0x3f8
80107245:	e8 30 fe ff ff       	call   8010707a <inb>
8010724a:	83 c4 04             	add    $0x4,%esp
8010724d:	0f b6 c0             	movzbl %al,%eax
}
80107250:	c9                   	leave  
80107251:	c3                   	ret    

80107252 <uartintr>:

void
uartintr(void)
{
80107252:	55                   	push   %ebp
80107253:	89 e5                	mov    %esp,%ebp
80107255:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107258:	83 ec 0c             	sub    $0xc,%esp
8010725b:	68 0f 72 10 80       	push   $0x8010720f
80107260:	e8 78 95 ff ff       	call   801007dd <consoleintr>
80107265:	83 c4 10             	add    $0x10,%esp
}
80107268:	90                   	nop
80107269:	c9                   	leave  
8010726a:	c3                   	ret    

8010726b <vector0>:
8010726b:	6a 00                	push   $0x0
8010726d:	6a 00                	push   $0x0
8010726f:	e9 a6 f9 ff ff       	jmp    80106c1a <alltraps>

80107274 <vector1>:
80107274:	6a 00                	push   $0x0
80107276:	6a 01                	push   $0x1
80107278:	e9 9d f9 ff ff       	jmp    80106c1a <alltraps>

8010727d <vector2>:
8010727d:	6a 00                	push   $0x0
8010727f:	6a 02                	push   $0x2
80107281:	e9 94 f9 ff ff       	jmp    80106c1a <alltraps>

80107286 <vector3>:
80107286:	6a 00                	push   $0x0
80107288:	6a 03                	push   $0x3
8010728a:	e9 8b f9 ff ff       	jmp    80106c1a <alltraps>

8010728f <vector4>:
8010728f:	6a 00                	push   $0x0
80107291:	6a 04                	push   $0x4
80107293:	e9 82 f9 ff ff       	jmp    80106c1a <alltraps>

80107298 <vector5>:
80107298:	6a 00                	push   $0x0
8010729a:	6a 05                	push   $0x5
8010729c:	e9 79 f9 ff ff       	jmp    80106c1a <alltraps>

801072a1 <vector6>:
801072a1:	6a 00                	push   $0x0
801072a3:	6a 06                	push   $0x6
801072a5:	e9 70 f9 ff ff       	jmp    80106c1a <alltraps>

801072aa <vector7>:
801072aa:	6a 00                	push   $0x0
801072ac:	6a 07                	push   $0x7
801072ae:	e9 67 f9 ff ff       	jmp    80106c1a <alltraps>

801072b3 <vector8>:
801072b3:	6a 08                	push   $0x8
801072b5:	e9 60 f9 ff ff       	jmp    80106c1a <alltraps>

801072ba <vector9>:
801072ba:	6a 00                	push   $0x0
801072bc:	6a 09                	push   $0x9
801072be:	e9 57 f9 ff ff       	jmp    80106c1a <alltraps>

801072c3 <vector10>:
801072c3:	6a 0a                	push   $0xa
801072c5:	e9 50 f9 ff ff       	jmp    80106c1a <alltraps>

801072ca <vector11>:
801072ca:	6a 0b                	push   $0xb
801072cc:	e9 49 f9 ff ff       	jmp    80106c1a <alltraps>

801072d1 <vector12>:
801072d1:	6a 0c                	push   $0xc
801072d3:	e9 42 f9 ff ff       	jmp    80106c1a <alltraps>

801072d8 <vector13>:
801072d8:	6a 0d                	push   $0xd
801072da:	e9 3b f9 ff ff       	jmp    80106c1a <alltraps>

801072df <vector14>:
801072df:	6a 0e                	push   $0xe
801072e1:	e9 34 f9 ff ff       	jmp    80106c1a <alltraps>

801072e6 <vector15>:
801072e6:	6a 00                	push   $0x0
801072e8:	6a 0f                	push   $0xf
801072ea:	e9 2b f9 ff ff       	jmp    80106c1a <alltraps>

801072ef <vector16>:
801072ef:	6a 00                	push   $0x0
801072f1:	6a 10                	push   $0x10
801072f3:	e9 22 f9 ff ff       	jmp    80106c1a <alltraps>

801072f8 <vector17>:
801072f8:	6a 11                	push   $0x11
801072fa:	e9 1b f9 ff ff       	jmp    80106c1a <alltraps>

801072ff <vector18>:
801072ff:	6a 00                	push   $0x0
80107301:	6a 12                	push   $0x12
80107303:	e9 12 f9 ff ff       	jmp    80106c1a <alltraps>

80107308 <vector19>:
80107308:	6a 00                	push   $0x0
8010730a:	6a 13                	push   $0x13
8010730c:	e9 09 f9 ff ff       	jmp    80106c1a <alltraps>

80107311 <vector20>:
80107311:	6a 00                	push   $0x0
80107313:	6a 14                	push   $0x14
80107315:	e9 00 f9 ff ff       	jmp    80106c1a <alltraps>

8010731a <vector21>:
8010731a:	6a 00                	push   $0x0
8010731c:	6a 15                	push   $0x15
8010731e:	e9 f7 f8 ff ff       	jmp    80106c1a <alltraps>

80107323 <vector22>:
80107323:	6a 00                	push   $0x0
80107325:	6a 16                	push   $0x16
80107327:	e9 ee f8 ff ff       	jmp    80106c1a <alltraps>

8010732c <vector23>:
8010732c:	6a 00                	push   $0x0
8010732e:	6a 17                	push   $0x17
80107330:	e9 e5 f8 ff ff       	jmp    80106c1a <alltraps>

80107335 <vector24>:
80107335:	6a 00                	push   $0x0
80107337:	6a 18                	push   $0x18
80107339:	e9 dc f8 ff ff       	jmp    80106c1a <alltraps>

8010733e <vector25>:
8010733e:	6a 00                	push   $0x0
80107340:	6a 19                	push   $0x19
80107342:	e9 d3 f8 ff ff       	jmp    80106c1a <alltraps>

80107347 <vector26>:
80107347:	6a 00                	push   $0x0
80107349:	6a 1a                	push   $0x1a
8010734b:	e9 ca f8 ff ff       	jmp    80106c1a <alltraps>

80107350 <vector27>:
80107350:	6a 00                	push   $0x0
80107352:	6a 1b                	push   $0x1b
80107354:	e9 c1 f8 ff ff       	jmp    80106c1a <alltraps>

80107359 <vector28>:
80107359:	6a 00                	push   $0x0
8010735b:	6a 1c                	push   $0x1c
8010735d:	e9 b8 f8 ff ff       	jmp    80106c1a <alltraps>

80107362 <vector29>:
80107362:	6a 00                	push   $0x0
80107364:	6a 1d                	push   $0x1d
80107366:	e9 af f8 ff ff       	jmp    80106c1a <alltraps>

8010736b <vector30>:
8010736b:	6a 00                	push   $0x0
8010736d:	6a 1e                	push   $0x1e
8010736f:	e9 a6 f8 ff ff       	jmp    80106c1a <alltraps>

80107374 <vector31>:
80107374:	6a 00                	push   $0x0
80107376:	6a 1f                	push   $0x1f
80107378:	e9 9d f8 ff ff       	jmp    80106c1a <alltraps>

8010737d <vector32>:
8010737d:	6a 00                	push   $0x0
8010737f:	6a 20                	push   $0x20
80107381:	e9 94 f8 ff ff       	jmp    80106c1a <alltraps>

80107386 <vector33>:
80107386:	6a 00                	push   $0x0
80107388:	6a 21                	push   $0x21
8010738a:	e9 8b f8 ff ff       	jmp    80106c1a <alltraps>

8010738f <vector34>:
8010738f:	6a 00                	push   $0x0
80107391:	6a 22                	push   $0x22
80107393:	e9 82 f8 ff ff       	jmp    80106c1a <alltraps>

80107398 <vector35>:
80107398:	6a 00                	push   $0x0
8010739a:	6a 23                	push   $0x23
8010739c:	e9 79 f8 ff ff       	jmp    80106c1a <alltraps>

801073a1 <vector36>:
801073a1:	6a 00                	push   $0x0
801073a3:	6a 24                	push   $0x24
801073a5:	e9 70 f8 ff ff       	jmp    80106c1a <alltraps>

801073aa <vector37>:
801073aa:	6a 00                	push   $0x0
801073ac:	6a 25                	push   $0x25
801073ae:	e9 67 f8 ff ff       	jmp    80106c1a <alltraps>

801073b3 <vector38>:
801073b3:	6a 00                	push   $0x0
801073b5:	6a 26                	push   $0x26
801073b7:	e9 5e f8 ff ff       	jmp    80106c1a <alltraps>

801073bc <vector39>:
801073bc:	6a 00                	push   $0x0
801073be:	6a 27                	push   $0x27
801073c0:	e9 55 f8 ff ff       	jmp    80106c1a <alltraps>

801073c5 <vector40>:
801073c5:	6a 00                	push   $0x0
801073c7:	6a 28                	push   $0x28
801073c9:	e9 4c f8 ff ff       	jmp    80106c1a <alltraps>

801073ce <vector41>:
801073ce:	6a 00                	push   $0x0
801073d0:	6a 29                	push   $0x29
801073d2:	e9 43 f8 ff ff       	jmp    80106c1a <alltraps>

801073d7 <vector42>:
801073d7:	6a 00                	push   $0x0
801073d9:	6a 2a                	push   $0x2a
801073db:	e9 3a f8 ff ff       	jmp    80106c1a <alltraps>

801073e0 <vector43>:
801073e0:	6a 00                	push   $0x0
801073e2:	6a 2b                	push   $0x2b
801073e4:	e9 31 f8 ff ff       	jmp    80106c1a <alltraps>

801073e9 <vector44>:
801073e9:	6a 00                	push   $0x0
801073eb:	6a 2c                	push   $0x2c
801073ed:	e9 28 f8 ff ff       	jmp    80106c1a <alltraps>

801073f2 <vector45>:
801073f2:	6a 00                	push   $0x0
801073f4:	6a 2d                	push   $0x2d
801073f6:	e9 1f f8 ff ff       	jmp    80106c1a <alltraps>

801073fb <vector46>:
801073fb:	6a 00                	push   $0x0
801073fd:	6a 2e                	push   $0x2e
801073ff:	e9 16 f8 ff ff       	jmp    80106c1a <alltraps>

80107404 <vector47>:
80107404:	6a 00                	push   $0x0
80107406:	6a 2f                	push   $0x2f
80107408:	e9 0d f8 ff ff       	jmp    80106c1a <alltraps>

8010740d <vector48>:
8010740d:	6a 00                	push   $0x0
8010740f:	6a 30                	push   $0x30
80107411:	e9 04 f8 ff ff       	jmp    80106c1a <alltraps>

80107416 <vector49>:
80107416:	6a 00                	push   $0x0
80107418:	6a 31                	push   $0x31
8010741a:	e9 fb f7 ff ff       	jmp    80106c1a <alltraps>

8010741f <vector50>:
8010741f:	6a 00                	push   $0x0
80107421:	6a 32                	push   $0x32
80107423:	e9 f2 f7 ff ff       	jmp    80106c1a <alltraps>

80107428 <vector51>:
80107428:	6a 00                	push   $0x0
8010742a:	6a 33                	push   $0x33
8010742c:	e9 e9 f7 ff ff       	jmp    80106c1a <alltraps>

80107431 <vector52>:
80107431:	6a 00                	push   $0x0
80107433:	6a 34                	push   $0x34
80107435:	e9 e0 f7 ff ff       	jmp    80106c1a <alltraps>

8010743a <vector53>:
8010743a:	6a 00                	push   $0x0
8010743c:	6a 35                	push   $0x35
8010743e:	e9 d7 f7 ff ff       	jmp    80106c1a <alltraps>

80107443 <vector54>:
80107443:	6a 00                	push   $0x0
80107445:	6a 36                	push   $0x36
80107447:	e9 ce f7 ff ff       	jmp    80106c1a <alltraps>

8010744c <vector55>:
8010744c:	6a 00                	push   $0x0
8010744e:	6a 37                	push   $0x37
80107450:	e9 c5 f7 ff ff       	jmp    80106c1a <alltraps>

80107455 <vector56>:
80107455:	6a 00                	push   $0x0
80107457:	6a 38                	push   $0x38
80107459:	e9 bc f7 ff ff       	jmp    80106c1a <alltraps>

8010745e <vector57>:
8010745e:	6a 00                	push   $0x0
80107460:	6a 39                	push   $0x39
80107462:	e9 b3 f7 ff ff       	jmp    80106c1a <alltraps>

80107467 <vector58>:
80107467:	6a 00                	push   $0x0
80107469:	6a 3a                	push   $0x3a
8010746b:	e9 aa f7 ff ff       	jmp    80106c1a <alltraps>

80107470 <vector59>:
80107470:	6a 00                	push   $0x0
80107472:	6a 3b                	push   $0x3b
80107474:	e9 a1 f7 ff ff       	jmp    80106c1a <alltraps>

80107479 <vector60>:
80107479:	6a 00                	push   $0x0
8010747b:	6a 3c                	push   $0x3c
8010747d:	e9 98 f7 ff ff       	jmp    80106c1a <alltraps>

80107482 <vector61>:
80107482:	6a 00                	push   $0x0
80107484:	6a 3d                	push   $0x3d
80107486:	e9 8f f7 ff ff       	jmp    80106c1a <alltraps>

8010748b <vector62>:
8010748b:	6a 00                	push   $0x0
8010748d:	6a 3e                	push   $0x3e
8010748f:	e9 86 f7 ff ff       	jmp    80106c1a <alltraps>

80107494 <vector63>:
80107494:	6a 00                	push   $0x0
80107496:	6a 3f                	push   $0x3f
80107498:	e9 7d f7 ff ff       	jmp    80106c1a <alltraps>

8010749d <vector64>:
8010749d:	6a 00                	push   $0x0
8010749f:	6a 40                	push   $0x40
801074a1:	e9 74 f7 ff ff       	jmp    80106c1a <alltraps>

801074a6 <vector65>:
801074a6:	6a 00                	push   $0x0
801074a8:	6a 41                	push   $0x41
801074aa:	e9 6b f7 ff ff       	jmp    80106c1a <alltraps>

801074af <vector66>:
801074af:	6a 00                	push   $0x0
801074b1:	6a 42                	push   $0x42
801074b3:	e9 62 f7 ff ff       	jmp    80106c1a <alltraps>

801074b8 <vector67>:
801074b8:	6a 00                	push   $0x0
801074ba:	6a 43                	push   $0x43
801074bc:	e9 59 f7 ff ff       	jmp    80106c1a <alltraps>

801074c1 <vector68>:
801074c1:	6a 00                	push   $0x0
801074c3:	6a 44                	push   $0x44
801074c5:	e9 50 f7 ff ff       	jmp    80106c1a <alltraps>

801074ca <vector69>:
801074ca:	6a 00                	push   $0x0
801074cc:	6a 45                	push   $0x45
801074ce:	e9 47 f7 ff ff       	jmp    80106c1a <alltraps>

801074d3 <vector70>:
801074d3:	6a 00                	push   $0x0
801074d5:	6a 46                	push   $0x46
801074d7:	e9 3e f7 ff ff       	jmp    80106c1a <alltraps>

801074dc <vector71>:
801074dc:	6a 00                	push   $0x0
801074de:	6a 47                	push   $0x47
801074e0:	e9 35 f7 ff ff       	jmp    80106c1a <alltraps>

801074e5 <vector72>:
801074e5:	6a 00                	push   $0x0
801074e7:	6a 48                	push   $0x48
801074e9:	e9 2c f7 ff ff       	jmp    80106c1a <alltraps>

801074ee <vector73>:
801074ee:	6a 00                	push   $0x0
801074f0:	6a 49                	push   $0x49
801074f2:	e9 23 f7 ff ff       	jmp    80106c1a <alltraps>

801074f7 <vector74>:
801074f7:	6a 00                	push   $0x0
801074f9:	6a 4a                	push   $0x4a
801074fb:	e9 1a f7 ff ff       	jmp    80106c1a <alltraps>

80107500 <vector75>:
80107500:	6a 00                	push   $0x0
80107502:	6a 4b                	push   $0x4b
80107504:	e9 11 f7 ff ff       	jmp    80106c1a <alltraps>

80107509 <vector76>:
80107509:	6a 00                	push   $0x0
8010750b:	6a 4c                	push   $0x4c
8010750d:	e9 08 f7 ff ff       	jmp    80106c1a <alltraps>

80107512 <vector77>:
80107512:	6a 00                	push   $0x0
80107514:	6a 4d                	push   $0x4d
80107516:	e9 ff f6 ff ff       	jmp    80106c1a <alltraps>

8010751b <vector78>:
8010751b:	6a 00                	push   $0x0
8010751d:	6a 4e                	push   $0x4e
8010751f:	e9 f6 f6 ff ff       	jmp    80106c1a <alltraps>

80107524 <vector79>:
80107524:	6a 00                	push   $0x0
80107526:	6a 4f                	push   $0x4f
80107528:	e9 ed f6 ff ff       	jmp    80106c1a <alltraps>

8010752d <vector80>:
8010752d:	6a 00                	push   $0x0
8010752f:	6a 50                	push   $0x50
80107531:	e9 e4 f6 ff ff       	jmp    80106c1a <alltraps>

80107536 <vector81>:
80107536:	6a 00                	push   $0x0
80107538:	6a 51                	push   $0x51
8010753a:	e9 db f6 ff ff       	jmp    80106c1a <alltraps>

8010753f <vector82>:
8010753f:	6a 00                	push   $0x0
80107541:	6a 52                	push   $0x52
80107543:	e9 d2 f6 ff ff       	jmp    80106c1a <alltraps>

80107548 <vector83>:
80107548:	6a 00                	push   $0x0
8010754a:	6a 53                	push   $0x53
8010754c:	e9 c9 f6 ff ff       	jmp    80106c1a <alltraps>

80107551 <vector84>:
80107551:	6a 00                	push   $0x0
80107553:	6a 54                	push   $0x54
80107555:	e9 c0 f6 ff ff       	jmp    80106c1a <alltraps>

8010755a <vector85>:
8010755a:	6a 00                	push   $0x0
8010755c:	6a 55                	push   $0x55
8010755e:	e9 b7 f6 ff ff       	jmp    80106c1a <alltraps>

80107563 <vector86>:
80107563:	6a 00                	push   $0x0
80107565:	6a 56                	push   $0x56
80107567:	e9 ae f6 ff ff       	jmp    80106c1a <alltraps>

8010756c <vector87>:
8010756c:	6a 00                	push   $0x0
8010756e:	6a 57                	push   $0x57
80107570:	e9 a5 f6 ff ff       	jmp    80106c1a <alltraps>

80107575 <vector88>:
80107575:	6a 00                	push   $0x0
80107577:	6a 58                	push   $0x58
80107579:	e9 9c f6 ff ff       	jmp    80106c1a <alltraps>

8010757e <vector89>:
8010757e:	6a 00                	push   $0x0
80107580:	6a 59                	push   $0x59
80107582:	e9 93 f6 ff ff       	jmp    80106c1a <alltraps>

80107587 <vector90>:
80107587:	6a 00                	push   $0x0
80107589:	6a 5a                	push   $0x5a
8010758b:	e9 8a f6 ff ff       	jmp    80106c1a <alltraps>

80107590 <vector91>:
80107590:	6a 00                	push   $0x0
80107592:	6a 5b                	push   $0x5b
80107594:	e9 81 f6 ff ff       	jmp    80106c1a <alltraps>

80107599 <vector92>:
80107599:	6a 00                	push   $0x0
8010759b:	6a 5c                	push   $0x5c
8010759d:	e9 78 f6 ff ff       	jmp    80106c1a <alltraps>

801075a2 <vector93>:
801075a2:	6a 00                	push   $0x0
801075a4:	6a 5d                	push   $0x5d
801075a6:	e9 6f f6 ff ff       	jmp    80106c1a <alltraps>

801075ab <vector94>:
801075ab:	6a 00                	push   $0x0
801075ad:	6a 5e                	push   $0x5e
801075af:	e9 66 f6 ff ff       	jmp    80106c1a <alltraps>

801075b4 <vector95>:
801075b4:	6a 00                	push   $0x0
801075b6:	6a 5f                	push   $0x5f
801075b8:	e9 5d f6 ff ff       	jmp    80106c1a <alltraps>

801075bd <vector96>:
801075bd:	6a 00                	push   $0x0
801075bf:	6a 60                	push   $0x60
801075c1:	e9 54 f6 ff ff       	jmp    80106c1a <alltraps>

801075c6 <vector97>:
801075c6:	6a 00                	push   $0x0
801075c8:	6a 61                	push   $0x61
801075ca:	e9 4b f6 ff ff       	jmp    80106c1a <alltraps>

801075cf <vector98>:
801075cf:	6a 00                	push   $0x0
801075d1:	6a 62                	push   $0x62
801075d3:	e9 42 f6 ff ff       	jmp    80106c1a <alltraps>

801075d8 <vector99>:
801075d8:	6a 00                	push   $0x0
801075da:	6a 63                	push   $0x63
801075dc:	e9 39 f6 ff ff       	jmp    80106c1a <alltraps>

801075e1 <vector100>:
801075e1:	6a 00                	push   $0x0
801075e3:	6a 64                	push   $0x64
801075e5:	e9 30 f6 ff ff       	jmp    80106c1a <alltraps>

801075ea <vector101>:
801075ea:	6a 00                	push   $0x0
801075ec:	6a 65                	push   $0x65
801075ee:	e9 27 f6 ff ff       	jmp    80106c1a <alltraps>

801075f3 <vector102>:
801075f3:	6a 00                	push   $0x0
801075f5:	6a 66                	push   $0x66
801075f7:	e9 1e f6 ff ff       	jmp    80106c1a <alltraps>

801075fc <vector103>:
801075fc:	6a 00                	push   $0x0
801075fe:	6a 67                	push   $0x67
80107600:	e9 15 f6 ff ff       	jmp    80106c1a <alltraps>

80107605 <vector104>:
80107605:	6a 00                	push   $0x0
80107607:	6a 68                	push   $0x68
80107609:	e9 0c f6 ff ff       	jmp    80106c1a <alltraps>

8010760e <vector105>:
8010760e:	6a 00                	push   $0x0
80107610:	6a 69                	push   $0x69
80107612:	e9 03 f6 ff ff       	jmp    80106c1a <alltraps>

80107617 <vector106>:
80107617:	6a 00                	push   $0x0
80107619:	6a 6a                	push   $0x6a
8010761b:	e9 fa f5 ff ff       	jmp    80106c1a <alltraps>

80107620 <vector107>:
80107620:	6a 00                	push   $0x0
80107622:	6a 6b                	push   $0x6b
80107624:	e9 f1 f5 ff ff       	jmp    80106c1a <alltraps>

80107629 <vector108>:
80107629:	6a 00                	push   $0x0
8010762b:	6a 6c                	push   $0x6c
8010762d:	e9 e8 f5 ff ff       	jmp    80106c1a <alltraps>

80107632 <vector109>:
80107632:	6a 00                	push   $0x0
80107634:	6a 6d                	push   $0x6d
80107636:	e9 df f5 ff ff       	jmp    80106c1a <alltraps>

8010763b <vector110>:
8010763b:	6a 00                	push   $0x0
8010763d:	6a 6e                	push   $0x6e
8010763f:	e9 d6 f5 ff ff       	jmp    80106c1a <alltraps>

80107644 <vector111>:
80107644:	6a 00                	push   $0x0
80107646:	6a 6f                	push   $0x6f
80107648:	e9 cd f5 ff ff       	jmp    80106c1a <alltraps>

8010764d <vector112>:
8010764d:	6a 00                	push   $0x0
8010764f:	6a 70                	push   $0x70
80107651:	e9 c4 f5 ff ff       	jmp    80106c1a <alltraps>

80107656 <vector113>:
80107656:	6a 00                	push   $0x0
80107658:	6a 71                	push   $0x71
8010765a:	e9 bb f5 ff ff       	jmp    80106c1a <alltraps>

8010765f <vector114>:
8010765f:	6a 00                	push   $0x0
80107661:	6a 72                	push   $0x72
80107663:	e9 b2 f5 ff ff       	jmp    80106c1a <alltraps>

80107668 <vector115>:
80107668:	6a 00                	push   $0x0
8010766a:	6a 73                	push   $0x73
8010766c:	e9 a9 f5 ff ff       	jmp    80106c1a <alltraps>

80107671 <vector116>:
80107671:	6a 00                	push   $0x0
80107673:	6a 74                	push   $0x74
80107675:	e9 a0 f5 ff ff       	jmp    80106c1a <alltraps>

8010767a <vector117>:
8010767a:	6a 00                	push   $0x0
8010767c:	6a 75                	push   $0x75
8010767e:	e9 97 f5 ff ff       	jmp    80106c1a <alltraps>

80107683 <vector118>:
80107683:	6a 00                	push   $0x0
80107685:	6a 76                	push   $0x76
80107687:	e9 8e f5 ff ff       	jmp    80106c1a <alltraps>

8010768c <vector119>:
8010768c:	6a 00                	push   $0x0
8010768e:	6a 77                	push   $0x77
80107690:	e9 85 f5 ff ff       	jmp    80106c1a <alltraps>

80107695 <vector120>:
80107695:	6a 00                	push   $0x0
80107697:	6a 78                	push   $0x78
80107699:	e9 7c f5 ff ff       	jmp    80106c1a <alltraps>

8010769e <vector121>:
8010769e:	6a 00                	push   $0x0
801076a0:	6a 79                	push   $0x79
801076a2:	e9 73 f5 ff ff       	jmp    80106c1a <alltraps>

801076a7 <vector122>:
801076a7:	6a 00                	push   $0x0
801076a9:	6a 7a                	push   $0x7a
801076ab:	e9 6a f5 ff ff       	jmp    80106c1a <alltraps>

801076b0 <vector123>:
801076b0:	6a 00                	push   $0x0
801076b2:	6a 7b                	push   $0x7b
801076b4:	e9 61 f5 ff ff       	jmp    80106c1a <alltraps>

801076b9 <vector124>:
801076b9:	6a 00                	push   $0x0
801076bb:	6a 7c                	push   $0x7c
801076bd:	e9 58 f5 ff ff       	jmp    80106c1a <alltraps>

801076c2 <vector125>:
801076c2:	6a 00                	push   $0x0
801076c4:	6a 7d                	push   $0x7d
801076c6:	e9 4f f5 ff ff       	jmp    80106c1a <alltraps>

801076cb <vector126>:
801076cb:	6a 00                	push   $0x0
801076cd:	6a 7e                	push   $0x7e
801076cf:	e9 46 f5 ff ff       	jmp    80106c1a <alltraps>

801076d4 <vector127>:
801076d4:	6a 00                	push   $0x0
801076d6:	6a 7f                	push   $0x7f
801076d8:	e9 3d f5 ff ff       	jmp    80106c1a <alltraps>

801076dd <vector128>:
801076dd:	6a 00                	push   $0x0
801076df:	68 80 00 00 00       	push   $0x80
801076e4:	e9 31 f5 ff ff       	jmp    80106c1a <alltraps>

801076e9 <vector129>:
801076e9:	6a 00                	push   $0x0
801076eb:	68 81 00 00 00       	push   $0x81
801076f0:	e9 25 f5 ff ff       	jmp    80106c1a <alltraps>

801076f5 <vector130>:
801076f5:	6a 00                	push   $0x0
801076f7:	68 82 00 00 00       	push   $0x82
801076fc:	e9 19 f5 ff ff       	jmp    80106c1a <alltraps>

80107701 <vector131>:
80107701:	6a 00                	push   $0x0
80107703:	68 83 00 00 00       	push   $0x83
80107708:	e9 0d f5 ff ff       	jmp    80106c1a <alltraps>

8010770d <vector132>:
8010770d:	6a 00                	push   $0x0
8010770f:	68 84 00 00 00       	push   $0x84
80107714:	e9 01 f5 ff ff       	jmp    80106c1a <alltraps>

80107719 <vector133>:
80107719:	6a 00                	push   $0x0
8010771b:	68 85 00 00 00       	push   $0x85
80107720:	e9 f5 f4 ff ff       	jmp    80106c1a <alltraps>

80107725 <vector134>:
80107725:	6a 00                	push   $0x0
80107727:	68 86 00 00 00       	push   $0x86
8010772c:	e9 e9 f4 ff ff       	jmp    80106c1a <alltraps>

80107731 <vector135>:
80107731:	6a 00                	push   $0x0
80107733:	68 87 00 00 00       	push   $0x87
80107738:	e9 dd f4 ff ff       	jmp    80106c1a <alltraps>

8010773d <vector136>:
8010773d:	6a 00                	push   $0x0
8010773f:	68 88 00 00 00       	push   $0x88
80107744:	e9 d1 f4 ff ff       	jmp    80106c1a <alltraps>

80107749 <vector137>:
80107749:	6a 00                	push   $0x0
8010774b:	68 89 00 00 00       	push   $0x89
80107750:	e9 c5 f4 ff ff       	jmp    80106c1a <alltraps>

80107755 <vector138>:
80107755:	6a 00                	push   $0x0
80107757:	68 8a 00 00 00       	push   $0x8a
8010775c:	e9 b9 f4 ff ff       	jmp    80106c1a <alltraps>

80107761 <vector139>:
80107761:	6a 00                	push   $0x0
80107763:	68 8b 00 00 00       	push   $0x8b
80107768:	e9 ad f4 ff ff       	jmp    80106c1a <alltraps>

8010776d <vector140>:
8010776d:	6a 00                	push   $0x0
8010776f:	68 8c 00 00 00       	push   $0x8c
80107774:	e9 a1 f4 ff ff       	jmp    80106c1a <alltraps>

80107779 <vector141>:
80107779:	6a 00                	push   $0x0
8010777b:	68 8d 00 00 00       	push   $0x8d
80107780:	e9 95 f4 ff ff       	jmp    80106c1a <alltraps>

80107785 <vector142>:
80107785:	6a 00                	push   $0x0
80107787:	68 8e 00 00 00       	push   $0x8e
8010778c:	e9 89 f4 ff ff       	jmp    80106c1a <alltraps>

80107791 <vector143>:
80107791:	6a 00                	push   $0x0
80107793:	68 8f 00 00 00       	push   $0x8f
80107798:	e9 7d f4 ff ff       	jmp    80106c1a <alltraps>

8010779d <vector144>:
8010779d:	6a 00                	push   $0x0
8010779f:	68 90 00 00 00       	push   $0x90
801077a4:	e9 71 f4 ff ff       	jmp    80106c1a <alltraps>

801077a9 <vector145>:
801077a9:	6a 00                	push   $0x0
801077ab:	68 91 00 00 00       	push   $0x91
801077b0:	e9 65 f4 ff ff       	jmp    80106c1a <alltraps>

801077b5 <vector146>:
801077b5:	6a 00                	push   $0x0
801077b7:	68 92 00 00 00       	push   $0x92
801077bc:	e9 59 f4 ff ff       	jmp    80106c1a <alltraps>

801077c1 <vector147>:
801077c1:	6a 00                	push   $0x0
801077c3:	68 93 00 00 00       	push   $0x93
801077c8:	e9 4d f4 ff ff       	jmp    80106c1a <alltraps>

801077cd <vector148>:
801077cd:	6a 00                	push   $0x0
801077cf:	68 94 00 00 00       	push   $0x94
801077d4:	e9 41 f4 ff ff       	jmp    80106c1a <alltraps>

801077d9 <vector149>:
801077d9:	6a 00                	push   $0x0
801077db:	68 95 00 00 00       	push   $0x95
801077e0:	e9 35 f4 ff ff       	jmp    80106c1a <alltraps>

801077e5 <vector150>:
801077e5:	6a 00                	push   $0x0
801077e7:	68 96 00 00 00       	push   $0x96
801077ec:	e9 29 f4 ff ff       	jmp    80106c1a <alltraps>

801077f1 <vector151>:
801077f1:	6a 00                	push   $0x0
801077f3:	68 97 00 00 00       	push   $0x97
801077f8:	e9 1d f4 ff ff       	jmp    80106c1a <alltraps>

801077fd <vector152>:
801077fd:	6a 00                	push   $0x0
801077ff:	68 98 00 00 00       	push   $0x98
80107804:	e9 11 f4 ff ff       	jmp    80106c1a <alltraps>

80107809 <vector153>:
80107809:	6a 00                	push   $0x0
8010780b:	68 99 00 00 00       	push   $0x99
80107810:	e9 05 f4 ff ff       	jmp    80106c1a <alltraps>

80107815 <vector154>:
80107815:	6a 00                	push   $0x0
80107817:	68 9a 00 00 00       	push   $0x9a
8010781c:	e9 f9 f3 ff ff       	jmp    80106c1a <alltraps>

80107821 <vector155>:
80107821:	6a 00                	push   $0x0
80107823:	68 9b 00 00 00       	push   $0x9b
80107828:	e9 ed f3 ff ff       	jmp    80106c1a <alltraps>

8010782d <vector156>:
8010782d:	6a 00                	push   $0x0
8010782f:	68 9c 00 00 00       	push   $0x9c
80107834:	e9 e1 f3 ff ff       	jmp    80106c1a <alltraps>

80107839 <vector157>:
80107839:	6a 00                	push   $0x0
8010783b:	68 9d 00 00 00       	push   $0x9d
80107840:	e9 d5 f3 ff ff       	jmp    80106c1a <alltraps>

80107845 <vector158>:
80107845:	6a 00                	push   $0x0
80107847:	68 9e 00 00 00       	push   $0x9e
8010784c:	e9 c9 f3 ff ff       	jmp    80106c1a <alltraps>

80107851 <vector159>:
80107851:	6a 00                	push   $0x0
80107853:	68 9f 00 00 00       	push   $0x9f
80107858:	e9 bd f3 ff ff       	jmp    80106c1a <alltraps>

8010785d <vector160>:
8010785d:	6a 00                	push   $0x0
8010785f:	68 a0 00 00 00       	push   $0xa0
80107864:	e9 b1 f3 ff ff       	jmp    80106c1a <alltraps>

80107869 <vector161>:
80107869:	6a 00                	push   $0x0
8010786b:	68 a1 00 00 00       	push   $0xa1
80107870:	e9 a5 f3 ff ff       	jmp    80106c1a <alltraps>

80107875 <vector162>:
80107875:	6a 00                	push   $0x0
80107877:	68 a2 00 00 00       	push   $0xa2
8010787c:	e9 99 f3 ff ff       	jmp    80106c1a <alltraps>

80107881 <vector163>:
80107881:	6a 00                	push   $0x0
80107883:	68 a3 00 00 00       	push   $0xa3
80107888:	e9 8d f3 ff ff       	jmp    80106c1a <alltraps>

8010788d <vector164>:
8010788d:	6a 00                	push   $0x0
8010788f:	68 a4 00 00 00       	push   $0xa4
80107894:	e9 81 f3 ff ff       	jmp    80106c1a <alltraps>

80107899 <vector165>:
80107899:	6a 00                	push   $0x0
8010789b:	68 a5 00 00 00       	push   $0xa5
801078a0:	e9 75 f3 ff ff       	jmp    80106c1a <alltraps>

801078a5 <vector166>:
801078a5:	6a 00                	push   $0x0
801078a7:	68 a6 00 00 00       	push   $0xa6
801078ac:	e9 69 f3 ff ff       	jmp    80106c1a <alltraps>

801078b1 <vector167>:
801078b1:	6a 00                	push   $0x0
801078b3:	68 a7 00 00 00       	push   $0xa7
801078b8:	e9 5d f3 ff ff       	jmp    80106c1a <alltraps>

801078bd <vector168>:
801078bd:	6a 00                	push   $0x0
801078bf:	68 a8 00 00 00       	push   $0xa8
801078c4:	e9 51 f3 ff ff       	jmp    80106c1a <alltraps>

801078c9 <vector169>:
801078c9:	6a 00                	push   $0x0
801078cb:	68 a9 00 00 00       	push   $0xa9
801078d0:	e9 45 f3 ff ff       	jmp    80106c1a <alltraps>

801078d5 <vector170>:
801078d5:	6a 00                	push   $0x0
801078d7:	68 aa 00 00 00       	push   $0xaa
801078dc:	e9 39 f3 ff ff       	jmp    80106c1a <alltraps>

801078e1 <vector171>:
801078e1:	6a 00                	push   $0x0
801078e3:	68 ab 00 00 00       	push   $0xab
801078e8:	e9 2d f3 ff ff       	jmp    80106c1a <alltraps>

801078ed <vector172>:
801078ed:	6a 00                	push   $0x0
801078ef:	68 ac 00 00 00       	push   $0xac
801078f4:	e9 21 f3 ff ff       	jmp    80106c1a <alltraps>

801078f9 <vector173>:
801078f9:	6a 00                	push   $0x0
801078fb:	68 ad 00 00 00       	push   $0xad
80107900:	e9 15 f3 ff ff       	jmp    80106c1a <alltraps>

80107905 <vector174>:
80107905:	6a 00                	push   $0x0
80107907:	68 ae 00 00 00       	push   $0xae
8010790c:	e9 09 f3 ff ff       	jmp    80106c1a <alltraps>

80107911 <vector175>:
80107911:	6a 00                	push   $0x0
80107913:	68 af 00 00 00       	push   $0xaf
80107918:	e9 fd f2 ff ff       	jmp    80106c1a <alltraps>

8010791d <vector176>:
8010791d:	6a 00                	push   $0x0
8010791f:	68 b0 00 00 00       	push   $0xb0
80107924:	e9 f1 f2 ff ff       	jmp    80106c1a <alltraps>

80107929 <vector177>:
80107929:	6a 00                	push   $0x0
8010792b:	68 b1 00 00 00       	push   $0xb1
80107930:	e9 e5 f2 ff ff       	jmp    80106c1a <alltraps>

80107935 <vector178>:
80107935:	6a 00                	push   $0x0
80107937:	68 b2 00 00 00       	push   $0xb2
8010793c:	e9 d9 f2 ff ff       	jmp    80106c1a <alltraps>

80107941 <vector179>:
80107941:	6a 00                	push   $0x0
80107943:	68 b3 00 00 00       	push   $0xb3
80107948:	e9 cd f2 ff ff       	jmp    80106c1a <alltraps>

8010794d <vector180>:
8010794d:	6a 00                	push   $0x0
8010794f:	68 b4 00 00 00       	push   $0xb4
80107954:	e9 c1 f2 ff ff       	jmp    80106c1a <alltraps>

80107959 <vector181>:
80107959:	6a 00                	push   $0x0
8010795b:	68 b5 00 00 00       	push   $0xb5
80107960:	e9 b5 f2 ff ff       	jmp    80106c1a <alltraps>

80107965 <vector182>:
80107965:	6a 00                	push   $0x0
80107967:	68 b6 00 00 00       	push   $0xb6
8010796c:	e9 a9 f2 ff ff       	jmp    80106c1a <alltraps>

80107971 <vector183>:
80107971:	6a 00                	push   $0x0
80107973:	68 b7 00 00 00       	push   $0xb7
80107978:	e9 9d f2 ff ff       	jmp    80106c1a <alltraps>

8010797d <vector184>:
8010797d:	6a 00                	push   $0x0
8010797f:	68 b8 00 00 00       	push   $0xb8
80107984:	e9 91 f2 ff ff       	jmp    80106c1a <alltraps>

80107989 <vector185>:
80107989:	6a 00                	push   $0x0
8010798b:	68 b9 00 00 00       	push   $0xb9
80107990:	e9 85 f2 ff ff       	jmp    80106c1a <alltraps>

80107995 <vector186>:
80107995:	6a 00                	push   $0x0
80107997:	68 ba 00 00 00       	push   $0xba
8010799c:	e9 79 f2 ff ff       	jmp    80106c1a <alltraps>

801079a1 <vector187>:
801079a1:	6a 00                	push   $0x0
801079a3:	68 bb 00 00 00       	push   $0xbb
801079a8:	e9 6d f2 ff ff       	jmp    80106c1a <alltraps>

801079ad <vector188>:
801079ad:	6a 00                	push   $0x0
801079af:	68 bc 00 00 00       	push   $0xbc
801079b4:	e9 61 f2 ff ff       	jmp    80106c1a <alltraps>

801079b9 <vector189>:
801079b9:	6a 00                	push   $0x0
801079bb:	68 bd 00 00 00       	push   $0xbd
801079c0:	e9 55 f2 ff ff       	jmp    80106c1a <alltraps>

801079c5 <vector190>:
801079c5:	6a 00                	push   $0x0
801079c7:	68 be 00 00 00       	push   $0xbe
801079cc:	e9 49 f2 ff ff       	jmp    80106c1a <alltraps>

801079d1 <vector191>:
801079d1:	6a 00                	push   $0x0
801079d3:	68 bf 00 00 00       	push   $0xbf
801079d8:	e9 3d f2 ff ff       	jmp    80106c1a <alltraps>

801079dd <vector192>:
801079dd:	6a 00                	push   $0x0
801079df:	68 c0 00 00 00       	push   $0xc0
801079e4:	e9 31 f2 ff ff       	jmp    80106c1a <alltraps>

801079e9 <vector193>:
801079e9:	6a 00                	push   $0x0
801079eb:	68 c1 00 00 00       	push   $0xc1
801079f0:	e9 25 f2 ff ff       	jmp    80106c1a <alltraps>

801079f5 <vector194>:
801079f5:	6a 00                	push   $0x0
801079f7:	68 c2 00 00 00       	push   $0xc2
801079fc:	e9 19 f2 ff ff       	jmp    80106c1a <alltraps>

80107a01 <vector195>:
80107a01:	6a 00                	push   $0x0
80107a03:	68 c3 00 00 00       	push   $0xc3
80107a08:	e9 0d f2 ff ff       	jmp    80106c1a <alltraps>

80107a0d <vector196>:
80107a0d:	6a 00                	push   $0x0
80107a0f:	68 c4 00 00 00       	push   $0xc4
80107a14:	e9 01 f2 ff ff       	jmp    80106c1a <alltraps>

80107a19 <vector197>:
80107a19:	6a 00                	push   $0x0
80107a1b:	68 c5 00 00 00       	push   $0xc5
80107a20:	e9 f5 f1 ff ff       	jmp    80106c1a <alltraps>

80107a25 <vector198>:
80107a25:	6a 00                	push   $0x0
80107a27:	68 c6 00 00 00       	push   $0xc6
80107a2c:	e9 e9 f1 ff ff       	jmp    80106c1a <alltraps>

80107a31 <vector199>:
80107a31:	6a 00                	push   $0x0
80107a33:	68 c7 00 00 00       	push   $0xc7
80107a38:	e9 dd f1 ff ff       	jmp    80106c1a <alltraps>

80107a3d <vector200>:
80107a3d:	6a 00                	push   $0x0
80107a3f:	68 c8 00 00 00       	push   $0xc8
80107a44:	e9 d1 f1 ff ff       	jmp    80106c1a <alltraps>

80107a49 <vector201>:
80107a49:	6a 00                	push   $0x0
80107a4b:	68 c9 00 00 00       	push   $0xc9
80107a50:	e9 c5 f1 ff ff       	jmp    80106c1a <alltraps>

80107a55 <vector202>:
80107a55:	6a 00                	push   $0x0
80107a57:	68 ca 00 00 00       	push   $0xca
80107a5c:	e9 b9 f1 ff ff       	jmp    80106c1a <alltraps>

80107a61 <vector203>:
80107a61:	6a 00                	push   $0x0
80107a63:	68 cb 00 00 00       	push   $0xcb
80107a68:	e9 ad f1 ff ff       	jmp    80106c1a <alltraps>

80107a6d <vector204>:
80107a6d:	6a 00                	push   $0x0
80107a6f:	68 cc 00 00 00       	push   $0xcc
80107a74:	e9 a1 f1 ff ff       	jmp    80106c1a <alltraps>

80107a79 <vector205>:
80107a79:	6a 00                	push   $0x0
80107a7b:	68 cd 00 00 00       	push   $0xcd
80107a80:	e9 95 f1 ff ff       	jmp    80106c1a <alltraps>

80107a85 <vector206>:
80107a85:	6a 00                	push   $0x0
80107a87:	68 ce 00 00 00       	push   $0xce
80107a8c:	e9 89 f1 ff ff       	jmp    80106c1a <alltraps>

80107a91 <vector207>:
80107a91:	6a 00                	push   $0x0
80107a93:	68 cf 00 00 00       	push   $0xcf
80107a98:	e9 7d f1 ff ff       	jmp    80106c1a <alltraps>

80107a9d <vector208>:
80107a9d:	6a 00                	push   $0x0
80107a9f:	68 d0 00 00 00       	push   $0xd0
80107aa4:	e9 71 f1 ff ff       	jmp    80106c1a <alltraps>

80107aa9 <vector209>:
80107aa9:	6a 00                	push   $0x0
80107aab:	68 d1 00 00 00       	push   $0xd1
80107ab0:	e9 65 f1 ff ff       	jmp    80106c1a <alltraps>

80107ab5 <vector210>:
80107ab5:	6a 00                	push   $0x0
80107ab7:	68 d2 00 00 00       	push   $0xd2
80107abc:	e9 59 f1 ff ff       	jmp    80106c1a <alltraps>

80107ac1 <vector211>:
80107ac1:	6a 00                	push   $0x0
80107ac3:	68 d3 00 00 00       	push   $0xd3
80107ac8:	e9 4d f1 ff ff       	jmp    80106c1a <alltraps>

80107acd <vector212>:
80107acd:	6a 00                	push   $0x0
80107acf:	68 d4 00 00 00       	push   $0xd4
80107ad4:	e9 41 f1 ff ff       	jmp    80106c1a <alltraps>

80107ad9 <vector213>:
80107ad9:	6a 00                	push   $0x0
80107adb:	68 d5 00 00 00       	push   $0xd5
80107ae0:	e9 35 f1 ff ff       	jmp    80106c1a <alltraps>

80107ae5 <vector214>:
80107ae5:	6a 00                	push   $0x0
80107ae7:	68 d6 00 00 00       	push   $0xd6
80107aec:	e9 29 f1 ff ff       	jmp    80106c1a <alltraps>

80107af1 <vector215>:
80107af1:	6a 00                	push   $0x0
80107af3:	68 d7 00 00 00       	push   $0xd7
80107af8:	e9 1d f1 ff ff       	jmp    80106c1a <alltraps>

80107afd <vector216>:
80107afd:	6a 00                	push   $0x0
80107aff:	68 d8 00 00 00       	push   $0xd8
80107b04:	e9 11 f1 ff ff       	jmp    80106c1a <alltraps>

80107b09 <vector217>:
80107b09:	6a 00                	push   $0x0
80107b0b:	68 d9 00 00 00       	push   $0xd9
80107b10:	e9 05 f1 ff ff       	jmp    80106c1a <alltraps>

80107b15 <vector218>:
80107b15:	6a 00                	push   $0x0
80107b17:	68 da 00 00 00       	push   $0xda
80107b1c:	e9 f9 f0 ff ff       	jmp    80106c1a <alltraps>

80107b21 <vector219>:
80107b21:	6a 00                	push   $0x0
80107b23:	68 db 00 00 00       	push   $0xdb
80107b28:	e9 ed f0 ff ff       	jmp    80106c1a <alltraps>

80107b2d <vector220>:
80107b2d:	6a 00                	push   $0x0
80107b2f:	68 dc 00 00 00       	push   $0xdc
80107b34:	e9 e1 f0 ff ff       	jmp    80106c1a <alltraps>

80107b39 <vector221>:
80107b39:	6a 00                	push   $0x0
80107b3b:	68 dd 00 00 00       	push   $0xdd
80107b40:	e9 d5 f0 ff ff       	jmp    80106c1a <alltraps>

80107b45 <vector222>:
80107b45:	6a 00                	push   $0x0
80107b47:	68 de 00 00 00       	push   $0xde
80107b4c:	e9 c9 f0 ff ff       	jmp    80106c1a <alltraps>

80107b51 <vector223>:
80107b51:	6a 00                	push   $0x0
80107b53:	68 df 00 00 00       	push   $0xdf
80107b58:	e9 bd f0 ff ff       	jmp    80106c1a <alltraps>

80107b5d <vector224>:
80107b5d:	6a 00                	push   $0x0
80107b5f:	68 e0 00 00 00       	push   $0xe0
80107b64:	e9 b1 f0 ff ff       	jmp    80106c1a <alltraps>

80107b69 <vector225>:
80107b69:	6a 00                	push   $0x0
80107b6b:	68 e1 00 00 00       	push   $0xe1
80107b70:	e9 a5 f0 ff ff       	jmp    80106c1a <alltraps>

80107b75 <vector226>:
80107b75:	6a 00                	push   $0x0
80107b77:	68 e2 00 00 00       	push   $0xe2
80107b7c:	e9 99 f0 ff ff       	jmp    80106c1a <alltraps>

80107b81 <vector227>:
80107b81:	6a 00                	push   $0x0
80107b83:	68 e3 00 00 00       	push   $0xe3
80107b88:	e9 8d f0 ff ff       	jmp    80106c1a <alltraps>

80107b8d <vector228>:
80107b8d:	6a 00                	push   $0x0
80107b8f:	68 e4 00 00 00       	push   $0xe4
80107b94:	e9 81 f0 ff ff       	jmp    80106c1a <alltraps>

80107b99 <vector229>:
80107b99:	6a 00                	push   $0x0
80107b9b:	68 e5 00 00 00       	push   $0xe5
80107ba0:	e9 75 f0 ff ff       	jmp    80106c1a <alltraps>

80107ba5 <vector230>:
80107ba5:	6a 00                	push   $0x0
80107ba7:	68 e6 00 00 00       	push   $0xe6
80107bac:	e9 69 f0 ff ff       	jmp    80106c1a <alltraps>

80107bb1 <vector231>:
80107bb1:	6a 00                	push   $0x0
80107bb3:	68 e7 00 00 00       	push   $0xe7
80107bb8:	e9 5d f0 ff ff       	jmp    80106c1a <alltraps>

80107bbd <vector232>:
80107bbd:	6a 00                	push   $0x0
80107bbf:	68 e8 00 00 00       	push   $0xe8
80107bc4:	e9 51 f0 ff ff       	jmp    80106c1a <alltraps>

80107bc9 <vector233>:
80107bc9:	6a 00                	push   $0x0
80107bcb:	68 e9 00 00 00       	push   $0xe9
80107bd0:	e9 45 f0 ff ff       	jmp    80106c1a <alltraps>

80107bd5 <vector234>:
80107bd5:	6a 00                	push   $0x0
80107bd7:	68 ea 00 00 00       	push   $0xea
80107bdc:	e9 39 f0 ff ff       	jmp    80106c1a <alltraps>

80107be1 <vector235>:
80107be1:	6a 00                	push   $0x0
80107be3:	68 eb 00 00 00       	push   $0xeb
80107be8:	e9 2d f0 ff ff       	jmp    80106c1a <alltraps>

80107bed <vector236>:
80107bed:	6a 00                	push   $0x0
80107bef:	68 ec 00 00 00       	push   $0xec
80107bf4:	e9 21 f0 ff ff       	jmp    80106c1a <alltraps>

80107bf9 <vector237>:
80107bf9:	6a 00                	push   $0x0
80107bfb:	68 ed 00 00 00       	push   $0xed
80107c00:	e9 15 f0 ff ff       	jmp    80106c1a <alltraps>

80107c05 <vector238>:
80107c05:	6a 00                	push   $0x0
80107c07:	68 ee 00 00 00       	push   $0xee
80107c0c:	e9 09 f0 ff ff       	jmp    80106c1a <alltraps>

80107c11 <vector239>:
80107c11:	6a 00                	push   $0x0
80107c13:	68 ef 00 00 00       	push   $0xef
80107c18:	e9 fd ef ff ff       	jmp    80106c1a <alltraps>

80107c1d <vector240>:
80107c1d:	6a 00                	push   $0x0
80107c1f:	68 f0 00 00 00       	push   $0xf0
80107c24:	e9 f1 ef ff ff       	jmp    80106c1a <alltraps>

80107c29 <vector241>:
80107c29:	6a 00                	push   $0x0
80107c2b:	68 f1 00 00 00       	push   $0xf1
80107c30:	e9 e5 ef ff ff       	jmp    80106c1a <alltraps>

80107c35 <vector242>:
80107c35:	6a 00                	push   $0x0
80107c37:	68 f2 00 00 00       	push   $0xf2
80107c3c:	e9 d9 ef ff ff       	jmp    80106c1a <alltraps>

80107c41 <vector243>:
80107c41:	6a 00                	push   $0x0
80107c43:	68 f3 00 00 00       	push   $0xf3
80107c48:	e9 cd ef ff ff       	jmp    80106c1a <alltraps>

80107c4d <vector244>:
80107c4d:	6a 00                	push   $0x0
80107c4f:	68 f4 00 00 00       	push   $0xf4
80107c54:	e9 c1 ef ff ff       	jmp    80106c1a <alltraps>

80107c59 <vector245>:
80107c59:	6a 00                	push   $0x0
80107c5b:	68 f5 00 00 00       	push   $0xf5
80107c60:	e9 b5 ef ff ff       	jmp    80106c1a <alltraps>

80107c65 <vector246>:
80107c65:	6a 00                	push   $0x0
80107c67:	68 f6 00 00 00       	push   $0xf6
80107c6c:	e9 a9 ef ff ff       	jmp    80106c1a <alltraps>

80107c71 <vector247>:
80107c71:	6a 00                	push   $0x0
80107c73:	68 f7 00 00 00       	push   $0xf7
80107c78:	e9 9d ef ff ff       	jmp    80106c1a <alltraps>

80107c7d <vector248>:
80107c7d:	6a 00                	push   $0x0
80107c7f:	68 f8 00 00 00       	push   $0xf8
80107c84:	e9 91 ef ff ff       	jmp    80106c1a <alltraps>

80107c89 <vector249>:
80107c89:	6a 00                	push   $0x0
80107c8b:	68 f9 00 00 00       	push   $0xf9
80107c90:	e9 85 ef ff ff       	jmp    80106c1a <alltraps>

80107c95 <vector250>:
80107c95:	6a 00                	push   $0x0
80107c97:	68 fa 00 00 00       	push   $0xfa
80107c9c:	e9 79 ef ff ff       	jmp    80106c1a <alltraps>

80107ca1 <vector251>:
80107ca1:	6a 00                	push   $0x0
80107ca3:	68 fb 00 00 00       	push   $0xfb
80107ca8:	e9 6d ef ff ff       	jmp    80106c1a <alltraps>

80107cad <vector252>:
80107cad:	6a 00                	push   $0x0
80107caf:	68 fc 00 00 00       	push   $0xfc
80107cb4:	e9 61 ef ff ff       	jmp    80106c1a <alltraps>

80107cb9 <vector253>:
80107cb9:	6a 00                	push   $0x0
80107cbb:	68 fd 00 00 00       	push   $0xfd
80107cc0:	e9 55 ef ff ff       	jmp    80106c1a <alltraps>

80107cc5 <vector254>:
80107cc5:	6a 00                	push   $0x0
80107cc7:	68 fe 00 00 00       	push   $0xfe
80107ccc:	e9 49 ef ff ff       	jmp    80106c1a <alltraps>

80107cd1 <vector255>:
80107cd1:	6a 00                	push   $0x0
80107cd3:	68 ff 00 00 00       	push   $0xff
80107cd8:	e9 3d ef ff ff       	jmp    80106c1a <alltraps>

80107cdd <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107cdd:	55                   	push   %ebp
80107cde:	89 e5                	mov    %esp,%ebp
80107ce0:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ce6:	83 e8 01             	sub    $0x1,%eax
80107ce9:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107ced:	8b 45 08             	mov    0x8(%ebp),%eax
80107cf0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107cf4:	8b 45 08             	mov    0x8(%ebp),%eax
80107cf7:	c1 e8 10             	shr    $0x10,%eax
80107cfa:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107cfe:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107d01:	0f 01 10             	lgdtl  (%eax)
}
80107d04:	90                   	nop
80107d05:	c9                   	leave  
80107d06:	c3                   	ret    

80107d07 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107d07:	55                   	push   %ebp
80107d08:	89 e5                	mov    %esp,%ebp
80107d0a:	83 ec 04             	sub    $0x4,%esp
80107d0d:	8b 45 08             	mov    0x8(%ebp),%eax
80107d10:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107d14:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107d18:	0f 00 d8             	ltr    %ax
}
80107d1b:	90                   	nop
80107d1c:	c9                   	leave  
80107d1d:	c3                   	ret    

80107d1e <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107d1e:	55                   	push   %ebp
80107d1f:	89 e5                	mov    %esp,%ebp
80107d21:	83 ec 04             	sub    $0x4,%esp
80107d24:	8b 45 08             	mov    0x8(%ebp),%eax
80107d27:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107d2b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107d2f:	8e e8                	mov    %eax,%gs
}
80107d31:	90                   	nop
80107d32:	c9                   	leave  
80107d33:	c3                   	ret    

80107d34 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107d34:	55                   	push   %ebp
80107d35:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107d37:	8b 45 08             	mov    0x8(%ebp),%eax
80107d3a:	0f 22 d8             	mov    %eax,%cr3
}
80107d3d:	90                   	nop
80107d3e:	5d                   	pop    %ebp
80107d3f:	c3                   	ret    

80107d40 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107d40:	55                   	push   %ebp
80107d41:	89 e5                	mov    %esp,%ebp
80107d43:	8b 45 08             	mov    0x8(%ebp),%eax
80107d46:	05 00 00 00 80       	add    $0x80000000,%eax
80107d4b:	5d                   	pop    %ebp
80107d4c:	c3                   	ret    

80107d4d <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107d4d:	55                   	push   %ebp
80107d4e:	89 e5                	mov    %esp,%ebp
80107d50:	8b 45 08             	mov    0x8(%ebp),%eax
80107d53:	05 00 00 00 80       	add    $0x80000000,%eax
80107d58:	5d                   	pop    %ebp
80107d59:	c3                   	ret    

80107d5a <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107d5a:	55                   	push   %ebp
80107d5b:	89 e5                	mov    %esp,%ebp
80107d5d:	53                   	push   %ebx
80107d5e:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107d61:	e8 c5 b1 ff ff       	call   80102f2b <cpunum>
80107d66:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107d6c:	05 80 33 11 80       	add    $0x80113380,%eax
80107d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d77:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d80:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d89:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d90:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d94:	83 e2 f0             	and    $0xfffffff0,%edx
80107d97:	83 ca 0a             	or     $0xa,%edx
80107d9a:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da0:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107da4:	83 ca 10             	or     $0x10,%edx
80107da7:	88 50 7d             	mov    %dl,0x7d(%eax)
80107daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dad:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107db1:	83 e2 9f             	and    $0xffffff9f,%edx
80107db4:	88 50 7d             	mov    %dl,0x7d(%eax)
80107db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dba:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107dbe:	83 ca 80             	or     $0xffffff80,%edx
80107dc1:	88 50 7d             	mov    %dl,0x7d(%eax)
80107dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc7:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107dcb:	83 ca 0f             	or     $0xf,%edx
80107dce:	88 50 7e             	mov    %dl,0x7e(%eax)
80107dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd4:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107dd8:	83 e2 ef             	and    $0xffffffef,%edx
80107ddb:	88 50 7e             	mov    %dl,0x7e(%eax)
80107dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de1:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107de5:	83 e2 df             	and    $0xffffffdf,%edx
80107de8:	88 50 7e             	mov    %dl,0x7e(%eax)
80107deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dee:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107df2:	83 ca 40             	or     $0x40,%edx
80107df5:	88 50 7e             	mov    %dl,0x7e(%eax)
80107df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dfb:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107dff:	83 ca 80             	or     $0xffffff80,%edx
80107e02:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e08:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0f:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107e16:	ff ff 
80107e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1b:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107e22:	00 00 
80107e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e27:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e31:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e38:	83 e2 f0             	and    $0xfffffff0,%edx
80107e3b:	83 ca 02             	or     $0x2,%edx
80107e3e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e47:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e4e:	83 ca 10             	or     $0x10,%edx
80107e51:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5a:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e61:	83 e2 9f             	and    $0xffffff9f,%edx
80107e64:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e6d:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e74:	83 ca 80             	or     $0xffffff80,%edx
80107e77:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e80:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e87:	83 ca 0f             	or     $0xf,%edx
80107e8a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e93:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e9a:	83 e2 ef             	and    $0xffffffef,%edx
80107e9d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea6:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107ead:	83 e2 df             	and    $0xffffffdf,%edx
80107eb0:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb9:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107ec0:	83 ca 40             	or     $0x40,%edx
80107ec3:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ecc:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107ed3:	83 ca 80             	or     $0xffffff80,%edx
80107ed6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107edf:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee9:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107ef0:	ff ff 
80107ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef5:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107efc:	00 00 
80107efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f01:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107f12:	83 e2 f0             	and    $0xfffffff0,%edx
80107f15:	83 ca 0a             	or     $0xa,%edx
80107f18:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f21:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107f28:	83 ca 10             	or     $0x10,%edx
80107f2b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f34:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107f3b:	83 ca 60             	or     $0x60,%edx
80107f3e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f47:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107f4e:	83 ca 80             	or     $0xffffff80,%edx
80107f51:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f61:	83 ca 0f             	or     $0xf,%edx
80107f64:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f74:	83 e2 ef             	and    $0xffffffef,%edx
80107f77:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f80:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f87:	83 e2 df             	and    $0xffffffdf,%edx
80107f8a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f93:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f9a:	83 ca 40             	or     $0x40,%edx
80107f9d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa6:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107fad:	83 ca 80             	or     $0xffffff80,%edx
80107fb0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb9:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc3:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107fca:	ff ff 
80107fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fcf:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107fd6:	00 00 
80107fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fdb:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe5:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107fec:	83 e2 f0             	and    $0xfffffff0,%edx
80107fef:	83 ca 02             	or     $0x2,%edx
80107ff2:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffb:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108002:	83 ca 10             	or     $0x10,%edx
80108005:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010800b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108015:	83 ca 60             	or     $0x60,%edx
80108018:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010801e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108021:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108028:	83 ca 80             	or     $0xffffff80,%edx
8010802b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108031:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108034:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010803b:	83 ca 0f             	or     $0xf,%edx
8010803e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108044:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108047:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010804e:	83 e2 ef             	and    $0xffffffef,%edx
80108051:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108057:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108061:	83 e2 df             	and    $0xffffffdf,%edx
80108064:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010806a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806d:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108074:	83 ca 40             	or     $0x40,%edx
80108077:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010807d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108080:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108087:	83 ca 80             	or     $0xffffff80,%edx
8010808a:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108090:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108093:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010809a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809d:	05 b4 00 00 00       	add    $0xb4,%eax
801080a2:	89 c3                	mov    %eax,%ebx
801080a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a7:	05 b4 00 00 00       	add    $0xb4,%eax
801080ac:	c1 e8 10             	shr    $0x10,%eax
801080af:	89 c2                	mov    %eax,%edx
801080b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b4:	05 b4 00 00 00       	add    $0xb4,%eax
801080b9:	c1 e8 18             	shr    $0x18,%eax
801080bc:	89 c1                	mov    %eax,%ecx
801080be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c1:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801080c8:	00 00 
801080ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cd:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801080d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d7:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
801080dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e0:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801080e7:	83 e2 f0             	and    $0xfffffff0,%edx
801080ea:	83 ca 02             	or     $0x2,%edx
801080ed:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801080f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f6:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801080fd:	83 ca 10             	or     $0x10,%edx
80108100:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108106:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108109:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108110:	83 e2 9f             	and    $0xffffff9f,%edx
80108113:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010811c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108123:	83 ca 80             	or     $0xffffff80,%edx
80108126:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010812c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108136:	83 e2 f0             	and    $0xfffffff0,%edx
80108139:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010813f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108142:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108149:	83 e2 ef             	and    $0xffffffef,%edx
8010814c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108152:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108155:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010815c:	83 e2 df             	and    $0xffffffdf,%edx
8010815f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108168:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010816f:	83 ca 40             	or     $0x40,%edx
80108172:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108182:	83 ca 80             	or     $0xffffff80,%edx
80108185:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010818b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010818e:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108197:	83 c0 70             	add    $0x70,%eax
8010819a:	83 ec 08             	sub    $0x8,%esp
8010819d:	6a 38                	push   $0x38
8010819f:	50                   	push   %eax
801081a0:	e8 38 fb ff ff       	call   80107cdd <lgdt>
801081a5:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
801081a8:	83 ec 0c             	sub    $0xc,%esp
801081ab:	6a 18                	push   $0x18
801081ad:	e8 6c fb ff ff       	call   80107d1e <loadgs>
801081b2:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
801081b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b8:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801081be:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801081c5:	00 00 00 00 
}
801081c9:	90                   	nop
801081ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801081cd:	c9                   	leave  
801081ce:	c3                   	ret    

801081cf <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801081cf:	55                   	push   %ebp
801081d0:	89 e5                	mov    %esp,%ebp
801081d2:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801081d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801081d8:	c1 e8 16             	shr    $0x16,%eax
801081db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081e2:	8b 45 08             	mov    0x8(%ebp),%eax
801081e5:	01 d0                	add    %edx,%eax
801081e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801081ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081ed:	8b 00                	mov    (%eax),%eax
801081ef:	83 e0 01             	and    $0x1,%eax
801081f2:	85 c0                	test   %eax,%eax
801081f4:	74 18                	je     8010820e <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801081f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081f9:	8b 00                	mov    (%eax),%eax
801081fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108200:	50                   	push   %eax
80108201:	e8 47 fb ff ff       	call   80107d4d <p2v>
80108206:	83 c4 04             	add    $0x4,%esp
80108209:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010820c:	eb 48                	jmp    80108256 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010820e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108212:	74 0e                	je     80108222 <walkpgdir+0x53>
80108214:	e8 ac a9 ff ff       	call   80102bc5 <kalloc>
80108219:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010821c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108220:	75 07                	jne    80108229 <walkpgdir+0x5a>
      return 0;
80108222:	b8 00 00 00 00       	mov    $0x0,%eax
80108227:	eb 44                	jmp    8010826d <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108229:	83 ec 04             	sub    $0x4,%esp
8010822c:	68 00 10 00 00       	push   $0x1000
80108231:	6a 00                	push   $0x0
80108233:	ff 75 f4             	pushl  -0xc(%ebp)
80108236:	e8 4b d4 ff ff       	call   80105686 <memset>
8010823b:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
8010823e:	83 ec 0c             	sub    $0xc,%esp
80108241:	ff 75 f4             	pushl  -0xc(%ebp)
80108244:	e8 f7 fa ff ff       	call   80107d40 <v2p>
80108249:	83 c4 10             	add    $0x10,%esp
8010824c:	83 c8 07             	or     $0x7,%eax
8010824f:	89 c2                	mov    %eax,%edx
80108251:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108254:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108256:	8b 45 0c             	mov    0xc(%ebp),%eax
80108259:	c1 e8 0c             	shr    $0xc,%eax
8010825c:	25 ff 03 00 00       	and    $0x3ff,%eax
80108261:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108268:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826b:	01 d0                	add    %edx,%eax
}
8010826d:	c9                   	leave  
8010826e:	c3                   	ret    

8010826f <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010826f:	55                   	push   %ebp
80108270:	89 e5                	mov    %esp,%ebp
80108272:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108275:	8b 45 0c             	mov    0xc(%ebp),%eax
80108278:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010827d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108280:	8b 55 0c             	mov    0xc(%ebp),%edx
80108283:	8b 45 10             	mov    0x10(%ebp),%eax
80108286:	01 d0                	add    %edx,%eax
80108288:	83 e8 01             	sub    $0x1,%eax
8010828b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108290:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108293:	83 ec 04             	sub    $0x4,%esp
80108296:	6a 01                	push   $0x1
80108298:	ff 75 f4             	pushl  -0xc(%ebp)
8010829b:	ff 75 08             	pushl  0x8(%ebp)
8010829e:	e8 2c ff ff ff       	call   801081cf <walkpgdir>
801082a3:	83 c4 10             	add    $0x10,%esp
801082a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801082a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801082ad:	75 07                	jne    801082b6 <mappages+0x47>
      return -1;
801082af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801082b4:	eb 47                	jmp    801082fd <mappages+0x8e>
    if(*pte & PTE_P)
801082b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082b9:	8b 00                	mov    (%eax),%eax
801082bb:	83 e0 01             	and    $0x1,%eax
801082be:	85 c0                	test   %eax,%eax
801082c0:	74 0d                	je     801082cf <mappages+0x60>
      panic("remap");
801082c2:	83 ec 0c             	sub    $0xc,%esp
801082c5:	68 84 96 10 80       	push   $0x80109684
801082ca:	e8 97 82 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
801082cf:	8b 45 18             	mov    0x18(%ebp),%eax
801082d2:	0b 45 14             	or     0x14(%ebp),%eax
801082d5:	83 c8 01             	or     $0x1,%eax
801082d8:	89 c2                	mov    %eax,%edx
801082da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082dd:	89 10                	mov    %edx,(%eax)
    if(a == last)
801082df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801082e5:	74 10                	je     801082f7 <mappages+0x88>
      break;
    a += PGSIZE;
801082e7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801082ee:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801082f5:	eb 9c                	jmp    80108293 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
801082f7:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801082f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801082fd:	c9                   	leave  
801082fe:	c3                   	ret    

801082ff <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801082ff:	55                   	push   %ebp
80108300:	89 e5                	mov    %esp,%ebp
80108302:	53                   	push   %ebx
80108303:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108306:	e8 ba a8 ff ff       	call   80102bc5 <kalloc>
8010830b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010830e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108312:	75 0a                	jne    8010831e <setupkvm+0x1f>
    return 0;
80108314:	b8 00 00 00 00       	mov    $0x0,%eax
80108319:	e9 8e 00 00 00       	jmp    801083ac <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
8010831e:	83 ec 04             	sub    $0x4,%esp
80108321:	68 00 10 00 00       	push   $0x1000
80108326:	6a 00                	push   $0x0
80108328:	ff 75 f0             	pushl  -0x10(%ebp)
8010832b:	e8 56 d3 ff ff       	call   80105686 <memset>
80108330:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108333:	83 ec 0c             	sub    $0xc,%esp
80108336:	68 00 00 00 0e       	push   $0xe000000
8010833b:	e8 0d fa ff ff       	call   80107d4d <p2v>
80108340:	83 c4 10             	add    $0x10,%esp
80108343:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108348:	76 0d                	jbe    80108357 <setupkvm+0x58>
    panic("PHYSTOP too high");
8010834a:	83 ec 0c             	sub    $0xc,%esp
8010834d:	68 8a 96 10 80       	push   $0x8010968a
80108352:	e8 0f 82 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108357:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
8010835e:	eb 40                	jmp    801083a0 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108360:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108363:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108366:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108369:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010836c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836f:	8b 58 08             	mov    0x8(%eax),%ebx
80108372:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108375:	8b 40 04             	mov    0x4(%eax),%eax
80108378:	29 c3                	sub    %eax,%ebx
8010837a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010837d:	8b 00                	mov    (%eax),%eax
8010837f:	83 ec 0c             	sub    $0xc,%esp
80108382:	51                   	push   %ecx
80108383:	52                   	push   %edx
80108384:	53                   	push   %ebx
80108385:	50                   	push   %eax
80108386:	ff 75 f0             	pushl  -0x10(%ebp)
80108389:	e8 e1 fe ff ff       	call   8010826f <mappages>
8010838e:	83 c4 20             	add    $0x20,%esp
80108391:	85 c0                	test   %eax,%eax
80108393:	79 07                	jns    8010839c <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108395:	b8 00 00 00 00       	mov    $0x0,%eax
8010839a:	eb 10                	jmp    801083ac <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010839c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801083a0:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
801083a7:	72 b7                	jb     80108360 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801083a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801083ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801083af:	c9                   	leave  
801083b0:	c3                   	ret    

801083b1 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801083b1:	55                   	push   %ebp
801083b2:	89 e5                	mov    %esp,%ebp
801083b4:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801083b7:	e8 43 ff ff ff       	call   801082ff <setupkvm>
801083bc:	a3 58 63 11 80       	mov    %eax,0x80116358
  switchkvm();
801083c1:	e8 03 00 00 00       	call   801083c9 <switchkvm>
}
801083c6:	90                   	nop
801083c7:	c9                   	leave  
801083c8:	c3                   	ret    

801083c9 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801083c9:	55                   	push   %ebp
801083ca:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801083cc:	a1 58 63 11 80       	mov    0x80116358,%eax
801083d1:	50                   	push   %eax
801083d2:	e8 69 f9 ff ff       	call   80107d40 <v2p>
801083d7:	83 c4 04             	add    $0x4,%esp
801083da:	50                   	push   %eax
801083db:	e8 54 f9 ff ff       	call   80107d34 <lcr3>
801083e0:	83 c4 04             	add    $0x4,%esp
}
801083e3:	90                   	nop
801083e4:	c9                   	leave  
801083e5:	c3                   	ret    

801083e6 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801083e6:	55                   	push   %ebp
801083e7:	89 e5                	mov    %esp,%ebp
801083e9:	56                   	push   %esi
801083ea:	53                   	push   %ebx
  pushcli();
801083eb:	e8 90 d1 ff ff       	call   80105580 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801083f0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083f6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801083fd:	83 c2 08             	add    $0x8,%edx
80108400:	89 d6                	mov    %edx,%esi
80108402:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108409:	83 c2 08             	add    $0x8,%edx
8010840c:	c1 ea 10             	shr    $0x10,%edx
8010840f:	89 d3                	mov    %edx,%ebx
80108411:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108418:	83 c2 08             	add    $0x8,%edx
8010841b:	c1 ea 18             	shr    $0x18,%edx
8010841e:	89 d1                	mov    %edx,%ecx
80108420:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108427:	67 00 
80108429:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108430:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108436:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010843d:	83 e2 f0             	and    $0xfffffff0,%edx
80108440:	83 ca 09             	or     $0x9,%edx
80108443:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108449:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108450:	83 ca 10             	or     $0x10,%edx
80108453:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108459:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108460:	83 e2 9f             	and    $0xffffff9f,%edx
80108463:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108469:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108470:	83 ca 80             	or     $0xffffff80,%edx
80108473:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108479:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108480:	83 e2 f0             	and    $0xfffffff0,%edx
80108483:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108489:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108490:	83 e2 ef             	and    $0xffffffef,%edx
80108493:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108499:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801084a0:	83 e2 df             	and    $0xffffffdf,%edx
801084a3:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801084a9:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801084b0:	83 ca 40             	or     $0x40,%edx
801084b3:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801084b9:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801084c0:	83 e2 7f             	and    $0x7f,%edx
801084c3:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801084c9:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801084cf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801084d5:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801084dc:	83 e2 ef             	and    $0xffffffef,%edx
801084df:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801084e5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801084eb:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801084f1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801084f7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801084fe:	8b 52 08             	mov    0x8(%edx),%edx
80108501:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108507:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010850a:	83 ec 0c             	sub    $0xc,%esp
8010850d:	6a 30                	push   $0x30
8010850f:	e8 f3 f7 ff ff       	call   80107d07 <ltr>
80108514:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80108517:	8b 45 08             	mov    0x8(%ebp),%eax
8010851a:	8b 40 04             	mov    0x4(%eax),%eax
8010851d:	85 c0                	test   %eax,%eax
8010851f:	75 0d                	jne    8010852e <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108521:	83 ec 0c             	sub    $0xc,%esp
80108524:	68 9b 96 10 80       	push   $0x8010969b
80108529:	e8 38 80 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
8010852e:	8b 45 08             	mov    0x8(%ebp),%eax
80108531:	8b 40 04             	mov    0x4(%eax),%eax
80108534:	83 ec 0c             	sub    $0xc,%esp
80108537:	50                   	push   %eax
80108538:	e8 03 f8 ff ff       	call   80107d40 <v2p>
8010853d:	83 c4 10             	add    $0x10,%esp
80108540:	83 ec 0c             	sub    $0xc,%esp
80108543:	50                   	push   %eax
80108544:	e8 eb f7 ff ff       	call   80107d34 <lcr3>
80108549:	83 c4 10             	add    $0x10,%esp
  popcli();
8010854c:	e8 74 d0 ff ff       	call   801055c5 <popcli>
}
80108551:	90                   	nop
80108552:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108555:	5b                   	pop    %ebx
80108556:	5e                   	pop    %esi
80108557:	5d                   	pop    %ebp
80108558:	c3                   	ret    

80108559 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108559:	55                   	push   %ebp
8010855a:	89 e5                	mov    %esp,%ebp
8010855c:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
8010855f:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108566:	76 0d                	jbe    80108575 <inituvm+0x1c>
    panic("inituvm: more than a page");
80108568:	83 ec 0c             	sub    $0xc,%esp
8010856b:	68 af 96 10 80       	push   $0x801096af
80108570:	e8 f1 7f ff ff       	call   80100566 <panic>
  mem = kalloc();
80108575:	e8 4b a6 ff ff       	call   80102bc5 <kalloc>
8010857a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010857d:	83 ec 04             	sub    $0x4,%esp
80108580:	68 00 10 00 00       	push   $0x1000
80108585:	6a 00                	push   $0x0
80108587:	ff 75 f4             	pushl  -0xc(%ebp)
8010858a:	e8 f7 d0 ff ff       	call   80105686 <memset>
8010858f:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108592:	83 ec 0c             	sub    $0xc,%esp
80108595:	ff 75 f4             	pushl  -0xc(%ebp)
80108598:	e8 a3 f7 ff ff       	call   80107d40 <v2p>
8010859d:	83 c4 10             	add    $0x10,%esp
801085a0:	83 ec 0c             	sub    $0xc,%esp
801085a3:	6a 06                	push   $0x6
801085a5:	50                   	push   %eax
801085a6:	68 00 10 00 00       	push   $0x1000
801085ab:	6a 00                	push   $0x0
801085ad:	ff 75 08             	pushl  0x8(%ebp)
801085b0:	e8 ba fc ff ff       	call   8010826f <mappages>
801085b5:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801085b8:	83 ec 04             	sub    $0x4,%esp
801085bb:	ff 75 10             	pushl  0x10(%ebp)
801085be:	ff 75 0c             	pushl  0xc(%ebp)
801085c1:	ff 75 f4             	pushl  -0xc(%ebp)
801085c4:	e8 7c d1 ff ff       	call   80105745 <memmove>
801085c9:	83 c4 10             	add    $0x10,%esp
}
801085cc:	90                   	nop
801085cd:	c9                   	leave  
801085ce:	c3                   	ret    

801085cf <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801085cf:	55                   	push   %ebp
801085d0:	89 e5                	mov    %esp,%ebp
801085d2:	53                   	push   %ebx
801085d3:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801085d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801085d9:	25 ff 0f 00 00       	and    $0xfff,%eax
801085de:	85 c0                	test   %eax,%eax
801085e0:	74 0d                	je     801085ef <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
801085e2:	83 ec 0c             	sub    $0xc,%esp
801085e5:	68 cc 96 10 80       	push   $0x801096cc
801085ea:	e8 77 7f ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801085ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801085f6:	e9 95 00 00 00       	jmp    80108690 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801085fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801085fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108601:	01 d0                	add    %edx,%eax
80108603:	83 ec 04             	sub    $0x4,%esp
80108606:	6a 00                	push   $0x0
80108608:	50                   	push   %eax
80108609:	ff 75 08             	pushl  0x8(%ebp)
8010860c:	e8 be fb ff ff       	call   801081cf <walkpgdir>
80108611:	83 c4 10             	add    $0x10,%esp
80108614:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108617:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010861b:	75 0d                	jne    8010862a <loaduvm+0x5b>
      panic("loaduvm: address should exist");
8010861d:	83 ec 0c             	sub    $0xc,%esp
80108620:	68 ef 96 10 80       	push   $0x801096ef
80108625:	e8 3c 7f ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010862a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010862d:	8b 00                	mov    (%eax),%eax
8010862f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108634:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108637:	8b 45 18             	mov    0x18(%ebp),%eax
8010863a:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010863d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108642:	77 0b                	ja     8010864f <loaduvm+0x80>
      n = sz - i;
80108644:	8b 45 18             	mov    0x18(%ebp),%eax
80108647:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010864a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010864d:	eb 07                	jmp    80108656 <loaduvm+0x87>
    else
      n = PGSIZE;
8010864f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108656:	8b 55 14             	mov    0x14(%ebp),%edx
80108659:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010865c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010865f:	83 ec 0c             	sub    $0xc,%esp
80108662:	ff 75 e8             	pushl  -0x18(%ebp)
80108665:	e8 e3 f6 ff ff       	call   80107d4d <p2v>
8010866a:	83 c4 10             	add    $0x10,%esp
8010866d:	ff 75 f0             	pushl  -0x10(%ebp)
80108670:	53                   	push   %ebx
80108671:	50                   	push   %eax
80108672:	ff 75 10             	pushl  0x10(%ebp)
80108675:	e8 f9 97 ff ff       	call   80101e73 <readi>
8010867a:	83 c4 10             	add    $0x10,%esp
8010867d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108680:	74 07                	je     80108689 <loaduvm+0xba>
      return -1;
80108682:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108687:	eb 18                	jmp    801086a1 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108689:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108693:	3b 45 18             	cmp    0x18(%ebp),%eax
80108696:	0f 82 5f ff ff ff    	jb     801085fb <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010869c:	b8 00 00 00 00       	mov    $0x0,%eax
}
801086a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801086a4:	c9                   	leave  
801086a5:	c3                   	ret    

801086a6 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801086a6:	55                   	push   %ebp
801086a7:	89 e5                	mov    %esp,%ebp
801086a9:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801086ac:	8b 45 10             	mov    0x10(%ebp),%eax
801086af:	85 c0                	test   %eax,%eax
801086b1:	79 0a                	jns    801086bd <allocuvm+0x17>
    return 0;
801086b3:	b8 00 00 00 00       	mov    $0x0,%eax
801086b8:	e9 b0 00 00 00       	jmp    8010876d <allocuvm+0xc7>
  if(newsz < oldsz)
801086bd:	8b 45 10             	mov    0x10(%ebp),%eax
801086c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086c3:	73 08                	jae    801086cd <allocuvm+0x27>
    return oldsz;
801086c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801086c8:	e9 a0 00 00 00       	jmp    8010876d <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
801086cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801086d0:	05 ff 0f 00 00       	add    $0xfff,%eax
801086d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801086dd:	eb 7f                	jmp    8010875e <allocuvm+0xb8>
    mem = kalloc();
801086df:	e8 e1 a4 ff ff       	call   80102bc5 <kalloc>
801086e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801086e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801086eb:	75 2b                	jne    80108718 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
801086ed:	83 ec 0c             	sub    $0xc,%esp
801086f0:	68 0d 97 10 80       	push   $0x8010970d
801086f5:	e8 cc 7c ff ff       	call   801003c6 <cprintf>
801086fa:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801086fd:	83 ec 04             	sub    $0x4,%esp
80108700:	ff 75 0c             	pushl  0xc(%ebp)
80108703:	ff 75 10             	pushl  0x10(%ebp)
80108706:	ff 75 08             	pushl  0x8(%ebp)
80108709:	e8 61 00 00 00       	call   8010876f <deallocuvm>
8010870e:	83 c4 10             	add    $0x10,%esp
      return 0;
80108711:	b8 00 00 00 00       	mov    $0x0,%eax
80108716:	eb 55                	jmp    8010876d <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80108718:	83 ec 04             	sub    $0x4,%esp
8010871b:	68 00 10 00 00       	push   $0x1000
80108720:	6a 00                	push   $0x0
80108722:	ff 75 f0             	pushl  -0x10(%ebp)
80108725:	e8 5c cf ff ff       	call   80105686 <memset>
8010872a:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010872d:	83 ec 0c             	sub    $0xc,%esp
80108730:	ff 75 f0             	pushl  -0x10(%ebp)
80108733:	e8 08 f6 ff ff       	call   80107d40 <v2p>
80108738:	83 c4 10             	add    $0x10,%esp
8010873b:	89 c2                	mov    %eax,%edx
8010873d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108740:	83 ec 0c             	sub    $0xc,%esp
80108743:	6a 06                	push   $0x6
80108745:	52                   	push   %edx
80108746:	68 00 10 00 00       	push   $0x1000
8010874b:	50                   	push   %eax
8010874c:	ff 75 08             	pushl  0x8(%ebp)
8010874f:	e8 1b fb ff ff       	call   8010826f <mappages>
80108754:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108757:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010875e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108761:	3b 45 10             	cmp    0x10(%ebp),%eax
80108764:	0f 82 75 ff ff ff    	jb     801086df <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
8010876a:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010876d:	c9                   	leave  
8010876e:	c3                   	ret    

8010876f <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010876f:	55                   	push   %ebp
80108770:	89 e5                	mov    %esp,%ebp
80108772:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108775:	8b 45 10             	mov    0x10(%ebp),%eax
80108778:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010877b:	72 08                	jb     80108785 <deallocuvm+0x16>
    return oldsz;
8010877d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108780:	e9 a5 00 00 00       	jmp    8010882a <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80108785:	8b 45 10             	mov    0x10(%ebp),%eax
80108788:	05 ff 0f 00 00       	add    $0xfff,%eax
8010878d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108792:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108795:	e9 81 00 00 00       	jmp    8010881b <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010879a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010879d:	83 ec 04             	sub    $0x4,%esp
801087a0:	6a 00                	push   $0x0
801087a2:	50                   	push   %eax
801087a3:	ff 75 08             	pushl  0x8(%ebp)
801087a6:	e8 24 fa ff ff       	call   801081cf <walkpgdir>
801087ab:	83 c4 10             	add    $0x10,%esp
801087ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801087b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801087b5:	75 09                	jne    801087c0 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
801087b7:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801087be:	eb 54                	jmp    80108814 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
801087c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087c3:	8b 00                	mov    (%eax),%eax
801087c5:	83 e0 01             	and    $0x1,%eax
801087c8:	85 c0                	test   %eax,%eax
801087ca:	74 48                	je     80108814 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
801087cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087cf:	8b 00                	mov    (%eax),%eax
801087d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801087d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801087dd:	75 0d                	jne    801087ec <deallocuvm+0x7d>
        panic("kfree");
801087df:	83 ec 0c             	sub    $0xc,%esp
801087e2:	68 25 97 10 80       	push   $0x80109725
801087e7:	e8 7a 7d ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
801087ec:	83 ec 0c             	sub    $0xc,%esp
801087ef:	ff 75 ec             	pushl  -0x14(%ebp)
801087f2:	e8 56 f5 ff ff       	call   80107d4d <p2v>
801087f7:	83 c4 10             	add    $0x10,%esp
801087fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801087fd:	83 ec 0c             	sub    $0xc,%esp
80108800:	ff 75 e8             	pushl  -0x18(%ebp)
80108803:	e8 20 a3 ff ff       	call   80102b28 <kfree>
80108808:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
8010880b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010880e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108814:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010881b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010881e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108821:	0f 82 73 ff ff ff    	jb     8010879a <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108827:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010882a:	c9                   	leave  
8010882b:	c3                   	ret    

8010882c <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010882c:	55                   	push   %ebp
8010882d:	89 e5                	mov    %esp,%ebp
8010882f:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108832:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108836:	75 0d                	jne    80108845 <freevm+0x19>
    panic("freevm: no pgdir");
80108838:	83 ec 0c             	sub    $0xc,%esp
8010883b:	68 2b 97 10 80       	push   $0x8010972b
80108840:	e8 21 7d ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108845:	83 ec 04             	sub    $0x4,%esp
80108848:	6a 00                	push   $0x0
8010884a:	68 00 00 00 80       	push   $0x80000000
8010884f:	ff 75 08             	pushl  0x8(%ebp)
80108852:	e8 18 ff ff ff       	call   8010876f <deallocuvm>
80108857:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010885a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108861:	eb 4f                	jmp    801088b2 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108863:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108866:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010886d:	8b 45 08             	mov    0x8(%ebp),%eax
80108870:	01 d0                	add    %edx,%eax
80108872:	8b 00                	mov    (%eax),%eax
80108874:	83 e0 01             	and    $0x1,%eax
80108877:	85 c0                	test   %eax,%eax
80108879:	74 33                	je     801088ae <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
8010887b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010887e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108885:	8b 45 08             	mov    0x8(%ebp),%eax
80108888:	01 d0                	add    %edx,%eax
8010888a:	8b 00                	mov    (%eax),%eax
8010888c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108891:	83 ec 0c             	sub    $0xc,%esp
80108894:	50                   	push   %eax
80108895:	e8 b3 f4 ff ff       	call   80107d4d <p2v>
8010889a:	83 c4 10             	add    $0x10,%esp
8010889d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801088a0:	83 ec 0c             	sub    $0xc,%esp
801088a3:	ff 75 f0             	pushl  -0x10(%ebp)
801088a6:	e8 7d a2 ff ff       	call   80102b28 <kfree>
801088ab:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801088ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801088b2:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801088b9:	76 a8                	jbe    80108863 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801088bb:	83 ec 0c             	sub    $0xc,%esp
801088be:	ff 75 08             	pushl  0x8(%ebp)
801088c1:	e8 62 a2 ff ff       	call   80102b28 <kfree>
801088c6:	83 c4 10             	add    $0x10,%esp
}
801088c9:	90                   	nop
801088ca:	c9                   	leave  
801088cb:	c3                   	ret    

801088cc <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801088cc:	55                   	push   %ebp
801088cd:	89 e5                	mov    %esp,%ebp
801088cf:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801088d2:	83 ec 04             	sub    $0x4,%esp
801088d5:	6a 00                	push   $0x0
801088d7:	ff 75 0c             	pushl  0xc(%ebp)
801088da:	ff 75 08             	pushl  0x8(%ebp)
801088dd:	e8 ed f8 ff ff       	call   801081cf <walkpgdir>
801088e2:	83 c4 10             	add    $0x10,%esp
801088e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801088e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801088ec:	75 0d                	jne    801088fb <clearpteu+0x2f>
    panic("clearpteu");
801088ee:	83 ec 0c             	sub    $0xc,%esp
801088f1:	68 3c 97 10 80       	push   $0x8010973c
801088f6:	e8 6b 7c ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
801088fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088fe:	8b 00                	mov    (%eax),%eax
80108900:	83 e0 fb             	and    $0xfffffffb,%eax
80108903:	89 c2                	mov    %eax,%edx
80108905:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108908:	89 10                	mov    %edx,(%eax)
}
8010890a:	90                   	nop
8010890b:	c9                   	leave  
8010890c:	c3                   	ret    

8010890d <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010890d:	55                   	push   %ebp
8010890e:	89 e5                	mov    %esp,%ebp
80108910:	53                   	push   %ebx
80108911:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108914:	e8 e6 f9 ff ff       	call   801082ff <setupkvm>
80108919:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010891c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108920:	75 0a                	jne    8010892c <copyuvm+0x1f>
    return 0;
80108922:	b8 00 00 00 00       	mov    $0x0,%eax
80108927:	e9 f8 00 00 00       	jmp    80108a24 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
8010892c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108933:	e9 c4 00 00 00       	jmp    801089fc <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108938:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010893b:	83 ec 04             	sub    $0x4,%esp
8010893e:	6a 00                	push   $0x0
80108940:	50                   	push   %eax
80108941:	ff 75 08             	pushl  0x8(%ebp)
80108944:	e8 86 f8 ff ff       	call   801081cf <walkpgdir>
80108949:	83 c4 10             	add    $0x10,%esp
8010894c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010894f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108953:	75 0d                	jne    80108962 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108955:	83 ec 0c             	sub    $0xc,%esp
80108958:	68 46 97 10 80       	push   $0x80109746
8010895d:	e8 04 7c ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108962:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108965:	8b 00                	mov    (%eax),%eax
80108967:	83 e0 01             	and    $0x1,%eax
8010896a:	85 c0                	test   %eax,%eax
8010896c:	75 0d                	jne    8010897b <copyuvm+0x6e>
      panic("copyuvm: page not present");
8010896e:	83 ec 0c             	sub    $0xc,%esp
80108971:	68 60 97 10 80       	push   $0x80109760
80108976:	e8 eb 7b ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010897b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010897e:	8b 00                	mov    (%eax),%eax
80108980:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108985:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108988:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010898b:	8b 00                	mov    (%eax),%eax
8010898d:	25 ff 0f 00 00       	and    $0xfff,%eax
80108992:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108995:	e8 2b a2 ff ff       	call   80102bc5 <kalloc>
8010899a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010899d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801089a1:	74 6a                	je     80108a0d <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801089a3:	83 ec 0c             	sub    $0xc,%esp
801089a6:	ff 75 e8             	pushl  -0x18(%ebp)
801089a9:	e8 9f f3 ff ff       	call   80107d4d <p2v>
801089ae:	83 c4 10             	add    $0x10,%esp
801089b1:	83 ec 04             	sub    $0x4,%esp
801089b4:	68 00 10 00 00       	push   $0x1000
801089b9:	50                   	push   %eax
801089ba:	ff 75 e0             	pushl  -0x20(%ebp)
801089bd:	e8 83 cd ff ff       	call   80105745 <memmove>
801089c2:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801089c5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801089c8:	83 ec 0c             	sub    $0xc,%esp
801089cb:	ff 75 e0             	pushl  -0x20(%ebp)
801089ce:	e8 6d f3 ff ff       	call   80107d40 <v2p>
801089d3:	83 c4 10             	add    $0x10,%esp
801089d6:	89 c2                	mov    %eax,%edx
801089d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089db:	83 ec 0c             	sub    $0xc,%esp
801089de:	53                   	push   %ebx
801089df:	52                   	push   %edx
801089e0:	68 00 10 00 00       	push   $0x1000
801089e5:	50                   	push   %eax
801089e6:	ff 75 f0             	pushl  -0x10(%ebp)
801089e9:	e8 81 f8 ff ff       	call   8010826f <mappages>
801089ee:	83 c4 20             	add    $0x20,%esp
801089f1:	85 c0                	test   %eax,%eax
801089f3:	78 1b                	js     80108a10 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801089f5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a02:	0f 82 30 ff ff ff    	jb     80108938 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a0b:	eb 17                	jmp    80108a24 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108a0d:	90                   	nop
80108a0e:	eb 01                	jmp    80108a11 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108a10:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108a11:	83 ec 0c             	sub    $0xc,%esp
80108a14:	ff 75 f0             	pushl  -0x10(%ebp)
80108a17:	e8 10 fe ff ff       	call   8010882c <freevm>
80108a1c:	83 c4 10             	add    $0x10,%esp
  return 0;
80108a1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108a24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108a27:	c9                   	leave  
80108a28:	c3                   	ret    

80108a29 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108a29:	55                   	push   %ebp
80108a2a:	89 e5                	mov    %esp,%ebp
80108a2c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108a2f:	83 ec 04             	sub    $0x4,%esp
80108a32:	6a 00                	push   $0x0
80108a34:	ff 75 0c             	pushl  0xc(%ebp)
80108a37:	ff 75 08             	pushl  0x8(%ebp)
80108a3a:	e8 90 f7 ff ff       	call   801081cf <walkpgdir>
80108a3f:	83 c4 10             	add    $0x10,%esp
80108a42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a48:	8b 00                	mov    (%eax),%eax
80108a4a:	83 e0 01             	and    $0x1,%eax
80108a4d:	85 c0                	test   %eax,%eax
80108a4f:	75 07                	jne    80108a58 <uva2ka+0x2f>
    return 0;
80108a51:	b8 00 00 00 00       	mov    $0x0,%eax
80108a56:	eb 29                	jmp    80108a81 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a5b:	8b 00                	mov    (%eax),%eax
80108a5d:	83 e0 04             	and    $0x4,%eax
80108a60:	85 c0                	test   %eax,%eax
80108a62:	75 07                	jne    80108a6b <uva2ka+0x42>
    return 0;
80108a64:	b8 00 00 00 00       	mov    $0x0,%eax
80108a69:	eb 16                	jmp    80108a81 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a6e:	8b 00                	mov    (%eax),%eax
80108a70:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a75:	83 ec 0c             	sub    $0xc,%esp
80108a78:	50                   	push   %eax
80108a79:	e8 cf f2 ff ff       	call   80107d4d <p2v>
80108a7e:	83 c4 10             	add    $0x10,%esp
}
80108a81:	c9                   	leave  
80108a82:	c3                   	ret    

80108a83 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108a83:	55                   	push   %ebp
80108a84:	89 e5                	mov    %esp,%ebp
80108a86:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108a89:	8b 45 10             	mov    0x10(%ebp),%eax
80108a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108a8f:	eb 7f                	jmp    80108b10 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108a91:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a94:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a99:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108a9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a9f:	83 ec 08             	sub    $0x8,%esp
80108aa2:	50                   	push   %eax
80108aa3:	ff 75 08             	pushl  0x8(%ebp)
80108aa6:	e8 7e ff ff ff       	call   80108a29 <uva2ka>
80108aab:	83 c4 10             	add    $0x10,%esp
80108aae:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108ab1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108ab5:	75 07                	jne    80108abe <copyout+0x3b>
      return -1;
80108ab7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108abc:	eb 61                	jmp    80108b1f <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ac1:	2b 45 0c             	sub    0xc(%ebp),%eax
80108ac4:	05 00 10 00 00       	add    $0x1000,%eax
80108ac9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108acf:	3b 45 14             	cmp    0x14(%ebp),%eax
80108ad2:	76 06                	jbe    80108ada <copyout+0x57>
      n = len;
80108ad4:	8b 45 14             	mov    0x14(%ebp),%eax
80108ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108ada:	8b 45 0c             	mov    0xc(%ebp),%eax
80108add:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108ae0:	89 c2                	mov    %eax,%edx
80108ae2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ae5:	01 d0                	add    %edx,%eax
80108ae7:	83 ec 04             	sub    $0x4,%esp
80108aea:	ff 75 f0             	pushl  -0x10(%ebp)
80108aed:	ff 75 f4             	pushl  -0xc(%ebp)
80108af0:	50                   	push   %eax
80108af1:	e8 4f cc ff ff       	call   80105745 <memmove>
80108af6:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108afc:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b02:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b08:	05 00 10 00 00       	add    $0x1000,%eax
80108b0d:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108b10:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108b14:	0f 85 77 ff ff ff    	jne    80108a91 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108b1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b1f:	c9                   	leave  
80108b20:	c3                   	ret    

80108b21 <seminit>:
// function to initiallize the semophore table (at booting time)
// You don't need call this seminit function!!

void
seminit(void)
{
80108b21:	55                   	push   %ebp
80108b22:	89 e5                	mov    %esp,%ebp
80108b24:	83 ec 18             	sub    $0x18,%esp
	int i, j;

	for(i = 0; i < NSEMS; ++i)
80108b27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b2e:	eb 7c                	jmp    80108bac <seminit+0x8b>
	{
		initlock(&sem[i].lock, "semaphore");
80108b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b33:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108b39:	05 00 01 00 00       	add    $0x100,%eax
80108b3e:	05 60 63 11 80       	add    $0x80116360,%eax
80108b43:	83 c0 08             	add    $0x8,%eax
80108b46:	83 ec 08             	sub    $0x8,%esp
80108b49:	68 7a 97 10 80       	push   $0x8010977a
80108b4e:	50                   	push   %eax
80108b4f:	e8 ad c8 ff ff       	call   80105401 <initlock>
80108b54:	83 c4 10             	add    $0x10,%esp
		sem[i].active = 0;
80108b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b5a:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108b60:	05 64 63 11 80       	add    $0x80116364,%eax
80108b65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		sem[i].value = 0;
80108b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b6e:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108b74:	05 60 63 11 80       	add    $0x80116360,%eax
80108b79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		for (j=0; j<MAX_WAITERS; j++)
80108b7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108b86:	eb 1a                	jmp    80108ba2 <seminit+0x81>
			sem[i].waiters[j] = -1; // HUFS
80108b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b8b:	6b d0 4f             	imul   $0x4f,%eax,%edx
80108b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b91:	01 d0                	add    %edx,%eax
80108b93:	c7 04 85 68 63 11 80 	movl   $0xffffffff,-0x7fee9c98(,%eax,4)
80108b9a:	ff ff ff ff 
	{
		initlock(&sem[i].lock, "semaphore");
		sem[i].active = 0;
		sem[i].value = 0;

		for (j=0; j<MAX_WAITERS; j++)
80108b9e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108ba2:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
80108ba6:	7e e0                	jle    80108b88 <seminit+0x67>
void
seminit(void)
{
	int i, j;

	for(i = 0; i < NSEMS; ++i)
80108ba8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108bac:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
80108bb0:	0f 8e 7a ff ff ff    	jle    80108b30 <seminit+0xf>

		for (j=0; j<MAX_WAITERS; j++)
			sem[i].waiters[j] = -1; // HUFS

	}
}
80108bb6:	90                   	nop
80108bb7:	c9                   	leave  
80108bb8:	c3                   	ret    

80108bb9 <sem_create>:

int
sem_create(int max)
{
80108bb9:	55                   	push   %ebp
80108bba:	89 e5                	mov    %esp,%ebp
80108bbc:	83 ec 18             	sub    $0x18,%esp
	int i;

	// find an entry is NOT active (not used)
	for (i=0; i<NSEMS; i++) {
80108bbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108bc6:	e9 ab 00 00 00       	jmp    80108c76 <sem_create+0xbd>
		acquire(&sem[i].lock);
80108bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bce:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108bd4:	05 00 01 00 00       	add    $0x100,%eax
80108bd9:	05 60 63 11 80       	add    $0x80116360,%eax
80108bde:	83 c0 08             	add    $0x8,%eax
80108be1:	83 ec 0c             	sub    $0xc,%esp
80108be4:	50                   	push   %eax
80108be5:	e8 39 c8 ff ff       	call   80105423 <acquire>
80108bea:	83 c4 10             	add    $0x10,%esp
		if (sem[i].active == 0) {
80108bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bf0:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108bf6:	05 64 63 11 80       	add    $0x80116364,%eax
80108bfb:	8b 00                	mov    (%eax),%eax
80108bfd:	85 c0                	test   %eax,%eax
80108bff:	75 4f                	jne    80108c50 <sem_create+0x97>
			sem[i].value = max;
80108c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c04:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108c0a:	8d 90 60 63 11 80    	lea    -0x7fee9ca0(%eax),%edx
80108c10:	8b 45 08             	mov    0x8(%ebp),%eax
80108c13:	89 02                	mov    %eax,(%edx)
			sem[i].active = 1; // mark it as used (will be)
80108c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c18:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108c1e:	05 64 63 11 80       	add    $0x80116364,%eax
80108c23:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			release(&sem[i].lock);
80108c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c2c:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108c32:	05 00 01 00 00       	add    $0x100,%eax
80108c37:	05 60 63 11 80       	add    $0x80116360,%eax
80108c3c:	83 c0 08             	add    $0x8,%eax
80108c3f:	83 ec 0c             	sub    $0xc,%esp
80108c42:	50                   	push   %eax
80108c43:	e8 42 c8 ff ff       	call   8010548a <release>
80108c48:	83 c4 10             	add    $0x10,%esp
			return i;
80108c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c4e:	eb 35                	jmp    80108c85 <sem_create+0xcc>
		}
		release(&sem[i].lock);
80108c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c53:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108c59:	05 00 01 00 00       	add    $0x100,%eax
80108c5e:	05 60 63 11 80       	add    $0x80116360,%eax
80108c63:	83 c0 08             	add    $0x8,%eax
80108c66:	83 ec 0c             	sub    $0xc,%esp
80108c69:	50                   	push   %eax
80108c6a:	e8 1b c8 ff ff       	call   8010548a <release>
80108c6f:	83 c4 10             	add    $0x10,%esp
sem_create(int max)
{
	int i;

	// find an entry is NOT active (not used)
	for (i=0; i<NSEMS; i++) {
80108c72:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108c76:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
80108c7a:	0f 8e 4b ff ff ff    	jle    80108bcb <sem_create+0x12>
			return i;
		}
		release(&sem[i].lock);
	}

	return -1;
80108c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108c85:	c9                   	leave  
80108c86:	c3                   	ret    

80108c87 <sem_destroy>:

int
sem_destroy(int num)
{
80108c87:	55                   	push   %ebp
80108c88:	89 e5                	mov    %esp,%ebp
80108c8a:	83 ec 08             	sub    $0x8,%esp
	// check if the entry is valid
	if(num < 0 || num > NSEMS)
80108c8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108c91:	78 06                	js     80108c99 <sem_destroy+0x12>
80108c93:	83 7d 08 20          	cmpl   $0x20,0x8(%ebp)
80108c97:	7e 07                	jle    80108ca0 <sem_destroy+0x19>
		return -1;
80108c99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108c9e:	eb 79                	jmp    80108d19 <sem_destroy+0x92>

	acquire(&sem[num].lock);
80108ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80108ca3:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108ca9:	05 00 01 00 00       	add    $0x100,%eax
80108cae:	05 60 63 11 80       	add    $0x80116360,%eax
80108cb3:	83 c0 08             	add    $0x8,%eax
80108cb6:	83 ec 0c             	sub    $0xc,%esp
80108cb9:	50                   	push   %eax
80108cba:	e8 64 c7 ff ff       	call   80105423 <acquire>
80108cbf:	83 c4 10             	add    $0x10,%esp
	// check if the entry is actived
	if(sem[num].active != 1)
80108cc2:	8b 45 08             	mov    0x8(%ebp),%eax
80108cc5:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108ccb:	05 64 63 11 80       	add    $0x80116364,%eax
80108cd0:	8b 00                	mov    (%eax),%eax
80108cd2:	83 f8 01             	cmp    $0x1,%eax
80108cd5:	74 07                	je     80108cde <sem_destroy+0x57>
		return -1;
80108cd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108cdc:	eb 3b                	jmp    80108d19 <sem_destroy+0x92>
	sem[num].active = 0;
80108cde:	8b 45 08             	mov    0x8(%ebp),%eax
80108ce1:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108ce7:	05 64 63 11 80       	add    $0x80116364,%eax
80108cec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	release(&sem[num].lock);
80108cf2:	8b 45 08             	mov    0x8(%ebp),%eax
80108cf5:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108cfb:	05 00 01 00 00       	add    $0x100,%eax
80108d00:	05 60 63 11 80       	add    $0x80116360,%eax
80108d05:	83 c0 08             	add    $0x8,%eax
80108d08:	83 ec 0c             	sub    $0xc,%esp
80108d0b:	50                   	push   %eax
80108d0c:	e8 79 c7 ff ff       	call   8010548a <release>
80108d11:	83 c4 10             	add    $0x10,%esp

	return 0;
80108d14:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d19:	c9                   	leave  
80108d1a:	c3                   	ret    

80108d1b <enqueue>:

/*
   You have to just fill up the following functions!!!
*/

int enqueue(struct semaphore *sem, int pid){
80108d1b:	55                   	push   %ebp
80108d1c:	89 e5                	mov    %esp,%ebp
80108d1e:	83 ec 10             	sub    $0x10,%esp
	int i;

	for (i=0; i<MAX_WAITERS; i++){
80108d21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80108d28:	eb 27                	jmp    80108d51 <enqueue+0x36>
		if (sem->waiters[i]==-1){
80108d2a:	8b 45 08             	mov    0x8(%ebp),%eax
80108d2d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80108d30:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80108d34:	83 f8 ff             	cmp    $0xffffffff,%eax
80108d37:	75 14                	jne    80108d4d <enqueue+0x32>
			sem->waiters[i] = pid;
80108d39:	8b 45 08             	mov    0x8(%ebp),%eax
80108d3c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80108d3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108d42:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
			return 0;
80108d46:	b8 00 00 00 00       	mov    $0x0,%eax
80108d4b:	eb 0f                	jmp    80108d5c <enqueue+0x41>
*/

int enqueue(struct semaphore *sem, int pid){
	int i;

	for (i=0; i<MAX_WAITERS; i++){
80108d4d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80108d51:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
80108d55:	7e d3                	jle    80108d2a <enqueue+0xf>
		if (sem->waiters[i]==-1){
			sem->waiters[i] = pid;
			return 0;
		}
	}
	return -1;
80108d57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108d5c:	c9                   	leave  
80108d5d:	c3                   	ret    

80108d5e <dequeue>:

int dequeue(struct semaphore *sem){
80108d5e:	55                   	push   %ebp
80108d5f:	89 e5                	mov    %esp,%ebp
80108d61:	83 ec 10             	sub    $0x10,%esp
	int i,pid;

	for (i=0; i<MAX_WAITERS; i++){
80108d64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80108d6b:	eb 2a                	jmp    80108d97 <dequeue+0x39>
		pid = sem->waiters[i];
80108d6d:	8b 45 08             	mov    0x8(%ebp),%eax
80108d70:	8b 55 fc             	mov    -0x4(%ebp),%edx
80108d73:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80108d77:	89 45 f8             	mov    %eax,-0x8(%ebp)
		if (pid!=-1){
80108d7a:	83 7d f8 ff          	cmpl   $0xffffffff,-0x8(%ebp)
80108d7e:	74 13                	je     80108d93 <dequeue+0x35>
			sem->waiters[i]=-1;
80108d80:	8b 45 08             	mov    0x8(%ebp),%eax
80108d83:	8b 55 fc             	mov    -0x4(%ebp),%edx
80108d86:	c7 44 90 08 ff ff ff 	movl   $0xffffffff,0x8(%eax,%edx,4)
80108d8d:	ff 
			return pid;
80108d8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108d91:	eb 0f                	jmp    80108da2 <dequeue+0x44>
}

int dequeue(struct semaphore *sem){
	int i,pid;

	for (i=0; i<MAX_WAITERS; i++){
80108d93:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80108d97:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
80108d9b:	7e d0                	jle    80108d6d <dequeue+0xf>
		if (pid!=-1){
			sem->waiters[i]=-1;
			return pid;
		}
	}
	return -1;
80108d9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108da2:	c9                   	leave  
80108da3:	c3                   	ret    

80108da4 <sem_wait>:

int
sem_wait(int num)
{
80108da4:	55                   	push   %ebp
80108da5:	89 e5                	mov    %esp,%ebp
80108da7:	83 ec 08             	sub    $0x8,%esp
	acquire(&sem[num].lock);
80108daa:	8b 45 08             	mov    0x8(%ebp),%eax
80108dad:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108db3:	05 00 01 00 00       	add    $0x100,%eax
80108db8:	05 60 63 11 80       	add    $0x80116360,%eax
80108dbd:	83 c0 08             	add    $0x8,%eax
80108dc0:	83 ec 0c             	sub    $0xc,%esp
80108dc3:	50                   	push   %eax
80108dc4:	e8 5a c6 ff ff       	call   80105423 <acquire>
80108dc9:	83 c4 10             	add    $0x10,%esp

	if(sem[num].active == 0) {
80108dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80108dcf:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108dd5:	05 64 63 11 80       	add    $0x80116364,%eax
80108dda:	8b 00                	mov    (%eax),%eax
80108ddc:	85 c0                	test   %eax,%eax
80108dde:	75 2c                	jne    80108e0c <sem_wait+0x68>
		release(&sem[num].lock);
80108de0:	8b 45 08             	mov    0x8(%ebp),%eax
80108de3:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108de9:	05 00 01 00 00       	add    $0x100,%eax
80108dee:	05 60 63 11 80       	add    $0x80116360,%eax
80108df3:	83 c0 08             	add    $0x8,%eax
80108df6:	83 ec 0c             	sub    $0xc,%esp
80108df9:	50                   	push   %eax
80108dfa:	e8 8b c6 ff ff       	call   8010548a <release>
80108dff:	83 c4 10             	add    $0x10,%esp
		return -1;
80108e02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e07:	e9 12 01 00 00       	jmp    80108f1e <sem_wait+0x17a>
	}

	sem[num].value--;
80108e0c:	8b 45 08             	mov    0x8(%ebp),%eax
80108e0f:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108e15:	05 60 63 11 80       	add    $0x80116360,%eax
80108e1a:	8b 00                	mov    (%eax),%eax
80108e1c:	8d 50 ff             	lea    -0x1(%eax),%edx
80108e1f:	8b 45 08             	mov    0x8(%ebp),%eax
80108e22:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108e28:	05 60 63 11 80       	add    $0x80116360,%eax
80108e2d:	89 10                	mov    %edx,(%eax)

	if (sem[num].value < 0){
80108e2f:	8b 45 08             	mov    0x8(%ebp),%eax
80108e32:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108e38:	05 60 63 11 80       	add    $0x80116360,%eax
80108e3d:	8b 00                	mov    (%eax),%eax
80108e3f:	85 c0                	test   %eax,%eax
80108e41:	0f 89 b0 00 00 00    	jns    80108ef7 <sem_wait+0x153>
		if (enqueue(&sem[num], proc->pid)==-1) {
80108e47:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108e4d:	8b 40 10             	mov    0x10(%eax),%eax
80108e50:	8b 55 08             	mov    0x8(%ebp),%edx
80108e53:	69 d2 3c 01 00 00    	imul   $0x13c,%edx,%edx
80108e59:	81 c2 60 63 11 80    	add    $0x80116360,%edx
80108e5f:	83 ec 08             	sub    $0x8,%esp
80108e62:	50                   	push   %eax
80108e63:	52                   	push   %edx
80108e64:	e8 b2 fe ff ff       	call   80108d1b <enqueue>
80108e69:	83 c4 10             	add    $0x10,%esp
80108e6c:	83 f8 ff             	cmp    $0xffffffff,%eax
80108e6f:	75 2c                	jne    80108e9d <sem_wait+0xf9>
			release(&sem[num].lock);
80108e71:	8b 45 08             	mov    0x8(%ebp),%eax
80108e74:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108e7a:	05 00 01 00 00       	add    $0x100,%eax
80108e7f:	05 60 63 11 80       	add    $0x80116360,%eax
80108e84:	83 c0 08             	add    $0x8,%eax
80108e87:	83 ec 0c             	sub    $0xc,%esp
80108e8a:	50                   	push   %eax
80108e8b:	e8 fa c5 ff ff       	call   8010548a <release>
80108e90:	83 c4 10             	add    $0x10,%esp
			return -1;
80108e93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e98:	e9 81 00 00 00       	jmp    80108f1e <sem_wait+0x17a>
		}
		sleep(&sem[num],&sem[num].lock);
80108e9d:	8b 45 08             	mov    0x8(%ebp),%eax
80108ea0:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108ea6:	05 00 01 00 00       	add    $0x100,%eax
80108eab:	05 60 63 11 80       	add    $0x80116360,%eax
80108eb0:	8d 50 08             	lea    0x8(%eax),%edx
80108eb3:	8b 45 08             	mov    0x8(%ebp),%eax
80108eb6:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108ebc:	05 60 63 11 80       	add    $0x80116360,%eax
80108ec1:	83 ec 08             	sub    $0x8,%esp
80108ec4:	52                   	push   %edx
80108ec5:	50                   	push   %eax
80108ec6:	e8 b4 bd ff ff       	call   80104c7f <sleep>
80108ecb:	83 c4 10             	add    $0x10,%esp
		// block(&sem[num].lock);

		release(&sem[num].lock);
80108ece:	8b 45 08             	mov    0x8(%ebp),%eax
80108ed1:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108ed7:	05 00 01 00 00       	add    $0x100,%eax
80108edc:	05 60 63 11 80       	add    $0x80116360,%eax
80108ee1:	83 c0 08             	add    $0x8,%eax
80108ee4:	83 ec 0c             	sub    $0xc,%esp
80108ee7:	50                   	push   %eax
80108ee8:	e8 9d c5 ff ff       	call   8010548a <release>
80108eed:	83 c4 10             	add    $0x10,%esp
		return 0;
80108ef0:	b8 00 00 00 00       	mov    $0x0,%eax
80108ef5:	eb 27                	jmp    80108f1e <sem_wait+0x17a>
	}
	else {
		release(&sem[num].lock);
80108ef7:	8b 45 08             	mov    0x8(%ebp),%eax
80108efa:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108f00:	05 00 01 00 00       	add    $0x100,%eax
80108f05:	05 60 63 11 80       	add    $0x80116360,%eax
80108f0a:	83 c0 08             	add    $0x8,%eax
80108f0d:	83 ec 0c             	sub    $0xc,%esp
80108f10:	50                   	push   %eax
80108f11:	e8 74 c5 ff ff       	call   8010548a <release>
80108f16:	83 c4 10             	add    $0x10,%esp
		return 0;
80108f19:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
80108f1e:	c9                   	leave  
80108f1f:	c3                   	ret    

80108f20 <sem_signal>:

int
sem_signal(int num)
{
80108f20:	55                   	push   %ebp
80108f21:	89 e5                	mov    %esp,%ebp
80108f23:	83 ec 18             	sub    $0x18,%esp
	acquire(&sem[num].lock);
80108f26:	8b 45 08             	mov    0x8(%ebp),%eax
80108f29:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108f2f:	05 00 01 00 00       	add    $0x100,%eax
80108f34:	05 60 63 11 80       	add    $0x80116360,%eax
80108f39:	83 c0 08             	add    $0x8,%eax
80108f3c:	83 ec 0c             	sub    $0xc,%esp
80108f3f:	50                   	push   %eax
80108f40:	e8 de c4 ff ff       	call   80105423 <acquire>
80108f45:	83 c4 10             	add    $0x10,%esp

	if(sem[num].active == 0)
80108f48:	8b 45 08             	mov    0x8(%ebp),%eax
80108f4b:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108f51:	05 64 63 11 80       	add    $0x80116364,%eax
80108f56:	8b 00                	mov    (%eax),%eax
80108f58:	85 c0                	test   %eax,%eax
80108f5a:	75 0a                	jne    80108f66 <sem_signal+0x46>
		return -1;
80108f5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f61:	e9 31 01 00 00       	jmp    80109097 <sem_signal+0x177>

	sem[num].value++;
80108f66:	8b 45 08             	mov    0x8(%ebp),%eax
80108f69:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108f6f:	05 60 63 11 80       	add    $0x80116360,%eax
80108f74:	8b 00                	mov    (%eax),%eax
80108f76:	8d 50 01             	lea    0x1(%eax),%edx
80108f79:	8b 45 08             	mov    0x8(%ebp),%eax
80108f7c:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108f82:	05 60 63 11 80       	add    $0x80116360,%eax
80108f87:	89 10                	mov    %edx,(%eax)
	if (sem[num].value<=0){
80108f89:	8b 45 08             	mov    0x8(%ebp),%eax
80108f8c:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108f92:	05 60 63 11 80       	add    $0x80116360,%eax
80108f97:	8b 00                	mov    (%eax),%eax
80108f99:	85 c0                	test   %eax,%eax
80108f9b:	0f 8f cf 00 00 00    	jg     80109070 <sem_signal+0x150>

		int pid = dequeue(&sem[num]);
80108fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80108fa4:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108faa:	05 60 63 11 80       	add    $0x80116360,%eax
80108faf:	83 ec 0c             	sub    $0xc,%esp
80108fb2:	50                   	push   %eax
80108fb3:	e8 a6 fd ff ff       	call   80108d5e <dequeue>
80108fb8:	83 c4 10             	add    $0x10,%esp
80108fbb:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if (pid == -1) {
80108fbe:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
80108fc2:	75 2c                	jne    80108ff0 <sem_signal+0xd0>
			release(&sem[num].lock);
80108fc4:	8b 45 08             	mov    0x8(%ebp),%eax
80108fc7:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108fcd:	05 00 01 00 00       	add    $0x100,%eax
80108fd2:	05 60 63 11 80       	add    $0x80116360,%eax
80108fd7:	83 c0 08             	add    $0x8,%eax
80108fda:	83 ec 0c             	sub    $0xc,%esp
80108fdd:	50                   	push   %eax
80108fde:	e8 a7 c4 ff ff       	call   8010548a <release>
80108fe3:	83 c4 10             	add    $0x10,%esp
			return -1;
80108fe6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108feb:	e9 a7 00 00 00       	jmp    80109097 <sem_signal+0x177>
		}

		// wakeup(&sem[num]);

		int ppid = wakeup_pid(pid, &sem[num].lock);
80108ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80108ff3:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80108ff9:	05 00 01 00 00       	add    $0x100,%eax
80108ffe:	05 60 63 11 80       	add    $0x80116360,%eax
80109003:	83 c0 08             	add    $0x8,%eax
80109006:	83 ec 08             	sub    $0x8,%esp
80109009:	50                   	push   %eax
8010900a:	ff 75 f4             	pushl  -0xc(%ebp)
8010900d:	e8 ed c2 ff ff       	call   801052ff <wakeup_pid>
80109012:	83 c4 10             	add    $0x10,%esp
80109015:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (ppid == -1) {
80109018:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
8010901c:	75 29                	jne    80109047 <sem_signal+0x127>
			release(&sem[num].lock);
8010901e:	8b 45 08             	mov    0x8(%ebp),%eax
80109021:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80109027:	05 00 01 00 00       	add    $0x100,%eax
8010902c:	05 60 63 11 80       	add    $0x80116360,%eax
80109031:	83 c0 08             	add    $0x8,%eax
80109034:	83 ec 0c             	sub    $0xc,%esp
80109037:	50                   	push   %eax
80109038:	e8 4d c4 ff ff       	call   8010548a <release>
8010903d:	83 c4 10             	add    $0x10,%esp
			return -1;
80109040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109045:	eb 50                	jmp    80109097 <sem_signal+0x177>
		}

		release(&sem[num].lock);
80109047:	8b 45 08             	mov    0x8(%ebp),%eax
8010904a:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80109050:	05 00 01 00 00       	add    $0x100,%eax
80109055:	05 60 63 11 80       	add    $0x80116360,%eax
8010905a:	83 c0 08             	add    $0x8,%eax
8010905d:	83 ec 0c             	sub    $0xc,%esp
80109060:	50                   	push   %eax
80109061:	e8 24 c4 ff ff       	call   8010548a <release>
80109066:	83 c4 10             	add    $0x10,%esp
        	return 0;
80109069:	b8 00 00 00 00       	mov    $0x0,%eax
8010906e:	eb 27                	jmp    80109097 <sem_signal+0x177>
	}
	else {
		release(&sem[num].lock);
80109070:	8b 45 08             	mov    0x8(%ebp),%eax
80109073:	69 c0 3c 01 00 00    	imul   $0x13c,%eax,%eax
80109079:	05 00 01 00 00       	add    $0x100,%eax
8010907e:	05 60 63 11 80       	add    $0x80116360,%eax
80109083:	83 c0 08             	add    $0x8,%eax
80109086:	83 ec 0c             	sub    $0xc,%esp
80109089:	50                   	push   %eax
8010908a:	e8 fb c3 ff ff       	call   8010548a <release>
8010908f:	83 c4 10             	add    $0x10,%esp
		return 0;
80109092:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
80109097:	c9                   	leave  
80109098:	c3                   	ret    
