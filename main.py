import time
from instrument import instrument, save_log_to_file


@instrument
def example_function():
    time.sleep(0.0001)
    hello_world()
    some_math()
    hello_world()


@instrument
def another_function():
    time.sleep(0.0002)
    hello_world()
    time.sleep(0.0003)


@instrument
def hello_world():
    print("Hello, World!")


@instrument
def some_math():
    return 1 + 1


@instrument
def run():
    example_function()
    another_function()
    some_math()


if __name__ == "__main__":
    run()
    save_log_to_file("execution_log.txt")
