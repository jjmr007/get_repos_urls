#!/bin/bash

# Solicitar el nombre del archivo
echo "Por favor, ingresa la ruta/nombre del archivo JSON:"
read input_file

# Solicitar el token de GitHub (modo seguro)
echo -n "Por favor, ingresa tu token de GitHub:"
read -s github_token
echo # para que no se vea el token en la terminal

# Verificar si el archivo existe
if [ ! -f "$input_file" ]; then
    echo "Error: El archivo $input_file no existe"
    exit 1
fi

# Crear nombre del archivo de salida
output_file="${input_file%.*}_with_creation_dates.json"

# Iniciar el array JSON de salida
echo "[" > "$output_file"
first_entry=true

# Leer el archivo JSON y procesar cada URL
cat "$input_file" | jq -r '.[]' | while read repo; do
    # Extraer el owner y nombre del repositorio de la URL
    owner_repo=$(echo $repo | sed 's/https:\/\/github.com\///')
    
    # Hacer la consulta a la API con autenticación
    created_at=$(curl -s -H "Authorization: token $github_token" "https://api.github.com/repos/$owner_repo" | jq -r '.created_at')
    
    # Si es la primera entrada, no añadir coma
    if [ "$first_entry" = true ]; then
        first_entry=false
    else
        echo "," >> "$output_file"
    fi
    
    # Escribir el array con la URL y la fecha en el archivo de salida
    echo "  [\"$repo\", \"$created_at\"]" >> "$output_file"
    
    # Mostrar progreso
    echo "Procesando: $repo -> $created_at"
    
    # Esperar un segundo para no sobrecargar la API
    sleep 1
done

# Cerrar el array JSON
echo "]" >> "$output_file"

echo "Proceso completado. Los resultados se han guardado en $output_file"