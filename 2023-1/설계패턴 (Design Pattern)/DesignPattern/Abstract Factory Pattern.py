# Button abstract(interface)
class Button:
    def click(self):
        pass

class DarkButton(Button):
    def click(self):
        print("dark click")

class LightButton(Button):
    def click(self):
        print("light click")

class RedButton(Button):
    def click(self):
        print("red click")

class BlueButton(Button):
    def click(self):
        print("blue click")


# Scrollbar abstract(interface)
class ScrollBar:
    def scroll(self):
        pass

class DarkScrollBar(ScrollBar):
    def scroll(self):
        print("dark scroll")

class LightScrollBar(ScrollBar):
    def scroll(self):
        print("light scroll")

class RedScrollBar(ScrollBar):
    def scroll(self):
        print("red scroll")

class BlueScrollBar(ScrollBar):
    def scroll(self):
        print("blue scroll")


# Checkbox abstract(interface)
class CheckBox:
    def check(self):
        pass

class DarkCheckBox(CheckBox):
    def check(self):
        print("dark check")

class LightCheckBox(CheckBox):
    def check(self):
        print("light check")

class RedCheckBox(CheckBox):
    def check(self):
        print("red check")

class BlueCheckBox(CheckBox):
    def check(self):
        print("blue check")


# Slider abstract(interface)
class Slider:
    def slide(self):
        pass
class DarkSlider(Slider):
    def slide(self):
        print("dark slider")

class LightSlider(Slider):
    def slide(self):
        print("light slider")

class RedSlider(Slider):
    def slide(self):
        print("red slider")

class BlueSlider(Slider):
    def slide(self):
        print("blue slider")


# TextBox abstract(interface)
class TextBox:
    def text(self):
        pass

class DarkTextBox(TextBox):
    def text(self):
        print("dark text")

class LightTextBox(TextBox):
    def text(self):
        print("light text")

class RedTextBox(TextBox):
    def text(self):
        print("red text")

class BlueTextBox(TextBox):
    def text(self):
        print("blue text")


# UIFactory Abstract(interface)
class UIFactory:
    def getButton(self):
        pass

    def getScrollBar(self):
        pass

    def getCheckBox(self):
        pass

    def getSlider(self):
        pass

    def getTextBox(self):
        pass

class DarkFactory(UIFactory):
    def getButton(self):
        return DarkButton()

    def getScrollBar(self):
        return DarkScrollBar()

    def getCheckBox(self):
        return DarkCheckBox()

    def getSlider(self):
        return DarkSlider()

    def getTextBox(self):
        return DarkTextBox()

class LightFactory(UIFactory):
    def getButton(self):
        return LightButton()

    def getScrollBar(self):
        return LightScrollBar()

    def getCheckBox(self):
        return LightCheckBox()

    def getSlider(self):
        return LightSlider()

    def getTextBox(self):
        return LightTextBox()

class RedFactory(UIFactory):
    def getButton(self):
        return RedButton()

    def getScrollBar(self):
        return RedScrollBar()

    def getCheckBox(self):
        return RedCheckBox()

    def getSlider(self):
        return RedSlider()

    def getTextBox(self):
        return RedTextBox()

class BlueFactory(UIFactory):
    def getButton(self):
        return BlueButton()

    def getScrollBar(self):
        return BlueScrollBar()

    def getCheckBox(self):
        return BlueCheckBox()

    def getSlider(self):
        return BlueSlider()

    def getTextBox(self):
        return BlueTextBox()

# darkTheme UI
dark_factory = DarkFactory()
dark_btn = dark_factory.getButton()
dark_scrollBar = dark_factory.getScrollBar()
dark_checkBox = dark_factory.getCheckBox()
dark_slider = dark_factory.getSlider()
dark_textBox = dark_factory.getTextBox()

dark_btn.click()
dark_scrollBar.scroll()
dark_checkBox.check()
dark_slider.slide()
dark_textBox.text()

print() # \n
# lightTheme UI
light_factory = LightFactory()
light_btn = light_factory.getButton()
light_scrollBar = light_factory.getScrollBar()
light_checkBox = light_factory.getCheckBox()
light_slider = light_factory.getSlider()
light_textBox = light_factory.getTextBox()

light_btn.click()
light_scrollBar.scroll()
light_checkBox.check()
light_slider.slide()
light_textBox.text()

print() # \n
# redTheme UI
red_factory = RedFactory()
red_btn = red_factory.getButton()
red_scrollBar = red_factory.getScrollBar()
red_checkBox = red_factory.getCheckBox()
red_slider = red_factory.getSlider()
red_textBox = red_factory.getTextBox()

red_btn.click()
red_scrollBar.scroll()
red_checkBox.check()
red_slider.slide()
red_textBox.text()

print() # \n
# blueTheme UI
blue_factory = BlueFactory()
blue_btn = blue_factory.getButton()
blue_scrollBar = blue_factory.getScrollBar()
blue_checkBox = blue_factory.getCheckBox()
blue_slider = blue_factory.getSlider()
blue_textBox = blue_factory.getTextBox()

blue_btn.click()
blue_scrollBar.scroll()
blue_checkBox.check()
blue_slider.slide()
blue_textBox.text()