
# Programming from the Ground Up - Notes

## Chapter 2. Computer Architecture
### Data Accessing Methods
##### Immediate Mode
The data to access is embedded in the instruction.
Example: `movl $0 %ebx`

##### Register Addressing Mode
The instruction contains a register to access, rather than a memory location.

##### Direct Addressing Mode
The instruction contains the memory address to access.
For example, I could say, please load this register with the data at address 2002. The computer would go directly to byte 2002 and copy the contents into our register.

##### Indexed Addressing mode
The instruction contains a memory address to access and also specifies an index register to offset that address. For example we could specify address 2002 and an index register to offset that address. If the index contains 4, the actual address would be 2006. We can also specify a **multiplier** for the index. This allows you to access memory a word at a time (4 bytes). In this case the multiplier would be 4.

##### Indirect Addressing 
The instruction contains a register that contains a pointer to where the data should be accessed. For example 

## Chapter 3. Your First Programs
### Registers
There are several **general-purpose** registers (can all be used with movl):
- %eax
- %ebx
- %ecx
- %edx
- %edi
- %esi
In addition to these there are several **special-purpose** registers:
- %ebp
- %esp
- %eip
- %eflags

### Address Referencing
##### General Form of Memory Address Referencing

`ADDRESS_OR_OFFSET(%BASE_OR_OFFSET,%INDEX, %MULTIPLIER)`

All fields are optional. To calculate the address you perform the following calculation.

FINAL ADDRESS = ADDRESS_OR_OFFSET + %BASE_OR_OFFSET + MULTIPLIER * INDEX

- ADDRESS_OR_OFFSET and MULTIPLIER must **both be constants**
- BASE_OR_OFFSET and INDEX must be **registers**

All addressing modes mentioned so far can be represented in this fashion:

##### Direct Addressing Mode
This is done by only using the ADDRESS_OR_OFFSET portion. Example:
`movl ADDRESS, %eax`
This loads %eax with the value at memory ADDRESS
##### Indexed Adressing


