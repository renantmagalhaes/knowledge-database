import json 
from faker import Faker
import random
from random import randint
fake = Faker('en_US')
for _ in range(10):
        my_dict = {    'foo': randint(0, 100),    'bar': {'baz': fake.name(),       'poo': float(random.randrange(155, 389))/100   } }
        print(my_dict)