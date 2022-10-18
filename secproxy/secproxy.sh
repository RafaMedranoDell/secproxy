#!/bin/bash

FECHA_EJECUCION=`date +%Y%m%d-%s`
PATH_GOAV=/home/admin
PATH_FICHEROS=/tmp/secproxy/files
PATH_LOGS=/tmp/secproxy/logs
PATH_PAQUETES=/tmp/secproxy/paquetes
LOGFILE=$PATH_LOGS/$FECHA_EJECUCION.log

HOTFIX=`ls -ltr $PATH_PAQUETES/AvPlatform* |  awk '//{print $9}' |tail -n 1`
ROLLUP=`ls -ltr $PATH_PAQUETES/*OsRollup* |  awk '//{print $9}' |tail -n 1`

echo "Total parametro=" $# >> $LOGFILE
echo $* >> $LOGFILE


funcion_password_goav()
{
$PATH_GOAV/goav proxy disks --name $i -n
}


funcion_backupfiles()
{
  #$PATH_GOAV/goav proxy upload --local $PATH_SECURIZACION/backup_files.sh --remote /tmp/backup_files.sh -n
  #$PATH_GOAV/oav proxy exec "chmod 744 /tmp/backup_files.sh" -n
  #$PATH_GOAV/goav proxy exec "/tmp/backup_files.sh" -n
  echo "    $i: Haciendo copia de seguridad de ficheros de configuración" >> $LOGFILE
}


funcion_hardening_sh()
{
  echo "    $i: ejecutando script hardening.sh" >> $LOGFILE
  #$PATH_GOAV/goav proxy upload --local $PATH_SECURIZACION/hardening.sh --remote /tmp/hardening.sh -n
  #$PATH_GOAV/goav proxy exec "chown root:root /tmp/hardening.sh" -n
  #$PATH_GOAV/goav proxy exec "chmod 700 /tmp/hardening.sh" -n
  #$PATH_GOAV/goav proxy exec "/tmp/hardening.sh" -n
}


funcion_passwords()
{
  echo "    $i: modificando useradd y creando fichero opasswd" >> $LOGFILE
  #$PATH_GOAV/goav proxy exec "useradd -D -f 60" -n
  #$PATH_GOAV/goav proxy exec "touch /etc/security/opasswd" -n
  #$PATH_GOAV/goav proxy exec "chmod 600 /etc/security/opasswd" -n

  #$PATH_GOAV/goav proxy upload --local $PATH_FICHEROS/login.defs --remote /etc/login.defs -n


  echo "    $i: modificando ficheros common-password" >> $LOGFILE
  #$PATH_GOAV/goav proxy upload --local $PATH_FICHEROS/common-password --remote /etc/pam.d/common-password -n
  #$PATH_GOAV/goav proxy upload --local $PATH_FICHEROS/common-auth --remote /etc/pam.d/common-auth -n
  #$PATH_GOAV/goav proxy upload --local $PATH_FICHEROS/common-account --remote /etc/pam.d/common-account -n
}


if [ $# -gt 0 ]; then
  $PATH_GOAV/goav proxy show -n > show_proxies.txt
  NUMPROXIES=$((`wc -l show_proxies.txt | awk '//{print $1}'` -2))
  echo "NUMERO DE PROXIES:" $NUMPROXIES >> $LOGFILE
  tail -n $NUMPROXIES show_proxies.txt > list_proxies.txt
  for i in "$@"
    do
      if grep "$i" list_proxies.txt > /dev/null
        PROXIES=$i,$PROXIES
        then
          echo $i "existe"  >> $LOGFILE
#	  funcion_backupfiles
#	  funcion_hardening_sh
#	  funcion_passwords
#          funcion_password_goav
        else
          echo $i "no encontrado" >> $LOGFILE
          echo "NO TODOS LOS PROXIES DEL LISTADO EXISTEN" >> $LOGFILE
          exit
      fi
    done
else
  echo "sin parametros" >> $LOGFILE
  exit
fi


echo $PROXIES
funcion_password_goav



echo "fin" >> $LOGFILE

