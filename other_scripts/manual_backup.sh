#!/bin/bash
echo "Yedekleme işlemi başlatılıyor..."
pg_dump -U postgres -d KutuphaneDB > ~/Desktop/Veritabani_Projesi/Yedekleme_ve_Kurtarma/sql_scripts/full_backup.sql
echo "Yedekleme başarıyla tamamlandı."
