#!/bin/bash

cat <<EOL > access.log
192.168.1.1 - - [28/Jul/2024:12:34:56 +0000] "GET /index.html HTTP/1.1" 200 1234
192.168.1.2 - - [28/Jul/2024:12:35:56 +0000] "POST /login HTTP/1.1" 200 567
192.168.1.3 - - [28/Jul/2024:12:36:56 +0000] "GET /home HTTP/1.1" 404 890
192.168.1.1 - - [28/Jul/2024:12:37:56 +0000] "GET /index.html HTTP/1.1" 200 1234
192.168.1.4 - - [28/Jul/2024:12:38:56 +0000] "GET /about HTTP/1.1" 200 432
192.168.1.2 - - [28/Jul/2024:12:39:56 +0000] "GET /index.html HTTP/1.1" 200 1234
EOL


report_file="report.txt"


total_requests=$(wc -l < access.log)
echo "Общее количество запросов: $total_requests" > "$report_file"


unique_ips=$(awk '{print $1}' access.log | sort | uniq | wc -l)
echo "Количество уникальных IP-адресов: $unique_ips" >> "$report_file"


echo "Количество запросов по методам:" >> "$report_file"
awk '{print $6}' access.log | cut -d'"' -f2 | sort | uniq -c | awk '{print "Метод:", $2, "Количество:", $1}' >> "$report_file"


echo "Самый популярный URL:" >> "$report_file"
awk '{print $7}' access.log | sort | uniq -c | sort -nr | head -n 1 | awk '{print "URL:", $2, "Количество запросов:", $1}' >> "$report_file"


cat "$report_file"