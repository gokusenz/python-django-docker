#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys


def main():
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app.settings')
    try:
        from django.core.management import execute_from_command_line
        from django.conf import settings

        # MyProject Customization: run coverage.py around tests automatically
        running_tests = (sys.argv[1] == 'test')
        if running_tests:
            from coverage import Coverage
            cov = Coverage()
            cov.erase()
            cov.start()

        if settings.DEBUG:
            if os.environ.get('RUN_MAIN') or os.environ.get('WERKZEUG_RUN_MAIN'):
                import ptvsd
                ptvsd.enable_attach(address = ('0.0.0.0', 3500))
                print("Attached remote debugger")
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
    execute_from_command_line(sys.argv)

    if running_tests:
        cov.stop()
        cov.save()
        covered = cov.report()
        if covered < 100:
            sys.exit(1)

if __name__ == '__main__':
    main()
