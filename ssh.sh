#!/bin/bash

echo "Ingresa la cantidad de llaves SSH que deseas configurar:"
read -r cantidad_llaves

# Verificar que la cantidad ingresada sea un número positivo
if ! [[ $cantidad_llaves =~ ^[1-9][0-9]*$ ]]; then
    echo "Por favor, ingresa un número válido mayor que cero."
    exit 1
fi

# Opciones para el repositorio remoto
opciones=("github.com" "gitlab.com" "bitbucket.org")

# Bucle para configurar la cantidad especificada de llaves SSH
for ((i = 1; i <= cantidad_llaves; i++)); do
    echo "Configurando llave SSH $i de $cantidad_llaves"

    # Solicitar al usuario que ingrese el correo electrónico para esta llave
    echo "Ingresa el correo electrónico para la llave SSH $i:"
    read -r email

    # Solicitar al usuario que ingrese el host para esta llave
    echo "Ingresa el host para la llave SSH $i (Ej. company-name):"
    read -r host

    # Menú para escoger el repositorio remoto
    PS3="Escoge el repositorio remoto a utilizar (introduce el número): "
    select repositorio in "${opciones[@]}"; do
        if [[ $repositorio ]]; then
            echo "Has seleccionado: $repositorio"
            break
        else
            echo "Opción no válida. Inténtalo de nuevo."
        fi
    done

    # Generar la clave SSH usando el algoritmo ed25519
    ssh-keygen -t ed25519 -C "$email" -f "/root/.ssh/${host}_ed25519"

    # Agregar configuración al archivo de configuración SSH
    echo -e "\nHost $host\n\tHostname $repositorio\n\tIdentityFile /root/.ssh/${host}_ed25519" >> "/root/.ssh/config"

    # Iniciar el agente SSH
    eval "$(ssh-agent -s)"

    # Añadir la llave al agente SSH
    ssh-add "/root/.ssh/${host}_ed25519"

    echo "Llave generada para $email en $host"
    echo "A continuación, copia y pega la llave pública:"
    echo ""
    cat "/root/.ssh/${host}_ed25519.pub"
    echo ""
done

echo "Proceso completado. Ejemplo de uso: git clone git@$host:nombre-repo/repo.git"
