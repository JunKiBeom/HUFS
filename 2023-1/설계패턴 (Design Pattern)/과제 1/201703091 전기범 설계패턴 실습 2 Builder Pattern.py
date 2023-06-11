import random

# Product
class Actor:
    def __init__(self, x, y, vital, agi, strength):
        self.x = x
        self.y = y

        self.vitality = vital
        self.agility = agi
        self.strength = strength

    def getPosition(self):
        return self.x, self.y

    def getInfo(self):
        return self.vitality, self.agility, self.strength

class Hero(Actor):
    def __init__(self, x, y, vital, agi, strength, skill, level, money, weapon, armour, job):
        super().__init__(x, y, vital, agi, strength)

        self.skill = skill
        self.level = level
        self.money = money
        self.weapon = weapon
        self.armour = armour
        self.job = job

    def printState(self):
        print("새로운 " + self.job + " 이(가) 태어났습니다.")
        print("착용 중인 아이템은 " + self.weapon + ", " + self.armour + "입니다.")

    def action(self):
        print(self.skill + "기술을 사용했습니다.")

    def levelUp(self):
        self.level += 1
        self.vitality += 1
        self.agility += 1
        self.strength += 1

    def getHero(self):
        return self.skill, self.level, self.money, self.weapon, self.armour, self.job

class Monster(Actor):
    def __init__(self, x, y, vital, agi, strength, residence, color, itemDropRate):
        super().__init__(x, y, vital, agi, strength)

        self.residence = residence
        self.color = color
        self.itemDropRate = itemDropRate

    def printState(self):
        print(self.residence + " 지역에서 몬스터 출몰")

    def getMonster(self):
        return self.residence, self.color, self.itemDropRate

# Builder
class ActorBuilder:
    def __init__(self):
        self.x = None
        self.y = None

        self.vitality = None
        self.agility = None
        self.strength = None

    # Setter
    def setX(self, x):
        self.x = max(0, min(x, 100))
        return self

    def setY(self, y):
        self.y = max(0, min(y, 100))
        return self

    def setVitality(self, vital):
        self.vitality = vital
        return self

    def setAgility(self, agi):
        self.agility = agi
        return self

    def setStrength(self, strength):
        self.strength = strength
        return self

# Concrete Builder
class HeroBuilder(ActorBuilder):
    def __init__(self):
        super().__init__()
        self.skill = None
        self.level = None
        self.money = None
        self.weapon = None
        self.armour = None
        self.job = None

    # Setter
    def setSkill(self, skill):
        self.skill = skill
        return self

    def setLevel(self, level):
        self.level = level
        return self

    def setMoney(self, money):
        self.money = money
        return self

    def setWeapon(self, weapon):
        self.weapon = weapon
        return self

    def setArmour(self, armour):
        self.armour = armour
        return self

    def setJob(self, job):
        self.job = job
        return self

    def heroBuild(self):
        hero = Hero(self.x, self.y, self.vitality, self.agility, self.strength,
                    self.skill, self.level, self.money, self.weapon, self.armour, self.job)
        return hero

class MonsterBuilder(ActorBuilder):
    def __init__(self):
        super().__init__()
        self.residence = None
        self.color = None
        self.itemDropRate = None

    # Setter
    def setResidence(self, residence):
        self.residence = residence
        return self

    def setColor(self, color):
        self.color = color
        return self

    def setItemDropRate(self, itemDropRate):
        self.itemDropRate = itemDropRate
        return self

    def monsterBuilder(self):
        self.x = random.randint(0, 100)
        self.y = random.randint(0, 100)
        self.vitality = random.randint(50, 100)
        self.agility = random.randint(50, 100)
        self.strength = random.randint(50, 100)

        monster = Monster(self.x, self.y, self.vitality, self.agility, self.strength,
                          self.residence, self.color, self.itemDropRate)
        return monster

# Director(preset)
class Director:
    def monster(builder:MonsterBuilder):
        builder.setX(random.randint(0, 100))
        builder.setY(random.randint(0, 100))
        builder.setVitality(random.randint(50, 100))
        builder.setAgility(random.randint(50, 100))
        builder.setStrength(random.randint(50, 100))

# Client
hero1 = HeroBuilder().setX(-49).setY(140).setVitality(80).setAgility(400).setStrength(108).\
    setJob("아마존").setWeapon("그랜드 메이트런 보우").setArmour("와이어 플리스").heroBuild()
hero1.printState()
print("주인공1의 위치", hero1.getPosition())
print("주인공1의 상태", hero1.getInfo(), hero1.getHero(),"\n")

hero2 = HeroBuilder().setX(95).setY(10).setVitality(420).setAgility(50).setStrength(156)\
    .setLevel(80).setSkill("연쇄 번개").setMoney(302445).setJob("원소술사").setWeapon("엘드리치 오브").setArmour("웜하이드")\
    .heroBuild()
hero2.printState()
print("주인공2의 위치", hero2.getPosition())
print("주인공2의 상태", hero2.getInfo(), hero2.getHero())
hero2.action()
hero2.levelUp()
print("주인공2의 상태", hero2.getInfo(), hero2.getHero(),"\n")

monster1 = MonsterBuilder().setResidence("불길의 강").monsterBuilder()
monster1.printState()
print("몬스터1의 위치", monster1.getPosition())
print("몬스터1의 상태", monster1.getInfo(), monster1.getMonster(),"\n")

monster2 = MonsterBuilder().setResidence("평원 외곽").setColor("파랑").setItemDropRate(4.5).monsterBuilder()
monster2.printState()
print("몬스터2의 위치", monster2.getPosition())
print("몬스터2의 상태", monster2.getInfo(), monster2.getMonster(),"\n")

# Client (using Director(Preset))
preset1 = MonsterBuilder()
Director.monster(preset1)
monster3 = preset1.setResidence("매장지").setItemDropRate(7.8).monsterBuilder()
monster3.printState()
print("몬스터3의 위치", monster3.getPosition())
print("몬스터3의 상태", monster3.getInfo(), monster3.getMonster(),"\n")