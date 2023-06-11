class Cat:
    def __init__(self, height, weight, color):
        self.height = height
        self.weight = weight
        self.color = color

    def print(self):
        return print(f"{self.height}cm,{self.weight}kg,{self.color}")


class CatBuilder:
    def __init__(self):
        self.height = None
        self.weight = None
        self.color = None

    def setHeight(self, height):
        self.height = height
        return self

    def setWeight(self, weight):
        self.weight = weight
        return self

    def setColor(self, color):
        self.color = color
        return self

    def build(self):
        cat = Cat(self.height, self.weight, self.color)
        return cat


cat_builder = CatBuilder()
cat_builder.setHeight(30)
cat_builder.setWeight(7)
cat_builder.setColor("black")
cat = cat_builder.build()
cat.print()
