from talon import Context, Module, actions, settings
from typing import Tuple

## Configuration.

namespaced_types = {
    "stud" : 
        ("std", "::",
            {"optional": "optional",
             "vector": "vector",
             "unique pointer": "unique_ptr",
             "shared pointer": "shared_ptr",
             "weak pointer": "weak_ptr"}),
    "glum" :
        ("glm", "::",
            {"vec two": "vec2",
            "vec three": "vec3",
            "vec four": "vec4",

            "int two": "i32vec2",
            "int three": "i32vec3",
            "int four": "i32vec4",

            "you int two": "u32vec2",
            "you int three": "u32vec3",
            "you int four": "u32vec4",

            "long two": "i64vec2",
            "long three": "i64vec3",
            "long four": "i64vec4",

            "you long two": "u64vec2",
            "you long three": "u64vec3",
            "you long four": "u64vec4"}),
    "gabby" :
        ("gba", "::",
            {"vec": "vec2",
            "bee two": "bvec2",
            "as two": "svec2",

            "you vec": "uvec2",
            "you bee two": "ubvec2",
            "you as two": "usvec2",

            "dim": "dim",
            "big dim": "bigdim"}),
    "gee cry" :
        ("gcry", "_",
            {})
}

namespace_meta = {}

## Implementation.

mod = Module()
mod.setting(
    "use_stdint_datatypes ", type=int, default=1, desc="beep",
)

ctx = Context()

ctx.lists["self.cpp_integral"] = {
    "char": "char",
    "byte": "int8_t",
    "short": "int16_t",
    "long": "int32_t",
    "long long": "int64_t",
    "integer": "int32_t",
    "float": "float",
    "double": "double",
    "size type": "std::size_t",

    "you byte": "uint8_t",
    "you short": "uint16_t",
    "you long": "uint32_t",
    "you long long": "uint64_t",
    "you integer": "uint32_t",

    "auto": "auto",
    "boolean": "bool",
    "void": "void",
}

ctx.lists["self.cpp_modifiers"] = {
    "constant": "const",
    "inline": "inline",
    "volatile": "volatile",
    "virtual": "virtual",
    "static": "static"
}

def codeword_namespace_list():
    list_rule = {}
    for word, namespace in namespaced_types.items():
        list_rule[word] = namespace[0]
    return list_rule

ctx.lists["self.cpp_known_namespaces"] = codeword_namespace_list()
mod.list("cpp_known_namespaces", desc = "Known C++ namespaces.")

# Get the list name for the given namespace name.
def namespace_list_symbol(namespace_name, prefixSelf = False):
    return ("self." if prefixSelf else "") + "cpp_{}_types".format(namespace_name)

# Get the unified capture rule for all the namespaced types.
def namespaced_types_rule():
    return " | ".join(map(lambda chi: "{} {{{}}}".format(chi[0], namespace_list_symbol(chi[1][0], True)), namespaced_types.items()))

# Add all the namespaced types to the grammar and secondary map.
for word, namespace in namespaced_types.items():
    sym = namespace_list_symbol(namespace[0])
    namespace_meta[namespace[0]] = namespace
    ctx.lists["self." + sym] = namespace[2]
    mod.list(sym, desc="C++ types in the {} namespace.".format(namespace[0]))


# Module declarations

@mod.capture
def cpp_namespaced_type(m) -> str:
    "Returns a string"

@ctx.capture(rule=namespaced_types_rule())
def cpp_namespaced_type(m) -> str:
    ns = namespaced_types[str(m[0])]
    return "{}{}{}".format(ns[0], ns[1], ns[2][str(m[1])])

mod.list("cpp_integral", desc="C++ integral types.")
mod.list("cpp_modifiers", desc="C++ modifiers.")

@mod.capture
def cpp_integral(m) -> str:
    "Returns a string"

@ctx.capture(rule="{self.cpp_integral}")
def cpp_integral(m) -> str:
    return m.cpp_integral

@mod.capture
def cpp_modifiers(m) -> str:
    "Returns a string"

@ctx.capture(rule = "{self.cpp_modifiers}+")
def cpp_modifiers(m) -> str:
    return " ".join(m.cpp_modifiers_list)

@mod.capture
def cpp_known_namespaces(m) -> str:
    "Returns a string"

@ctx.capture(rule="{self.cpp_known_namespaces}")
def cpp_known_namespaces(m) -> Tuple[str, str]:
    joiner = namespace_meta[m.cpp_known_namespaces][1]
    return (m.cpp_known_namespaces, joiner)


@mod.action_class
class Actions:
    def cpp_namespace_with_joiner(ns: Tuple[str, ...]) -> str:
        """Returns a namespace and its joiner, e.g. 'std::' """
        return ns[0] + ns[1]
    def cpp_naked_namespace(ns: Tuple[str, ...]) -> str:
        """Gets only the namespace part of a namespace."""
        return ns[0]
    pass

# mod.list("c_signed", desc="Common C datatype signed modifiers")
# mod.list("c_types", desc="Common C types")
# mod.list("c_libraries", desc="Standard C library")
# mod.list("c_functions", desc="Standard C functions")
# mod.list("stdint_types", desc="Common stdint C types")
# mod.list("stdint_signed", desc="Common stdint C datatype signed modifiers")


@mod.capture
def cast(m) -> str:
    "Returns a string"


@mod.capture
def stdint_cast(m) -> str:
    "Returns a string"


@mod.capture
def c_pointers(m) -> str:
    "Returns a string"


@mod.capture
def c_signed(m) -> str:
    "Returns a string"




@mod.capture
def c_functions(m) -> str:
    "Returns a string"


@mod.capture
def stdint_types(m) -> str:
    "Returns a string"


@mod.capture
def stdint_signed(m) -> str:
    "Returns a string"


@mod.capture
def variable(m) -> str:
    "Returns a string"


@mod.capture
def function(m) -> str:
    "Returns a string"


@mod.capture
def library(m) -> str:
    "Returns a string"


@ctx.capture(rule="{self.c_pointers}")
def c_pointers(m) -> str:
    return m.c_pointers


@ctx.capture(rule="{self.c_signed}")
def c_signed(m) -> str:
    return m.c_signed


@ctx.capture(rule="{self.c_types}")
def c_types(m) -> str:
    return m.c_types


@ctx.capture(rule="{self.c_types}")
def c_types(m) -> str:
    return m.c_types


@ctx.capture(rule="{self.c_functions}")
def c_functions(m) -> str:
    return m.c_functions


@ctx.capture(rule="{self.stdint_types}")
def stdint_types(m) -> str:
    return m.stdint_types


@ctx.capture(rule="{self.stdint_signed}")
def stdint_signed(m) -> str:
    return m.stdint_signed


@ctx.capture(rule="{self.c_libraries}")
def library(m) -> str:
    return m.c_libraries


# NOTE: we purposely we don't have a space after signed, to faciltate stdint
# style uint8_t constructions
@ctx.capture(rule="[<self.c_signed>]<self.c_types> [<self.c_pointers>+]")
def cast(m) -> str:
    return "(" + " ".join(list(m)) + ")"


# NOTE: we purposely we don't have a space after signed, to faciltate stdint
# style uint8_t constructions
@ctx.capture(rule="[<self.stdint_signed>]<self.stdint_types> [<self.c_pointers>+]")
def stdint_cast(m) -> str:
    return "(" + "".join(list(m)) + ")"


@ctx.capture(rule="[<self.c_signed>]<self.c_types>[<self.c_pointers>]")
def variable(m) -> str:
    return " ".join(list(m))
