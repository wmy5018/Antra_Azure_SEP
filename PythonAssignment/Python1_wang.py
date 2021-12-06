import csv


def remove_duplicates(filename: str):
    result = []
    duplicates = set()
    with open('C:/Users/yaowa/Documents/Antra/Python/people/' + filename) as f:
        contents = [line.strip() for line in f]
        for c in contents:
            info = c.split('\t')
            fn = info[0].lower().strip(' ')
            ln = info[1].lower().strip(' ')
            em = info[2].lower().strip(' ')
            ph = info[3].strip(' ').replace('-', '')
            ad = info[4].lower().replace('no.', '').replace('#', '')
            total = fn + ' ' + ln + ' ' + em + ' ' + ph + ' ' + ad
            if total not in duplicates:
                duplicates.add(total)
                result.append([fn, ln, em, ph, ad])
        print(f'found: {len(contents) - len(duplicates)} duplicates for {filename}')
        return result


if __name__ == '__main__':
    # specify the filenames you wish to remove duplicates
    filenames = ['people_1.txt', 'people_2.txt']
    results = []
    for f in filenames:
        results += remove_duplicates(f)
    with open('C:\Users\yaowa\Documents\Antra\Python\results.csv', 'w+') as c:
        cw = csv.writer(c, delimiter=',')
        cw.writerows(results)