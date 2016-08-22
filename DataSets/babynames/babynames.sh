dir=/Users/volinsky/DataScience/DataSets/babynames
cd $dir
for year in `seq 1880 2014`
do
    ff=yob$year.txt
      cat $ff | tr -d '\r' |  awk -F, -v yr=$year '{printf("%s,%s,%s,%s\n", $1,$2,$3,yr) }' 
    done > allbabynames.txt
    
