#!/bin/bash

PASSWORD="passwordmoltosicura"
OUTPUT="result.hw3-1649359.csv"
CICLI=10
truncate -s 0 $OUTPUT

echo ++++++ HOMEWORK 3 ++++++

for cipher in aes-256-cbc aes-256-gcm
do
    echo $cipher >>  $OUTPUT
    echo +++++ CIPHER $cipher +++++    
    for text in text1 text2 text3
    do
        echo ===== ENCRYPTION =====       
        echo $text >>  $OUTPUT
        runtime=0
        for i in {1..$CICLI}
        do
            start=$(date +%s%N)
            openssl $cipher -a -salt -pbkdf2 -in "$text-hw3-1649359.txt" -out "$text.enc" -pass pass:$PASSWORD
            runtime="$(($runtime+($(date +%s%N)-$start)))"       
           
        done

        enc_runtime_scaled=$(bc <<< "scale=3;$runtime/$CICLI/1000000")
        echo ENC_SPEED $enc_runtime_scaled

        echo ===== DECRYPTION =====       
        
        runtime=0
        for i in {1..$CICLI}
        do
            start=$(date +%s%N)
            openssl $cipher -d -a -salt -pbkdf2 -in "$text.enc" -out "$text.new.txt" -pass pass:$PASSWORD
            runtime="$(($runtime+($(date +%s%N)-$start)))"       
           
        done

        dec_runtime_scaled=$(bc <<< "scale=3;$runtime/$CICLI/1000000")
        echo DEC_SPEED $dec_runtime_scaled
        echo $size >> $OUTPUT
        echo ENC";"$enc_runtime_scaled >> $OUTPUT
        echo DEC";"$dec_runtime_scaled >> $OUTPUT
              
    done 

    for bin in 1024 3238 10240
        do
        dd if="/dev/urandom" of="$bin.file" bs="$bin" count="$bin"
        echo ===== ENCRYPTION =====       
        echo $bin >>  $OUTPUT
        runtime=0
        for i in {1..$CICLI}
        do
            start=$(date +%s%N)
            openssl $cipher -a -salt -pbkdf2 -in "$bin.file" -out "$bin.enc" -pass pass:$PASSWORD
            runtime="$(($runtime+($(date +%s%N)-$start)))"       
           
        done

        enc_runtime_scaled=$(bc <<< "scale=3;$runtime/$CICLI/1000000")
        echo ENC_SPEED $enc_runtime_scaled

        echo ===== DECRYPTION =====       
        
        runtime=0
        for i in {1..$CICLI}
        do
            start=$(date +%s%N)
            openssl $cipher -d -a -salt -pbkdf2 -in "$bin.enc" -out "$bin.new.file" -pass pass:$PASSWORD
            runtime="$(($runtime+($(date +%s%N)-$start)))"       
           
        done

        dec_runtime_scaled=$(bc <<< "scale=3;$runtime/$CICLI/1000000")
        echo DEC_SPEED $dec_runtime_scaled
        echo $size >> $OUTPUT
        echo ENC";"$enc_runtime_scaled >> $OUTPUT
        echo DEC";"$dec_runtime_scaled >> $OUTPUT     
              
    done

    
done

for bin in 1024 3238 10240
        do
        rm "$bin.file"
        rm "$bin.enc"
        rm "$bin.new.file"
done

for text in text1 text2 text3
    do
    rm "$text.enc"
    rm "$text.new.txt"
done




