collatexfrom collatex import *
c = Collation()
c.add_plain_witness("A", "Hi, Mia and Jackie!")
c.add_plain_witness("B", "Bye, Jackie and Mia!")
t = collate(c)
print(t)




