@echo off
start cmd /k "cd flutter\website && flutter run"
start cmd /k "cd node_server && node server.js"
start cmd /k "cd flask && python main.py"