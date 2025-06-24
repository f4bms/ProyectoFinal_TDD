from PIL import Image

def mem_to_image(mem_filepath, width, height, mode, output_filepath):
    """
    Builds an image from a .mem file.

    Args:
        mem_filepath: Path to the .mem file.
        width: Width of the image.
        height: Height of the image.
        mode: Color mode (e.g., "RGB", "L" for grayscale).
        output_filepath: Path to save the output image.
    """
    with open(mem_filepath, "r") as f:
        mem_data = f.read()
    print(mem_data[0:6])
    img = Image.frombytes(mode, (width, height), mem_data)
    img.save(output_filepath)

# Example usage:
#mem_to_image("ImageMemoryFile/MemoryFile.mem", 90, 90, "RGB", "output_image.png")

import binascii
from PIL import Image

def hex_to_image(hex_data, width, height, output_path):
    """
    Converts hexadecimal data to an image file.

    Args:
        hex_data: A string containing hexadecimal representation of image data.
        width: The width of the image in pixels.
        height: The height of the image in pixels.
        output_path: The path to save the output image file.
    """
    try:
        # Clean the hex data
        hex_data = hex_data.replace(" ", "").replace("\n", "")

        # Convert hex to bytes
        image_bytes = binascii.unhexlify(hex_data)

        # Create a PIL Image object from the bytes
        img = Image.frombytes("RGB", (width, height), image_bytes)

        # Save the image
        img.save(output_path)
        print(f"Image saved to {output_path}")

    except binascii.Error as e:
        print(f"Error decoding hex data: {e}")
    except Exception as e:
         print(f"An error occurred: {e}")

# Example usage:
image_width = 70
image_height = 70
output_file_path = "output_image.png"
with open("ImageMemoryFile/MemoryFileGreen.mem", "r") as f:
    mem_data = f.read()
hex_to_image(mem_data, image_width, image_height, output_file_path)
