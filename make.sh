#!/bin/bash

source=$1

# assemble
as $source.s -o $source.o

# Link
ld $source.o -o $source.out

# Run
./$source
echo Exit code is $?

# Clean
rm *.o *.out
