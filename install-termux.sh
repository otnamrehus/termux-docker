#!/bin/bash

show_menu() {
    echo "Pilih Opsi Instalasi atau Eksekusi Perintah Termux Berikut:"
    echo "1. Install Termux Versi ARM [Not Update]"
    echo "2. Install Termux Versi ARM [Update] **"
    echo "3. Install Termux Versi PC *"
    echo "4. Jalankan Termux [ARM] ***"
    echo "5. Jalankan Termux [PC]"
    echo "6. Keluar"
}

install_termux() {
    local container_name="termux"

    case $1 in
        1) docker run -d --restart always -it --privileged --name $container_name --hostname $container_name -p 1111:8022 -p 1212:2222 --entrypoint /entrypoint_root.sh termux/termux-docker:aarch64 ;;
        2) docker run -d --restart always -it --privileged --name $container_name --hostname $container_name -p 1111:8022 -p 1212:2222 --entrypoint /entrypoint.sh termux/termux-docker:aarch64 ;;
        3) docker run -d --restart always -it --name $container_name --hostname $container_name -p 1111:8022 -p 1212:2222 --entrypoint /entrypoint_root.sh termux/termux-docker:latest ;;
        *) echo "Terima kasih telah menggunakan skrip ini. Selamat tinggal!"; exit ;;
    esac
}

exec_command_in_termux() {
    local container_name="termux"

    case $1 in
        #4) docker exec -d $container_name ;; #/some_command_update.sh ;;
        4) docker exec -it $container_name /entrypoint_root.sh;; #/some_command_not_update.sh ;;
        5) docker exec -it $container_name /entrypoint.sh ;;
        *) echo "Terima kasih telah menggunakan skrip ini. Selamat tinggal!"; exit ;;
    esac
}

activate_screen() {
    local count=$1
    if [ $((count % 3)) -eq 0 ]; then
        screen -dmS termux_screen
    fi
}

count=0

while true; do
    show_menu
    read -p "Masukkan pilihan Anda: " choice

    case $choice in
        [1-3]) install_termux $choice ;;
        [4-5]) exec_command_in_termux $choice ;;
        6) echo "Terima kasih telah menggunakan skrip ini. Selamat tinggal!"; exit ;;
        *) echo "Pilihan tidak valid. Silakan pilih nomor dari menu."; continue ;;
    esac

    ((count++))
    activate_screen $count
done
