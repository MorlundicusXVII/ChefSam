from multiprocessing import context
from flask_cors import CORS
from flask import Flask,send_file,send_from_directory,jsonify,request
from langchain_ollama import ChatOllama
import mysql.connector
import json

app = Flask(__name__)
CORS(app)

lcmodel =ChatOllama(
    temperature=0,
    model="gemma3:1b",
    reasoning=False
)


def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="turismoDB"
    )
def run_sql(sql):

    if not sql.lower().strip().startswith("select"):
        raise Exception("Query non valida: " + sql)
    
    conn=get_connection()
    cursor =conn.cursor(dictionary=True)
    res =None
    try:
        cursor.execute(sql)
        res=cursor.fetchall()
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise e
    finally:
        cursor.close()
        conn.close()
    return res

def answer(information,question):

    contesto=f'''
    sei un agenzia di viaggio e devi rispondere in linguaggio naturale in italiano
    in base alle informazioni:
    {information}
'''
    context=[("system",contesto),
             ("human",question)
             ]
    res =lcmodel.invoke(context)
    return res.content

@app.route("/",methods=["GET"])
def index():
    return send_file("index.html")

@app.route("/<path:filename>")
def file(filename):
    return send_from_directory(".",filename)


@app.route("/chat", methods=["POST"])
def chat():
    



    try:
        #logica per interrogare 
        data = request.get_json()
        question = data["input"]
        citta = None
        sqlCitta = "SELECT * FROM Citta;"
        infoCitta = run_sql(sqlCitta)
        print('check pre ai')
        cittaTrovata = False
        for c in infoCitta:
            if c['nome'].lower() in question.lower():
                cittaTrovata = True
                citta = c
                break
        print('check1')
        print(cittaTrovata)
        if cittaTrovata:
            sqlAttrazioni = "SELECT * FROM Attrazioni JOIN Citta on Attrazioni.citta_id = Citta.id WHERE Citta.nome='"+citta['nome']+"';"
            print('check2')

            try:
                information = run_sql(sqlAttrazioni)

            except Exception as e:
                
                return jsonify({
                    "error": "sql_error"+str(e),
                }), 400

            print("secondo check")
            ai = answer(information, question)

            return jsonify({
                "ai": ai,
            }),200
        else:
            information = None
            print('check3')
            question = question + "voglio una risposta in base alla domanda che ti ho fatto "
            ai = answer(information, question)
            print('check4')
            return jsonify({
                "ai": ai,
            }),200
    except Exception as e:
        return jsonify({
            "error": "server_error"+str(e),
        }), 500


if __name__=="__main__":
    app.run(port=8080)
