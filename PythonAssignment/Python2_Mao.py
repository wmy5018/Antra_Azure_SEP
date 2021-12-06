import json

with open(r'C:\Users\yaowa\Documents\Antra\Python\movie.json', encoding='utf-8') as file:
    js= json.load(file)

CHUNKS = 8
movies = js['movie']
movies_per_chunk = len(movies)// CHUNKS

for current_chunk in range(CHUNKS):
    with open('movie_' + str(current_chunk) + '.json', 'w') as outfile:
        to_write = {
            'movie': movies[current_chunk * movies_per_chunk:(current_chunk + 1) * movies_per_chunk]
        }
        json.dump(to_write, outfile, indent = 4)