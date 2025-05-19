from django.db import models


class Task(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField()
    points = models.IntegerField(10)

    def __str__(self):
        return self.name