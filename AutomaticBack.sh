### FICHERO PARA AUTOMATIZAR LA COPIA DE SEGURIDAD 
### DE TODOS LOS DATOS DEL SERVIDOR
FECHA=$(date +%Y%m%d%H%M%S)

# COPIA A FICHERO DE LA BD
mysqldump wordpress -uusuario -ppassword > backups/wordpress.temp.sql
tar -cvzf backups/wordpress.${FECHA}.tar.gz backups/wordpress.temp.sql
rm backups/wordpress.temp.sql

# BD otras bds..
# copia incremental en el directorio de copia
# ojo! la primera vez hay que poner ‘full’ en vez de ‘incremental’ para preparar la primera copia
duplicity incremental –encrypt-key “password” –volsize 100 –no-encryption /tmp/backs file:///tmp/backs.backup/
–exclude /tmp/backs/undirectoriodecache/

# borra historial de archivos antiguos
duplicity remove-older-than 60D file:///tmp/backs.backup/
# limpia copias incompletas o mal realizadas
duplicity –no-encryption cleanup file:///tmp/backs.backup/