class Animal():
    def speak(self):
        pass

class Cat(Animal):
    def speak(self):
        print("meow")

class Dog(Animal):
    def speak(self):
        print("bark")

# # Enum 사용 추천
# def Factoryfn(animal:str) -> Animal:
#     if animal == "Cat":
#         return Cat()
#     elif animal == "Dog":
#         return Dog()
#
# cat = Factoryfn("Cat")
# cat.speak()
# dog = Factoryfn("Dog")
# dog.speak()

class AnimalFactory():
    #enum
    def createAnimal(self,animal:str) -> Animal :
        if animal == "Cat":
            return Cat()
        elif animal == "Dog":
            return Dog()

facoty = AnimalFactory()
cat = facoty.createAnimal("Cat")
dog = facoty.createAnimal("Dog")
cat.speak()
dog.speak()