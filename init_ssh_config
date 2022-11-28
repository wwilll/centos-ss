#!/bin/bash
set -o errexit

# ssh port
port=${1:-'22'}
input_port=$1

# config file
config_file=${2:-'/etc/ssh/sshd_config'}
config_file_bak=$config_file".$(date "+%Y-%m-%d")"".bak"

if [ ! -f "$config_file" ]; then
  echo file\("$config_file"\) does not exist
  exit 0
fi

if [ ! -f "$config_file_bak" ]; then
  cp "$config_file" "$config_file_bak"
fi

: >"$config_file"
while IFS= read -r var; do
  [[ $var =~ ^\#.* ]] && continue
  [[ $var =~ ^$ ]] && continue
  echo "$var" >>"$config_file"
done <"$config_file_bak"

if grep -q "^UseDNS" "$config_file"; then
  sed -i '/^UseDNS/c UseDNS no' "$config_file"
elif grep -q "^#UseDNS" "$config_file"; then
  sed -i '/^#UseDNS/a UseDNS no' "$config_file"
else
  sed -i '$a UseDNS no' "$config_file"
fi

if grep -q "^PermitRootLogin" "$config_file"; then
  sed -i '/^PermitRootLogin/c PermitRootLogin yes' "$config_file"
elif grep -q "^#PermitRootLogin" "$config_file"; then
  sed -i '/^#PermitRootLogin/a PermitRootLogin yes' "$config_file"
else
  sed -i '$a PermitRootLogin yes' "$config_file"
fi

if grep -q "^PasswordAuthentication" "$config_file"; then
  sed -i '/^PasswordAuthentication/c PasswordAuthentication yes' "$config_file"
elif grep -q "^#PasswordAuthentication" "$config_file"; then
  sed -i '/^#PasswordAuthentication/a PasswordAuthentication yes' "$config_file"
else
  sed -i '$a PasswordAuthentication yes' "$config_file"
fi

if grep -q "^Port" "$config_file"; then
  if [ "$input_port" ]; then
    sed -i "/^Port/c Port $port" "$config_file"
  fi
elif grep -q "^#Port" "$config_file"; then
  sed -i "/^#Port/a Port $port" "$config_file"
else
  sed -i '$a Port '"$port"'' "$config_file"
fi

if grep -q "^RSAAuthentication" "$config_file"; then
  sed -i "/^RSAAuthentication/c RSAAuthentication yes" "$config_file"
elif grep -q "^#RSAAuthentication" "$config_file"; then
  sed -i "/^#Port/a RSAAuthentication yes" "$config_file"
else
  sed -i '$a RSAAuthentication yes' "$config_file"
fi

echo "ssh setup complete at $(date)"

echo "restarting sshd=========>"
service sshd restart
