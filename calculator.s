# A terminal calculator
#
# Reads a line of input, interprets it as a simple arithmetic expression,
# and prints the result. The input format is
# <long_integer> <operation> <long_integer>

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

main:
  # Function prologue
  enter $0, $0

  # Use scanf to retrieve and process a line of input
  # This block implements the following line of C code: 
  #   scanf("%ld %c %ld", &a, &op, &b);
  # Take a look at the man page for scanf and ask questions. You can also look 
  # at scanf_example.c
  movq $scanf_fmt, %rdi
  movq $a, %rsi
  movq $op, %rdx
  movq $b, %rcx
  xorb %al, %al
  call scanf

  movb op, %al
  movq a, %r8

  cmpb $'+', %al
  je do_addition
  cmpb $'-', %al
  je do_subtraction
  cmpb $'*', %al
  je do_multiplication
  cmpb $'/', %al
  je do_division
  jmp unknown_op

  # Add b to value of a stored in %r8 and print output
  do_addition:
    addq b, %r8
    movq $output_fmt, %rdi
    movq %r8, %rsi
    xorb %al, %al
    call printf
    jmp end_program

  # Subtract b from the value of a stored in %r8 and print output
  do_subtraction:
    subq b, %r8
    movq $output_fmt, %rdi
    movq %r8, %rsi
    xorb %al, %al
    call printf
    jmp end_program

  # Multiply b times value of a stored in %r8 and print output
  do_multiplication:
    imulq b, %r8
    movq $output_fmt, %rdi
    movq %r8, %rsi
    xorb %al, %al
    call printf
    jmp end_program

  # Check for division by zero. Divide value of a in %rax by b and print output
  do_division:
    cmpq $0, b
    je div_by_zero
    movq %r8, %rax
    cqto
    idivq b
    movq $output_fmt, %rdi
    movq %rax, %rsi
    xorb %al, %al
    call printf
    jmp end_program

  # Return error message and end program in error
  div_by_zero:
    movq $div_by_zero_msg, %rdi
    xorb %al, %al
    call printf
    jmp error_exit

  # Return error message and end program in error
  unknown_op:
    movq $unknown_op_msg, %rdi
    xorb %al, %al
    call printf
    jmp error_exit

  # End program with an error
  error_exit:
    movq $1, %rax
    jmp finish

  # End program successfully
  end_program:
    movq $0, %rax

  # Complete program
  finish:
    leave
    ret

# Start of the data section
.data

output_fmt: 
  .asciz "%ld\n"
scanf_fmt: 
  .asciz "%ld %c %ld"
div_by_zero_msg:
  .asciz "Cannot divide by zero\n"
unknown_op_msg:
  .asciz "Unknown operation\n"

# "Slots" for scanf
a:  .quad 0
b:  .quad 0
op: .byte 0

