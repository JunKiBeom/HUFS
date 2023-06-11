import random

class Player:
    cnt = 0 # 플레이어 수

    def __init__(self):
        Player.cnt += 1
        self.name = "Player " + str(Player.cnt)
        self.balance = 500000*4 + 100000* 10 + 50000*5
        self.loc = 0

class City:
    def __init__(self, name, owner, price, toll):
        self.name = name
        self.owner = owner
        self.price = price
        self.toll = toll
        self.observers = []

    def add_observer(self, observer):
        self.observers.append(observer)

    def remove_observer(self, observer):
        self.observers.remove(observer)

    def notify_observers(self):
        for observer in self.observers:
            observer.update(self)

    def update_owner(self, new_owner):
        print(f"{self.name}의 소유자가 {new_owner}로 변경되었습니다.")
        self.owner = new_owner
        self.notify_observers()


class CityBuilder:
    def __init__(self):
        self.name = None
        self.owner = None
        self.price = None
        self.toll = None
        self.room = []

    def set_name(self, name):
        self.name = name
        return self

    def set_owner(self, owner):
        self.owner = owner
        return self

    def set_price(self, price):
        self.price = price
        return self

    def set_toll(self, toll):
        self.toll = toll
        return self

    def build(self):
        city = City(self.name, self.owner, self.price, self.toll)
        return city


class OwnerObserver:
    def update(self, city):
        print(f"{city.name}이(가) 구매되었습니다! 소유자: {city.owner}")


cityList = ["출발", "타이페이", "황금열쇠", "홍콩", "마닐라", "제주도", "싱가폴", "황금열쇠", "카이로", "이스탄불", "무인도",
            "아테네", "황금열쇠", "코펜하겐", "스톡홀름", "콩코드여객기", "취리히", "황금열쇠", "베를린", "몬트리올", "사회복지기금 접수처",
            "부에노스 아이레스", "황금열쇠", "상파울로", "시드니", "부산", "하와이", "리스본", "퀸 엘리자베스호", "마드리드", "우주여행",
            "도오쿄오", "콜럼비아호", "파리", "로마", "황금열쇠", "런던", "뉴욕", "사회복지기금 15만원", "서울올림픽"]

priceList = [0, 5, 0, 8, 8, 20, 10, 0, 10, 12, 0, 14, 0, 16, 16, 20, 18, 0, 18, 20, 0,
             22, 0, 24, 24, 50, 26, 26, 30, 28, 0, 30, 45, 32, 32, 0, 35, 35, 15, 100]

# CityBuilder를 사용하여 City 객체 및 전체 맵 생성
builder = CityBuilder()
game_map = []

# Observer 객체 생성
observer = OwnerObserver()

for i in range(len(cityList)):
    city_name = cityList[i]
    city_price = priceList[i]

    if city_name:
        city = builder.set_name(city_name) \
                      .set_owner(None) \
                      .set_price(city_price) \
                      .set_toll(city_price * 0.1) \
                      .build()

        city.add_observer(observer)  # Observer 등록
        game_map.append(city)

# City 소유자 변경 및 Observer에게 알림
game_map[1].update_owner("John Doe")
game_map[25].update_owner("Yeonni")