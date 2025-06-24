# creating a variable and storing the text
# that we want to search
import re

white = "0xffffffff,"
replace_white = "4'b0000,\n"
cyan = "0xfffcff4c"
replace_cyan = "4'b0001,\n"
turquoise = "0xffc3ba52"
replace_turquoise = "4'b0010,\n"
teal = "0xff66989f"
replace_teal = "4'b0011,\n"
grey = "0xffaaa4ae,"
replace_grey = "4'b0100,\n"
carbon = "0xff292e31,"
replace_carbon = "4'b0101,\n"
cinder = "0xff3a4342,"
replace_cinder = "4'b0110,\n"
black = "0xff000909"
replace_black = "4'b0111,\n"
rust = "0xff8f4017,"
replace_rust = "4'b1000,\n"
mahogany = "0xff702a00,"
replace_mahogany = "4'b1001,\n"
pumpkin = "0xffd56e45,"
replace_pumpkin = "4'b1010,\n"
caramel = "0xffbf6540,"
replace_caramel = "4'b1011,\n"
daisy = "0xfff9d080,"
replace_daisy = "4'b1100,\n"
orange = "0xfffb8347,"
replace_orange = "4'b1101,\n"
indigo = "0xff4b2a2f,"
replace_indigo = "4'b1110,\n"


# Opening our text file in read only
# mode using the open() function
with open(r'door_closed.c', 'r') as file:

    # Reading the content of the file
    # using the read() function and storing
    # them in a new variable
    data = file.read()
    
    data = data.replace(white, replace_white)
    data = data.replace(cyan, replace_cyan)
    data = data.replace(turquoise, replace_turquoise)
    data = data.replace(teal, replace_teal)
    data = data.replace(grey, replace_grey)
    data = data.replace(carbon, replace_carbon)
    data = data.replace(cinder, replace_cinder)
    data = data.replace(black, replace_black)
    data = data.replace(rust, replace_rust)
    data = data.replace(mahogany, replace_mahogany)
    data = data.replace(pumpkin, replace_pumpkin)
    data = data.replace(caramel, replace_caramel)
    data = data.replace(daisy, replace_daisy)
    data = data.replace(orange, replace_orange)
    #data = re.sub(r"#([0-9a-fA-F]{6}),", replace_black, data)
      
          

# Opening our text file in write only
# mode to write the replaced content
with open(r'closed_door_.txt', 'w') as file:

    # Writing the replaced data in our
    # text file
    file.write(data)

# Printing Text replaced
print("Text replaced")