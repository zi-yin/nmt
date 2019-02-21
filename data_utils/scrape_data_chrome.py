import os
from selenium import webdriver
import subprocess as sp
import time

path= "./data"

if __name__ == "__main__":
    options = webdriver.ChromeOptions()
    options.add_argument('--headless')
    options.add_argument('--allow-running-insecure-content')
    options.add_argument('--disable-web-security')
    options.add_argument('--no-referrers')
    # options.add_argument('{"download.default_directory": "/home/zyin/data"}')
    sp.check_output("mkdir -p {}".format(path), shell=True)
    profile = {"download.default_directory": path,
               "download.prompt_for_download": False,
               "download.directory_upgrade": True} 
    options.add_experimental_option("prefs", profile)
    driver = webdriver.Chrome(chrome_options=options,
            executable_path='/usr/local/bin/chromedriver')
    driver.get('https://archive.org/download/stackexchange');
    links = driver.find_elements_by_partial_link_text('.7z')
    print(len(links))
    for link in links:
        if os.path.isfile("data/{}".format(link.text)):
            print("file {} exists, skipping download...".format(link.text))
        else:
            print("downloading {}".format(link.text))
            sp.check_output("wget -nc -O data/{} https://archive.org/download/stackexchange/{}"
                    .format(link.text, link.text), shell=True)
            #link.click()   # why the heck is this not working ???
    driver.quit()
