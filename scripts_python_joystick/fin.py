from gpiozero import Button
from pynput.mouse import Controller, Button as MouseButton
import time

# GPIO22, sans pull-up interne (car SW va vers 3.3V)
sw_button = Button(22)  # pull_up=False par défaut si rien n’est précisé
mouse = Controller()

print("🖱️ Appuie sur le bouton pour faire un clic droit.")

try:
    while True:
        sw_button.wait_for_press()
        print("➡️ Clic droit envoyé !")
        mouse.click(MouseButton.left)  # Clic droit ici
        sw_button.wait_for_release()

except KeyboardInterrupt:
    print("\n🚪 Script arrêté.")
