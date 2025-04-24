#!/bin/bash

# Función para mostrar los directorios disponibles
mostrar_directorios() {
  echo "Directorios disponibles en la ruta actual ($PWD):"
  find . -maxdepth 1 -type d | sed 's|./||' | grep -v '^\.$'
}

# Pide al usuario que seleccione un directorio
echo "¿Deseas ver los directorios disponibles antes de seleccionar uno? (s/n)"
read -p "Opción: " VER_DIRECTORIOS

if [[ "$VER_DIRECTORIOS" == "s" || "$VER_DIRECTORIOS" == "S" ]]; then
  mostrar_directorios
fi

# Pide al usuario que ingrese el directorio a limpiar
read -p "Introduce la ruta del directorio que deseas limpiar (o presiona Enter para usar el actual): " DIRECTORIO

# Si no se introduce un directorio, se usa el directorio actual
DIRECTORIO=${DIRECTORIO:-.}

# Verifica si el directorio existe
if [ ! -d "$DIRECTORIO" ]; then
  echo "El directorio $DIRECTORIO no existe."
  exit 1
fi

# Busca y elimina archivos vacíos (0 bytes) desde ayer hacia atrás
find "$DIRECTORIO" -type f -size 0 -mtime +0 -exec rm -v {} \;

# Busca y elimina carpetas vacías desde ayer hacia atrás
find "$DIRECTORIO" -type d -empty -mtime +0 -exec rmdir -v {} \;

echo "Limpieza completada. Archivos y carpetas vacías eliminados en $DIRECTORIO."
