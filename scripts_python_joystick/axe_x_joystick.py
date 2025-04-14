import RPi.GPIO as GPIO
import time

# CONFIG
VRX_PIN = 17  # GPIO17
CHARGE_DELAY = 0.001  # Temps d’attente avant mesure

GPIO.setmode(GPIO.BCM)

def read_analog(pin):
    # Décharge le condensateur
    GPIO.setup(pin, GPIO.OUT)
    GPIO.output(pin, False)
    time.sleep(0.01)

    # Met en entrée et attend qu’il passe à HIGH
    GPIO.setup(pin, GPIO.IN)
    start_time = time.time()
    
    # Attend que le GPIO monte à HIGH (tension atteinte)
    while GPIO.input(pin) == GPIO.LOW:
        if time.time() - start_time > 0.1:
            return 10000  # Timeout = tension très basse
    duration = time.time() - start_time
    return duration

try:
    while True:
        vrx_val = read_analog(VRX_PIN)
        print(f"VRx ~ Temps de charge : {vrx_val:.5f} sec")

        if vrx_val < 0.001:
            print("➡️ Droite")
        elif vrx_val > 0.008:
            print("⬅️ Gauche")
        else:
            print("⏺️ Centre")

        time.sleep(0.1)

except KeyboardInterrupt:
    GPIO.cleanup()
    print("Script arrêté.")
