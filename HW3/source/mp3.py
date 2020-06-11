from customer import Customer

import psycopg2

from config import read_config
from messages import *

POSTGRESQL_CONFIG_FILE_NAME = "database.cfg"

"""
    Connects to PostgreSQL database and returns connection object.
"""


def connect_to_db():
    db_conn_params = read_config(filename=POSTGRESQL_CONFIG_FILE_NAME, section="postgresql")
    conn = psycopg2.connect(**db_conn_params)
    conn.autocommit = False
    return conn


"""
    Splits given command string by spaces and trims each token.
    Returns token list.
"""


def tokenize_command(command):
    tokens = command.split(" ")
    return [t.strip() for t in tokens]


"""
    Prints list of available commands of the software.
"""


def help():
    # prints the choices for commands and parameters
    print("\n*** Please enter one of the following commands ***")
    print("> help")
    print("> sign_up <email> <password> <first_name> <last_name> <plan_id>")
    print("> sign_in <email> <password>")
    print("> sign_out")
    print("> show_plans")
    print("> show_subscription")
    print("> subscribe <plan_id>")
    print("> watched_movies <movie_id_1> <movie_id_2> <movie_id_3> ... <movie_id_n>")
    print("> search_for_movies <keyword_1> <keyword_2> <keyword_3> ... <keyword_n>")
    print("> suggest_movies")
    print("> quit")


"""
    Saves customer with given details.
    - Return type is a tuple, 1st element is a boolean and 2nd element is the response message from messages.py.
    - If the operation is successful, commit changes and return tuple (True, CMD_EXECUTION_SUCCESS).
    - If any exception occurs; rollback, do nothing on the database and return tuple (False, CMD_EXECUTION_FAILED).
"""


def sign_up(conn, email, password, first_name, last_name, plan_id):
    # TODO: Implement this function
    insertCustomer = "INSERT INTO Customer(email, password, first_name, last_name, session_count, plan_id) VALUES(%s,%s,%s,%s,%s,%s);"

    try:
        cur = conn.cursor()
        cur.execute(insertCustomer,(email, password, first_name, last_name, 0 ,plan_id))
        
        conn.commit()
        cur.close()
        return True, CMD_EXECUTION_SUCCESS
    except (Exception, psycopg2.DatabaseError) as error:
        conn.rollback()
        cur.close()
        return False, CMD_EXECUTION_FAILED

"""
    Retrieves customer information if email and password is correct and customer's session_count < max_parallel_sessions.
    - Return type is a tuple, 1st element is a customer object and 2nd element is the response message from messages.py.
    - If email or password is wrong, return tuple (None, USER_SIGNIN_FAILED).
    - If session_count < max_parallel_sessions, commit changes (increment session_count) and return tuple (customer, CMD_EXECUTION_SUCCESS).
    - If session_count >= max_parallel_sessions, return tuple (None, USER_ALL_SESSIONS_ARE_USED).
    - If any exception occurs; rollback, do nothing on the database and return tuple (None, USER_SIGNIN_FAILED).
"""


def sign_in(conn, email, password):
    # TODO: Implement this function
    selectCustomerWithEmail = "SELECT * FROM Customer WHERE email = %s AND password = %s;"
    selectPlanWithPlanID = "SELECT * FROM Plan WHERE plan_id = %s"
    updateCustomer = "UPDATE Customer SET session_count = %s WHERE email = %s AND password = %s;"
    try:
        cur = conn.cursor()
        cur.execute(selectCustomerWithEmail,(email,password,))
        selectedCustomer = cur.fetchall()
        if len(selectedCustomer) == 1:
            cur.execute(selectPlanWithPlanID,(selectedCustomer[0][6],))
            selectedPlan = cur.fetchall()
            max_parallel_sessions = selectedPlan[0][3]
            if selectedCustomer[0][5] < max_parallel_sessions:              
                cur.execute(updateCustomer,(selectedCustomer[0][5]+1,email,password,))
                customerObject = Customer(customer_id = selectedCustomer[0][0],email = selectedCustomer[0][1],first_name = selectedCustomer[0][3],last_name = selectedCustomer[0][4],session_count = selectedCustomer[0][5]+1,plan_id = selectedCustomer[0][6])
                conn.commit()
                cur.close()
                return customerObject, CMD_EXECUTION_SUCCESS
            else:
                conn.rollback()
                cur.close()
                return None, USER_ALL_SESSIONS_ARE_USED
    except (Exception, psycopg2.DatabaseError) as error:
        conn.rollback()
        cur.close()
        return None, USER_SIGNIN_FAILED
    conn.rollback()
    cur.close()
    return None, USER_SIGNIN_FAILED


