f = open("words.txt", "r")
output = open("words.dart", "a")
for line in f:
    string = line[:-1]
    output.write('"' + string + '"' + ", " + "\n")
