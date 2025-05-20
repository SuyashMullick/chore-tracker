# README

## To use Django:
1. 'cd equalchores/dev_django'
2. activate virtual environment by 'python -m venv venv' and '\venv\Scripts\activate'      
# source venv/bin/activate # Mac/Linux
3. 'pip install -r requirements.txt'
4. Run the Development Server
'python manage.py runserver'

Note:
1. Always activate the virtual environment before running any commands.
2. Communicate any changes to requirements.txt to the team.


## To use SQLite: 
'python manage.py makemigrations'
'python manage.py migrate'
'python manage.py shell' # open shell
'from api.models import User'
# Save new data
p = User(points="4", gender="Female")
p.save()
# inquiry data
users = User.objects.all()
print(users)

sqlite3 db.sqlite3	

