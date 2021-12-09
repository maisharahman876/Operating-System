#!/bin/bash
all()
{
	IFS=$''
    for path in "$1"/*; do
	if [ -d "$path" ]
	then
		for dfile in "$path"; do
			all  "$dfile"
		done
	else
		if [[ "$path" = *.pdf ]];
		then
			files+=($path)
		fi

	fi
	done
}
files=()
[ -e "./output/" ] && rm "./output/" -r
[ -e "./output1/" ] && rm "./output1/" -r
all .
min_size=$1

mkdir output1
#pdfinfo "${PDFFILE}" | grep Pages | sed 's/[^0-9]*//'
#pdftk my.pdf dump_data | grep NumberOfPages
f=()
for i in ${files[@]};
do
	#`pdftk my.pdf dump_data | grep NumberOfPages | sed 's/[^0-9]*//'`
	count=$(pdfinfo "${i}" | grep Pages | sed 's/[^0-9]*//')
	if((count>min_size));
	then
		cp "$i" "output1/"
		filename=$(basename -- "$i")
		f+=("$filename")
	fi
done

mkdir output

for i in ${!f[@]}; do
	min=9999
	for j in output1/*; do
	count=$(pdfinfo "${j}" | grep Pages | sed 's/[^0-9]*//')
	if((count<min));
	then
		min=$count
		m_file=$j
	fi
	done
	mv "$m_file" output/"$((i+1))".pdf
done
rm "./output1/" -r
