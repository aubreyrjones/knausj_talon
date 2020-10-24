mode: user.cplusplus
mode: command
and code.language: cplusplus
-
tag(): user.code_operators
tag(): user.code_comment
tag(): user.code_block_comment
tag(): user.code_generic
settings():
    user.code_private_function_formatter = ""
    user.code_protected_function_formatter = "SNAKE_CASE"
    user.code_public_function_formatter = "SNAKE_CASE"
    user.code_private_variable_formatter = "SNAKE_CASE"
    user.code_protected_variable_formatter = "SNAKE_CASE"
    user.code_public_variable_formatter = "SNAKE_CASE"
    # whether or not to use uint_8 style datatypes
    #    user.use_stdint_datatypes = 1


action(user.code_operator_not): "!"
action(user.code_operator_indirection): "*"
action(user.code_operator_address_of): "&"
action(user.code_operator_structure_dereference): "->"
action(user.code_operator_subscript):
    insert("[]")
    key(left)
action(user.code_operator_assignment): " = "
action(user.code_operator_subtraction): " - "
action(user.code_operator_subtraction_assignment): " -= "
action(user.code_operator_addition): " + "
action(user.code_operator_addition_assignment): " += "
action(user.code_operator_multiplication): " * "
action(user.code_operator_multiplication_assignment): " *= "
#action(user.code_operator_exponent): " ** "
action(user.code_operator_division): " / "
action(user.code_operator_division_assignment): " /= "
action(user.code_operator_modulo): " % "
action(user.code_operator_modulo_assignment): " %= "
action(user.code_operator_equal): " == "
action(user.code_operator_not_equal): " != "
action(user.code_operator_greater_than): " > "
action(user.code_operator_greater_than_or_equal_to): " >= "
action(user.code_operator_less_than): " < "
action(user.code_operator_less_than_or_equal_to): " <= "
action(user.code_operator_and): " && "
action(user.code_operator_or): " || "
action(user.code_operator_bitwise_and): " & "
action(user.code_operator_bitwise_and_assignment): " &= "
action(user.code_operator_bitwise_or): " | "
action(user.code_operator_bitwise_or_assignment): " |= "
action(user.code_operator_bitwise_exclusive_or): " ^ "
action(user.code_operator_bitwise_exclusive_or_assignment): " ^= "
action(user.code_operator_bitwise_left_shift): " << "
action(user.code_operator_bitwise_left_shift_assignment): " <<= "
action(user.code_operator_bitwise_right_shift): " >> "
action(user.code_operator_bitwise_right_shift_assignment): " >>= "
action(user.code_null): "NULL"
action(user.code_is_null): " == NULL "
action(user.code_is_not_null): " != NULL"
action(user.code_state_if):
    insert("if () {}")
    key(left)
    key(enter)
    key(up)
action(user.code_state_else_if):
    insert("else if () {}")
    key(left enter up right:5)
action(user.code_state_else):
    insert("else {}")
    key(left enter)
action(user.code_state_switch):
    insert("switch () {}")
    key(left enter up right:4)
action(user.code_state_case):
    insert("case :")
    key(enter)
    insert("break;")
    key(up left)
action(user.code_state_for): 
    "for () {}"
    key(left enter up right)
action(user.code_state_go_to): "goto "
action(user.code_state_while):
    insert("while () {}")
    key(left enter up right:3)
action(user.code_state_return): "return "
action(user.code_break): "break;"
action(user.code_next): "continue;"
action(user.code_true): "true"
action(user.code_false): "false"
action(user.code_type_definition): "typedef "
action(user.code_from_import): "using "
action(user.code_include): insert("#include ")
action(user.code_include_system):
    insert("#include <>")
    edit.left()
action(user.code_include_local):
    insert('#include ""')
    edit.left()
action(user.code_comment): "//"
action(user.code_block_comment):
    insert("/*")
    key(enter)
    key(enter)
    insert("*/")
    edit.up()
action(user.code_block_comment_prefix): "/*"
action(user.code_block_comment_suffix): "*/"

action(user.code_block):
    insert("{}")
    key(left enter)

