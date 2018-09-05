from collatex import *
c = Collation()
c.add_plain_witness("A", "Hi, Elisa!")
c.add_plain_witness("B", "Bye, Elisa!")
t = collate(c)
print(t)
