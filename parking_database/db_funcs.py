import sqlite3

DB_FILE = './sqlite/db/online_parking.db'
ONLINE_PARKING_TABLE = 'ONLINE_PARKING'


def display_table_content():
    con = sqlite3.connect(DB_FILE)
    cur = con.cursor()
    cur.execute(f"SELECT * FROM {ONLINE_PARKING_TABLE};")
    print(cur.fetchall())
    con.close()


def display_table_titles():
    con = sqlite3.connect(DB_FILE)
    cur = con.cursor()
    cur.execute(f"PRAGMA table_info({ONLINE_PARKING_TABLE});")
    print(cur.fetchall())
    con.close()


def display_db_tables():
    con = sqlite3.connect(DB_FILE)
    cur = con.cursor()
    cur.execute("SELECT name FROM sqlite_master WHERE type='table';")
    print(cur.fetchall())
    con.close()


def create_db_tables():
    con = sqlite3.connect(DB_FILE)

    con.execute("DROP TABLE IF EXISTS ONLINE_PARKING")

    con.execute(f'''CREATE TABLE {ONLINE_PARKING_TABLE}(
   ID INTEGER PRIMARY KEY AUTOINCREMENT,
   LOCATION TEXT NOT NULL,
   NUM_PARKING_SPOTS INT,
   NUM_SAVED_SPOTS INT DEFAULT 0,
   NUM_CAUGHT_SPOTS INT DEFAULT 0
   );''')

    # Commit your changes in the database
    con.commit()

    # Closing the connection
    con.close()


def add_parking_location(location, num_parking_location):
    con = sqlite3.connect(DB_FILE)

    con.execute(f'''INSERT INTO {ONLINE_PARKING_TABLE} (LOCATION,
   NUM_PARKING_SPOTS) 
      VALUES ('{location}',{num_parking_location});''')

    # Commit your changes in the database
    con.commit()

    # Closing the connection
    con.close()


def get_parking_by_id(parking_id):
    con = sqlite3.connect(DB_FILE)
    cur = con.cursor()

    cur.execute(f'''SELECT * FROM {ONLINE_PARKING_TABLE} WHERE ID={parking_id}''')
    records = cur.fetchall()

    con.close()

    return records[0]


def is_parking_free(parking_id):
    parking_id, location, num_parking_spots, num_saved_spots, num_caught_spots = get_parking_by_id(parking_id)

    return num_saved_spots + num_caught_spots < num_parking_spots


def get_best_parking_location_available(possible_parking_area):
    for parking_id in possible_parking_area:
        if is_parking_free(parking_id):
            return parking_id


def save_parking_location(parking_id):
    if not is_parking_free(parking_id):
        return None, None

    con = sqlite3.connect(DB_FILE)

    con.execute(f'''UPDATE {ONLINE_PARKING_TABLE} 
      SET NUM_SAVED_SPOTS = NUM_SAVED_SPOTS + 1,
      WHERE
          ID={parking_id} ''')

    con.commit()

    con.close()


def free_saved_parking(parking_id):
    con = sqlite3.connect(DB_FILE)

    con.execute(f'''UPDATE {ONLINE_PARKING_TABLE} 
        SET NUM_SAVED_SPOTS = NUM_SAVED_SPOTS - 1,
        WHERE
            ID={parking_id} ''')

    con.commit()

    con.close()


def caught_parking(parking_id):
    con = sqlite3.connect(DB_FILE)

    con.execute(f'''UPDATE {ONLINE_PARKING_TABLE} 
          SET NUM_CAUGHT_SPOTS = NUM_CAUGHT_SPOTS + 1,
          WHERE
              ID={parking_id} ''')

    con.commit()

    con.close()

    free_saved_parking(parking_id)


if __name__ == '__main__':
    create_db_tables()

    add_parking_location('location', 5)
    print(get_parking_by_id(1))
    display_table_content()
    display_table_titles()

    display_db_tables()
