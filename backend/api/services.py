from django.core.exceptions import ValidationError
from .models import CreatedTask, Group, User, PlannedTask
from datetime import datetime

def create_task_template(group: Group, task_name: str, description: str, points: int) -> CreatedTask:
 
    if CreatedTask.objects.filter(group=group, task_name=task_name).exists():
        raise ValidationError("Task with this name already exists in this group")

    return CreatedTask.objects.create(
        group=group,
        task_name=task_name,
        description=description,
        points=points
    )

def plan_task(task_template: CreatedTask, assignee: User, assigner: User, state: PlannedTask.StateChoices, custom_points: int, start_time:datetime) -> PlannedTask:
    if PlannedTask.objects.filter(task_template=task_template, start_time=start_time, assigner=assigner).exists():
        raise ValidationError("Task already planned to the user")

    return PlannedTask.objects.create(
        task_template=task_template,
        assigner=assigner,
        assignee=assignee,
        start_time=start_time,
        state=state,
        custom_points=custom_points
    )