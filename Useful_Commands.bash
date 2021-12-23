if [ "$#" -ne 1 ] ; then
	echo "$0: incorrect number of arguments"
	echo "usage: $0 /path/to/files" >&2
	exit 1
fi

num_of_agrs=$# 
ARG1=$1
ARG2=$2
ARG3=$3
shift 3

func()
{
	echo "----- ${FUNCNAME[0]} ------"
	
	src_dir=$1
	dest_dir=$2	
	curr_dir=$(pwd)

	#if dest_dir and src_dir are relative then get absolute path
	#else absolute path will be unaffected.
	dest_dir=$(cd ${dest_dir} && pwd && cd ${curr_dir})
	src_dir=$(cd ${src_dir} && pwd && cd ${curr_dir})
	
	echo "----- ${FUNCNAME[0]} done ------"
	exit 0
}

version=$(echo ${ver} | sed 's/[^0-9.]*\([0-9.]*\).*/\1/')
if [ "x${version}" = "x" ]; then
	log_message err "version is invalid"
	log_message inform "use version like 1.2.3, 1.2"
	exit 4
fi

function ctrl_c()
{
	echo "----- ${FUNCNAME[0]} ------"
	rm -rf ${staging_dir}
	echo "----- ${FUNCNAME[0]} done ------"
	exit 0
}
#let's make sure we are deleting temp folder on ctrl-c
trap ctrl_c INT

echo -e "----$0 usage----"
log_message warn "$0 cmd appName"
log_message warn "Options :"
log_message warn "	cmd 	-  run, build"
log_message warn "	appName -  app1, app2"
echo -e "-------------------"
log_message inform "For running app1"
log_message warn "$0 run app1"
echo -e "-------------------"
log_message inform "For building app2"
log_message warn "$0 build app2"
echo -e "-------------------"

myData=x$(cat /home/data.txt)
if [ "${myData}" = "x" ];then 
	log_message " data file not found"
	exit
fi

if cat /tmp/data.txt | grep app1; then
    log_message "app1"
elif cat /tmp/data.txt | grep app2; then
    log_message "app2"
else
    log_message "app not found"
	exit
fi

app_logfile=$1
app_start_stop=$2
case "${app_start_stop}" in
  start)
	while true
	do
		echo "Starting application:"
		killall application 1>/dev/null 2>/dev/null
		chmod 0666 ${app_logfile}
		su root -c -l "nohup  /home/app >> ${app_logfile}"
		sleep 5
	done
	;;
  stop)
	printf "Stopping application: "
    pwd
	killall application 1>/dev/null 2>/dev/null
	;;
  restart|reload)
	"$0" stop
	"$0" start
	;;
  *)
	echo "Usage: $0 {start|stop|restart}"
	exit 1
esac

# wait till file is created
while [ ! -e /tmp/myFile ]
do
		sleep 5
done

info()
{
	echo >> ${log}
	date | tr -d '\n' >> ${log}
	echo "  " | tr -d '\n' >> ${log}
	echo $1 >> ${log} ; sync
	echo
	echo $1
}

while true;
do
	check_connection
	sleep 5
done

if [ ${name} != "app1" ] && [ ${name} != "app2" ]
then
	appName="not found"
else
	appName="$name$size.$ext"
fi

status=1
cnt=0
while [ $status -gt 0 ] && [ $cnt -lt 3 ]
do
	echo myData
	status=$?
	if [ $status -gt 0 ]
	then
		sleep 2
	fi
	cnt=`expr $cnt + 1`
done

d=`date +"%Y-%0m-%0d_%0k:%0M:%0S"`

nice -n -5 /home/app/myScript.sh &

if ps | grep "[m]yScript.sh"; then
	info "myScript.sh already running"
else
	/home/app/myScript.sh &
fi

killall -9 myScript.sh 
/home/app/myScript.sh &

if [ $(cat ${my_file}) -eq 1 ]
then
	exit 0
fi

uptime_in_sec=$(cat /proc/uptime | cut -d " " -f1 | cut -d "." -f1)

permissions=$(ls -l ${my_file} | awk '{print $1 ":" $3 ":" $4}')

echo 1 > ${my_file};sync

#parse input arguments
for i in "$@"; do
case $i in
	app1)
	shift # move past argument
	;;
	app2)
	shift # move past argument
	;;
	*)
          # unknown option
	exit 4
	;;
esac
done

data_size=$(df | grep ${PARTITION} | awk 'NR==1{print $4}')

#clear file buffer/cache
sync; echo 3 > /proc/sys/vm/drop_caches

chown -R root:root /home/my_app

chmod -R 755 /home/my_app

ln -s /home/old  /home/new

dos2unix /home/app/*.sh

#find out the name of binary
name=$(file ./* |grep ELF | cut -d: -f1 | cut -d/ -f2);

echo "1" > /home/app/myFile

if [[ "${1}" = '1'  &&  ("${2}" != '0' || "${3}" != '1') ]]; then
	echo success
fi
		
if [ -z "${NAME// }" ] || [ -z "$NAME" ]
if [[ ! "${DATA^^}" == "${LOG^^}" ]]
if [ $? -eq 0 ]
if [ $? -ne 0 ]

zip -r -q $1/app1.zip  *
zip -q -D $1/app2.zip  *

date ; nice -n -20 free;
date ; killall top; nice -n -20 top -b -d 600

