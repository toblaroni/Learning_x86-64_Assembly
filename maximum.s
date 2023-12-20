# PURPOSE: This is a program that finds the maximum number in a list of numbers.

# VARIABLES: The registers have the following uses
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
#
# The following memory locations used:
#
# data_items - contains the item data. 0 is used to terminate the data

.section .data

data_items:
 .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

 .section .text
 .globl _start
_start:
 movl $0, %edi						  # Move 0 into index registry
 movl data_items(,%edi,4), %eax # Load the first byte of the data
 movl %eax, %ebx					  # This is the max
start_loop:
 cmpl $0, %eax						  # Check to see if we're at the end
 je loop_exit
 incl %edi							  # Increment index
 movl data_items(,%edi,4), %eax
 cmpl %ebx, %eax					  # Compare
 jle start_loop					  # jump if less than
 movl %eax, %ebx					  # If not then it's bigger
 jmp start_loop

loop_exit:
 movl $1, %eax
 int $0x80
