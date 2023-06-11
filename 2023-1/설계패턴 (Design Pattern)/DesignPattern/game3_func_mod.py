import pygame
import MyVector as mv #vector 클래스

rgb = {
    'BLACK':(0, 0, 0),
    'WHITE':(255, 255, 255),
    'BLUE':(0, 0, 255),
    'GREEN':(0, 255, 0),
    'RED':(255, 0, 0),
    'YELLOW':(255,255,0) # YELLOW 게임을 위해 추가
} # 딕셔너리 타임

# Implementor
class Actor:

    def __init__(self, x, y):
        self.pos = mv.MyVector(x, y)
        self.name = ""
        self.skill = ""

    def setPos(self, x, y):
        self.pos.x = x
        self.pos.y = y

    def move(self, delta):
        self.pos = self.pos + delta
    
    def setName(self, name):
        self.name = name
    
    def setSkill(self, skill):
        pass

# Concrete Implementor 1
class Hero(Actor):

    def setSkill(self, skill):
        self.skill = skill

# Concrete Implementor 2
class Enermy(Actor):

    def setSkill(self, skill):
        self.skill = skill

# Concrete Implementor 3
class NPC(Actor):
    def setQuest(self, quest):
        self.skill = quest

# Abstraction
class GameFramework:

    def __init__(self):
        self.pygame = pygame
        self.screen = 0

        self.nY = 0 # 스크린의 크기를 담당 
        self.nX = 0

        self.hero = 0 #기능을 실제로 수행하는 위임자가 존재한다.

        print("init")

    def setDisplay(self, nX, nY): 
        self.nY = nY
        self.nX = nX
        self.screen = self.pygame.display.set_mode([self.nX, self.nY])
        self.pygame.display.set_caption("Prince") #게임창의 이름


    def setHero(self, hero:Actor):
        self.hero = hero

    def ready(self):
        self.pygame.init() #pygame 초기화

    def drawPolygon(self, color, points, thickness):
        self.pygame.draw.polygon(self.screen, color, points, thickness)

    def drawEdges(self):
        p1 = mv.MyVector(0, 0)
        p2 = mv.MyVector(0, 10)
        p3 = mv.MyVector(10, 0)
        
        self.drawPolygon(rgb["WHITE"], [p1.vec(), p2.vec(), p3.vec()], 1)

    def printText(self, msg, color, pos):
        font= self.pygame.font.SysFont("consolas",20)
        textSurface     = font.render(msg,True, color, None) #self.pygame.Color(color)
        textRect        = textSurface.get_rect()
        textRect.topleft= pos
        self.screen.blit(textSurface, textRect)

    #게임 실행
    def launch(self):
        pass


# Modified Refind Abstraction
class Game(GameFramework):
    def __init__(self, color):
        super().__init__()
        self.color = color

    def launch(self):
        print("launch")
        clock = self.pygame.time.Clock()
  
        delta = mv.MyVector(0, 0)

        keyFlag = None

        done = False
        while not done: 
            clock.tick(60) #set on 30 frames per second

            for event in self.pygame.event.get():
                if event.type == self.pygame.QUIT: #alt + f4
                    print("종료")
                    done = True

                elif event.type == self.pygame.KEYDOWN: #키를 눌렀을때
                    print("key down")
                    if event.key == self.pygame.K_LEFT: #어떤키가 눌렸는가?
                        print("K_LEFT")
                        delta.x = -5
                    elif event.key == self.pygame.K_RIGHT:
                        print("K_RIGHT")
                        delta.x = 5
                    elif event.key == self.pygame.K_DOWN:
                        print("K_DOWN")
                        delta.y = 5
                    elif event.key == self.pygame.K_UP:
                        print("K_UP")
                        delta.y = -5

                    keyFlag = True

                elif event.type == self.pygame.KEYUP:
                    delta.setPos(0, 0)
                    print("key up")
                    keyFlag = False


            if keyFlag == True:

                self.hero.move(delta) #주인공의 위치가 업데이트가 됨

                print("pressed", self.hero.pos.getState()) #in console
                self.screen.fill(rgb[self.color.upper()]) #특성을 살린 부분
                # 소문자로 입력이 되는 경우 Dict의 key는 대문자라 모두 문자열이 대문자로 치환하게 upper()를 사용
                self.printText(self.hero.name, rgb["RED"], self.hero.pos.vec()) 
                self.printText(self.hero.skill, rgb["GREEN"], (self.hero.pos + mv.MyVector(0, 15)).vec())

            self.pygame.display.flip()

        self.pygame.quit()



game = Game("white")
game.ready()
game.setDisplay(500, 500)
# game.drawEdges()

hero = Hero(0, 0)
hero.setName("prince")
hero.setSkill("swing a sword")

monster = Enermy(50, 50)
monster.setName("JunKiBeom")
monster.setSkill("201703091")

npc = NPC(100,100)
npc.setName("Akara")
npc.setQuest("Den of Evil")

# game.setHero(npc)
game.setHero(monster)

game.launch()






