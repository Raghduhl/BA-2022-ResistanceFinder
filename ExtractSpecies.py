import sys,os
Speciesfinder = sys.argv[1]

with open(Speciesfinder, 'r') as file:
	lines = file.read()
	lines=lines.splitlines()
	for index, line in enumerate(lines):
		if line.startswith("Taxon:"):
			test = lines[index + 1].replace("Support:","")
			test = test.replace("%","")
			if int(test) > 50:
				print(lines[index].replace("Taxon:","").replace(" ","_"))
