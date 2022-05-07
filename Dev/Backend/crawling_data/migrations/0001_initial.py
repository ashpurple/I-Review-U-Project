# Generated by Django 3.2.5 on 2022-05-01 14:03

from django.db import migrations, models
import uuid


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='BuildingData',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('building_name', models.CharField(max_length=50, unique=True)),
                ('slug', models.SlugField(allow_unicode=True, default=uuid.uuid1, unique=True)),
                ('building_loc', models.CharField(max_length=50)),
                ('building_call', models.CharField(max_length=20)),
            ],
        ),
        migrations.CreateModel(
            name='ReviewData',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('building_name', models.CharField(max_length=50)),
                ('review_content', models.TextField()),
            ],
        ),
    ]
