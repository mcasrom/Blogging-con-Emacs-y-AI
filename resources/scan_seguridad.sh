#!/bin/bash
LOGFILE="$HOME/seguridad/logs/seguridad_$(date +%F_%H%M).log"
ORGFILE="$HOME/seguridad/reportes/seguridad_$(date +%F_%H%M).org"
mkdir -p "$(dirname "$LOGFILE")"
mkdir -p "$(dirname "$ORGFILE")"

echo "* Informe de seguridad generado el $(date)" > "$ORGFILE"
echo "------------------------------------------" > "$LOGFILE"

echo "** 🧠 Memoria y carga del sistema" | tee -a "$ORGFILE" >> "$LOGFILE"
free -h | tee -a "$LOGFILE" | sed 's/^/    /' >> "$ORGFILE"
uptime | tee -a "$LOGFILE" | sed 's/^/    /' >> "$ORGFILE"

echo "** 🌐 Interfaces de red activas" | tee -a "$ORGFILE" >> "$LOGFILE"
ip addr show | grep inet | tee -a "$LOGFILE" | sed 's/^/    /' >> "$ORGFILE"

echo "** 🔐 Puertos abiertos (localhost)" | tee -a "$ORGFILE" >> "$LOGFILE"
nmap -sT -p- 127.0.0.1 | tee -a "$LOGFILE" | sed 's/^/    /' >> "$ORGFILE"

echo "** 🕵️ Conexiones activas sospechosas" | tee -a "$ORGFILE" >> "$LOGFILE"
ss -tunap | grep -v "127.0.0.1" | tee -a "$LOGFILE" | sed 's/^/    /' >> "$ORGFILE"

echo "** 🚨 IP pública y análisis básico" | tee -a "$ORGFILE" >> "$LOGFILE"
IP=$(curl -s ifconfig.me)
echo "IP pública: $IP" | tee -a "$LOGFILE" | sed 's/^/    /' >> "$ORGFILE"
whois "$IP" | grep -iE "org|country|name" | tee -a "$LOGFILE" | sed 's/^/    /' >> "$ORGFILE"

echo "** 🔍 Análisis rootkits (chkrootkit si disponible)" | tee -a "$ORGFILE" >> "$LOGFILE"
if command -v chkrootkit &> /dev/null; then
    chkrootkit | tee -a "$LOGFILE" | sed 's/^/    /' >> "$ORGFILE"
else
    echo "chkrootkit no instalado. Instálalo con: sudo apt install chkrootkit" | tee -a "$LOGFILE" | sed 's/^/    /' >> "$ORGFILE"
fi

echo "** 📊 Procesos sospechosos (más consumo CPU)" | tee -a "$ORGFILE" >> "$LOGFILE"
ps aux --sort=-%cpu | head -n 10 | tee -a "$LOGFILE" | sed 's/^/    /' >> "$ORGFILE"

echo "** ✅ Recomendaciones generales" >> "$ORGFILE"
echo "- Verifica puertos abiertos innecesarios" >> "$ORGFILE"
echo "- Usa firewalld o ufw para cerrar conexiones" >> "$ORGFILE"
echo "- Revisa procesos con consumo elevado" >> "$ORGFILE"
echo "- Instala y configura fail2ban si es un servidor expuesto" >> "$ORGFILE"
