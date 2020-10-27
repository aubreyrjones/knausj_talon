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
action(user.code_block_comment_prefix): "/**"
action(user.code_block_comment_suffix): "*/"

action(user.code_block):
    insert("{}")
    key(left enter)

# XXX - make these generic in programming, as they will match cpp, etc
state define: "#define "
state undefine: "#undef "
state if define: "#ifdef "

# XXX - preprocessor instead of pre?
state error: "#error "
state pre if: "#if "
state pre else: "#else\n"
state pre else if: "#elif "
state pre end: "#endif "
state pragma: "#pragma "

state default: 
    "default:"
    key("enter")
state break: "break;"

state (name space | namespace): "namespace "
state using: "using "
state realize:
    insert("<>")
    key(left)


# exclamations

yolo: ";\n"
olive: "; "
hut: ", "
new bungee:
    key("end")
    key("enter")
    key("tab")
bungee:
    key("end")
    key("down")
    key("end")

increment: "++"
decrement: "--"
scope: "::"

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

declare template:
    insert("template <>")
    key(left)


# Verbs

see out:
    insert("std::cout << ")
see out format:
    insert("std::cout << tfm::format(\"\")")
    key(left:2)
see air:
    insert("std::cerr << ")
see air format:
    insert("std::cerr << tfm::format(\"\")")
    key(left:2)


# Adjectives

con ref: " const& "
<user.cpp_modifiers>: "{cpp_modifiers}"


# Nouns.

<user.cpp_integral>: "{cpp_integral} "
<user.cpp_namespaced_type> : "{cpp_namespaced_type} "

state <user.cpp_known_namespaces>: insert(user.cpp_naked_namespace(cpp_known_namespaces))
<user.cpp_known_namespaces> scope : insert(user.cpp_namespace_with_joiner(cpp_known_namespaces))

<user.cpp_namespaced_template>: 
    insert(cpp_namespaced_template)
    insert("<>")
    key(left)


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