"""
    Signs out from given customer's account.
    - Return type is a tuple, 1st element is a boolean and 2nd element is the response message from messages.py.
    - Decrement session_count of the customer in the database.
    - If the operation is successful, commit changes and return tuple (True, CMD_EXECUTION_SUCCESS).
    - If any exception occurs; rollback, do nothing on the database and return tuple (False, CMD_EXECUTION_FAILED).
"""


def sign_out(conn, customer):
    updateCustomer = "UPDATE Customer SET session_count = %s WHERE customer_id = %s;"
    try:
        cur = conn.cursor()
        sessionCount = int(customer.session_count)-1
        customer.session_count = customer.session_count -1 
        cur.execute(updateCustomer,(sessionCount,customer.customer_id,))
        conn.commit()
        cur.close()
        return True, CMD_EXECUTION_SUCCESS
    except (Exception, psycopg2.DatabaseError) as error:
        conn.rollback()
        cur.close()
        return False, CMD_EXECUTION_FAILED


"""
    Quits from program.
    - Return type is a tuple, 1st element is a boolean and 2nd element is the response message from messages.py.
    - Remember to sign authenticated user out first.
    - If the operation is successful, commit changes and return tuple (True, CMD_EXECUTION_SUCCESS).
    - If any exception occurs; rollback, do nothing on the database and return tuple (False, CMD_EXECUTION_FAILED).
"""


def quit(conn, customer):
    # TODO: Implement this function
    try:
        return sign_out(conn,customer)
    except (Exception, psycopg2.DatabaseError) as error:
        conn.rollback()
        cur.close()
        return False, CMD_EXECUTION_FAILED


"""
    Retrieves all available plans and prints them.
    - Return type is a tuple, 1st element is a boolean and 2nd element is the response message from messages.py.
    - If the operation is successful; print available plans and return tuple (True, CMD_EXECUTION_SUCCESS).
    - If any exception occurs; return tuple (False, CMD_EXECUTION_FAILED).

    Output should be like:
    #|Name|Resolution|Max Sessions|Monthly Fee
    1|Basic|720P|2|30
    2|Advanced|1080P|4|50
    3|Premium|4K|10|90
"""


def show_plans(conn):
    # TODO: Implement this function
    selectAllPlans = "SELECT * FROM Plan;"
    try:
        cur = conn.cursor()
        cur.execute(selectAllPlans)
        allPlans = cur.fetchall()
        print("#|Name|Resolution|Max Sessions|Monthly Fee")
        for i in range(0,len(allPlans)):
            print(str(allPlans[i][0])+"|"+str(allPlans[i][1])+"|"+str(allPlans[i][2])+"|"+str(allPlans[i][3])+"|"+str(allPlans[i][4]))
        conn.commit()
        cur.close()
        return True, CMD_EXECUTION_SUCCESS
    except (Exception, psycopg2.DatabaseError) as error:
        conn.rollback()
        cur.close()
        return False, CMD_EXECUTION_FAILED

"""
    Retrieves authenticated user's plan and prints it. 
    - Return type is a tuple, 1st element is a boolean and 2nd element is the response message from messages.py.
    - If the operation is successful; print the authenticated customer's plan and return tuple (True, CMD_EXECUTION_SUCCESS).
    - If any exception occurs; return tuple (False, CMD_EXECUTION_FAILED).

    Output should be like:
    #|Name|Resolution|Max Sessions|Monthly Fee
    1|Basic|720P|2|30
"""


