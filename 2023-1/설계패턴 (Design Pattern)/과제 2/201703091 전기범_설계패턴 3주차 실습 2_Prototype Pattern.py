import copy
from abc import *


class Character(metaclass = ABCMeta):
    def __init__(self, name, strength, dexterity, vitality, energy, skills):
        self.name = name
        self.strength = strength
        self.dexterity = dexterity
        self.vitality = vitality
        self.energy = energy
        self.skills = []+skills

    @abstractmethod
    def use_skill(self):
        pass

    @abstractmethod
    def clone(self):
        pass


class Warrior(Character):
    def __init__(self, name, strength, dexterity, vitality, energy, skills):
        super().__init__(name, strength, dexterity, vitality, energy, skills)

    def use_skill(self, skill):
        if skill == "Zeal":
            print(f"{self.name} Swing!")
        elif skill in self.skills:
            print(f"{self.name} use {skill}.")
        else:
            print(f"{self.name} doesn't have {skill}.")

    def clone(self):
        return copy.deepcopy(self)


class Rogue(Character):
    def __init__(self, name, strength, dexterity, vitality, energy, skills):
        super().__init__(name, strength, dexterity, vitality, energy, skills)

    def use_skill(self, skill):
        if skill == "Magic Arrow":
            print(f"{self.name} Magic Arrow!")
        elif skill in self.skills:
            print(f"{self.name} use {skill}.")
        else:
            print(f"{self.name} doesn't have {skill}.")

    def clone(self):
        return copy.deepcopy(self)


class Sorcerer(Character):
    def __init__(self, name, strength, dexterity, vitality, energy, skills):
        super().__init__(name, strength, dexterity, vitality, energy, skills)

    def use_skill(self, skill):
        if skill == "Fire Ball":
            print(f"{self.name} Fire!")
        elif skill in self.skills:
            print(f"{self.name} use {skill}.")
        else:
            print(f"{self.name} doesn't have {skill}.")

    def clone(self):
        return copy.deepcopy(self)


class CharacterManager:
    def __init__(self):
        self.characters = {}

    def add_character(self, name: str, proto: Character):
        self.characters[name] = proto

    def get_character(self, protoName):
        print(f"Name: {protoName.name}, Strength: {protoName.strength}, Dexterity: {protoName.dexterity},"
              f" Vitality: {protoName.vitality}, Energy: {protoName.energy}")
        print("Skills:", ", ".join(protoName.skills))
        print()

    def create_character(self, protoName):
        char = self.characters[protoName]
        return char.clone()


# name, strength, dexterity, vitality, energy, skills
manager = CharacterManager()
warrior1 = Warrior("Prince Aidan", 75, 25, 75, 25, ["Zeal", "Holy Shield"])
sorcerer1 = Sorcerer("Jazreth", 35, 35, 75, 55, ["Fire Ball", "Mana Shield"])
rouge1 = Rogue("Moreina", 45, 75, 55, 25, ["Magic Arrow", "Inner Sight"])

manager.add_character("Warrior", warrior1)
manager.add_character("Sorcerer", sorcerer1)
manager.add_character("Rogue", rouge1)

warrior1 = manager.create_character("Warrior")
sorcerer1 = manager.create_character("Sorcerer")

manager.get_character(warrior1)
manager.get_character(sorcerer1)

warrior1.use_skill("Zeal")
warrior1.use_skill("Magic Arrow")
print()

sorcerer1.use_skill("Fire Ball")
sorcerer1.use_skill("Holy Shield")
print()

rouge1 = manager.create_character("Rogue")
manager.get_character(rouge1)

rouge1.use_skill("Inner Sight")
rouge1.use_skill("Fire Arrow")
print()

sorcerer2 = Sorcerer("Zep", 30, 40, 80, 50, ["Fire Wall", "Mana Storm"])
manager.add_character("Sorcerer", sorcerer2)
sorcerer2 = manager.create_character("Sorcerer")
manager.get_character(sorcerer2)
sorcerer2.use_skill("Fire Wall")
sorcerer2.use_skill("Mana Storm")