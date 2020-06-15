import json

csvf = open("mnist_handwritten_train.csv", "w")
with open("mnist_handwritten_train.json", "r") as jsonf:
  json = json.loads(jsonf.read())
  for obj in json:
    # print(str(obj['label']))
    # print(','.join(str(i) for i in obj['image']))
    csvf.write(str(obj['label'])+'\n')
    csvf.write(','.join(str(i) for i in obj['image'])+'\n')

