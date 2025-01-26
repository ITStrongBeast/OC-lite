#!/bin/bash

full_report="../logs/system_info1.log"
report_file="../logs/report.log"
top_output="../logs/top_mem_processes1.log"
dmesg_output="../logs/dmesg1.log"

> "$full_report"
> "$top_output"
> "$dmesg_output"

echo "Сбор информации о конфигурации системы перед запуском эксперимента..." > "$full_report"
echo "Дата и время: $(date)" >> "$full_report"
echo "---------------------------------------" >> "$full_report"

echo "Общий объём оперативной памяти:" >> "$full_report"
free -h | grep "Mem:" | awk '{print $2}' >> "$full_report"

echo -e "\nОбъём раздела подкачки:" >> "$full_report"
free -h | grep "Swap:" | awk '{print $2}' >> "$full_report"

echo -e "\nРазмер страницы виртуальной памяти:" >> "$full_report"
getconf PAGESIZE >> "$full_report"

echo -e "\nОбъём свободной физической памяти:" >> "$full_report"
free -h | grep "Mem:" | awk '{print "Свободно: "$4}' >> "$full_report"

echo -e "\nОбъём свободного пространства в разделе подкачки:" >> "$full_report"
free -h | grep "Swap:" | awk '{print "Свободно: "$4}' >> "$full_report"

echo -e "\nНачальная информация о системе собрана и сохранена в $full_report."
echo "---------------------------------------" >> "$full_report"

echo -e "\nЗапуск 1 этапа 1 эксперимента..." | tee -a "$full_report"

./mem.bash $report_file &
pid1=$! 

echo "Запущен скрипт: mem.bash (PID $pid1)" | tee -a "$full_report"

echo "Запуск мониторинга процесса mem.bash через top..." | tee -a "$full_report"
echo "Снапшоты сохраняются в файл $top_output."

counter=0
while kill -0 $pid1 2>/dev/null ; do
	((counter++))

    top -b -n 1 | grep -iE "mem|swap" | head -2 >> "$top_output"
    echo "" >> "$top_output"
    
    sleep 1
done

wait $pid1

echo "Процесс mem.bash завершен." | tee -a "$full_report"

echo "Сбор последних сообщений из системного журнала для mem.bash..." | tee -a "$full_report"
sudo dmesg | grep "mem.bash" | tail -n 2 > "$dmesg_output"

echo "Последние сообщения из dmesg сохранены в $dmesg_output" | tee -a "$full_report"

echo "Сбор финальных данных после завершения эксперимента..." | tee -a "$full_report"

echo -e "\nПоследняя строка из $report_file:" >> "$full_report"
tail -n 1 "$report_file" >> "$full_report"

echo -e "\nЭтап завершён. Все результаты сохранены в файлы:" | tee -a "$full_report"
echo "1. Начальные данные: $full_report" | tee -a "$full_report"
echo "2. Снапшоты top: $top_output" | tee -a "$full_report"
echo "3. Последние сообщения dmesg: $dmesg_output" | tee -a "$full_report"
echo "4. Отчёты скрипта: $report_file" | tee -a "$full_report"
