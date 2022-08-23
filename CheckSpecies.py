import sys,os
Speciesfinder = sys.argv[1] + "/SampleResults/" + sys.argv[2] + "/" + "Spezies_" + sys.argv[2] + ".txt"
Blast = sys.argv[1] + "/SampleResults/" + sys.argv[2] + "/" + "Blast16S_" + sys.argv[2] + ".txt"
Result = sys.argv[1] + "/OverallResults/BlastCheck.txt"
Check = False
Species = ""

with open(Speciesfinder, 'r') as file:
	lines = file.read()
	lines=lines.splitlines()
	for index, line in enumerate(lines):
		if line.startswith("Taxon:"):
			test = lines[index + 1].replace("Support:","")
			test = test.replace("%","")
			if int(test) > 50:
				Species = lines[index].replace("Taxon:","")
with open(Blast, 'r') as file:
     if Species in file.read().replace('\n', ""):
     	Check = True

with open(Result, 'a+') as file:
	if Check == True:
		file.write(os.linesep + sys.argv[2] + "," + Species + ",WAHR")
	else:
		file.write(os.linesep + sys.argv[2] + "," + Species + ",FALSE")
     	
