#Benjamin Ramirez Dec 5 2016
#making a GUI for linking with a MYSQL Database containing hearthstone data

import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *
from Database import MyDB

WINDOW_LENGTH = 600
WINDOW_HEIGHT = 500

class Window(QDialog):
    def __init__(self):
        super(Window, self).__init__()
        self.setGeometry(50, 50, WINDOW_LENGTH, WINDOW_HEIGHT)
        self.mainLayout = QVBoxLayout()
        self.setWindowTitle("Hearthstone DB")
        self.database = None

        self.create_main_display()

        self.setLayout(self.mainLayout)
        self.show()

    def create_main_display(self):
        self.db_connection_fields()
        self.query_text_fields()
        self.createHearthstoneFields()
        self.createHearthstoneViews()

    def make_line_box(self, name):
        label = QLabel(name)
        line_box = QLineEdit()
        line_box.setEnabled(False)
        line_box.setFrame(False)
        return (label, line_box)



    def add_layout_widgets(self, widgets_list):
        layout = QHBoxLayout()
        for i in range(len(widgets_list)):
            layout.addWidget(widgets_list[i])
        return layout


    def db_connection_fields(self):
        self.db_connection_row = QGroupBox("DB Connection Params")
        layout = QHBoxLayout()

        self.host_textbox = QLineEdit(self)
        self.host_textbox.setPlaceholderText("Host (ex: 'localhost')")
        layout.addWidget(self.host_textbox)

        self.user_textbox = QLineEdit(self)
        self.user_textbox.setPlaceholderText("UserName (ex: 'root')")
        layout.addWidget(self.user_textbox)

        self.password_textbox = QLineEdit(self)
        self.password_textbox.setPlaceholderText("Password")
        layout.addWidget(self.password_textbox)

        self.database_textbox = QLineEdit(self)
        self.database_textbox.setPlaceholderText("DB Name ('aviationco')")
        layout.addWidget(self.database_textbox)

        connect_button = QPushButton("Connect")
        connect_button.clicked.connect(self.connect_DB)
        layout.addWidget(connect_button)
        layout.addStretch(1)

        plane_label = QLabel(self)
        plane_label.setPixmap(QPixmap('airplane_dude.png'))
        plane_label.setMaximumSize(100, 50)
        plane_label.setScaledContents(True)
        layout.addWidget(plane_label)

        self.db_connection_row.setLayout(layout)
        self.mainLayout.addWidget(self.db_connection_row)


    def createHearthstoneFields(self):
        hs_group = QGroupBox("Hearthstone Procedures")
        hs_layout = QHBoxLayout()
        hs_layout_list = []

        add_deck_label, self.deck_id_line = self.make_line_box("Set id:")
        add_deck_name, self.deck_name_line = self.make_line_box("Set Name")

        self.add_deck_button= QPushButton("Add Deck!") #button that launches the query
        self.add_deck_button.clicked.connect(self.createDeck)

        hs_layout_list.extend([add_deck_label, self.deck_id_line,
                               add_deck_name, self.deck_name_line,
                               self.add_deck_button] )

        hs_group.setLayout(self.add_layout_widgets(hs_layout_list))
        self.mainLayout.addWidget(hs_group)

    def createHearthstoneViews(self):
        #adding buttons that disply the information in from the view we created
        hs_view_group = QGroupBox("Hearthstone Views")
        hs_view_layout = QHBoxLayout()
        hs_view_list = []

        #creating the buttons which launch connects to the different views we made
        self.pro_decks_button = QPushButton("View Popular Pro Decks")
        self.pro_decks_button.clicked.connect(self.pro_decks_query)

        self.streamer_decks_button = QPushButton("View Popular Streamer Decks")
        self.streamer_decks_button.clicked.connect(self.streamer_deck_view)

        self.popular_streamers_button = QPushButton("Popular Streamers")
        self.popular_streamers_button.clicked.connect(self.popular_streamers_view)

        self.pro_earnings_button = QPushButton("Pro Earnings")
        self.pro_earnings_button.clicked.connect(self.pro_earnings_view)

        self.tournament_info_button = QPushButton("Tournament Info")
        self.tournament_info_button.clicked.connect(self.tournament_info_view)

        hs_view_list.extend([self.pro_decks_button, self. streamer_decks_button,
                             self.popular_streamers_button, self.pro_earnings_button,
                             self.tournament_info_button])
        hs_view_group.setLayout(self.add_layout_widgets(hs_view_list))
        self.mainLayout.addWidget(hs_view_group)


    #the following could use some refactoring or generation as a function
    def pro_decks_query(self, view_name):
        self.sql_textbox.setText("select * from popular_pro_decks;")
        self.run_query()

    def streamer_deck_view(self):
        self.sql_textbox.setText("select * from popular_streamer_decks;")
        self.run_query()

    def popular_streamers_view(self):
        self.sql_textbox.setText("select * from popular_streamers;")
        self.run_query()

    def pro_earnings_view(self):
        self.sql_textbox.setText("select * from pro_earnings;")
        self.run_query()

    def tournament_info_view(self):
        self.sql_textbox.setText("select * from tournament_info;")
        self.run_query()

    def createDeck(self):
        deck_id = self.deck_id_line.text()
        deck_name = self.deck_name_line.text()
        print (deck_id, deck_name)
        querystring = "insert into decks( deck_id , deck_name) values(" + deck_id + "," + deck_name + ");"
        # querystring = "call createdeck(" + str(deck_id) + "," + deck_name + ");"
        try:
            self.sql_textbox.setText(querystring)
            self.run_query()
        except:
            self.result_textbox.setText("Query Failed")


    def addCardToDeck(self, deck_id, card_name, card_count):
        querystring = "call addcard(" + deck_id + "," +card_name+ "," +card_count +");"
        try:
            self.sql_textbox.setText(querystring)
            self.run_query()
        except:
            self.result_textbox.setText("Query Failed")


    def connect_DB(self):
        try:
            self.database = MyDB(self.host_textbox.text(),
                                 self.user_textbox.text(),
                                 self.password_textbox.text(),
                                 self.database_textbox.text())
            QMessageBox.question(self, 'ConnectionResult', "Connection SUCCESS", QMessageBox.Ok, QMessageBox.Ok)
            self.enable_fields()
        except:
            QMessageBox.question(self, 'ConnectionResult', "Connection FAILED", QMessageBox.Ok, QMessageBox.Ok)

    def create_insertion_sql(self, table_name, values_array):
        query_string = "INSERT INTO " + table_name + " VALUES ("
        for i in range(len(values_array)):
            if i == (len(values_array) - 1):
                query_string += " " + values_array[i] + ");"
            query_string += " " + values_array[i] + ","
        try:
            self.sql_textbox.setText(query_string)
            self.run_query()
        except:
            "Select_sql failed"
            # self.execute_query(query_string

    def create_deletion_deletion(self, table_name, row_val, column):
        deletion_string = "DELETE FROM " + table_name + " WHERE " + column + " = " + row_val + ";"
        # self.execute_query(deletion_string)
        try:
            self.sql_textbox.setText(deletion_string)
            self.run_query()
        except:
            "Select_sql failed"

    def create_selection_sql(self, table_name, column, row, order_col):

        query_string = "SELECT * from " + table_name
        row_string, order_string = "", ""
        if column != '':
            if row != '':
                row_string = " WHERE " + column + " = " + row
        if order_col != '':
            order_string = " ORDER BY " + order_col
        query_string += row_string + order_string + ";"

        try:
            self.sql_textbox.setText(query_string)
            self.run_query()
        except:
            "Select_sql failed"

    def enable_fields(self):
        self.execute_button.setEnabled(True)
        self.deck_name_line.setEnabled(True)
        self.deck_id_line.setEnabled(True)

    def query_text_fields(self):
        query_group = QGroupBox("SQL")
        query_box = QHBoxLayout()
        result_group = QGroupBox("RESULTS")
        result_box = QHBoxLayout()

        self.sql_textbox = QLineEdit(self)
        self.sql_textbox.setPlaceholderText("ENTER YOUR QUERY HERE")
        self.result_textbox = QTextEdit(self)
        self.result_textbox.setPlaceholderText("RESULT SPACE")
        query_box.addWidget(self.sql_textbox)
        query_group.setLayout(query_box)

        result_box.addWidget(self.result_textbox)
        result_group.setLayout(result_box)

        self.mainLayout.addWidget(query_group)
        self.mainLayout.addWidget(result_group)

        self.execute_button = QPushButton('ExecuteSQL!')
        self.execute_button.clicked.connect(self.run_query)
        self.execute_button.setEnabled(False)
        self.mainLayout.addWidget(self.execute_button)

    def run_query(self):
        self.database.execute_query(self.sql_textbox.text())
        try:
            self.result_textbox.clear()
            results = self.database.cursor.fetchall()
            if results is not None:
                self.result_textbox.append("COLUMNS:")

                result_string = ""
                for key in results[0]:
                    result_string += key + "\t"
                self.result_textbox.append(result_string)
                self.result_textbox.append("VALUES:")

                for result in results:
                    print(result)
                    value_string = ""
                    for key in result:
                        # self.result_textbox.append(str(value))
                        value_string += str(result[key]) + "\t"
                    self.result_textbox.append(value_string)

        except:
            self.result_textbox.setText("Improper query or return is empty")


print("starting application")
app = QApplication(sys.argv)
GUI = Window()
sys.exit(app.exec_())
