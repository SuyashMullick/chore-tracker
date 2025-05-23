from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.utils.translation import gettext_lazy as _
from .models import User, Group, GroupMembership, CreatedTask, PlannedTask


# Custom User admin
@admin.register(User)
class CustomUserAdmin(BaseUserAdmin):
    model = User

    list_display = ('id', 'email', 'username', 'gender')
    list_filter = ('gender',)
    search_fields = ('email', 'username')
    ordering = ('id',)


    fieldsets = (
        (None, {'fields': ('id', 'email', 'password')}),
        (_('Personal info'), {'fields': ('username', 'gender')}),
        # (_('Permissions'), {'fields': ('is_active', 'is_staff', 'is_superuser')}),
        # (_('Important dates'), {'fields': ('last_login', 'date_joined')}),
    )

    add_fieldsets = (  # For adding new users
    (None, {
        'classes': ('wide',),
        'fields': ('email', 'password1', 'password2'), # passwords and confirmation
    }),
    )

    readonly_fields = ('id',)
    filter_horizontal = ()


@admin.register(Group)
class GroupAdmin(admin.ModelAdmin):
    list_display = ('id', 'group_name', 'creator')
    search_fields = ('group_name',)
    list_filter = ('creator',)

@admin.register(GroupMembership)
class GroupMembershipAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'group', 'team_credits', 'individual_credits')
    list_filter = ('group', 'user')
    search_fields = ('user__email', 'group__group_name')


@admin.register(CreatedTask)
class CreatedTaskAdmin(admin.ModelAdmin):
    list_display = ('id', 'task_name', 'group', 'points', 'description')
    search_fields = ('task_name',)
    list_filter = ('group', 'points')


@admin.register(PlannedTask)
class PlannedTaskAdmin(admin.ModelAdmin):
    list_display = ('id', 'task_template', 'assignee', 'assigner', 'start_time', 'state', 'custom_description')
    search_fields = ('task_template__task_name', 'assignee__email', 'assigner__email')
    list_filter = ('state', 'start_time', 'assignee', 'assigner')


