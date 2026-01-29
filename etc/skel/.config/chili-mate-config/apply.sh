#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# shellcheck shell=bash disable=SC1091,SC2039,SC2166
#
#  apply.sh
#  Created: 2025/05/19 - 01:59
#  Altered: 2025/05/19 - 01:59
#
#  Copyright (c) 2025-2025, Vilmar Catafesta <vcatafesta@gmail.com>
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR AS IS'' AND ANY EXPRESS OR
#  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
#  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
#  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
#  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
#  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##############################################################################
CONF_DIR="$HOME/.config/chili-mate-config"
INI_FILE="$CONF_DIR/mate-default.ini"
FLAG_FILE="$CONF_DIR/.applied"

# Requisitos mínimos para aplicar dconf com sucesso
if [[ -f "$FLAG_FILE" ]]; then
	echo "[chili-mate-config] Configurações já aplicadas. Pulando."
	exit 0
fi

# Verifica se estamos em uma sessão gráfica com dconf disponível
if [[ -z "$DBUS_SESSION_BUS_ADDRESS" || -z "$DISPLAY" ]]; then
	echo "[chili-mate-config] Ambiente gráfico não detectado. Abortando."
	exit 1
fi

# Verifica se o arquivo de configuração existe
if [[ ! -f "$INI_FILE" ]]; then
	echo "[chili-mate-config] Arquivo '$INI_FILE' não encontrado. Abortando."
	exit 1
fi

echo "[chili-mate-config] Aplicando configurações MATE do pacote Chili..."

# Substitui variáveis e aplica com dconf
sed "s|\$HOME|$HOME|g; s|\$USER|$USER|g" "$INI_FILE" | dconf load /

# Marca como aplicado
touch "$FLAG_FILE"
echo "[chili-mate-config] Configurações aplicadas com sucesso."
