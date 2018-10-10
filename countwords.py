import re

with open("paper.md") as f:
  text=f.read()
text=text.split("...")[1]

count = len(re.findall(r'\w+', text))
print(count)
