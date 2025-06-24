import re

# Ruta de entrada y salida
input_file = "memory.mem"
output_file = "door_open.txt"

# Umbral de oscuridad (puedes ajustar este valor)
DARK_THRESHOLD = 40  # valor entre 0 y 255

with open(input_file, "r") as f:
    content = f.read()

# Encuentra todos los valores tipo 0xAARRGGBB
hex_values = re.findall(r'[0-9a-fA-F]{6}', content)

with open(output_file, "w") as out:
    out.write("logic [23:0] memory [0:{}] = '{{\n".format(len(hex_values) - 1))
    for i, value in enumerate(hex_values):
        argb = int(value, 16)
        r = (argb >> 16) & 0xFF
        g = (argb >> 8) & 0xFF
        b = argb & 0xFF

        # Detectar píxeles oscuros
        if r < DARK_THRESHOLD and g < DARK_THRESHOLD and b < DARK_THRESHOLD:
            rgb_24bit = 0  # negro puro
        else:
            rgb_24bit = (r << 16) | (g << 8) | b

        line = f"    24'b{rgb_24bit:024b}"
        if i != len(hex_values) - 1:
            line += ","
        out.write(line + "\n")
    out.write("};\n")

print(f"Archivo '{output_file}' generado con {len(hex_values)} píxeles.")
