#Benjamin Ramirez
#November 23 2016
import pymysql

class MyDB():
    def __init__(self, host, user, password, database):

        self.database = database

        self.connection = pymysql.connect(host=host,
                                              user=user,
                                              password=password,
                                              db=database,
                                              charset='utf8mb4',
                                              cursorclass=pymysql.cursors.DictCursor)

        self.cursor = self.connection.cursor()

    def execute_query(self, query):
        try:
            print(query)
            self.cursor.execute(query)
        except:
            print("Query Failed")


