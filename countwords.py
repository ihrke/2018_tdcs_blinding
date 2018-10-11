import re

with open("paper.md") as f:
  text=f.read()
text=text.split("...")[1]

text=re.sub("<!--.+?-->", "", text, flags=re.DOTALL)

count = len(re.findall(r'\w+', text))
print(count)
