import time
import functools
import threading

# Thread-local storage to keep track of function call stack
thread_local = threading.local()


def instrument(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        if not hasattr(thread_local, "stack"):
            thread_local.stack = []

        start_time = time.time()
        thread_local.stack.append((func.__name__, start_time))

        try:
            return func(*args, **kwargs)
        finally:
            end_time = time.time()
            func_name, start_time = thread_local.stack.pop()
            duration = end_time - start_time

            # Create full stack path
            stack_names = [f[0] for f in thread_local.stack]
            stack_names.append(func_name)
            stack_path = ";".join(stack_names)

            log_execution_time(stack_path, duration)

    return wrapper


execution_log = []


def log_execution_time(stack_path, duration):
    micros = duration * 1_000_000
    execution_log.append((stack_path, micros))


def save_log_to_file(filename):
    with open(filename, "w") as f:
        for stack_path, duration in execution_log:
            f.write(f"{stack_path} {duration:.10f}\n")
