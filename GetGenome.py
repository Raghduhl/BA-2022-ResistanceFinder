import SplitSequences as SS
import sys, os

if __name__ == "__main__":
	sampleID = sys.argv[2]
	path = sys.argv[1] + "/SampleResults/" + sampleID
	SequenceLocation = sys.argv[1] + "/Sequences/" + sampleID + ".fasta"
	GenomeListFile = path + "/GenomeList_" + sampleID + ".txt"
	
	GenomeID = SS.getgenomeid(SequenceLocation)
	with open(GenomeListFile, 'w') as file:
		file.write(str(GenomeID[0]) + os.linesep)
		
	SS.writeseqtofile(path + "/GenomeSequences_" + sampleID + ".fasta", GenomeID[0], SequenceLocation)
