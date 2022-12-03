def mean(list_of_nums):
    return sum(list_of_nums)/len(list_of_nums)

def add_num(list_of_nums, num):
    return [n + num  for n in list_of_nums]

def main():
    print("Testing the mean function")

    list_sample = [34, 44, 12]
    correct_mean = 30

    num = 5

    result = [39, 49, 17]

    assert(mean(list_sample) == correct_mean)
    print("Test 1 Passed")

    assert(add_num(list_sample, num))
    print("Test 2 Passed")

if __name__ == "__main__":
    main()