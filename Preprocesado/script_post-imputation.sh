## Primero los indexamos, necesarios para filtrar los cromosomas
for file in *.vcf.gz;
do
tabix -p vcf $file
done

## Luego los filtramos una vez esté hecho el indexado
for file in *.vcf.gz
do
bcftools view -i 'MIN(INFO/R2)>0.3' $file --threads 8 | bgzip -c > ${file::-7}_FILTRADO.vcf.gz
done

## Indexamos los nuevos filtrados
for file in *_FILTRADO.vcf.gz
do
tabix -p vcf $file
done

## Juntamos todos los cromosomas en un archivo solo
bcftools concat *_FILTRADO.vcf.gz -o GENOTIPOS_IMPUTADOS
