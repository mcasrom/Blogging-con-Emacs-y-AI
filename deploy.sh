#!/bin/bash

cd ~/public_html || exit

# Verificar si hay cambios
if ! git diff --quiet || ! git diff --cached --quiet; then
    git add .
    git commit -m "Actualización del blog: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin main
else
    echo "No hay cambios para subir."
fi
