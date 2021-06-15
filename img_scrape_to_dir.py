import os
import requests
from bs4 import BeautifulSoup

def grab_img(url, folder):
    os.mkdir(os.path.join(os.getcwd(), folder))
    os.chdir(os.path.join(os.getcwd(), folder))
    r = requests.get(url)
    soup = BeautifulSoup(r.text, 'html.parser')
    images = soup.find_all('img')
    for image in images:
        name = image['alt']
        link = image['src']
        with open(name.replace(' ', '_').replace('/', '') + '.jpg', 'wb') as f:
            im = requests.get(link)
            f.write(im.content)
            print('SAVING ', name, 'TO TEMP FOLDER')

grab_img('https://www.muckrock.com/', 'TEMP_SCRAPE')