from Bio import SeqIO
import sys,os

def createoutputfile(targetlist):
	for path in targetlist:
		if os.path.exists(path):
			os.remove(path)
			open(path, 'a').close()
		else:
			open(path, 'a').close()
	
def writeseqtofile(target, seq, SequenceLocation):	
	with open(target, "a+") as file:
		for seq_record in list(SeqIO.parse(SequenceLocation, "fasta")):
			if (seq_record.id == seq):
				file.write(seq_record.format("fasta"))
				
def writeIDtofile(target, IDList):	
	with open(target, "w") as file:
		for ID in IDList:
			file.write(ID + os.linesep)

def getids(source):
	ids = []
	with open(source) as file:
		for line in file:
			ids.append(line.rstrip())
	return ids
	
def getallids(source):
	ids = []
	for seq_record in list(SeqIO.parse(source, "fasta")):
		ids.append(str(seq_record.id)),
	return ids
	
def getgenomeid(source):
	id = []
	length = 0
	maxlength = 0
	for seq_record in list(SeqIO.parse(source, "fasta")):
		length = len(seq_record.seq)
		if (length > maxlength):
			id = []
			id.append(str(seq_record.id))
			maxlength = length
	return id
	
def getremainingids(allids, assignedids):
	ids = []
	for ID in allids:
		if ID not in assignedids:
			ids.append(ID)
	return ids
	
if __name__ == "__main__":
	sampleID = sys.argv[2]
	path = sys.argv[1] + "/SampleResults/" + sampleID
	PlasmidIDs = path + "/PlasmidList_" + sampleID + ".txt"
	CircularIDs = path + "/CircularList_" + sampleID + ".txt"
	PseudoCircularIDs = path + "/PseudoCircularList_" + sampleID + ".txt"
	GenomeIDs = path + "/GenomeList_" + sampleID + ".txt"
	GenomeCoverageIDs = path + "/IdenticalCoverageGenome_" + sampleID + ".txt"
	BlastGenomeIDs = path + "/BlastGenomeList_" + sampleID + ".txt"
	targetBlastGen = path + "/BlastGenomeSequences_" + sampleID + ".fasta"
	targetPlasmid = path + "/PlasmidSequences_" + sampleID + ".fasta"
	targetGenome = path + "/GenomeSequences_" + sampleID + ".fasta"
	targetPseudoCircular = path + "/PseudoCircularSequences_" + sampleID + ".fasta"
	targetCircular = path + "/CircularSequences_" + sampleID + ".fasta"
	targetUnassigned = path + "/UnassignedSequences_" + sampleID + ".fasta"
	targetUnasList = path + "/UnassignedList_" + sampleID + ".txt"
	targetUCircList = path + "/UniqCircularList_" + sampleID + ".txt"
	SequenceLocation = sys.argv[1] + "/Sequences/" + sampleID + ".fasta"
	
	PlasIDs = getids(PlasmidIDs)
	CircIDs = getids(CircularIDs)
	PseuCircIDs = getids(PseudoCircularIDs)
	GenomeIDs = getids(GenomeIDs)
	BlastGenIDs = getids(BlastGenomeIDs)
	GenCovIDs = getids(GenomeCoverageIDs)
	PlasIDs = getremainingids(PlasIDs, GenomeIDs)
	CircIDs = getremainingids(CircIDs, GenomeIDs + PlasIDs)
	PseuCircIDs = getremainingids(PseuCircIDs, GenomeIDs + PlasIDs + CircIDs)
	BlastGenIDs = getremainingids(BlastGenIDs, GenomeIDs + PlasIDs + CircIDs + PseuCircIDs)
	GenCovIDs = getremainingids(GenCovIDs, BlastGenIDs + GenomeIDs + PlasIDs + CircIDs + PseuCircIDs)
	AllIDs = getallids(SequenceLocation)
	RemainingIDs = getremainingids(AllIDs, GenomeIDs + PlasIDs + CircIDs + BlastGenIDs + GenCovIDs + PseuCircIDs)
	
	createoutputfile([targetPlasmid, targetGenome, targetUnassigned, targetCircular, targetPseudoCircular, targetUnasList, targetUCircList, targetBlastGen])

	print(sampleID + ":")
	print("Genome IDs: " + str(GenomeIDs))
	print("Plasmid IDs: " + str(PlasIDs))
	print("Circular IDs: " + str(CircIDs))
	print("Pseudo-Circular IDs: " + str(PseuCircIDs))
	print("Blast assigned Genome IDs: " + str(BlastGenIDs))
	print("Coverage assigned Genome IDs: " + str(GenCovIDs))
	print("Unassigned Ids: " + str(RemainingIDs))
	
	for seq in PlasIDs:
		writeseqtofile(targetPlasmid, seq, SequenceLocation)
	for seq in CircIDs:
		writeseqtofile(targetCircular, seq, SequenceLocation)
	for seq in PseuCircIDs:
		writeseqtofile(targetCircular, seq, SequenceLocation)
	for seq in GenomeIDs:
		writeseqtofile(targetGenome, seq, SequenceLocation)
	for seq in BlastGenIDs:
		writeseqtofile(targetBlastGen, seq, SequenceLocation)
	for seq in GenCovIDs:
		writeseqtofile(targetBlastGen, seq, SequenceLocation)
	for seq in RemainingIDs:
		writeseqtofile(targetUnassigned, seq, SequenceLocation)
	print("Succesfully created Fasta-files")
	
	writeIDtofile(CircularIDs, CircIDs)
	writeIDtofile(PlasmidIDs, PlasIDs)
	writeIDtofile(PseudoCircularIDs, PseuCircIDs)
	writeIDtofile(path + "/GenomeList_" + sampleID + ".txt", GenomeIDs)
	writeIDtofile(BlastGenomeIDs, BlastGenIDs)
	writeIDtofile(GenomeCoverageIDs, GenCovIDs)
	
	with open (sys.argv[1]+ "/OverallResults/PlasmidCounts.csv", 'a+') as outfile:
		outfile.write(sampleID + "," + str(len(GenomeIDs)) + "," + "Genome" + os.linesep)
		outfile.write(sampleID + "," + str(len(PlasIDs)) + "," + "Plasmids" + os.linesep)
		outfile.write(sampleID + "," + str(len(CircIDs)) + "," + "Circular" + os.linesep)
		outfile.write(sampleID + "," + str(len(PseuCircIDs)) + "," + "Pseudo_Circular" + os.linesep)
		outfile.write(sampleID + "," + str(len(BlastGenIDs)) + "," + "Blast_Genome" + os.linesep)
		outfile.write(sampleID + "," + str(len(GenCovIDs)) + "," + "Coverage_Genome" + os.linesep)
		outfile.write(sampleID + "," + str(len(RemainingIDs)) + "," + "Unassigned" + os.linesep)
		
		
	with open (path + "/UnassignedList_" + sampleID + ".txt", 'a+') as outfile:
		if len(RemainingIDs) > 0:
			for i in range(len(RemainingIDs)):
				outfile.write(RemainingIDs.pop(0))
				outfile.write(os.linesep)
	with open (path + "/UniqCircularList_" + sampleID + ".txt", 'a+') as outfile:
		if len(CircIDs) > 0:
			for i in range(len(CircIDs)):
				outfile.write(CircIDs.pop(0))
				outfile.write(os.linesep)
