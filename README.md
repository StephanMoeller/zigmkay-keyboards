# ZigMKay Keyboard Sample
ZigMkay is a keyboard firmware made with zig.
This is a sample repo showing how to cofigure a custom board and keymap.
It is relying on the [ZigMkay library](https://github.com/StephanMoeller/zigmkay).

# Getting started
ZigMKay can run on all keyboards that have an mcu supported by the microzig library.

To get started, follow these steps:

1. Install zig. 
Follow these instructions: https://ziglang.org/learn/getting-started/ - The objective is to be able to call "zig version" and get the zig version displayed. That means you have installed zig correctly and it can be found in your path

2. Fork this repo and clone it to your local machine and open your favourite IDE with the zigmkay folder as the root folder (the folder that contains the hidden .git folder)

3. Contact me on the discord "microzig" for a personal guide to get you up and running. :) 
 
# Getting started
- Open a terminal at the root folder (the parent folder of the src folder) and run the follow command:
```bash
zig build
```

If you don't encounter any build errors, nothing will be outputted in the terminal.

Now you can find a .uf2 file in zig-out/firmware/zigmkay.uf2

Now flash this file to your keyboard.

# Updating ZigMkay dependency
```bash
zig fetch --save git+https://github.com/StephanMoeller/zigmkay.git
```

# Editing your keymap
Typically you will only need to edit the keymap.zig file. This will contain your keymap with combos and custom code, and your pin mappings which you only need to alter if the board you use is different from what the copied keyboard was made for.

# Introduction to using ZigMKay
Please check out the documentation of the [ZigMKay Library](https://github.com/StephanMoeller/zigmkay/blob/main/README.md)