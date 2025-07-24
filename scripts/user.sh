docker exec visor_i2d_backend python manage.py createsuperuser --username admin --email admin@humboldt.gov.co --noinput
docker exec visor_i2d_backend python manage.py shell -c "from django.contrib.auth import get_user_model; User = get_user_model(); admin = User.objects.get(username='admin'); admin.set_password('admin123'); admin.save(); print('Password set successfully')"
docker exec visor_i2d_backend python manage.py shell -c "from django.contrib.auth import get_user_model; User = get_user_model(); admin = User.objects.get(username='admin'); print(f'Username: {admin.username}'); print(f'Email: {admin.email}'); print(f'Is superuser: {admin.is_superuser}'); print(f'Is staff: {admin.is_staff}')"

docker exec visor_i2d_backend python manage.py collectstatic --noinput
