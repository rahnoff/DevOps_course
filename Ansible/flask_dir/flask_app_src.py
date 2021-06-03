#!/usr/bin/python3

from flask import Flask, request
import emoji

app = Flask(__name__)


@app.route('/', methods=['GET'])
def hello():
    return 'Hello Flask'
    

@app.route('/emoji', methods=['POST'])
def create_emoji():
    delimeter_one = ':'
    delimeter_two = ':'
    request_data = request.get_json()
    emoji_input = request_data['word']
    emoji_input_formatted = delimeter_one + emoji_input + delimeter_two
    emoji_output = emoji.emojize(emoji_input_formatted)
    emoji_input_second = request_data['sound']
    emoji_count = int(request_data['count'])
    emoji_in_signature = '\u2764\ufe0f'
    return (((emoji_output + " " + "says" + " " + emoji_input_second + "\n") * emoji_count) + "Made with" + " " + emoji_in_signature + "  " + "by Ramzes" + "\n")

if __name__ == '__main__':
    app.run(port=8000, host='0.0.0.0')
