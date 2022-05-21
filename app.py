from flask import Flask
from time import time


app = Flask(__name__)


@app.route('/')
def hello_geek():
    unix_time = int(time())
    return '<h2>Hello from Flask & Docker @{}</h2>'.format(unix_time)


if __name__ == "__main__":
    app.run(debug=True)
