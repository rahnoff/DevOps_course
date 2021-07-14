import http.server, json

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
        emoji_dict = {'see-no-evil-monkey':'\U0001F648', 'hear-no-evil-monkey':'\U0001F649', 'speak-no-evil-monkey':'\U0001F64A', 'collision':'\U0001F4A5', 'dizzy':'\U0001F4AB', 'sweat droplets':'\U0001F4A6', 'dashing away':'\U0001F4A8', 'monkey face':'\U0001F435', 'monkey':'\U0001F412', 'gorilla':'\U0001F98D', 'orangutan':'\U0001F9A7', 'dog face':'\U0001F436', 'dog':'\U0001F415', 'guide dog':'\U0001F9AE', 'service dog':'\U0001F415', 'poodle':'\U0001F429', 'wolf':'\U0001F43A', 'fox':'\U0001F98A', 'raccoon':'\U0001F99D', 'cat face':'\U0001F431', 'cat':'\U0001F408', 'lion':'\U0001F981', 'tiger face':'\U0001F42F', 'tiger':'\U0001F405', 'leopard':'\U0001F406', 'horse face':'\U0001F434', 'horse':'\U0001F40E', 'unicorn':'\U0001F984', 'zebra':'\U0001F993', 'deer':'\U0001F98C', 'bison':'\U0001F9AC', 'cow face':'\U0001F42E', 'ox':'\U0001F402', 'water buffalo':'\U0001F403', 'cow':'\U0001F404', 'pig face':'\U0001F437', 'pig':'\U0001F416', 'boar':'\U0001F417', 'pig nose':'\U0001F43D', 'ram':'\U0001F40F', 'ewe':'\U0001F411', 'goat':'\U0001F410', 'camel':'\U0001F42A', 'two-hump camel':'\U0001F42B', 'llama':'\U0001F999', 'giraffe':'\U0001F992', 'elephant':'\U0001F418', 'mammoth':'\U0001F9A3', 'rhinoceros':'\U0001F98F', 'hippopotamus':'\U0001F99B', 'mouse face':'\U0001F42D', 'mouse':'\U0001F401', 'rat':'\U0001F400', 'hamster':'\U0001F439', 'rabbit face':'\U0001F430', 'rabbit':'\U0001F407', 'chipmunk':'\U0001F43F', 'beaver':'\U0001F9AB', 'hedgehog':'\U0001F994', 'bat':'\U0001F987', 'bear':'\U0001F43B', 'koala':'\U0001F428', 'panda':'\U0001F43C', 'sloth':'\U0001F9A5', 'otter':'\U0001F9A6', 'skunk':'\U0001F9A8', 'kangaroo':'\U0001F998', 'badger':'\U0001F9A1', 'paw prints':'\U0001F43E', 'turkey':'\U0001F983', 'chicken':'\U0001F414', 'rooster':'\U0001F413', 'hatching chick':'\U0001F423', 'baby chick':'\U0001F424', 'front-facing baby chick':'\U0001F425', 'bird':'\U0001F426', 'penguin':'\U0001F427', 'dove':'\U0001F54A', 'eagle':'\U0001F985', 'duck':'\U0001F986', 'swan':'\U0001F9A2', 'owl':'\U0001F989', 'dodo':'\U0001F9A4', 'feather':'\U0001FAB6', 'flamingo':'\U0001F9A9', 'peacock':'\U0001F99A', 'parrot':'\U0001F99C', 'frog':'\U0001F438', 'crocodile':'\U0001F40A', 'turtle':'\U0001F422', 'lizard':'\U0001F98E', 'snake':'\U0001F40D', 'dragon face':'\U0001F432', 'dragon':'\U0001F409', 'sauropod':'\U0001F995', 't-rex':'\U0001F996', 'spouting whale':'\U0001F433', 'whale':'\U0001F40B', 'dolphin':'\U0001F42C', 'seal':'\U0001F9AD', 'fish':'\U0001f41F', 'tropical fish':'\U0001F420', 'blowfish':'\U0001F421', 'shark':'\U0001F988', 'octopus':'\U0001F419', 'spiral shell':'\U0001F41A', 'snail':'\U0001F40C', 'butterfly':'\U0001F98B', 'bug':'\U0001F41B', 'ant':'\U0001F41C', 'honeybee':'\U0001F41D', 'beetle':'\U0001FAB2', 'lady beetle':'\U0001F41E', 'cricket':'\U0001F997', 'spider':'\U0001F577', 'spider web':'\U0001F578', 'scorpion':'\U0001F982', 'mosquito':'\U0001F99F', 'fly':'\U0001FAB0', 'worm':'\U0001FAB1'}
        length = int(self.headers['Content-Length'])
        post_body_bytes = self.rfile.read(length)
        post_body_text = post_body_bytes.decode()
        post_body_json = json.loads(post_body_text)
        emoji_input = post_body_json['animal']
        if emoji_input in emoji_dict:
            emoji_output = emoji_dict[emoji_input]
        emoji_input_second = post_body_json['sound']
        emoji_count = int(post_body_json['count'])
        emoji_in_signature = '\u2764\ufe0f'
        message = (((emoji_output + " " + "says" + " " + emoji_input_second + "\n") * emoji_count) + "Made with" + " " + emoji_in_signature + " " + "by Ramzes" + "\n")
        self.send_response(200)
        self.send_header('Content-Type', 'text/json')
        self.end_headers()
        message_bytes = message.encode()
        self.wfile.write(message_bytes)

host_socket = 8080
host_ip = '0.0.0.0'
host_address = (host_ip, host_socket)
my_server = http.server.HTTPServer(host_address, WebServerHandler)
my_server.serve_forever()
