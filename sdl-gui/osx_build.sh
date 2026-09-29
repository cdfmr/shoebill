#!/bin/bash

CC=gcc

files=""
for i in adb fpu mc68851 mem via floppy core_api cpu dis; do
	perl ../core/macro.pl ../core/$i.c $i.post.c
	files="$files $i.post.c"
done

for i in SoftFloat/softfloat atrap_tab coff exception macii_symbols redblack scsi video filesystem alloc_pool toby_frame_buffer ethernet sound; do
	files="$files ../core/$i.c"
done

$CC -O1 ../core/decoder_gen.c -o decoder_gen
./decoder_gen inst .
./decoder_gen dis .


cmd_arm64="$CC -arch arm64 -F/Library/Frameworks -rpath /Library/Frameworks -O3 -ggdb -flto -DSDL_DISABLE_IMMINTRIN_H $files sdl.c -framework OpenGL -framework SDL2 -o shoebill.arm64"
echo $cmd_arm64
$cmd_arm64

cmd_x86_64="$CC -arch x86_64 -F/Library/Frameworks -rpath /Library/Frameworks -O3 -ggdb -flto $files sdl.c -framework OpenGL -framework SDL2 -o shoebill.x86_64"
echo $cmd_x86_64
$cmd_x86_64

cmd_lipo="lipo -create -output shoebill shoebill.arm64 shoebill.x86_64"
echo $cmd_lipo
$cmd_lipo
