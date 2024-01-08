from flask import Flask, url_for, redirect, request, make_response, render_template, session, g
import jinja2
import MySQLdb


app = Flask('Prva flask aplikacija')


app.secret_key = '_de5jRRR83x'

@app.get('/login')
def login():
    response = render_template('login.html',  naslov = 'Stranica za prijavu')
    return response

@app.get('/logout')
def logout():
    session.pop('username')
    return redirect(url_for('login'))



# 2.zad (7.vjezba)
@app.before_request
def before_request_func():
    g.connection = MySQLdb.connect(host = 'localhost', user = 'app', passwd = '1234', db = 'lvj6')
    g.cursor = g.connection.cursor()
 
    if request.path == '/login' or  request.path.startswith('/static') or request.path == '/temperatura': 
        return
    if session.get('username') is None:
        return redirect(url_for('login'))
        
@app.after_request
def after_request_func(response):
    g.connection.commit()
    g.connection.close()
    return response


# 3/6 i 7 zad (7.vjezba)
@app.get('/')
def index():
    id_param = request.args.get('id')
    if id_param == '1' or id_param == None:
        g.cursor.execute(render_template('fetch_temp.sql', id_korisnika = session.get('id')))
        podaci_temp = g.cursor.fetchall()
        print(podaci_temp)
        response = render_template('index.html', naslov = 'Pocetna stranica', tip = 'Temperatura', username = session.get('username').capitalize(), podaci = podaci_temp, tip_podatka = id_param)
        return response, 200
    elif id_param == '2':
        g.cursor.execute(render_template('fetch_vlaga.sql', id_korisnika = session.get('id')))
        podaci_vlaga = g.cursor.fetchall()
        response = render_template('index.html', naslov = 'Pocetna stranica', tip = 'Vlaga', username = session.get('username').capitalize(), podaci = podaci_vlaga, tip_podatka = id_param)
        return response, 200

# 4.zad (7.vjezba)
@app.post('/temperatura')
def temp_add():
    global temperatura
    if request.json.get('temperatura'):
        query = render_template('insert_values.sql', value = request.json.get('temperatura'))
        g.cursor.execute(query)
        return  'Uspješno ste postavili temperaturu', 201    
    else:
        return 'Niste upisali ispravan ključ', 404

# 5.zad (7. vjezba) 
@app.post('/login')
def check():    
    username = request.form.get('username')
    password = request.form.get('password')    
    upit  = render_template('select_user.sql', username = username, password = password)
    odgovor = g.cursor.execute(upit)
    print("Ovo je odgovor:")
    print(odgovor)
    redak = g.cursor.fetchone()
    print("Ovo je redak:")
    print(redak)
    if redak:
        id_korisnika = redak[0]
        session['username'] = username
        session['id'] = id_korisnika
        return redirect(url_for('index'))
    else:
        return render_template('login.html', naslov='Stranica za prijavu', poruka='Uneseni su pogresni podaci')

# id_podatka definira tip podatka(temp/vlaga) dok id_retka definira neku odredenu temperaturu ili vlagu
@app.route('/temperatura/<int:id_retka>', methods=['POST'])
def delete(id_retka):
    id_podatka = request.args.get('id_podatka')
    if id_podatka == '' or id_podatka == '1' and id_retka is not None:
        query = render_template('delete_temp.sql', id_temp=id_retka)
        g.cursor.execute(query)  
        if id_podatka == '1':
            return redirect(url_for('index', id=id_podatka))
        else:
            return redirect(url_for('index'))
    elif id_podatka == '2' and id_retka is not None:
        query = render_template('delete_vlaga.sql', id_vlage=id_retka)
        g.cursor.execute(query)
        return redirect(url_for('index', id=id_podatka))   
       
    else:
        return
        


if __name__ == '__main__':
    app.run(host = '0.0.0.0', port = 80)