def show_subscription(conn, customer):
    # TODO: Implement this function
    selectAllPlans = "SELECT * FROM Plan WHERE plan_id = %s;"
    try:
        cur = conn.cursor()
        cur.execute(selectAllPlans,(customer.plan_id,))
        allPlans = cur.fetchall()
        if len(allPlans) == 1:
            print("#|Name|Resolution|Max Sessions|Monthly Fee")
            print(str(allPlans[0][0])+"|"+str(allPlans[0][1])+"|"+str(allPlans[0][2])+"|"+str(allPlans[0][3])+"|"+str(allPlans[0][4]))
            conn.commit()
            cur.close()
            return True, CMD_EXECUTION_SUCCESS
    except (Exception, psycopg2.DatabaseError) as error:
        conn.rollback()
        cur.close()
        return False, CMD_EXECUTION_FAILED
    conn.rollback()
    cur.close()
    return False, CMD_EXECUTION_FAILED

"""
    Insert customer-movie relationships to Watched table if not exists in Watched table.
    - Return type is a tuple, 1st element is a boolean and 2nd element is the response message from messages.py.
    - If a customer-movie relationship already exists, do nothing on the database and return (True, CMD_EXECUTION_SUCCESS).
    - If the operation is successful, commit changes and return tuple (True, CMD_EXECUTION_SUCCESS).
    - If any one of the movie ids is incorrect; rollback, do nothing on the database and return tuple (False, CMD_EXECUTION_FAILED).
    - If any exception occurs; rollback, do nothing on the database and return tuple (False, CMD_EXECUTION_FAILED).
"""


def watched_movies(conn, customer, movie_ids):
    # TODO: Im
    insertWatchedMovie = "INSERT INTO Watched(customer_id, movie_id) VALUES(%s,%s);"
    checkIfMovieIdExist = "SELECT * FROM Movies WHERE movie_id = %s;"
    checkIfWatched = "SELECT * FROM Watched WHERE customer_id = %s and movie_id = %s;"

    try:
        cur = conn.cursor()
        for i in range(0,len(movie_ids)):
            cur.execute(checkIfMovieIdExist,(movie_ids[i],))
            isMovieExist = cur.fetchall()
            if len(isMovieExist) > 0:
                    cur.execute(checkIfWatched,(customer.customer_id, movie_ids[i] ,))
                    isRecordExist = cur.fetchall()
                    if len(isRecordExist) == 0:
                         cur.execute(insertWatchedMovie,(customer.customer_id, movie_ids[i] ,))
                    else: 
                        continue
            else:
                conn.rollback()
                cur.close()
                return False, CMD_EXECUTION_FAILED
        conn.commit()
        cur.close()
        return True, CMD_EXECUTION_SUCCESS
    except (Exception, psycopg2.DatabaseError) as error:
        conn.rollback()
        cur.close()
        return False, CMD_EXECUTION_FAILED

"""
    Subscribe authenticated customer to new plan.
    - Return type is a tuple, 1st element is a customer object and 2nd element is the response message from messages.py.
    - If target plan does not exist on the database, return tuple (None, SUBSCRIBE_PLAN_NOT_FOUND).
    - If the new plan's max_parallel_sessions < current plan's max_parallel_sessions, return tuple (None, SUBSCRIBE_MAX_PARALLEL_SESSIONS_UNAVAILABLE).
    - If the operation is successful, commit changes and return tuple (customer, CMD_EXECUTION_SUCCESS).
    - If any exception occurs; rollback, do nothing on the database and return tuple (None, CMD_EXECUTION_FAILED).
"""


