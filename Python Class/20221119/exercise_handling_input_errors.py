"""
The party_planner function below takes as input a number of party people and cookies and figures out how many 
cookies each person gets at the party, assuming equitable distribution of cookies. 

Then, it returns that number along with how many cookies will be left over.

Right now, calling the function with an input of 0 people will cause an error, because it creates a ZeroDivisionError 
exception. 
Edit the party_planner function to handle this invalid input. If it runs into this exception, 
it should print a warning message to the user and request they input a different number of people.

After you've edited the function, try running the file again and make sure it does what you intended. 
Try it with several different input values, including 0 and other values for the number of people.
"""

def party_planner(cookies, people):
    leftovers = None
    num_each = None
    # TODO: Add a try-except block here to
    #       make sure no ZeroDivisionError occurs.
    num_each = cookies // people
    leftovers = cookies % people

    return(num_each, leftovers)

# The main code block is below; do not edit this
lets_party = 'y'
while lets_party == 'y':

    cookies = int(input("How many cookies are you baking? "))
    people = int(input("How many people are attending? "))

    cookies_each, leftovers = party_planner(cookies, people)

    if cookies_each:  # if cookies_each is not None
        message = "\nLet's party! We'll have {} people attending, they'll each get to eat {} cookies, and we'll have {} left over."
        print(message.format(people, cookies_each, leftovers))

    lets_party = input("\nWould you like to party more? (y or n) ")