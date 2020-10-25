from talon import Context, Module, actions, settings, resource, fs
from typing import Tuple, Dict
import os
import json
import pathlib
import sqlite3

## Configuration.

namespaced_templates = {}

json_namespace_table = {}
json_codeword_table = {}

## Load namespaces from JSON file.
def load_json(path):
    with resource.open(str(pathlib.Path('taxonomy') / path), 'r') as f:
        j = json.load(f)
        for ns in j:
            ns['joiner'] = ns.get('joiner', '::')
            json_namespace_table[ns['namespace']] = ns
            json_codeword_table[ns['codeword']] = ns

taxonomy_path = pathlib.Path(__file__).parent / 'taxonomy'

def on_json_change(path, exists):
    newfile = pathlib.Path(path).relative_to(taxonomy_path)
    if newfile.exists():
        load_json(newfile)   

fs.watch(str(taxonomy_path), on_json_change)

json_files = os.listdir(taxonomy_path)

for f in json_files:
    if not f.endswith(".json"):
        continue
    load_json(f)

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

# Extract the raw codeword -> namespace list.
def extract_codeword_namespace():
    list_rule = {}
    for word in json_codeword_table:
        list_rule[word] = json_codeword_table[word]['namespace']
    return list_rule

ctx.lists["self.cpp_known_namespaces"] = extract_codeword_namespace()
mod.list("cpp_known_namespaces", desc = "Known C++ namespaces.")

# Get the list name for the given namespace name.
def namespace_list_symbol(namespace_name, suffix = "types", prefix_self = False):
    return ("self." if prefix_self else "") + "cpp_{}_{}".format(namespace_name, suffix)

# Construct an or-separated rule to capture each list of types.
def construct_types_rule(suffix = "types"):
    mapped = map(lambda ns: "{} {{{}}}".format(ns['codeword'], namespace_list_symbol(ns['namespace'], suffix=suffix, prefix_self=True)), json_codeword_table.values())
    return " | ".join(mapped)

# Add a list from a particular namespace
def add_namespace_list(ns, json_key, list_suffix):
    sym = namespace_list_symbol(ns['namespace'], list_suffix, prefix_self = False)
    
    list_to_add = {}
    try:
        list_to_add = ns[json_key]
    except KeyError:
        pass

    ctx.lists["self." + sym] = list_to_add
    mod.list(sym, desc="C++ types in the {} namespace.".format(ns['namespace']))

def get_namespaced_noun(ns_codeword, noun, noun_type):
    ns = json_codeword_table[ns_codeword]
    type_parse = ns[noun_type][noun]
    return "{}{}{}".format(ns['namespace'], ns['joiner'], type_parse)

# Add all the known lists for all the loaded namespaces
for ns in json_codeword_table.values():
    add_namespace_list(ns, 'names', 'types')
    add_namespace_list(ns, 'templates', 'templates')


# Module/Context declarations

@mod.capture
def cpp_known_namespaces(m) -> str:
    "Returns a string"

@ctx.capture('self.cpp_known_namespaces', rule="{self.cpp_known_namespaces}")
def cpp_known_namespaces(m) -> Dict:
    return json_namespace_table[m.cpp_known_namespaces]

@mod.capture
def cpp_namespaced_type(m) -> str:
    "Returns a string"

@ctx.capture('self.cpp_namespaced_type', rule=construct_types_rule())
def cpp_namespaced_type(m) -> str:
    return get_namespaced_noun(str(m[0]), str(m[1]), 'names')

@mod.capture
def cpp_namespaced_template(m) -> str:
    "Returns a string"

@ctx.capture('self.cpp_namespaced_template', rule=construct_types_rule("templates"))
def cpp_namespaced_template(m) -> str:
    return get_namespaced_noun(str(m[0]), str(m[1]), 'templates')

mod.list("cpp_integral", desc="C++ integral types.")
mod.list("cpp_modifiers", desc="C++ modifiers.")

@mod.capture
def cpp_integral(m) -> str:
    "Returns a string"

@ctx.capture('self.cpp_integral', rule="{self.cpp_integral}")
def cpp_integral(m) -> str:
    return m.cpp_integral

@mod.capture
def cpp_modifiers(m) -> str:
    "Returns a string"

@ctx.capture('self.cpp_modifiers', rule = "{self.cpp_modifiers}+")
def cpp_modifiers(m) -> str:
    return " ".join(m.cpp_modifiers_list)

@mod.action_class
class Actions:
    def cpp_namespace_with_joiner(ns: Dict) -> str:
        """Returns a namespace and its joiner, e.g. 'std::' """
        return ns['namespace'] + ns['joiner']
    def cpp_naked_namespace(ns: Dict) -> str:
        """Gets only the namespace part of a namespace."""
        return ns['namespace']
    pass

