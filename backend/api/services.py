# from django.core.exceptions import ValidationError
# from .models import CreatedTask, Group


# def create_created_task(group: Group, task_name: str, description: str, points: int) -> CreatedTask:
 
#     if CreatedTask.objects.filter(group=group, task_name=task_name).exists():
#         raise ValidationError("Task with this name already exists in this group")

#     return CreatedTask.objects.create(
#         group=group,
#         task_name=task_name,
#         description=description,
#         points=points
#     )