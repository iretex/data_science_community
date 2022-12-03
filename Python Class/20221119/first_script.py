# print("Hello, World!")

# name = input("Enter your name: ")
# print("Hello {}!".format(name.title()))

num = [1,4,7]#input("Enter an integer")

def pp(index):
    if index < len(num):
        for i in num[:index]:
            print("Hello" * (i))

if __name__ == "__main__":
    pp(1)