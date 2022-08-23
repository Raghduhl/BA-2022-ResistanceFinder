import os,sys

def count(items):
	counts = dict()
	for i in items:
		counts[i] = counts.get(i, 0) + 1
	return counts


file = open(sys.argv[1] + '/Spezies.txt', 'r')
lines = file.read()
lines=lines.splitlines()
SpeciesList = []
for index, line in enumerate(lines):
	if line.startswith("Taxon:"):
		test = lines[index + 1].replace("Support:","")
		test = test.replace("%","")
		if int(test) > 50:
				SpeciesList.append(lines[index].replace("Taxon:",""))
file.close()
with open(sys.argv[1] + '/Spezies_Count.csv', 'a+') as file:
	for i, k in count(SpeciesList).items():
		file.write(i + ',' + str(k))
		file.write(os.linesep)
        
