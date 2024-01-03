# Programming from the Ground Up - Notes

## Chapter 2. Computer Architecture
### Data Accessing Methods
#### Immediate Mode
The data to access is embedded in the instruction.
Example: `movl $0 %ebx`

#### Register Addressing Mode
The instruction contains a register to access, rather than a memory location.

#### Direct Addressing Mode
The instruction contains the memory address to access.
For example, I could say, please load this register with the data at address 2002. The computer would go directly to byte 2002 and copy the contents into our register.

#### Indexed Addressing mode
The instruction contains a memory address to access and also specifies an index register to offset that address. For example we could specify address 2002 and an index register to offset that address. If the index contains 4, the actual address would be 2006. We can also specify a **multiplier** for the index. This allows you to access memory a word at a time (4 bytes). In this case the multiplier would be 4.

#### Indirect Addressing Mode
The instruction contains a register that contains a pointer to where the data should be accessed. For example, if we used indirect addressing mode and specified the **%eax** register, and the **%eax** register contained the value 4, whatever was at memory location 4 would be used. In direct addressing we would just load the value 4.

#### Base Pointer Addressing Mode
This is similar to indirect addressing, but you also include a number called the *offset* to add to the register's value before using it for lookup.

## Chapter 3. Your First Programs
### Registers
There are several **general-purpose** registers (can all be used with movl):
**- %eax
- %ebx
- %ecx
- %edx
- %edi
- %esi**

In addition to these there are several **special-purpose** registers:

**- %ebp
- %esp
- %eip
- %eflags**

### Address Referencing
#### General Form of Memory Address Referencing

`ADDRESS_OR_OFFSET(%BASE_OR_OFFSET,%INDEX, %MULTIPLIER)`

All fields are optional. To calculate the address you perform the following calculation.

`FINAL ADDRESS = ADDRESS_OR_OFFSET + %BASE_OR_OFFSET + MULTIPLIER * INDEX`

- `ADDRESS_OR_OFFSET` and `MULTIPLIER` must **both be constants**
- `BASE_OR_OFFSET` and `INDEX` must be **registers**

All addressing modes mentioned so far can be represented in this fashion:

#### Direct Addressing
This is done by only using the ADDRESS_OR_OFFSET portion. Example:
`movl ADDRESS, %eax`
This loads %eax with the value at memory ADDRESS

#### Indexed Adressing
This is done by using the `ADDRESS_OR_OFFSET` and the `%INDEX` portion. You can use any general-purpose register as the index register. You can also have a constant multiplier of 1, 2 or 4 for the index register, to make it easier to index by bytes, double-bytes, and words. 

#### Indirect Addressing
(Loads a value of an address indicated by a register. For example, if **%eax** held an address, we could move the value at that address, we could move the value at that address by doing the following:
`movl (%eax), %ebx`

#### Base Pointer Addressing
Base-pointer addressing is similar to indirect addressing, except that it adds a constant value to the address in the register. For example, if you have a record where the age value is 4 bytes into the record, and you have the address of the record in **%eax**, you can retrieve the age into %ebx by the following instruction:
`movl 4(%eax), %ebx`

#### Immediate Addressing
`movl $12, %eax`

#### Register Addressing
(Simply moves data in or out of a register) All of our examples, register addressing mode was used for the other operand.

Every mode can be used as either the source or destination operand, **except immediate mode**, which can only be used as source operand. (makes sense).

In addition to these modes, there's also different instructions depending on what size of values you're moving around. `movl` moves a word at a time (long or 4 bytes).
Sometimes you might want to only move a byte, in which case you can use `movb`. Since registers are word-sized, and not byte-sized, you have to use a portion of the register.
Take `%eax` for instance. If you wanted to work with two bytes at a time you could just use `%ax`. `%ax` is the *least-significant* half (last half) of the `%eax` register.
`%ax` is further divided up into `%al` and `%ah`. `%al` being the least significant byte of `%ax`.


## Chapter 4. Functions 
Functions are comprised of several different pieces:

#### Function Name
Address where the function's code starts.

#### Function Parameters
Some functions have no parameters.

#### Local Variables
Variables used by the function and then thrown away when the function returns.

#### Static Variables
Variables used by the function but not thrown away after the function returns. They're used everytime the function is called. Not accessible by any other part of the program. Generally not used unless absolutely necessary.

#### Global Variables
Data storage that the function uses that is managed outside the function.

#### Return Address
"Invisible" parameter that isn't directly used inside the function. Tells the function where to return to after execution is finished. This param is passed automatically by the **call** instruction. The **ret** instruction handles returning to that address. 

### Computer Stack
Computer stack *lives at the top addresses of memory*.

You can push values to the top of the stack using **pushl**, which pushes either a *register* or *memory value* onto the top of the stack. The "top" of the stack is actually the bottom of the stack's memory. The stack starts at the top of memory and grows downwards due to architectural considerations. 

You can also pop values off the top using **popl**. This pops the value from the top of the stack and places it into a register or memory address of your choosing.

The stack register **%esp** always contains a pointer to the current top of the stack. Whenever we push something onto the stack **%esp** gets subtracted by 4.

If we simply want to access the value on the top of the stack without removing it we can use indirect addressing mode. We can use `movl (%esp), %eax` to move whatever is in the top of the stack into **%eax**. 
If we just did `movl %esp, %eax` then **%eax** would just hold the pointer to the top of the stack rather than the value at the top.

Putting **%esp** in parenthesis causes the computer to go into indirect addressing mode. If we wanted the value just below the top value, we can simply use `movl 4(%esp), %eax`.

In the C language calling convention, before function execution, a program:
1. pushes all of the parameters of the function onto the stack in reverse order that they're documented. 
2. Then the function issues a **call** instruction indicating which function it wishes to start. The call instruction does 2 things:
    1. First it pushes the address of the next instruction, which is the return address, onto the stack. 
    2. Then it modifies the instruction pointer (%eip) to point to the start of the function

So the stack looks something like this:

**Parameter #N**
**...**
**Parameter 2**
**Parameter 1**
**Return Address <-- (%esp)** 

Now that the return address is on the stack, the function has some work to do.

The first thing it does is save the current base pointer register with `pushl %ebp`. The base pointer register is a special register for accessing function parameters and local variables.
Next it copies the stack pointer to the base pointer with `movl %esp, %ebp`. 
