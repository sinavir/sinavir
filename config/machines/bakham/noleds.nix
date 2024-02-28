{...}: {
  system.activationScripts.noled.text = ''
    echo 0 > /sys/devices/platform/leds/leds/PWR/brightness
    echo 0 > /sys/devices/platform/leds/leds/ACT/brightness
  '';
}
