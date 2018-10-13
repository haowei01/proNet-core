set -x
Threads=1

# download youtube-links dataset
zipfile="youtube-links.txt.gz"
if test -e "$zipfile";
then
    echo 'zip file exists'
else
    wget http://socialnetworks.mpi-sws.mpg.de/data/youtube-links.txt.gz
fi

# generate the network
gzcat youtube-links.txt.gz | awk -F '	' '{print $1" "$2" 1"}' > net.txt

# generate the field meta
gzcat youtube-links.txt.gz | awk -F '   ' '{print $1}' | sort -u | awk '{print $0" u"}' > field_meta.txt
gzcat youtube-links.txt.gz | awk -F '   ' '{print $2}' | sort -u | awk '{print $0" i"}' >> field_meta.txt

# run the comment
../bin/deepwalk -train net.txt -save rep_dw.txt -undirected 1 -dimensions 64 -walk_times 1 -walk_steps 40 -window_size 5 -negative_samples 5 -alpha 0.025 -threads $Threads
../bin/walklets -train net.txt -save rep_wl.txt -undirected 1 -dimensions 64 -walk_times 1 -walk_steps 40 -window_min 2 -window_max 5 -negative_samples 5 -alpha 0.025 -threads $Threads
../bin/line -train net.txt -save rep_line1.txt -undirected 1 -order 1 -dimensions 64 -sample_times 10 -negative_samples 5 -alpha 0.025 -threads $Threads
../bin/line -train net.txt -save rep_line2.txt -undirected 1 -order 2 -dimensions 64 -sample_times 10 -negative_samples 5 -alpha 0.025 -threads $Threads
../bin/hpe -train net.txt -save rep_hpe.txt -undirected 1 -dimensions 64 -sample_times 10 -walk_steps 5 -negative_samples 5 -alpha 0.025 -threads $Threads
../bin/hoprec -train net.txt -save rep_hoprec.txt -field field_meta.txt -undirected 1 -dimensions 64 -walk_times 1 -walk_steps 40 -window_size 5 -negative_samples 5 -alpha 0.025 -threads $Threads 
