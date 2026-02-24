if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  local geoip=$(curl -s https://geoip.reluekiss.com)
  
  if [ $? -ne 0 ] || [ -z "$geoip" ]; then
    echo "No internet or API error. Starting X..."
    exec startx
  fi

  local remote_tz=$(echo $geoip | jq -r .timezone)
  # This line resolves the link and strips the prefix
  local local_tz=${$(readlink /etc/localtime)#*/zoneinfo/}

  if [ "$remote_tz" != "$local_tz" ]; then
    echo "Warning: System timezone ($local_tz) differs from IP location ($remote_tz)."
    echo "[y]: Change timezone to $remote_tz (sudo ln -s /usr/share/zoneinfo/$remote_tz /etc/localtime)"
    echo "[n]: Keep timezone as $local_tz"
    echo "[q]: Quit"
    read -k 1 response
    echo

    case "$response" in
      [yY]) 
        sudo unlink /etc/localtime 
        sudo ln -s /usr/share/zoneinfo/$remote_tz /etc/localtime
        startx 
        ;;
      [nN]) startx ;;
      [qQ]) exit 1 ;;
    esac

  fi

  exec startx
fi
