#!/bin/bash

echo
echo "Do you want to use the BWA aligner (y/n)?"
read answer
if [ $answer = "y" ]; then
    echo
    echo "Which indexing algorithm do you want to use? Type \"is\" for short genomes or \"bwtsw\" for long genomes."
    read index
    echo "What is the name of the forward-reads file (filename.fastq.gz)?"
    read read1
    echo 
    echo "What is the name of the reverse-reads file (filename.fastq.gz)?"
    read read2
    echo
    echo "Current working directory is $PWD" 
    echo "What folder are the reference genomes (.fa) located? Type name of folder and press enter."
    echo "Or if they are in the current working directory, don't type anything press enter:"
    read dir
    echo
    echo "For short reads: type \"aln -parameters... \", otherwise type \"aln\" for the default settings."
    echo For long reads: type \"mem -parameters...\", otherwise type \"mem\" for the default settings.
    read whichAlign
    echo $whichAlign  
    #http://stackoverflow.com/questions/4168371/how-can-i-remove-all-text-after-a-character-in-bash
    #google how to truncate string after a character in bash
    alignName=${whichAlign%% *}
    if [ $alignName = "aln" ]; then
	echo "Please enter SAMPE parameters for generating the SAM file. Enter nothing for the default."
	echo "Note that the output SAM file will be named \"aligned_to_refgenomename.sam\"."
	read sampeParam
    fi
    echo "About to start."
    echo
    printf '%s\n' 'These are the combined flagstats.' '' > "$alignName"_combined_flagstats.txt
    cd ./$dir
    for file in *.fa; do
		filename=`echo $file | sed 's/.fa//'`
		echo "Indexing $file..."
		echo
		module load bwa
		#Index the reference. Note we can change from "-a bwtsw" to -a "is"
		bwa index -a $index $file
		#mv $filename.* ./$filename
		echo
		echo "$filename has been indexed."
		echo
		cd ../
		echo
		echo "Aligning $read1 and $read2 to $file. This may take several minutes per reference file."
			echo
		sleep 1
		mkdir "$filename"_"$alignName"
		#for the aln and bwasw alignment
		if [ $alignName = "aln" ]; then 
		   #paramAln=`echo $whichAlign | sed 's/aln//'`
		   
		   refDir=./$dir/$file
		   (bwa $whichAlign $refDir $read1 > ./"$filename"_"$alignName"/`echo $read1 | sed 's/.fastq.gz/_1.sai/'`)
		   echo
		   echo "$read1 has been aligned!"
		   echo
		   (bwa $whichAlign $refDir $read2 > ./"$filename"_"$alignName"/`echo $read2 | sed 's/.fastq.gz/_2.sai/'`) 
			   echo
		   echo "$read2 has been aligned!"
		   echo
		   echo "Generating alignments in SAM format."
		   (bwa sampe $sampeParam $refDir ./"$filename"_"$alignName"/*_1.sai ./"$filename"_"$alignName"/*_2.sai $read1 $read2 > ./"$filename"_"$alignName"/"$alignName"_"$filename".sam)
		   echo 
		   rm -f ./"$filename"_"$alignName"/*.sai
		  
		else
			refDir=./$dir/$file
			(bwa $whichAlign $refDir $read1 $read2 > ./"$filename"_"$alignName"/"$alignName"_"$filename".sam)
			
		fi
		echo "SAM file generated. Now generating BAM file."
		(samtools view -bS ./"$filename"_"$alignName"/*.sam > ./"$filename"_"$alignName"/"$alignName"_"$filename".bam)
		echo
		echo "BAM file generated. Now sorting BAM file."
		(samtools sort ./"$filename"_"$alignName"/"$alignName"_"$filename".bam ./"$filename"_"$alignName"/"$alignName"_"$filename".sorted)
		echo
		echo "BAM file sorted. Now removing PCR duplicates using RMDUP"
		echo
		(samtools rmdup ./"$filename"_"$alignName"/"$alignName"_"$filename".sorted.bam ./"$filename"_"$alignName"/"$alignName"_"$filename".sorted.rmdup.bam)
		echo
		echo "Duplicates removed. Now indexing."
		echo
		(samtools index ./"$filename"_"$alignName"/*.sorted.rmdup.bam)
		echo 
		echo "BAM file indexed."
		echo
		(samtools flagstat ./"$filename"_"$alignName"/*.sorted.rmdup.bam > ./"$filename"_"$alignName"/"$alignName"_"$filename".flagstats.txt)
		echo "" >> "$alignName"_combined_flagstats.txt
		echo "Flagstats for genome aligned to $filename." >> "$alignName"_combined_flagstats.txt
		(samtools flagstat ./"$filename"_"$alignName"/*.sorted.rmdup.bam >> "$alignName"_combined_flagstats.txt)
		echo $index > ./"$filename"_"$alignName"/"$alignName"_"$filename"_log.txt
		echo $read1 >> ./"$filename"_"$alignName"/"$alignName"_"$filename"_log.txt
		echo $read2 >> ./"$filename"_"$alignName"/"$alignName"_"$filename"_log.txt
		echo $whichAlign >> ./"$filename"_"$alignName"/"$alignName"_"$filename"_log.txt
		echo $sampeParam >> ./"$filename"_"$alignName"/"$alignName"_"$filename"_log.txt
		cd ./$dir
	
	
    done
    #rm ./$dir/*.fa.*
	#rm ./$dir/*.fasta.*

fi
