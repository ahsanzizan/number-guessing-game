# How to Play (if you're interested)
You need to install [NASM](https://www.nasm.us/) first

#### 1. Assemble the Source Code
```bash
nasm -f win32 number_guess.asm -o number_guess.obj
```

#### 2. Link the Object File
```bash
link /SUBSYSTEM:CONSOLE /OUT:number_guess.exe number_guess.obj
```

#### 3. Run the Executable
```bash
number_guess.exe
```

I don't know why anyone is ever interested in doing all of that
