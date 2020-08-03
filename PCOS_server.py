import socket
import threading
import sqlite3
from datetime import datetime


class ClientThread(threading.Thread):

    login_database_path = "bd_login.sq3"
    data_database_path = "bd_data.sq3"

    def __init__(self, ip, port, clientsocket):
        threading.Thread.__init__(self)
        self.ip = ip
        self.port = port
        self.clientsocket = clientsocket
        print("[+] New thread for %s %s" % (self.ip, self.port,))

    def run(self):
        print("Connection from %s : %s" % (self.ip, self.port,))

        code = self.clientsocket.recv(2048)
        mess = code.decode("utf-8")

        # Commented out for use with iOS apps - only needs for weird thing that happens with android socket connection
        # mess = mess[2::]

        try:
            actionId = mess.split("^")[0]
            # autor gives us or not the authorization to send confirmation of good log/reg to user
            autor = 0
            data = mess.split("^")[1]

        except IndexError:
            print("<============================================>")
            print("The following message caused the error:")
            print(mess)
            print("<============================================>")

        print("Data: " + data)

        if actionId == "1":
            # REGISTER
            print("Register...")
            autor = self.sqlFuncRegister(data)
            self.sendAutor(autor)
        elif actionId == "2":
            # LOGIN
            print("Login..")
            autor = self.sqlFuncLogin(data)
            self.sendAutor(autor)
        elif actionId == "3":
            print("Data submission.")
            autor = self.sqlDATA(data)
            print(autor)
            self.sendAutor(autor)

        else:
            print("BADABOUM, we're HACKED")

        print("----------------------------------------------------------------------------")
        return

    def sendAutor(self, autor):
        if autor == 1:
            # Good log/reg
            message = "Successful login/register."
            print(message)
            message_to_send = ("1^" + message).encode("UTF-8")
            clientsocket.send(len(message_to_send).to_bytes(2, byteorder='big'))
            clientsocket.send(message_to_send)
            return

        elif autor == 0:
            # Bad log/reg
            message = "Unsuccessful login. Account does not exist."
            print(message)
            message_to_send = ("0^" + message).encode("UTF-8")
            clientsocket.send(len(message_to_send).to_bytes(2, byteorder='big'))
            clientsocket.send(message_to_send)

        elif autor == 2:
            message = "Unsuccessful register. Account with this username already exists."
            print(message)
            message_to_send = ("2^" + message).encode("UTF-8")
            clientsocket.send(len(message_to_send).to_bytes(2, byteorder='big'))
            clientsocket.send(message_to_send)
            return "Error"

        elif autor == 3:
            message = "Unsuccessful login. Password is incorrect."
            print(message)
            message_to_send = ("3^" + message).encode("UTF-8")
            clientsocket.send(len(message_to_send).to_bytes(2, byteorder='big'))
            clientsocket.send(message_to_send)
            return "Error"

        elif autor == 4:
            message = "Sent & Received"
            print(message)
            message_to_send = ("4^" + message).encode("UTF-8")
            clientsocket.send(len(message_to_send).to_bytes(2, byteorder='big'))
            clientsocket.send(message_to_send)
            return "OK"

        elif autor == 5:
            message = "Unsuccessful login. Cannot log in more than twice in one day."
            print(message)
            message_to_send = ("5^" + message).encode("UTF-8")
            clientsocket.send(len(message_to_send).to_bytes(2, byteorder='big'))
            clientsocket.send(message_to_send)
            return "Error"

        elif autor == 6:
            message = "Data was not received. Cannot submit data more than twice in one day."
            print(message)
            message_to_send = ("6^" + message).encode("UTF-8")
            clientsocket.send(len(message_to_send).to_bytes(2, byteorder='big'))
            clientsocket.send(message_to_send)
            return "Error"

        elif autor == 7:
            message = "Unknown Error Type."
            print(message)
            message_to_send = ("7^" + message).encode("UTF-8")
            clientsocket.send(len(message_to_send).to_bytes(2, byteorder='big'))
            clientsocket.send(message_to_send)
            return "Error"

    def sqlDATA(self, data):
        data1 = data.split("%")[0]  # id

        now = datetime.now()  # current date and time
        date_time = now.strftime("%d/%m/%Y")

        mess = data.split("%")[1]  # mess
        print(mess)

        data_file = self.login_database_path
        conn = sqlite3.connect(data_file)
        cur = conn.cursor()

        data_file1 = self.data_database_path
        conn1 = sqlite3.connect(data_file1)
        cur1 = conn1.cursor()
        cur1.execute(
            "CREATE TABLE IF NOT EXISTS QUIZZ_DATA (ID TEXT, DAY_DATE DATE, ANSWERS TEXT)")

        cur.execute(
            "CREATE TABLE IF NOT EXISTS PATIENTS (ID TEXT, PASSWORD TEXT, YEAR_BIRTH YEAR , F_DATE1 DATE, F_DATE2 DATE, F_DATE3 DATE, PCOS_DETEC INT)")

        # Need to double check client id
        a = 0   # (bad log/reg)
        cur.execute("SELECT * FROM PATIENTS")
        for l in cur:
            if l[0] == data1:
                # the user logs in
                a = 4   # (error)

        cur1.execute("SELECT * FROM QUIZZ_DATA")
        print(type(data1), type(date_time))
        for l in cur1:
            if (l[0], l[1]) == (data1, date_time):
                # User as already sent data today
                print("User has already sent data today - Cannot send data twice in one day")
                a = 6   # (2*day)

        if a == 0 or a == 6 or a == 7:    # (bad log/reg) or (2*day) or (Unknown)
            return a

        conn.commit()
        cur.close()
        conn.close()
        print("SAVING DATA")

        data = (data1, date_time, mess)

        # registered in the database
        cur1.execute("INSERT INTO QUIZZ_DATA VALUES ( ?,?,?)", data)
        conn1.commit()
        cur1.close()
        conn1.close()
        return 4    # data successful

    def sqlFuncLogin(self, data):

        data_file = self.login_database_path
        conn = sqlite3.connect(data_file)
        cur = conn.cursor()
        cur.execute(
            "CREATE TABLE IF NOT EXISTS PATIENTS (ID TEXT, PASSWORD TEXT, YEAR_BIRTH YEAR , F_DATE1 DATE, F_DATE2 DATE, F_DATE3 DATE, PCOS_DETEC INT)")

        data1 = data.split("%")[0]  # id - Checking id is not already in it
        data2 = data.split("%")[1]

        cur.execute("SELECT * FROM PATIENTS")
        for l in cur:
            # Correct username and password
            if (l[0], l[1]) == (data1, data2):

                conn.commit()
                cur.close()
                conn.close()
                return 1
            # Correct username, incorrect password
            elif l[0] == data1 and l[1] != data2:
                conn.commit()
                cur.close()
                conn.close()
                return 3
        # Username entered does not exist, password does not matter
        conn.commit()
        cur.close()
        conn.close()
        return 0

    def sqlFuncRegister(self, data):

        data_file = self.login_database_path
        conn = sqlite3.connect(data_file)
        cur = conn.cursor()
        cur.execute(
            "CREATE TABLE IF NOT EXISTS PATIENTS (ID TEXT, PASSWORD TEXT, YEAR_BIRTH YEAR , F_DATE1 DATE, F_DATE2 DATE, F_DATE3 DATE, PCOS_DETEC INT)")

        data1 = data.split("%")[0]  # id - Checking id is not already in it
        data2 = data.split("%")[1]  # password
        data3 = data.split("%")[2]  # Y Birth
        data4 = data.split("%")[3]  # Date1
        data5 = data.split("%")[4]  # Date2
        data6 = data.split("%")[5]  # Date3
        data7 = data.split("%")[6]  # P.C.O.S. confirmed

        data = (data1, data2, data3, data4, data5, data6, data7)

        cur.execute("SELECT * FROM PATIENTS")
        for l in cur:
            if l[0] == data1:
                if l[1] == data2:
                    # ALREADY IN THE DATABASE
                    print(l[0] + ", " + l[1] + ", " + data1 + ", " + data2)
                    print("ALREADY IN THE DATABASE.")
                    cur.close()
                    conn.close()
                    return 2
                # ID in the database, bad password
                print("ID IN THE DATABASE, BAD PASSWORD.")
                cur.close()
                conn.close()
                return 2

        # registered - entering information into the database
        cur.execute("INSERT INTO PATIENTS VALUES ( ?,?,?,?,?,?,?)", data)
        conn.commit()
        cur.close()
        conn.close()
        return 1


# Server running
tcpsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
tcpsock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
# Port 3456: cause it's life
tcpsock.bind(("", 3456))
while True:
    tcpsock.listen(10)
    print("Listening...")

    (clientsocket, (ip, port)) = tcpsock.accept()
    newthread = ClientThread(ip, port, clientsocket)
    newthread.start()