def subscribe(conn, customer, plan_id):
    # TODO: Implement this function
    selectPlan = "SELECT * FROM Plan WHERE plan_id = %s;"
    updateCustomer = "UPDATE Customer SET plan_id = %s WHERE customer_id = %s;"
    newPlan = None
    try:
        cur = conn.cursor()
        cur.execute(selectPlan,(plan_id,))
        newPlanList = cur.fetchall()
        if len(newPlanList) > 0:
            newPlan = newPlanList[0]
        else:
            conn.rollback()
            cur.close()  
            return None, SUBSCRIBE_PLAN_NOT_FOUND
        cur.execute(selectPlan,(customer.plan_id,))
        existingPlan = cur.fetchall()[0]
        if newPlan[3] < existingPlan[3]:
            conn.rollback()
            cur.close()
            return None, SUBSCRIBE_MAX_PARALLEL_SESSIONS_UNAVAILABLE
        else:
            cur.execute(updateCustomer,(plan_id,customer.customer_id,))
            customer.plan_id = plan_id
            conn.commit()
            cur.close()
            return customer, CMD_EXECUTION_SUCCESS

    except (Exception, psycopg2.DatabaseError) as error:
        conn.rollback()
        cur.close()
        return False, CMD_EXECUTION_FAILED
    conn.rollback()
    cur.close()  
    return None, CMD_EXECUTION_FAILED

"""
    Searches for movies with given search_text.
    - Return type is a tuple, 1st element is a boolean and 2nd element is the response message from messages.py.
    - Print all movies whose titles contain given search_text IN CASE-INSENSITIVE MANNER.
    - If the operation is successful; print movies found and return tuple (True, CMD_EXECUTION_SUCCESS).
    - If any exception occurs; return tuple (False, CMD_EXECUTION_FAILED).

    Output should be like:
    Id|Title|Year|Rating|Votes|Watched
    "tt0147505"|"Sinbad: The Battle of the Dark Knights"|1998|2.2|149|0
    "tt0468569"|"The Dark Knight"|2008|9.0|2021237|1
    "tt1345836"|"The Dark Knight Rises"|2012|8.4|1362116|0
    "tt3153806"|"Masterpiece: Frank Millers The Dark Knight Returns"|2013|7.8|28|0
    "tt4430982"|"Batman: The Dark Knight Beyond"|0|0.0|0|0
    "tt4494606"|"The Dark Knight: Not So Serious"|2009|0.0|0|0
    "tt4498364"|"The Dark Knight: Knightfall - Part One"|2014|0.0|0|0
    "tt4504426"|"The Dark Knight: Knightfall - Part Two"|2014|0.0|0|0
    "tt4504908"|"The Dark Knight: Knightfall - Part Three"|2014|0.0|0|0
    "tt4653714"|"The Dark Knight Falls"|2015|5.4|8|0
    "tt6274696"|"The Dark Knight Returns: An Epic Fan Film"|2016|6.7|38|0
"""


def search_for_movies(conn, customer, search_text):
    # TODO: Implement this function
    checkMovies = "SELECT * FROM Movies WHERE title ILIKE %s;"
    checkIsWatched = "SELECT * FROM Watched WHERE customer_id = %s AND movie_id = %s;"
    try:
        cur = conn.cursor()
        cur.execute(checkMovies,("%" + search_text + "%",))
        movies = cur.fetchall()
        print("Id|Title|Year|Rating|Votes|Watched")
        for i in range(0,len(movies)):
            cur.execute(checkIsWatched,(customer.customer_id,movies[i][0]))
            isWatched = cur.fetchall()
            if len(isWatched) > 0:
                print(str(movies[i][0])+"|"+str(movies[i][1])+"|"+str(movies[i][2])+"|"+str(movies[i][3])+"|"+str(movies[i][4])+"|1")
            else:
                print(str(movies[i][0])+"|"+str(movies[i][1])+"|"+str(movies[i][2])+"|"+str(movies[i][3])+"|"+str(movies[i][4])+"|0")
        conn.commit()
        cur.close()
        return True, CMD_EXECUTION_SUCCESS
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        conn.rollback()
        cur.close()
        return False, CMD_EXECUTION_FAILED


