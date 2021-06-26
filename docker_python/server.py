import emoji, http.server, json

class WebServerHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type', 'text/html')
        self.end_headers()
        message_text = '''Hello Flask\n'''
        message_bytes = message_text.encode()
        self.wfile.write(message_bytes)
        return
    def do_POST(self):
        delimeter_one = ':'
        delimeter_two = ':'
        #data = json.loads(self.request.body)
        #emoji_input = data['animal']
        #emoji_input_formatted = delimeter + emoji_input + delimeter
        #emoji_output = emoji.emojize(emoji_input_formatted)
        #emoji_input_second = data['sound']
        #emoji_count = int(data['count'])
        emoji_in_signature = delimeter_one + "red_heart" + delimeter_two
        #result = emoji_output + emoji_input_second + emoji_in_signature
        #self.write(result)
        length = int(self.headers['Content-Length'])
        post_body_bytes = self.rfile.read(length)
        post_body_text = post_body_bytes.decode()
        post_body_json = json.loads(post_body_text)
        #query_strings = urllib.parse.parse_qs(post_body_text, keep_blank_values=True)
        #request_data = requests.get_json()
        emoji_input = post_body_json['animal']
        emoji_input_formatted = delimeter_one + emoji_input + delimeter_two
        emoji_output = emoji.emojize(emoji_input_formatted)
        emoji_in_signature_output = emoji.emojize(emoji_in_signature, variant="emoji_type")
        emoji_input_second = post_body_json['sound']
        emoji_count = int(post_body_json['count'])
        message = (((emoji_output + " " + "says" + " " + emoji_input_second + "\n") * emoji_count) + "Made with" + " " + emoji_in_signature_output + "  " + "by Ramzes" + "\n")
        self.send_response(200)
        self.send_header('Content-Type', 'text/json')
        self.end_headers()
        message_bytes = message.encode()
        self.wfile.write(message_bytes)
   # def make_page(self): #make emoji
    #    all_messages = '<br>'.join(messages)
     #   page = 'tesdfdf'
      #  return page.format(all_messages)

host_socket = 8080
host_ip = '0.0.0.0'
host_address = (host_ip, host_socket)
my_server = http.server.HTTPServer(host_address, WebServerHandler)
my_server.serve_forever()
