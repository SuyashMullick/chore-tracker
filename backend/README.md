# README

## To use Django:
1. 'cd equalchores/backend'
2. activate virtual environment by 'python -m venv venv' and 
‘Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process’，'.\\venv\Scripts\activate'      
source venv/bin/activate # Mac/Linux
For git bash on Windows:
source 'venv/Scripts/activate'

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

## How to create superuer and manage data models at the backend
1. 'python manage.py createsuperuser'  # Once the account is created, u can skip step 1 the next time
2. 'python manage.py runserver'
3. Open 'http://127.0.0.1:8000/admin/'