# XXX - make these generic in programming, as they will match cpp, etc
state define: "#define "
state undefine: "#undef "
state if define: "#ifdef "

# XXX - preprocessor instead of pre?
state pre if: "#if "
state error: "#error "
state pre else if: "#elif "
state pre end: "#endif "
state pragma: "#pragma "

state default: 
    "default:"
    key("enter")
state break: "break;"

# Declare variables or structs etc.
# Ex. * int myList
#<user.variable> <phrase>:
#    insert("{variable} ")
#    insert(user.formatted_text(phrase, "PRIVATE_CAMEL_CASE,NO_SPACES"))

#<user.variable> <user.letter>:
#    insert("{variable} {letter} ")

# Ex. int * testFunction
# TODO: these clearly don't want to use function_key, so what do they want to use?
# fun <user.function> <phrase>:
#     insert("{function} ")
#     insert(user.formatted_text(phrase, "PRIVATE_CAMEL_CASE,NO_SPACES"))
#     insert("()")
#     edit.left()

# <user.function>:
#     insert("{function} ")

# Ex. (int *)
#cast to <user.cast>: "{cast}"
#standard cast to <user.stdint_cast>: "{stdint_cast}"
#<user.c_types>: "{c_types}"
#<user.c_pointers>: "{c_pointers}"
#<user.c_signed>: "{c_signed}"
#standard <user.stdint_types>: "{stdint_types}"
#call <user.c_functions>:
#    insert("{c_functions}()")
#    edit.left()
##import standard libraries
#include <user.library>:
#    insert("#include <{library}>")
#    key(enter)
#int main:
#    insert("int main()")
#    edit.left()

# exclamations

yolo: ";\n"
olive: "; "
increment: "++"
decrement: "--"
scope: "::"
hut: ", "

ref: "&"
return: "return "

# declarations

declare class <user.text>: 
    insert("class ")
    insert(user.formatted_text(text, "PUBLIC_CAMEL_CASE,NO_SPACES"))
    insert(" {};")
    key(left:2 enter)

declare struct <user.text>: 
    insert("struct ")
    insert(user.formatted_text(text, "SNAKE_CASE,NO_SPACES"))
    insert(" {};")
    key(left:2 enter)

declare name space <user.text>:
    insert("namespace ")
    insert(user.formatted_text(text, "SNAKE_CASE,NO_SPACES"))
    insert(" {};")
    key(left:2 enter)

# Verbs

see out:
    insert("std::cout << ")
see air:
    insert("std::cerr << ")
see air format:
    insert("std::cerr << tfm::format(\"\")")
    key(left:2)


# Adjectives

con ref: " const& "

<user.cpp_modifiers>: "{cpp_modifiers}"

# Nouns.

<user.cpp_namespaced_type> : "{cpp_namespaced_type} "

<user.cpp_integral>: "{cpp_integral} "
#stud scope: "std::"

#stud string: "std::string"
#stud string view: "std::string_view"

#stud <user.cpp_std_templates>: 
#    insert("std::")
#    insert(cpp_std_templates)
#    insert("<>")
#    key(left)

#glum scope: "glm::"
#glum <user.glm_types>: "glm::{glm_types} "

#gabby scope: "gba::"
#gabby <user.gba_types>: "gba::{gba_types} "

label <user.text>:
    insert(user.formatted_text(text, "SNAKE_CASE,NO_SPACES"))
    insert(":")
    key(enter)

class <user.text>:
    insert(user.formatted_text(text, "PUBLIC_CAMEL_CASE,NO_SPACES"))

meth <user.text>:
    insert(user.formatted_text(text, "PRIVATE_CAMEL_CASE,NO_SPACES"))

struct <user.text>:
    insert(user.formatted_text(text, "SNAKE_CASE,NO_SPACES"))

field <user.text>:
    insert(user.formatted_text(text, "PRIVATE_CAMEL_CASE,NO_SPACES"))

local <user.text>:
    insert(user.formatted_text(text, "PRIVATE_CAMEL_CASE,NO_SPACES"))

funk <user.text>:
    insert(user.formatted_text(text, "SNAKE_CASE,NO_SPACES"))
