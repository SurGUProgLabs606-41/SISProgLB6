
#!/bin/bash

LOG="$HOME/lab_admin/logs/resource_monitor.log"
REPORT="$HOME/lab_admin/logs/resource_report.txt"

mkdir -p "$HOME/lab_admin/logs"

echo "Время,CPU_проценты,Память_проценты,Количество_процессов" > "$LOG"

for i in {1..12}; do
    TIME=$(date "+%Y-%m-%d %H:%M:%S")

    CPU=$(top -l 1 -n 0 | awk '/CPU usage/ {print $3 + $5; exit}')
    MEMORY=$(memory_pressure | awk -F': ' '/System-wide memory free percentage/ {gsub("%","",$2); print 100-$2; exit}')
    PROCESSES=$(ps -A -o pid= | wc -l | tr -d ' ')

    CPU=${CPU:-0}
    MEMORY=${MEMORY:-0}
    PROCESSES=${PROCESSES:-0}

    echo "$TIME,$CPU,$MEMORY,$PROCESSES" >> "$LOG"
    echo "Измерение $i/12: CPU $CPU%, память $MEMORY%, процессов $PROCESSES"

    if [ "$i" -lt 12 ]; then
        sleep 5
    fi
done

{
    echo "ОТЧЁТ МОНИТОРИНГА ЗА 1 МИНУТУ"
    echo "Дата: $(date)"
    echo ""

    awk -F',' '
    NR > 1 {
        cpu += $2
        memory += $3
        processes += $4
        count++
    }
    END {
        if (count > 0) {
            printf "Средняя загрузка CPU: %.2f%%\n", cpu/count
            printf "Среднее использование памяти: %.2f%%\n", memory/count
            printf "Среднее количество процессов: %.0f\n", processes/count
            printf "Количество измерений: %d\n", count
        }
    }' "$LOG"
} > "$REPORT"

echo "Мониторинг завершён."
echo "Отчёт сохранён: $REPORT"