"""
    Suggests combination of these movies:
        1- Find customer's genres. For each genre, find movies with most number of votes among the movies that the customer didn't watch.

        2- Find top 10 movies with most number of votes and highest rating, such that these movies are released 
           after 2010 ( [2010, today) ) and the customer didn't watch these movies.
           (descending order for votes, descending order for rating)

        3- Find top 10 movies with votes higher than the average number of votes of movies that the customer watched.
           Disregard the movies that the customer didn't watch.
           (descending order for votes)

    - Return type is a tuple, 1st element is a boolean and 2nd element is the response message from messages.py.    
    - Output format and return format are same with search_for_movies.
    - Order these movies by their movie id, in ascending order at the end.
    - If the operation is successful; print movies suggested and return tuple (True, CMD_EXECUTION_SUCCESS).
    - If any exception occurs; return tuple (False, CMD_EXECUTION_FAILED).
"""


def suggest_movies(conn, customer):
    # TODO: Implement this function
    genresListQuery = "SELECT G.genre_name FROM Movies M, Watched W, Genres G WHERE W.customer_id = %s AND M.movie_id = W.movie_id AND G.movie_id = M.movie_id;"
    topMoviesListWithGenreQuery = "SELECT M.movie_id, M.title, M.movie_year, M.rating, M.votes FROM Movies M, Genres G WHERE  M.movie_id = G.movie_id AND G.genre_name = %s AND M.movie_id NOT IN (SELECT movie_id FROM Watched WHERE customer_id = %s) ORDER BY M.votes DESC LIMIT 1;"
    top10MoviesQuery = "SELECT * FROM Movies M WHERE M.movie_year >= 2010 AND M.movie_id NOT IN (SELECT movie_id FROM Watched WHERE customer_id = %s) ORDER BY M.votes DESC, M.rating DESC LIMIT 10;"
    findAvgVotesQuery = "SELECT AVG(M.votes) FROM Watched W, Movies M WHERE customer_id = %s AND M.movie_id = W.movie_id;"
    top10MoviesHigherThanAvgQuery = "SELECT * FROM Movies M WHERE M.votes > %s AND M.movie_id NOT IN (SELECT movie_id FROM Watched WHERE customer_id = %s) ORDER BY M.votes DESC LIMIT 10;"

    try:
        movies = set()
        
        cur = conn.cursor()
        cur.execute(genresListQuery,(customer.customer_id,))
        genres = cur.fetchall()
        uniqueGenreList = set()
        for genre in genres:
            uniqueGenreList.add(genre[0])
        for genre in genres:
            cur.execute(topMoviesListWithGenreQuery,(genre,customer.customer_id,))
            movie = cur.fetchall()[0]
            movies.add(movie)
        
        cur.execute(top10MoviesQuery,(customer.customer_id,))
        top10Movies = cur.fetchall()
        for movie in top10Movies:
            movies.add(movie)

        cur.execute(findAvgVotesQuery,(customer.customer_id,))
        avgVotes = cur.fetchall()
        if avgVotes[0][0] == None:
            cur.execute(top10MoviesHigherThanAvgQuery,(0,customer.customer_id,))
            top10MoviesHigherThanAvg = cur.fetchall()
            movies = top10MoviesHigherThanAvg
        else: 
            cur.execute(top10MoviesHigherThanAvgQuery,(float(avgVotes[0][0]),customer.customer_id,))
            top10MoviesHigherThanAvg = cur.fetchall()

        for movie in top10MoviesHigherThanAvg:
            movies.add(movie)

        movies = sorted(movies, key=lambda movie: movie[0], reverse=False)
        print("Id|Title|Year|Rating|Votes|Watched")
        for movie in movies:
            print(str(movie[0])+"|"+str(movie[1])+"|"+str(movie[2])+"|"+str(movie[3])+"|"+str(movie[4])+"|0")
        
        conn.commit()
        cur.close()
        return True, CMD_EXECUTION_SUCCESS
    except (Exception, psycopg2.DatabaseError) as error:
        conn.rollback()
        cur.close()
        return False, CMD_EXECUTION_FAILED
