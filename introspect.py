import inspect
import importlib.util


def get_module_functions(file_path):
    """Load a Python file and return all function objects defined in it."""
    # Create module spec and load the module
    spec = importlib.util.spec_from_file_location("dynamic_module", file_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)

    # Get all functions defined in the module
    functions = {}
    for name, obj in inspect.getmembers(module):
        if inspect.isfunction(obj) and obj.__module__ == "dynamic_module":
            functions[name] = obj

    return functions


# Usage example:
functions = get_module_functions("main.py")
for name, func in functions.items():
    print(f"Found function: {name}")
    # Get function's source code
    print(inspect.getsource(func))
    # Get called functions from function body
    for ref in inspect.getclosurevars(func).globals:
        if callable(ref):
            print(f"Calls: {ref.__name__}")
